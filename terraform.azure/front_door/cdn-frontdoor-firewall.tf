resource "azurerm_cdn_frontdoor_firewall_policy" "sac_frontdoor_firewall_policy" {
  name                = "examplecdnfdwafpolicy"
  resource_group_name = azurerm_resource_group.front_door_rg.name
  sku_name            = azurerm_cdn_frontdoor_profile.sac_testing_frontdoor_profile.sku_name
  enabled = true
  mode = "Detection"

  depends_on = [
    azurerm_cdn_frontdoor_profile.sac_testing_frontdoor_profile
  ]

  custom_rule {
    name = "RateLimitingRule"
    enabled = true
    priority = 1
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold = 10
    type = "MatchRule"
    action = "Allow"

    match_condition {
      match_variable = "RemoteAddr"
      operator = "Equal"
      match_values = ["US"]
    }
  }

    managed_rule {
      type = "DefaultRuleSet"
      version = "1.0"
      action = "Allow"

      override {
        rule_group_name = "PHP"

        rule {
          rule_id = "933100"
          enabled = false
          action  = "Block"
        }
      }
  }
}