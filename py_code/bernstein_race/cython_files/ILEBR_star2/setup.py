from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize("ILEBR_star2.pyx")
)
