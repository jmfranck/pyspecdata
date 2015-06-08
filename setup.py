#from setuptools import setup
import setuptools # I think this is needed for the following
from numpy.distutils.core import Extension,setup
from distutils.spawn import find_executable
import subprocess
import sys
import os
try:
    import PyQt4.QtCore
    import PyQt4.QtGui
except:
    raise RuntimeError("I couldn't import PyQt -- go install it first!!")
ext_test = Extension(name = 'pyspecdata.test_module',
        sources = ['pyspecdata/test_f90.pyf','pyspecdata/test_f90.f90','pyspecdata/anothertest.f90','pyspecdata/lprmpt.c','pyspecdata/fortrancall.h'],
        define_macros = [('ADD_UNDERSCORE',None)],
        )
ext_modules = [ext_test]

if os.name == 'nt':
    print "It looks like you're on windows, so I'm going to build lapack (from http://netlib.org/) on MinGW."
    target = os.path.dirname(os.path.dirname(find_executable('gcc'))) + os.sep + 'lib' + os.sep + 'gcc' + os.sep
    if 'liblapack.a' in os.listdir(target) and 'librefblas.a' in os.listdir(target):
        print "I see liblapack and librefblas in",target,"so I'm not going to rebuild"
    else:
        os.chdir('lapack-3.4.0')
        subprocess.call("cmd /c makelibs.bat")
        print "trying to move the built libraries to "+target
        os.rename('liblapack.a',target+'liblapack.a')
        os.rename('librefblas.a',target+'librefblas.a')
        print "press enter..."
        sys.stdin.readline(1)
        os.chdir('..')
ext_prop = Extension(name = 'pyspecdata.propagator',
        sources = ['pyspecdata/propagator.f90'],
        libraries = ['lapack','refblas'])
ext_modules.append(ext_prop)

tryagain = True
while tryagain == True:
    try:
        setup(
            name='pySpecData',
            author='J. M. Franck',
            version='0.1.0',
            packages=['pyspecdata'],
            license='LICENSE.md',
            description='object-oriented N-dimensional data processing with notebook functionality',
            long_description=open('README.rst').read(),
            install_requires=[
                "sympy",
                "numpy",
                "scipy",
                "matplotlib",
                "tables",
                "mayavi",
                ],
            ext_modules = ext_modules,
        #    entry_points=dict(
        #        notebook_info=["data_dir = pyspecdata:datadir ["+os.path.expanduser('~')+os.path.sep+'exp_data]']
        #        )
        )
        tryagain = False
    except:
        if len(ext_modules) == 2:
            print "something went wrong, so I'm going to try to rebuild without lapack -- this means you won't be able to use the prop module"
            print "this is OK, but press enter to acknowledge"
            sys.stdin.readline(1)
            ext_modules = [ext_test]
            tryagain = True
        elif len(ext_modules) == 1:
            print "something STILL went wrong, so I'm rebuilding without the fortran test module"
            print "this is OK, but press enter to acknowledge"
            sys.stdin.readline(1)
            ext_modules = []
            tryagain = True