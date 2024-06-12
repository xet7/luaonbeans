Routes = { ["GET"] = { [""] = "welcome#index" }} --define root

Resource("customers", {
  only = { "index", "new", "create", "edit", "update", "show", "delete" },
  var_name = "customer_id", -- default value is "id"
  var_regex = "([0-9a-zA-Z_\\-]+)", -- default value
})

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
