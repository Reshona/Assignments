resource "azurerm_sql_server" "sqlserver" {
  name                         = "${var.vm_name}-server"
  resource_group_name          = azurerm_resource_group.RG22012023.name
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "dbuser"
  administrator_login_password = "${var.password}"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_sql_database" "sqldb" {
  name                = "${var.vm_name}-db"
  resource_group_name = azurerm_resource_group.RG22012023.name
  location            = "${var.location}"
  server_name         = azurerm_sql_server.sqlserver.name

  tags = {
    environment = "dev"
  }
}