# variable "cloudflare_zone_id" {
#   description = "Zone ID of the CloudFlare zone where record will be created"
# }

# variable "cloudflare_dns_record_name" {
#   description = "Name of the CNAME record to alias to the public load balancer record"
# }

# variable "tls_cert_arn" {
#   description = "The ARN of the TLS certificate to attach to the load balancer listeners"
# }

variable "docker_tag" {
  description = "The tag of the ledn docker image to deploy"
  default = "latest"
}