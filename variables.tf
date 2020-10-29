# Resoource Group Ops
variable "resource-group-ops" {
  type        = string
  description = "Name of OPS Resource Group"
  default     = "gudiaolabsresourcegroupops"
}

variable "keyvaul-name" {
  type        = string
  description = "Name of key vault"
  default     = "gudiaolabsKeysVault"
}

variable "key-backend" {
  type        = string
  description = "(optional) describe your variable"
}

# General
variable "project-name" {
  type        = string
  description = "Nome do projeto"
  default     = "gudiaolabs"
}

variable "environment" {
  description = "Ambiente que estao sendo criados os recursos"
  type        = map
  default = {
    devops  = "devops"
    develop = "dev"
    qa      = "qa"
    homolog = "homolog"
    prod    = "prod"
  }
}

variable "location" {
  description = "Regiao em que o ambiente esta sendo criado"
  type        = map
  default = {
    devops  = "East US"
    develop = "East US"
    qa      = "East US"
    homolog = "Brazil South"
    prod    = "Brazil South"
  }
}

# Storage Account
variable "account-kind" {
  type        = map(string)
  description = "Tipo da conta utilizada no Storage"
  default = {
    devops  = "StorageV2"
    develop = "StorageV2"
    qa      = "StorageV2"
    homolog = "StorageV2"
    prod    = "StorageV2"
  }
}

variable "account-tier" {
  type        = map(string)
  description = "Plano de pagamento utilizado no Storage"
  default = {
    devops  = "Standard"
    develop = "Standard"
    qa      = "Standard"
    homolog = "Standard"
    prod    = "Standard"
  }
}

variable "account-replication-type" {
  type        = map(string)
  description = "Tipo de Replicacao utilizado no Storage"
  default = {
    devops  = "LRS"
    develop = "LRS"
    qa      = "LRS"
    homolog = "LRS"
    prod    = "LRS"
  }
}

# SQL Server and SQL Database
variable "sql-database-version" {
  type        = string
  description = "sql-database-version"
  default     = "12.0"
}

variable "sql-database-administrator-login" {
  type        = string
  description = "(optional) describe your variable"
  default     = "AdimaxProAdmin"
}

variable "sql-collation" {
  type        = string
  description = "collation"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sql-create-mode" {
  type        = string
  description = "sql-create-mode"
  default     = "Default"
}

variable "sql-edition" {
  type        = string
  description = "sql-create-mode"
  default     = "GeneralPurpose"
}

variable "sql-max-size-bytes" {
  type        = map(string)
  description = "sql-max-size-bytes"
  default = {
    devops  = "34359738368"
    develop = "34359738368"
    qa      = "34359738368"
    homolog = "34359738368"
    prod    = "34359738368"
  }
}

variable "sql-requested-service-objective-name" {
  type        = map(string)
  description = "sql-requested-service-objective-name"
  default = {
    devops  = "GP_S_Gen5_2"
    develop = "GP_S_Gen5_2"
    qa      = "GP_S_Gen5_2"
    homolog = "GP_S_Gen5_2"
    prod    = "GP_S_Gen5_2"
  }
}

variable "sql-auditing-policy-retention-days" {
  type        = map(string)
  description = "sql-auditing-policy-retention-days"
  default = {
    devops  = "1"
    develop = "1"
    qa      = "3"
    homolog = "5"
    prod    = "7"
  }
}

# App Service Plan and App Service
variable "service-plan-kind" {
  type        = string
  description = "(optional) describe your variable"
  default     = "Windows"
}

variable "service-plan-sku-tier" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "Basic"
    develop = "Basic"
    qa      = "Basic"
    homolog = "Basic"
    prod    = "Basic"
  }
}

variable "service-plan-sku-size" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "B1"
    develop = "B1"
    qa      = "B1"
    homolog = "B1"
    prod    = "B1"
  }
}

variable "app-service-site-config-dotnet-version" {
  type        = string
  description = "(optional) describe your variable"
  default     = "v4.0"
}

variable "app-service-site-config-scm-type" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "VSTSRM"
    develop = "VSTSRM"
    qa      = "VSTSRM"
    homolog = "VSTSRM"
    prod    = "VSTSRM"
  }
}

# Redis cache
variable "redis-capacity" {
  type        = map(number)
  description = "(optional) describe your variable"
  default = {
    devops  = 0
    develop = 0
    qa      = 0
    homolog = 0
    prod    = 0
  }
}

variable "redis-family" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "C"
    develop = "C"
    qa      = "C"
    homolog = "C"
    prod    = "C"
  }
}

variable "redis-sku-name" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "Basic"
    develop = "Basic"
    qa      = "Basic"
    homolog = "Basic"
    prod    = "Basic"
  }
}

variable "redis-minimum-tls-version" {
  type        = string
  description = "(optional) describe your variable"
  default     = "1.2"
}

variable "redis-config-maxmemory-reserved" {
  type        = map(number)
  description = "(optional) describe your variable"
  default = {
    devops  = 2
    develop = 2
    qa      = 2
    homolog = 2
    prod    = 2
  }
}

variable "redis-config-maxmemory-delta" {
  type        = map(number)
  description = "(optional) describe your variable"
  default = {
    devops  = 2
    develop = 2
    qa      = 2
    homolog = 2
    prod    = 2
  }
}

variable "redis-config-maxmemory-policy" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    devops  = "volatile-lru"
    develop = "volatile-lru"
    qa      = "volatile-lru"
    homolog = "volatile-lru"
    prod    = "volatile-lru"
  }
}




