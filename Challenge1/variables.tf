variable "rg_name" {
  type        = string
  default     = "KPMGchallenge1"
}

variable "location" {
  type        = string
  default     = "Central US"
}

variable "vm_name" {
  type        = string
  default     = "KPMGChallengeVm"
}

variable "password" {
  type        = string
  sensitive   = true
}