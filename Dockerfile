# Pinned by digest to python:3.8-slim, so this always resolves to the same
# old, unpatched package set — Trivy always finds the same 4 CRITICAL,
# fixable CVEs, no matter when this demo is run.
FROM python@sha256:1d52838af602b4b5a831beb13a0e4d073280665ea7be7f69ce2382f29c5a613f
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENV API_KEY="super-secret-key"
USER root
CMD ["python", "app.py"]
