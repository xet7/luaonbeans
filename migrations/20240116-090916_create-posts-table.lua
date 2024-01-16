return {
  up = function()
    local transaction = adb.BeginTransaction({
      collections = {
        writes = { "some", "tables" },
        reads = { "some", "tables" }
      }
    })
    if(pcall(function()
      assert(transaction.code == 201, "Transaction is not created")
      -- do something

    end)) then
      adb.CommitTransaction(transaction.result.id)
      return true
    else
      adb.AbortTransaction(transaction.result.id)
      return false
    end
  end,

  down = function()
    local transaction = adb.BeginTransaction({
      collections = {
        writes = { "some", "tables" },
        reads = { "some", "tables" }
      }
    })
    if(pcall(function()
      assert(transaction.code == 201, "Transaction is not created")
      -- do something

    end)) then
      adb.CommitTransaction(transaction.result.id)
      return true
    else
      adb.AbortTransaction(transaction.result.id)
      return false
    end
  end
}