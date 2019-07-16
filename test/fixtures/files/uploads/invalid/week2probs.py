# balance = 42
# annualInterestRate = 0.2
# monthlyPaymentRate = 0.04

# monthlyInterestRate = annualInterestRate / 12.0
# month = 1

# while month < 13:
#     month += 1
#     minimumMonthlyPayment = balance * monthlyPaymentRate
#     balance -= minimumMonthlyPayment
#     interest = balance * monthlyInterestRate
#     balance += interest

# print("Remaining balance: {}".format(round(balance, 2)))

balance = 320000
annualInterestRate = 0.2

monthlyInterestRate = annualInterestRate / 12.0
low = balance / 12.0
high = balance * (1 + annualInterestRate) / 12.0
solved = False
epsilon = 0.01

while not solved:
    unpaidBalance = balance
    monthlyPayment = (low + high) / 2.0

    for month in range(12):
        unpaidBalance -= monthlyPayment
        unpaidBalance += unpaidBalance * monthlyInterestRate

    if abs(unpaidBalance) <= epsilon:
        solved = True

    if unpaidBalance > 0:
        low = monthlyPayment
    elif unpaidBalance < 0:
        high = monthlyPayment

print("Lowest Payment: {}".format(round(monthlyPayment, 2)))
