from testy import symulation, test
import timeit


def sym(parameters_1, parameters_2):
    return symulation(parameters_1, parameters_2)


parameters_0 = [1, 1, 1]
n = 10
games_to_play = 1000
# cdef double x[100][2][3]
x = [[parameters_0, parameters_0]] * games_to_play

# print(timeit.timeit('sym([1,1,1], [1,1,1])',
#                     globals=globals(),
#                     number=n)/n)


print("asdas as" + "1223")

print(timeit.timeit('test(symulation, x)',
                    globals=globals(),
                    number=n) / n)
