# JavaScript-Test-App
This repo is meant to be used for testing a Veracode pipeline scan.

### To call the veracode pipeline scan workflow, add the following job to your workflow:
```
    veracode-pipeline-scan:
      needs: build
      uses: mclm-sandbox/ois-sts-security-scanning/.github/workflows/_pipeline-scan.yml@main
      secrets:
        VERACODE_API_ID: ${{ secrets.VERACODE_API_ID }}
        VERACODE_API_KEY: ${{ secrets.VERACODE_API_KEY }}
      with:
        vcode-app-id: "JavaScript-Test-App"
        vcode-artifact-name: "veracode-scan-target"
        vcode-artifact-filename: "veracode-scan-target.zip"
```
### To upload the results of a pipeline scan as issues, add the following job to your workflow:
```
   upload-results:
      needs: veracode-pipeline-scan
      uses: mclm-sandbox/ois-sts-security-scanning/.github/workflows/upload-scan-results.yml@main
```
### To call the veracode Upload & Scan (No sandbox) scan workflow, add the following job to your workflow:
```
    veracode-upload-and-scan:
      needs: build
      uses: mclm-sandbox/ois-sts-security-scanning/.github/workflows/_upload-and-scan.yml@main
      secrets:
        VERACODE_API_ID: ${{ secrets.VERACODE_API_ID }}
        VERACODE_API_KEY: ${{ secrets.VERACODE_API_KEY }}
      with:
        vcode-app-id: "OIS-STS-Pipeline-Dev - DEV- NodeJS Test App"
        vcode-artifact-name: "veracode-scan-target"
        vcode-artifact-filename: "veracode-scan-target.zip"
        criticality: "High"
```
### To call the veracode Upload & Scan (sandbox) scan workflow, add the following job to your workflow:
```
    veracode-upload-and-scan:
      needs: build
      uses: mclm-sandbox/ois-sts-security-scanning/.github/workflows/_veracode-sandbox-scan.yml@main
      secrets:
        VERACODE_API_ID: ${{ secrets.VERACODE_API_ID }}
        VERACODE_API_KEY: ${{ secrets.VERACODE_API_KEY }}
      with:
        vcode-app-id: "OIS-STS-Pipeline-Dev - DEV- NodeJS Test App"
        vcode-artifact-name: "veracode-scan-target"
        vcode-artifact-filename: "veracode-scan-target.zip"
        criticality: "High"
        sandboxname: "js-test-sandbox"
```
### To call the secrets scan workflow, add the following job to your workflow:
```
    secrets-scan:
      needs: build
      uses: mclm-sandbox/ois-sts-security-scanning/.github/workflows/_secrets-scan.yml@main
```

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
