r'''This package contains the Fourier transformation methods belonging to :class:`nddata`'''
from ..general_functions import inside_sphinx
# I name these all with "fourier" since they need to be renamed inside the main class
__all__ = [ "_ft_conj",
            "convolve",
            "ft",
            "ftshift",
            "shear",
            "ift",
            ]

if not inside_sphinx():
    from . import * # needed so that pyspecdata.fourier contains all the previous names
else:
    pi = 3.14
