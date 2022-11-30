import cython
from libcpp.vector cimport vector

cdef vector[int] vect
cdef int i
for i in range(10):
    vect.push_back(i)

print(vect)