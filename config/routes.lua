Routes = { ["GET"] = { [""] = "welcome#index" } } --define root

-- CustomRoute("GET", "ban*", "welcome#ban") -- use splat

-- Resource("customers", {
--   var_name = "customer_id", -- default value is "id"
--   var_regex = "([0-9a-zA-Z_\\-]+)", -- default value
-- })
--
-- CustomRoute("GET", "ban", "customers#ban", {
--   parent = { "customers" },
--   type = "member", -- collection or member
-- })
--
-- Resource("comments", {
--   var_name = "comment_id", -- default value is "id"
--   var_regex = "([0-9a-zA-Z_\\-]+)", -- default value
--   parent = { "customers" }
-- })
--
-- Resource("likes", {
--   var_name = "comment_id", -- default value is "id"
--   var_regex = "([0-9a-zA-Z_\\-]+)", -- default value
--   parent = { "customers", "comments" }
-- })
--
