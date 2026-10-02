# Security Gatekeeper Demo

A GitHub Actions pipeline that builds a Docker image, scans it with
[Trivy](https://github.com/aquasecurity/trivy), and pushes to Azure
Container Registry only if no CRITICAL (fixable) vulnerabilities are found.

The app itself is intentionally broken — same issues as the slides' "Spot
the Problems" example:

- Old base image, pinned by digest to `python:3.8-slim` (4 known CRITICAL CVEs, permanently reproducible)
- `API_KEY` secret baked into the image
- Container runs as `root`

## The fix

In `Dockerfile`:

1. Change the `FROM` line to `python:3-slim` (current, patched, auto-updating)
2. Remove the `ENV API_KEY=...` line
3. Add a non-root user and switch to it before `CMD`

After the fix, `Dockerfile` should look like:

```dockerfile
FROM python:3-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt \
    && useradd --create-home appuser \
    && chown -R appuser:appuser /app
USER appuser
CMD ["python", "app.py"]
```

Commit that change and push — the same pipeline, same gate, now passes.

## Required repo secrets

- `ACR_LOGIN_SERVER`
- `ACR_USERNAME`
- `ACR_PASSWORD`

```bash
gh secret set ACR_LOGIN_SERVER --body "<registry>.azurecr.io"
gh secret set ACR_USERNAME --body "<username>"
gh secret set ACR_PASSWORD --body "<password>"
```
