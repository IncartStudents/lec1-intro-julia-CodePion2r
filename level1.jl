# Print

println("I'm exited to learn Julia!")


# Variables

my_answer = 42
typeof(my_answer)

my_pi = 3.14159
typeof(my_answer)

my_name = "Jane"
typeof(my_answer)

my_answer = my_name
typeof(my_answer)


# comments

# Single-line comment

#=
Multi-line comment
Some text
=#


# Basic math operations

sum = 3 + 7
diff = 10 - 3
product = 20 * 5
quotient = 100 / 10
power = 10 ^ 2


# Strings

s1 = "I'm a string"
s2 = """I'm also a string. """

typeof('a')

# Interpolation

name = "Jane"
num_fingers = 10
num_toes = 10
println("Hello, my name is $name.")
println("I have $num_fingers fingers and $num_toes toes")

# Concatenation

s1= "How many cats"
s2 = "are too many cats?"

string("How many cats", "are too many cats?")
string("I have read", 2, "books today")
s1*s2
"s1$s2"


# Dict

myphonebook = Dict("Jenny" => "867-5309", "Mark" => "555-2378")
myphonebook["Kramer"] = "555-8885"
pop!(myphonebook, "Kramer")
myphonebook[1] 

# Tuple

myfavanimals = ("cats", "dogs", "cows")
myfavanimals[1]
myfavanimals[1] = "monkeys" 


# Array

myfriends = ["Tod", "Lina", "Nick"] 
fibonacci = [1, 1, 2, 3, 5, 8, 13]
mixedarray = [1, 2, 3.0, "hi"] 

myfriends[1] -> "Tod"
myfriends[3] = "Edith" 


push!(fibonacci, 21) 
pop!(fibonacci)
fibonacci

matrix = [[1, 2, 3], [4, 5], [6, 7, 8]]
rand(4, 3)
rand(4, 3, 2)


# Loops

# while

n = 0
while n < 10
	n += 1
	println(n)
end

myfriends = ["Tod", "Lina", "Nick"]
i = 1
while i <= length(myfriends)
	friend = myfriends[i]
	println("Hi $friend")
	i += 1
end

# for

for n in 1:10
	println(n)
end
	
myfriends = ["Tod", "Lina", "Nick"]
for friend in myfriends
	println("Hi $friend")
end

# "in" equals to "=" or to "∊"

m, n = 5, 5
A = zeros(m, n)

for i in 1:m
	for j in 1:n
		A[i, j] = i + j
	end
end

B = zeros(m, n)
for i in 1:m, j in 1:n
	B[i, j] = i+ j
end

C = [i + j for i in 1:m, j in 1:n]

for n in 1:10
	A[i + j for i in 1:n, j in 1:n]
	display(A)
end

#Conditionals
x = 50
y = 36

if x > y
	println("$x is larger than $y")
elseif y > x
	println("$y is larger than $x")
else
	println("$x and $y are equal")
end

if x > y
	x
else
	y
end

(x > y) ? x : y

(x > y) && print("$x is larger than $y")
(x < y) && print("$x is smaller than $y")

#Functions

function sayhi(name)
	println("Hi $name, it's great to see you!")
end

function f(x)
	x^2
end

sayhi("Donald")
f(95)

sayhi2(name) = println("Hi $name, it's great to see you!")
f2(x) = x^2

sayhi2("MCDonald")
f2(9)

sayhi3 = name -> println("Hi $name, it's great to see you!")
f3 = x -> x^2

sayhi3("MCDonalds")
f3(5)

sayhi(15852144)

A = rand(3,3)
A

f(A)

v = rand(3)
f(v)

v = [3, 5, 2]
sort(v)
v

sort!(v)
v

#Broadcasting

A = [i + 3*j for j in 0:2, i in 1:3]
f(A)
B = f.(A)

v = [1, 2, 3]
f.(v)

#Packages
#Pkg.add("Example")
using Example
hello("it's me")

#Pkg.add("Colors")
using Colors
palette = distinguishable_colors(100)
rnd(palette, 3, 3)

#Plotting
#Pkg.add("Plots")
using Plots

x = -3:0.1:3
f(x) = x^2

y = f.(x)

gr()

plot(x, y, label="line")
scatter!(x, y, label="points")

plotlyjs()

plot(x, y, label="line")
scatter!(x, y, label="points")

globaltemperatures = [14.4, 14.5, 14.8, 15.2, 15.5, 15.8]
numpirates = [45000, 20000, 15000, 5000, 400, 17]

plot(numpirates, globaltemperatures, legend=false)
scatter!(numpirates, globaltemperatures, legend=false)

xflip!()

xlabel!("Number of Pirates")
ylabel!("Global Temperature (C)")
title!("Influence of pirate population on global warming")

p1 = plot(x, x)
p2 = plot(x, x.^2)
p3 = plot(x, x.^3)
p4 = plot(x, x.^4)
plot(p1, p2, p3, p4, layout=(2,2), legend=false)

#Multiple dispatch
methods(+)

@which 3 + 3
@which 3.0 + 3.0
@which 3 + 3.0

import Base: +
"hello " + "world!"
@which "hello " + "world!"

+(x::String, y::String) = string(x, y)
"hello " + "world!"
@which "hello" + "world!"

foo(x, y) = println("duck-typed foo!")
foo(x::Int, y::Float64) = println("foo with integer and float!")
foo(x::Float64, y::Float64) = println("foo with two floats!")
foo(x::Int, y::Int) = println("foo with two integers!")

foo(1, 1)
foo(1., 1.)
foo(1, 1.0)
foo(true, false)

# Basic linear Algebra

A = rand(1:4,3,3)
B = A
C = copy(A)
[B C]

A[1] = 17
[B C] # B and A references to the same memory

x = ones(3)
b = A*x
Asym = A + A'

Apd = A'A # Apd = A' * A
A\b # Solving linear systems Ax = b for square A

Atall = A[:, 1:2]
display(Atall)
Atall\b

A = randn(3, 3)
[A[:, 1] A[:, 1]]\b

Ashort = A[1:2,:]
display(Ashort)
Ashort\b[1:2]



