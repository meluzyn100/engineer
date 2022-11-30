from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize("testy.pyx", language="c++")
)