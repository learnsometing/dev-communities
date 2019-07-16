class Profit
    attr_accessor :value, :purchase_date, :sale_date

    @value
    @purchase_date
    @sale_date
end

def stock_picker(array)   
    def profit low, high
        high - low
    end

    def calculate_profits(stocks)
        low = stocks[0]
        low_index = 0
        high = 0
        high_index = 0
        profits = []

        stocks.each_index do |index|
            stock = stocks[index]

            if stock < low && index > (- 1)
                low = stock
                low_index = index

                if low_index > high_index
                    high = 0
                end
            end

            if stock > low && index > 0
                high = stock
                high_index = index

                profit = Profit.new
                profit.value = profit(low, high)
                profit.purchase_date = low_index
                profit.sale_date = high_index
                profits.push profit
            end
        end
        profits
    end

    def pick_max_profit(profits)
        max_profit = 0
        max_profit_index = 0

        profits.each_index do |index|
            profit = profits[index]
            if profit.value > max_profit
                max_profit = profit.value
                max_profit_index = index
            end
        end
        max_profit = profits[max_profit_index]

        days = [max_profit.purchase_date, max_profit.sale_date]
        print days
    end

    
    pick_max_profit(calculate_profits(array))
end

# puts stock_picker([17,3,6,9,15,8,6,1,14])