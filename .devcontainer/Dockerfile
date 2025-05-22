FROM ghcr.io/opentofu/opentofu:minimal AS tofu

FROM alpine

# ── Install dependencies ────────────────────────────────────────────────────
RUN apk add --no-cache \
   git \
   curl \
   ca-certificates \
   openssl \
   #update-ca-certificates \
   libgcc \
   libstdc++ \
   gcompat

# ── Fetch latest kubectl ───────────────────────────────────────────────────
RUN KUBECTL_VER="$(curl -fsSL https://dl.k8s.io/release/stable.txt)" && \
   curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VER}/bin/linux/amd64/kubectl" \
   -o /usr/local/bin/kubectl && \
   chmod +x /usr/local/bin/kubectl

# ── Fetch latest Argo CD CLI ────────────────────────────────────────────────
RUN curl -fsSL \
   "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64" \
   -o /usr/local/bin/argocd && \
   chmod +x /usr/local/bin/argocd

# ── Fetch latest Talosctl ──────────────────────────────────────────────────
RUN curl -sL https://talos.dev/install | sh

# ── Fetch latest OpenTofu ─────────────────────────────────────────────────
COPY --from=tofu /usr/local/bin/tofu /usr/local/bin/tofu

# ── Fetch latest Helm ─────────────────────────────────────────────────
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh
