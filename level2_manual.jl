# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
const PI = 3.14159
PI = 3.14

#WARNING: redefinition of constant Main.PI. This may fail, cause incorrect answers, or produce other errors.
#Интерпретатор выдает предупреждение о том, что происходит переопределение константы, что может привести к ошибкам в будущем

# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1 #Int
b = 2.0 #Float64
c = a + b #Float64
# Переменная c будет иметь тип Float64, так как происходит автоматическое приведение типов при сложении.

# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo"
# Теперь переменная а типа String; переменная связывается с определенным значением в памяти, биндинг позволяет переменным указывать на разные значения в разные моменты времени.

# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1
g = "hi"

function greet()
    g = "hello"
    println(g)
end
greet()

# Глобальная переменная g сначала равна 1, затем hi. Далее в цикле создается локальная переменная g, которая не связана с глобальной, то есть глобальная переменная в цикле не изменяется
# Ограничения биндинга: локальные и глобальные переменные; если переменную объявили с конкретным типом (g::Int), то это может привести к предупреждениям

# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v # z указывает на тот же массив, что и v
v[1] = 3 #  v и z = [3, 2, 3]
v = "hello" # v = 'hello', z по-прежнему указывает на массив [3, 2, 3]
z # [3, 2, 3]
# Присвоение значений новому имени cоздает новое связывание с существующим объектом
# Мутация значений изменяет содержимое объекта, на который указывает переменная, не меняя само связывание переменной

# Написать тип, параметризованный другим типом
struct Box{T}
    value::T
end

int_box = Box(42)
float_box = Box(3.14)
string_box = Box("Julia")

println(int_box.value) # 42 
println(float_box.value) # 3.14
println(string_box.value) # Julia
#=
Написать функцию для двух аругментов, не указывая их тип,
и вторую функцию от двух аргментов с конкретными типами,
дать пример запуска
=#
function add(a, b)
    return a + b 
end

function add_ints(x::Int, y::Int)
    return x + y  
end

result1 = add(10, 30)
result2 = add(10.5, 30.5)

result3 = add_ints(50, 80)


println(result1) # 40
println(result2) # 41
println(result3) # 130
#=
Абстрактный тип - ключевое слово?
abstract type
Примитивный тип - ключевое слово?
Int, Float64, Bool, Char, ...
Композитный тип - ключевое слово?
struct
=#

#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#
abstract type Animal end
struct Dog <: Animal
    name::String
end

struct Cat <: Animal
    name::String
end

function describe(animal::Animal)
    println("This is animal!")
end

function describe(dog::Dog)
    println("This is a dog named $(dog.name).")
end

dog = Dog("Buddy")
cat = Cat("Whiskers")

describe(dog) # This is a dog named Buddy.
describe(cat) # Вывод: This is an animal. Так как у Cat нет собственной версии describe, поэтому принимает Animal

#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

# Пример обычной функции
function add(a, b)
    return a + b 
end
# Пример лямбда-функции (аннонимной функции)
add = (x, y) -> x + y
result1 = add(3, 5)   
# Пример функции с переменным количеством аргументов
function sum_numbers(args...)
    return sum(args)
end

result1 = sum_numbers(1, 2, 3) # 6
result2 = sum_numbers(10, 20, 30, 40, 50) # 150
result3 = sum_numbers() # 0
# Пример функции с именованными аргументами
function greet(name; greeting="Hello")
    return "$greeting, $name!"
end

message1 = greet("Alice") 
message2 = greet("Bob"; greeting="Hi")        
    
# Функции с переменным кол-вом именованных аргументов
function print_info(; kwargs...)
    for (key, value) in kwargs
        println("$key: $value")
    end
end

print_info(name="Alice", age=30, city="New York")
print_info(job="Engineer", hobby="Photography", country="USA")
#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#

function calculate(a, b)
    return a + b, a - b, a * b, a / b
end

results = calculate(10, 2)

sum_result, diff_result, product_result, division_result = results

println("Sum: ", sum_result)              # Вывод: Sum: 12
println("Difference: ", diff_result)       # Вывод: Difference: 8
println("Product: ", product_result)       # Вывод: Product: 20
println("Division: ", division_result)     # Вывод: Division: 5.0
#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
- через loop fusion и
- с помощью reduce
=#
arr = [1 , 2, 3 , 4, 5]
result_fusion = prod(arr)
result_reduce = reduce(*, arr)
#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
с помощью точки (broadcast)
c помощью map
c помощью list comprehension
указать, чем это лучше явного цикла?
=#
function square(x)
    return x^2
