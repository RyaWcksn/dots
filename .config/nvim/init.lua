require('plugins')
require('mappings')
require('options')
require('options.autocmd')
require('options.statusline')
require('options.winbar')
require('options.netrw')
require('options.sholat')


-- Account = {
-- 	balance = 0,

-- 	---Constructor
-- 	---@param initial_balance number
-- 	---@return table
-- 	new = function(self, initial_balance)
-- 		local o = {}
-- 		if initial_balance < 1 then
-- 			error("Initial balance should be more than 1")
-- 		end
-- 		o.balance = initial_balance or 0
-- 		setmetatable(o, self)
-- 		self.__index = self
-- 		return o
-- 	end,

-- 	---Deduct account balance
-- 	---@param self self
-- 	---@param v number
-- 	withdraw = function(self, v)
-- 		self.balance = self.balance - v
-- 	end,
-- 	---Add account balance
-- 	---@param self self
-- 	---@param v number
-- 	deposit = function(self, v)
-- 		self.balance = self.balance + v
-- 	end,
-- 	---Show balance
-- 	---@param self self
-- 	---@return number
-- 	show = function(self)
-- 		print(self.balance)
-- 		return self.balance
-- 	end
-- }
-- Account.__index = Account  -- Set the metatable for inheritance


-- local a = Account:new(10)
-- a:deposit(10)
-- a:show()
-- a:withdraw(5)
-- a:show()
-- a:show()
