output "url" {
  description = "Public URL of the environment"
  value       = "http://${module.web.alb_dns_name}"
}

output "asg_name" {
  value = module.web.asg_name
}
