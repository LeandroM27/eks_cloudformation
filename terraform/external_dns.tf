// deployed in same namespace as the app

resource "helm_release" "external_dns" {
  name       = "${var.project_name}-external-dns-${var.environment}"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  version    = "6.28.1"

  namespace = "default"

  set {
    name = "provider"
    value = "cloudflare"
  }

  set {
    name = "cloudflare.email"
    value = var.cloudflare_email // saved as sensitive in terraform cloud
  }

  set {
    name = "cloudflare.apiKey"
    value = var.cloudflare_api_key // saved as sensitive in terraform cloud
  }

}