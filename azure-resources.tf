# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.20.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "gudiaolabsresourcegroupops"
    storage_account_name = "gudiaolabsterraformstate"
    container_name       = "tfstate"
  }
}

# Extract variables and generates locals
# that depends on what workspace/env we are setting up
locals {
  environment                      = var.environment[terraform.workspace]
  location                         = var.location[terraform.workspace]
  accountKind                      = var.account-kind[terraform.workspace]
  accountTier                      = var.account-tier[terraform.workspace]
  accountReplicationType           = var.account-replication-type[terraform.workspace]
  sqlMaxSizeBytes                  = var.sql-max-size-bytes[terraform.workspace]
  sqlRequestedServiceObjectiveName = var.sql-requested-service-objective-name[terraform.workspace]
  sqlAuditingPolicyRetentionDays   = var.sql-auditing-policy-retention-days[terraform.workspace]
  servicePlanSkuTier               = var.service-plan-sku-tier[terraform.workspace]
  servicePlanSkuSize               = var.service-plan-sku-size[terraform.workspace]
  appServiceSiteConfigScmType      = var.app-service-site-config-scm-type[terraform.workspace]
  redisCapacity                    = var.redis-capacity[terraform.workspace]
  redisFamily                      = var.redis-family[terraform.workspace]
  redisSkuName                     = var.redis-sku-name[terraform.workspace]
  redisConfigMaxmemoryReserved     = var.redis-config-maxmemory-reserved[terraform.workspace]
  redisConfigMaxmemoryDelta        = var.redis-config-maxmemory-delta[terraform.workspace]
  redisConfigMaxmemoryPolicy       = var.redis-config-maxmemory-policy[terraform.workspace]
}


# Resource Group
resource "azurerm_resource_group" "resource-group" {
  name     = "${var.project-name}ResourceGroup${local.environment}"
  location = local.location

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Resource-Group"
  }

}

# Virtual Network
resource "azurerm_virtual_network" "virtual-network" {
  name                = "${var.project-name}VirtualNetwork${local.environment}"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Virtual-Network"
  }

}

# Public Subnet
resource "azurerm_subnet" "subnet-public" {
  name                 = "${var.project-name}SubnetPublic${local.environment}"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.10.0.0/24"]

}

# Public Private
resource "azurerm_subnet" "subnet-private" {
  name                 = "${var.project-name}SubnetPrivate${local.environment}"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.10.1.0/24"]

}

# Public Mgmt
resource "azurerm_subnet" "subnet-mgmt" {
  name                 = "${var.project-name}SubnetMgmt${local.environment}"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.10.2.0/24"]

}

/*
# Storage Account
resource "azurerm_storage_account" "storage-dbserver" {
  name                     = lower("${var.project-name}storage${local.environment}")
  resource_group_name      = azurerm_resource_group.resource-group.name
  location                 = azurerm_resource_group.resource-group.location
  account_kind             = local.accountKind
  account_tier             = local.accountTier
  account_replication_type = local.accountReplicationType

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Storage-Account"
  }
}

# SQL Server
resource "azurerm_sql_server" "sql-server" {
  name                         = lower("${var.project-name}dbserver${local.environment}")
  resource_group_name          = azurerm_resource_group.resource-group.name
  location                     = azurerm_resource_group.resource-group.location
  version                      = var.sql-database-version
  administrator_login          = var.sql-database-administrator-login
  administrator_login_password = data.azurerm_key_vault_secret.dbpass-secret.value

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storage-dbserver.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storage-dbserver.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = local.sqlAuditingPolicyRetentionDays
  }

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Sql-Server"
  }
}

# Allow access to Azure services
resource "azurerm_sql_firewall_rule" "allow-azure-services" {
  name                = "AllowAzureServicesAccessThisServer"
  resource_group_name = azurerm_resource_group.resource-group.name
  server_name         = azurerm_sql_server.sql-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# SQL Database
resource "azurerm_sql_database" "database" {
  name                             = "${var.project-name}db${local.environment}"
  server_name                      = azurerm_sql_server.sql-server.name
  resource_group_name              = azurerm_resource_group.resource-group.name
  location                         = azurerm_resource_group.resource-group.location
  collation                        = var.sql-collation
  create_mode                      = var.sql-create-mode
  edition                          = var.sql-edition
  max_size_bytes                   = local.sqlMaxSizeBytes
  requested_service_objective_name = local.sqlRequestedServiceObjectiveName

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storage-dbserver.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storage-dbserver.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = local.sqlAuditingPolicyRetentionDays
  }

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Sql-Database"
  }

}

# Redis cache
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = lower("${var.project-name}Redis${local.environment}")
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  capacity            = local.redisCapacity
  family              = local.redisFamily
  sku_name            = local.redisSkuName
  enable_non_ssl_port = false
  minimum_tls_version = var.redis-minimum-tls-version

  #subnet_id = azurerm_subnet.subnet-private.id

  # redis_configuration {
  #   maxmemory_reserved = local.redisConfigMaxmemoryReserved
  #   maxmemory_delta    = local.redisConfigMaxmemoryDelta
  #   maxmemory_policy   = local.redisConfigMaxmemoryPolicy
  # }

  tags = {
    "Name"        = var.project-name
    "Environment" = local.environment
    "Resource"    = "Redis-Cache"
  }

}
*/
# # Application Insights - API
# resource "azurerm_application_insights" "app-insights-api" {
#   name                = lower("${var.project-name}appinsightsapi${local.environment}")
#   resource_group_name = azurerm_resource_group.resource-group.name
#   location            = azurerm_resource_group.resource-group.location
#   application_type    = "web"
# }

