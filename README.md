# JavaScript-Test-App
This repo is meant to be used for testing a Veracode pipeline scan.


### To call the provence workflow, add the following job to your workflow:
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

### Issues
The Rekor issue.
Pull Request on the SLSA: https://github.com/slsa-framework/slsa-verifier/pull/98