end

squared_broadcast = square.(arr)
squared_map = map(square, arr)
squared_comprehension = [square(x) for x in arr]
# Улучшение проихводительности, лучшая читаемость

# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
row_vector = [1 2 3]
column_vector = [10, 20, 30] 
result = row_vector * column_vector
# Вывод: 140. Так как по формуле для скалярного умножения получаем данное число.

# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
arr = [1, -2, 2, 3, 4, -5, 0]
result = [x for x in arr if x > 0 && x % 2 == 0]

# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
# ---
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))
numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
numbers_sorted = sort(numbers)
number = findfirst(n -> !(n in numbers_sorted), 0:9)

# В итоге переменная number будет содержать первое число от 0 до 9, которое не присутствует в массиве numbers_sorted

# Упростить этот код обработки:
using Random
Random.seed!(123)
numbers = unique(parse.(Int, map(x -> split(x, "_")[end], filter(x -> startswith(x, "A"), 
    [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]))))

number = findfirst(n -> !(n in numbers), 0:9)

#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#

#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#
struct LazyArray
end

function Base.getindex(::LazyArray, index::Int)
    return (index - 1)^2
end

lazy_array = LazyArray()

println(lazy_array[1])  # Вывод: 0
println(lazy_array[2])  # Вывод: 1
println(lazy_array[3])  # Вывод: 4
println(lazy_array[4])  # Вывод: 9
println(lazy_array[5])  # Вывод: 16
#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#
# abstract type AbstractCommand end
# apply!(cmd::AbstractCommand, target::Vector) = error("Not implemented for type $(typeof(cmd))")

abstract type AbstractCommand end

function apply!(cmd::AbstractCommand, target::Vector)
    error("Not implemented for type $(typeof(cmd))")
end

struct SortCmd <: AbstractCommand
end

function apply!(cmd::SortCmd, target::Vector)
    sort!(target)
end

struct ChangeAtCmd <: AbstractCommand
    i::Int  
    val::Any 
end

function apply!(cmd::ChangeAtCmd, target::Vector)
    target[cmd.i] = cmd.val 
end

arr = [5, 3, 8, 1, 2]

sort_command = SortCmd()
apply!(sort_command, arr)
println("Sorted array: ", arr)  # Вывод: Sorted array: [1, 2, 3, 5, 8]

change_command = ChangeAtCmd(2, 10) 
apply!(change_command, arr)
println("Array after change: ", arr)  # Вывод: Array after change: [1, 10, 3, 5, 8]


# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
sort_cmd = () -> (arr) -> sort!(arr)
change_at_cmd = (i, val) -> (arr) -> (arr[i] = val)

arr = [5, 3, 8, 1, 2]

sort_command = sort_cmd()
sort_command(arr)

change_command = change_at_cmd(2, 10)
change_command(arr)

#===========================================================================================
5. Тесты: как проверять функции?
=#

# Написать тест для функции

using Test

function square(x)
    return x^2
end


@testset "Square Function Tests" begin
    @test square(2) == 4
    @test square(-3) == 9
    @test square(0) == 0 
end
#===========================================================================================
6. Дебаг: как отладить функцию по шагам?
=#

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова
=#
using Debugger

function sum_array(arr)
    total = 0
    @bp 
    for num in arr
        total += num
    end
    return total
end

@enter sum_array([1, 2, 3, 4, 5])

#===========================================================================================
7. Профилировщик: как оценить производительность функции?
=#

#=
Оценить производительность функции с помощью макроса @profview,
и добавить в этот репозиторий файл со скриншотом flamechart'а
=#
using Profile
using Random

function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1, 1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end
@profview generate_data(1_000_000)

function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

@time generate_data(1_000_000);


# Переписать функцию выше так, чтобы она выполнялась быстрее:

using Random

function generate_data(len)
    vec1 = randn(len)
    sort!(vec1)        
    vec3 = vec1 .^ 3 .- (sum(vec1) / len)  
    return vec3
end

@time generate_data(1_000_000);
#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#

#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#
function first_difference(x::Vector{T}) where T
    y = zeros(T, length(x))  

    for i in 2:length(x)
        y[i] = x[i] - x[i - 1]
    end

    return y
end
x = [1.0, 2.0, 4.0, 7.0, 11.0]
y = first_difference(x)

