resource "azurerm_subnet_route_table_association" "association" {
  subnet_id      = var.subnet_id
  route_table_id = var.udr_id
}