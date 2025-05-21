FROM ghcr.io/opentofu/opentofu:minimal AS tofu

FROM alpine:latest

# ── Install dependencies ────────────────────────────────────────────────────
RUN apk add --no-cache \
   git \
   curl \
   ca-certificates \
   openssl && \
   update-ca-certificates

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
#RUN TALOS_URL="$(curl -s https://api.github.com/repos/talos-systems/talos/releases/latest \
#   | jq -r '.assets[] | select(.name | test("talosctl.*linux-amd64.tar.gz")) | .browser_download_url')" && \
#   curl -fsSL "${TALOS_URL}" -o /tmp/talosctl.tgz && \
#   tar -C /usr/local/bin -xzf /tmp/talosctl.tgz && \
#   mv /usr/local/bin/talosctl-* /usr/local/bin/talosctl && \
#   chmod +x /usr/local/bin/talosctl && \
#   rm /tmp/talosctl.tgz

# ── Fetch latest OpenTofu ─────────────────────────────────────────────────
COPY --from=tofu /usr/local/bin/tofu /usr/local/bin/tofu
#RUN TOFU_URL="$(curl -s https://api.github.com/repos/OpenTofu/OpenTofu/releases/latest \
#   | jq -r '.assets[] | select(.name | test("opentofu_.*_linux_amd64.tar.gz")) | .browser_download_url')" && \
#   curl -fsSL "${TOFU_URL}" -o /tmp/tofu.tgz && \
#   tar -C /usr/local/bin -xzf /tmp/tofu.tgz && \
#   r

# ── Fetch latest Helm ─────────────────────────────────────────────────
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh
