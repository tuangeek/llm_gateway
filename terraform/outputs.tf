output "alb_dns" {
  description = "the alb dns name"
  value       = module.gateway.alb_dns
}