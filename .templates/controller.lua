##model_singular## = {}
##model_singular_capitalized## = require("##model_singular##")

-- A kind of before_each only: %w(edit update show) :)
if table.contains({ "edit", "update", "show" }, params.action) then
  ##model_singular## = ##model_singular_capitalized##.get(params.id)
end

-- Here a method to be more DRI
local function load_index()
  local ##model_plural## = ##model_singular_capitalized##.all()
  Page("##model_plural##/index", "app", { ##model_plural## = ##model_plural## })
end

local app = {
  -- GET ##model_plural###index => /##model_plural##
  index = function() load_index() end,

  -- GET ##model_plural###new => /##model_plural##/new
  new = function() Page("##model_plural##/new", "app") end,

  -- GET ##model_plural###show => /##model_plural##/:id
  show = function() Page("##model_plural##/show", "app", { ##model_singular## = ##model_singular## }) end,

  -- GET ##model_plural###edit => /##model_plural##/:id/edit
  edit = function() Page("##model_plural##/edit", "app", { ##model_singular## = ##model_singular## }) end,

  -- PUT ##model_plural###update => ##model_plural##/:id
  update = function()
    local bodyParams = GetBodyParams()
    local record = ##model_singular_capitalized##.update(params.id, bodyParams)

    if record.error then
      Page("##model_plural##/edit", "app", { ##model_singular## = table.merge(bodyParams, { _key = params.id }), record = record })
      return
    end

    RedirectTo("/##model_plural##")
  end,

  -- POST ##model_plural###create => /##model_plural##
  create = function()
    local bodyParams = GetBodyParams()
    local created_##model_singular## = ##model_singular_capitalized##.create(bodyParams)

    if created_##model_singular##.error then
      SetStatus(400)
      Page("##model_plural##/new", "app", { ##model_singular## = bodyParams })
      return
    end

    RedirectTo("/##model_plural##")
  end,

  -- DELETE ##model_plural###delete => /##model_plural##/:id
  delete = function()
    ##model_singular_capitalized##.destroy(params.id)
    load_index()
  end,

  offline = function()
    Write("Offline")
  end
}

assert(app[params.action] ~= null, "Missing method '" .. params.action .. "'!")
app[params.action]()