# angular/variables

variable "hosted_zone" {

}

variable "force_destroy" {
  default = false
}

variable "region" {
  default = "us-east-1"
}

variable "route_53_primart_zone_id" {
}

variable "alt_domain_list" {
  default = []
  description = "A list of alt domain names to add to the san list"
  type = list(string)
}