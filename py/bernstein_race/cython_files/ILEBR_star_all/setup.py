from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize("ILEBR_star_all.pyx")
)