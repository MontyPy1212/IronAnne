#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 16 11:01:39 2021

@author: Annie
"""

#1. Import the numpy package under the name np (★☆☆)
import numpy as np
import random


#2. Print the numpy version and the configuration (★☆☆)
print(np.__version__)
print(np.show_config())

#3. Create a null vector of size 10 (★☆☆)
print(np.zeros(10))

#4. How to find the memory size of any array (★☆☆)
n = np.zeros((2,2))
n1 = np.zeros((10))
print("%d bytes" % (n.size * n.itemsize))
print("%d bytes" % (n1.size * n1.itemsize))

#5. How to get the documentation of the numpy add function from the command line? (★☆☆)
#python -c "import numpy; numpy.info(numpy.add)"

#6. Create a null vector of size 10 but the fifth value which is 1 (★☆☆)
x = np.zeros(10)
x[4] = 1
print(x)

#7. Create a vector with values ranging from 10 to 49 (★☆☆)
print(np.arange(10,50))

#8. Reverse a vector (first element becomes last) (★☆☆)
x = np.arange(1,11)
x = x[::-1]
print(x)

#9. Create a 3x3 matrix with values ranging from 0 to 8 (★☆☆)
x = np.arange(0,9).reshape(3,3)
print(x)

#10. Find indices of non-zero elements from [1,2,0,0,4,0] (★☆☆)
non_zero = np.nonzero([1,2,0,0,4,0])
print(non_zero)

#11. Create a 3x3 identity matrix (★☆☆)
"""whats an identity matrix"""
i_m = np.eye(3)
print(i_m)

#12. Create a 3x3x3 array with random values (★☆☆)???
"""why only 3 values"""
z = np.random.uniform((3,3,3))
print(z)

#13. Create a 10x10 array with random values and find the minimum and maximum values (★☆☆)
z = np.random.random((10,10))
print(z)
z_min, z_max = z.min(), z.max()
print(z_min, z_max)

#14. Create a random vector of size 30 and find the mean value (★☆☆)
v = np.random.random(30)
print(v)
mean_v = v.mean()
print(mean_v)

#15. Create a 2d array with 1 on the border and 0 inside (★☆☆)



#16. How to add a border (filled with 0's) around an existing array? (★☆☆)

#17. What is the result of the following expression? (★☆☆)

#18. Create a 5x5 matrix with values 1,2,3,4 just below the diagonal (★☆☆)

#19. Create a 8x8 matrix and fill it with a checkerboard pattern (★☆☆)

#20. Consider a (6,7,8) shape array, what is the index (x,y,z) of the 100th element? (★☆☆)