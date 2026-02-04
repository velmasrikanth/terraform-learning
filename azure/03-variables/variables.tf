# Primitives
variable "project" {
  type        = string
  description = "Project name"
  default     = "velma"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "os_disk_size" {
  type        = number
  description = "OS disk size"
  default     = 30
}

variable "diable_password" {
  type        = bool
  description = "Disable password authentication"
  default     = false
}

variable "admin_password" {
  type        = string
  description = "Admin password"
  default     = "velma#123"
}

# complex

variable "location" {
  type        = list(string)
  description = "Location"
  default     = ["eastus", "eastus2"]
}

variable "vm_size" {
  type        = list(string)
  description = "VM size"
  default     = ["Standard_B1s", "Standard_B2ats_v2"]
}

variable "port_ranges" {
    type = tuple([number, number])
    description = "Port ranges"
    default = [80, 443]
}

variable "source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Source image"
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default = {
    vm_type = "linux"
    os_type = "ubuntu"
  }
}
   