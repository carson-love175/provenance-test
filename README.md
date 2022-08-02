# JavaScript-Test-App
This repo is meant to be used for testing a Veracode pipeline scan.


### To call the provenance workflow for SLSA Level 1, add the following job to your workflow:
```
  generate-provenance:
    needs: build
    name: Generate build provenance
    runs-on: ubuntu-latest
    steps:
      - name: Download build artifact
        uses: actions/download-artifact@v2

      - name: Generate provenance
        uses: slsa-framework/github-actions-demo@v0.1
        with:
          artifact_path: {ADD ARTIFACT PATH HERE}

      - name: Upload provenance
        uses: actions/upload-artifact@v2
        with:
          name: provenance
          path: build.provenance
 ```

### To call the provenance workflow for SLSA Level 3, add the following jobs to your workflow:

Within the artifact creation portion of your workflow add the following lines
Before
```
outputs:
      hashes: ${{ steps.hash.outputs.hashes }}
```
After
```
- name: Generate hashes
        shell: bash
        id: hash
        run: |
          echo "::set-output name=hashes::$(sha256sum {ADD YOUR ARTIFACT NAMES HERE} | base64 -w0)"
      - name: Upload artifact
        uses: actions/upload-artifact@3cea5372237819ed00197afe530f5a7ea3e805c8 # tag=v3.1.0
        with:
          name: {NAME YOUR ARTIFACT}
          path: {PATH TO ARTIFACT}
          if-no-files-found: error
          retention-days: 5
```

Add the following jobs
```
 provenance:
    needs: [build]
    permissions:
      actions: read
      id-token: write
      contents: write
    uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v1.2.0
    with:
      base64-subjects: "${{ needs.build.outputs.hashes }}"
      upload-assets: true

  # This step uploads our artifacts to the tagged GitHub release.
  release:
    needs: [build, provenance]
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    steps:
      - name: Download artifact
        uses: actions/download-artifact@fb598a63ae348fa914e94cd0ff38f362e927b741 # tag=v2.1.0
        with:
          name: {ADD ARTIFACT NAME HERE}

      - name: Upload assets
        uses: softprops/action-gh-release@1e07f4398721186383de40550babbdf2b84acfc5 # v0.1.14
        with:
          files: |
            {ADD FILE NAME HERE}
```

To add the provenance as an artifact
```
   - run: |
        cat {ATTESTATION PATH} | jq -r '.payload' | base64 -d | jq >> provenance.json
    - name: Upload Artifact
      uses: actions/upload-artifact@v3.1.0
      with:
        name: build.provenance
        path: {PROVENANCE PATH}
```

To find any files execute the following command within the job
```
readlink -f {FILE NAME}
```

### To verify any provenance add the following job

```
  verify-provenance:
    needs: provenance
    runs-on: ubuntu-latest
    name: Verify Provenance
    steps:
    - uses: actions/checkout@v2
    - name: Setup Go environment
      uses: actions/setup-go@v3.2.1
      with:
        go-version: 1.18
    - name: Verify Provenance File
      uses: actions/download-artifact@v2
    - run: |
        git clone https://github.com/slsa-framework/slsa-verifier.git
        cd slsa-verifier && git checkout v1.2.0
        go run . -artifact-path {ARTIFACT PATH} -provenance {PROVENANCE PATH} -source {SOURCE LINK} {-print-provenance #OPTIONAL}
```
