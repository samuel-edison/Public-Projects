#############################################
#Dive Into Algorithms
#History of Algorithms
#############################################
#Russian Peasant Multiplication (18)

##choose two numbers to multiply
n1=89
n2=18
##create the halving column
halving = [n1]
##use function to divide halving column by 2 and ignore remainder
import math
print(math.floor(halving[0]/2)) #math.floor ignores the remainder
##loop through each row of the halving column, dividing by 2 in each iteration (stop it when it reaches 1)
while(min(halving) > 1): #min function returns the lowest number
    halving.append(math.floor(min(halving)/2)) #append concatenates the halving vector w/ half of its last value
##create the doubling column by doubling the previous entry and stop when the length is equal to the halving column
doubling = [n2]
while(len(doubling) < len(halving)):
    doubling.append(max(doubling)*2)

##put the columns in a data frame
import pandas as pd
half_double = pd.DataFrame(zip(halving,doubling)) #zip joins two tuples together

##remove rows whose entries in the halving column are even (19)
half_double = half_double.loc[half_double[0]%2 == 1,:] #the % (modulo) operator returns a remainder after division; loc from pandas lets us select specific rows
##answer = sum of the remaining doubling entries
sum(half_double.loc[:,1])

#Euclid's Algorithm (21)
##finding the greatest common divisor for two numbers
def gcd(x,y):
    larger = max(x,y)
    smaller = min(x,y)

    remainder = larger % smaller

    if(remainder == 0):
        return(smaller)

    if(remainder != 0):
        return(gcd(smaller,remainder))
gcd(105,33)

#Japanese Magic Squares
## A magic square is an array of unique , consecutive natural numbers such that all rows, columns, and main diagonals have the same sum
##Create a function that verfies if a matrix is a magic square
def verifysquare(square):
    sums = []
    rowsums = [sum(square[i]) for i in range(0, len(square))]
    sums.append(rowsums)
    colsums = [sum([row[i] for row in square]) for i in range(0, len(square))]
    sums.append(colsums)
    maindiag = sum([square[i][i] for i in range(0,len(square))])
    sums.append([maindiag])
    antidiag = sum([square[i][len(square) - 1 - i] for i in range(0,len(square))])
    sums.append([antidiag])
    flattened = [j for i in sums for j in i]
    return(len(list(set(flattened))) == 1)

verifysquare([[4,9,2],[3,5,7],[8,1,6]]) #loushu square