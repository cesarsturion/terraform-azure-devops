// Get Keyvault Data
data "azurerm_resource_group" "ops" {
  name = var.resource-group-ops
}

# data "azurerm_key_vault" "keyvault" {
#   name                = var.keyvaul-name
#   resource_group_name = data.azurerm_resource_group.ops.name
# }

# data "azurerm_key_vault_secret" "dbpass-secret" {
#   name         = "DBPassword${var.environment[terraform.workspace]}"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

# data "azurerm_key_vault_secret" "backend" {
#   name         = "KeyBackend"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }