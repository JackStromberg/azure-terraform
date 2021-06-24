resource "azurerm_public_ip" "lb_pip" {
    name                = "lb-${var.location}-${var.unique_id}-lb-pip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
    tags                = var.tags
}

resource "azurerm_lb" "lb" {
    name                = "lb-${var.location}-${var.unique_id}-lb"
    location            = var.location
    resource_group_name = var.resource_group_name
    tags                = var.tags

    frontend_ip_configuration {
        name                 = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.lb_pip.id
    }  
}

resource "azurerm_lb_rule" "lb_rule" {
    resource_group_name            = var.resource_group_name
    loadbalancer_id                = azurerm_lb.lb.id
    name                           = "HTTPS-Rule"
    protocol                       = "Tcp"
    frontend_port                  = 443
    backend_port                   = 443
    frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
    loadbalancer_id = azurerm_lb.lb.id
    name            = "BackEndAddressPool"
}