println("Input array: ", x)
println("First difference: ", y)
#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#
function first_difference!(x::Vector{T}, y::Vector{T}) where T
    if length(y) != length(x)
        throw(ArgumentError("Output array y must have the same length as input array x"))
    end

    y[1] = 0

    for i in 2:length(x)
        y[i] = x[i] - x[i - 1]
    end
end

x = [1.0, 2.0, 4.0, 7.0, 11.0]
y = zeros(Float64, length(x))

first_difference!(x, y)
println("Input array: ", x)
println("First difference: ", y)
#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#
function add_to_end!(arr::Vector{T}, value::T) where T
    push!(arr, value)  # Добавляем элемент в конец массива
end

function add_to_start!(arr::Vector{T}, value::T) where T
    push!(arr, value)  # Сначала добавляем элемент в конец
    for i in length(arr):-1:2  # Сдвигаем элементы вправо
        arr[i] = arr[i - 1]
    end
    arr[1] = value  # Устанавливаем новый элемент на первое место
end

function add_to_middle!(arr::Vector{T}, value::T) where T
    mid_index = div(length(arr), 2)  # Находим индекс середины
    push!(arr, arr[end])  # Увеличиваем размер массива
    for i in length(arr)-1:-1:mid_index+1  # Сдвигаем элементы вправо
        arr[i] = arr[i - 1]
    end
    arr[mid_index + 1] = value  # Устанавливаем новый элемент в середину
end

arr = [1, 2, 3, 4]

add_to_end!(arr, 5)
println("After adding to end: ", arr)  # Вывод: [1, 2, 3, 4, 5]

add_to_start!(arr, 0)
println("After adding to start: ", arr)  # Вывод: [0, 1, 2, 3, 4, 5]

add_to_middle!(arr, 2.5)
println("After adding to middle: ", arr)  # Вывод: [0, 1, 2, 2.5, 3, 4, 5]
#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
# module Foo
#     #export ?
# end
# # using .Foo ?
# # import .Foo ?

module Foo

function add(a::Number, b::Number)
    return a + b
end

function subtract(a::Number, b::Number)
    return a - b
end

export add

end

using .Foo

result_add = add(5, 3)
println(result_add)  # 8

result_subtract = Foo.subtract(5, 3)
println(result_subtract)  # 2

#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
#=
Environment — это набор пакетов и их версий, которые используются в проекте.
using Pkg
Pkg.activate("имя_окружения")
После активации окружения добавляем пакеты:
Pkg.add("ИмяПакета")
Чтобы поменять во время работы окружение:
Pkg.activate("имя_окружения")
=#

# Что такое пакет (package), как добавить новый пакет?
#=
Package — это набор кода, который предоставляет определенные функции, типы данных и другие возможности для использования в работе
using Pkg
Pkg.activate("MyProject")
Pkg.add("Plots")
Pkg.status()
=#


# Как начать разрабатывать чужой пакет?
#=
Склонироватать репозиторий пакета, далее ативировать его как окружение:
using Pkg
Pkg.activate("путь_к_пакету")
Можно добавить зависимостей, если нужно:
Pkg.add("ИмяПакета")
Далее внести изменения в код проекта, написать тесты
=#

#=
Как создать свой пакет?
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)
=#


#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#
using Pkg
Pkg.add("JLD2")
# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
using JLD2

data1 = [1, 2, 3, 4, 5]
data2 = Dict("a" => 1, "b" => 2, "c" => 3)
data3 = (name = "Julia", version = v"1.6.0")

@save "data.jld2" data1 data2 data3

loaded_data = @load "data.jld2"

loaded_data1 = loaded_data["data1"] 
loaded_data2 = loaded_data["data2"] 
loaded_data3 = loaded_data["data3"]  

println( data1 == loaded_data1)  # true
println(data2 == loaded_data2)  # true
println(data3 == loaded_data3)  # true


println(loaded_data1)
println(loaded_data2)
println(loaded_data3)
# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames") 

using CSV
using DataFrames

original_data = DataFrame(A = [1, 2, 3, 4, 5], B = ["a", "b", "c", "d", "e"])

CSV.write("data.csv", original_data)

loaded_data = CSV.File("data.csv") |> DataFrame

println(original_data)

println(loaded_data)

println(original_data == loaded_data)  # true

#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?

Если есть папка MyProject, в которой есть main.jl
julia --project=MyProject main.jl
=#

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl
б) из текста команды? (см. флаг -e)

Запуск скрипта:
julia myscript.jl

Использование флага -e:
julia -e 'println("Hello from command line!")'
=#

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