# App Service Plan - API
resource "azurerm_app_service_plan" "app-service-plan-api" {
  name                = "${var.project-name}AppServicePlanAPI${local.environment}"
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  kind                = var.service-plan-kind

  sku {
    tier = local.servicePlanSkuTier
    size = local.servicePlanSkuSize
  }
}

# App Service - API
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_app_service" "app-service-api" {
  name                = lower("${var.project-name}appapi${local.environment}")
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  app_service_plan_id = azurerm_app_service_plan.app-service-plan-api.id

  # site_config {
  #   cors {
  #     allowed_origins = [lower("https://${var.project-name}appweb${local.environment}.azurewebsites.net")]
  #   }
  # }

  # app_settings = {
  #   "AdimaxJwtSecurityConfiguration__ReferralUrl" = lower("https://${var.project-name}appapi${local.environment}.azurewebsites.net"),
  #   "ASPNETCORE_ENVIRONMENT"                      = "Development"
  # }

  # connection_string {
  #   name  = "MyConnection"
  #   type  = "SQLServer"
  #   value = "Server=tcp:${var.project-name}dbserver${local.environment}.database.windows.net,1433;Initial Catalog=${var.project-name}db${local.environment};Persist Security Info=False;User ID=${var.sql-database-administrator-login};Password=${data.azurerm_key_vault_secret.dbpass-secret.value};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  # }

  # connection_string {
  #   name  = "DistributedCacheConnection"
  #   type  = "Custom"
  #   value = azurerm_redis_cache.redis.primary_connection_string
  # }


  # depends_on = [
  #   azurerm_app_service_plan.app-service-plan-api,
  #   azurerm_sql_database.database,
  #   azurerm_redis_cache.redis
  # ]

}

# # Application Insights - WEB
# resource "azurerm_application_insights" "app-insights-web" {
#   name                = lower("${var.project-name}appinsightsweb${local.environment}")
#   resource_group_name = azurerm_resource_group.resource-group.name
#   location            = azurerm_resource_group.resource-group.location
#   application_type    = "web"
# }

# App Service Plan - WEB
resource "azurerm_app_service_plan" "app-service-plan-web" {
  name                = "${var.project-name}AppServicePlanWEB${local.environment}"
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  kind                = var.service-plan-kind

  sku {
    tier = local.servicePlanSkuTier
    size = local.servicePlanSkuSize
  }
}

# App Service - WEB
# NOTE: the Name used for App Service needs to be globally unique
resource "azurerm_app_service" "app-service-web" {
  name                = lower("${var.project-name}appweb${local.environment}")
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  app_service_plan_id = azurerm_app_service_plan.app-service-plan-api.id

  # depends_on = [
  #   azurerm_app_service_plan.app-service-plan-api,
  #   azurerm_app_service.app-service-api,
  #   azurerm_sql_database.database,
  #   azurerm_redis_cache.redis
  # ]
}
