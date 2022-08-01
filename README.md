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

Add the following jobs

For verification of the provenance add the following lines within the workflow

To find any files execute the following command within the job
