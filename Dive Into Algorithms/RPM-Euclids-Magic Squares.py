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

#Kurushima's Algorithm pg.24
## works only for magic squares of odd dimensions, meaning it works for any nxn squre if n is odd.
n = 7
#we do not know what numbers to put in the square so fill it with entries equal to float('nan') as a placeholder
square = [[float('nan') for i in range(0,n)] for j in range(0,n)]
print(square)
#write function to output in a more readable way
def printsquare(square):
    labels = ['['+str(x)+']' for x in range(0,len(square))]
    format_row = "{:>6" * (len(labels) +1)
    print(format_row.format("", *labels))
    for label, row in zip(labels, square):
        print(format_row.format(label, *row))

import math
#indices of central entry
center_i = math.floor(n/2)
center_j = math.floor(n/2)
#central five squares population
square[center_i][center_j] = int((n**2 +1)/2)
square[center_i + 1][center_j] = 1
square[center_i - 1][center_j] = n**2
square[center_i][center_j + 1] = n**2 + 1 - n
square[center_i][center_j - 1] = n

#specifying the three rules
## The purpose of Kurushima's algorithm is to fill in the remaining nan entries according to these rules
def rule1(x,n,upright):
    return((x+((-1)**upright) * n)%n**2) # ** =exponentiation and % = Modulus

print(rule1(1,3,True))

def rule2(x,n,upleft):
    return((x + ((-1)**upleft))%n**2)

def rule3(x,n,upleft):
    return((x + ((-1)**upleft * (-n + 1)))%n**2)

#filling in the rest of the square
center_i = math.floor(n/2)
center_j = math.floor(n/2)

import random
entry_i = center_i
entry_j = center_j
where_we_can_go = ['up_left','up_right','down_left','down_right']
where_to_go = random.choice(where_we_can_go)

