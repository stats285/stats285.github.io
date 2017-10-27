<div class="abstract">   
<strong>Scaling Python to GPUs and Clusters: Dask and Numba and ideas for future work</strong>
<p align="justify">In this lecture, I will discuss how Numba and Dask help to scale the PyData ecosystem including NumPy and Pandas to GPUs cluster.  We will discuss the design of Numba and how it builds on the array-oriented foundations of NumPy and enables simple parallelization of compute kernels on the GPU.    We will then look at Dask and how it's design enables re-use of the PyData ecosystem while defining a standardized task-graph and approach to creating arbitrary parallel objects in Python.   Finally, we will take a look at the distributed schedule for Dask that has enabled Dask to scale Pandas-like and NumPy-like workflows to 1000s of machines using very similar APIs that users are familiar with.</p>  
    
<strong>Readings for this lecture</strong>  
<ol>
    <li>
    <a href=""> Reading 1 </a>
    </li>
</ol>
</div>


![Travis Oliphant](/assets/img/travis_oliphant.jpg)  
Travis Oliphant is President, Chief Data Scientist & Co-Founder of Continuum Analytics. He holds a PhD from the Mayo Clinic and BS and MS degrees in mathematics and electrical engineering from Brigham Young University. Since 1997, he has worked extensively with Python for numerical and scientific programming, most notably as the primary developer of the NumPy package, and as a founding contributor of the SciPy package. He is also the author of the definitive Guide to NumPy.

Travis was an assistant professor of electrical and computer engineering at BYU from 2001-2007, where he taught courses in probability theory, electromagnetics, inverse problems and signal processing. He also served as Director of the Biomedical Imaging Lab, where he researched satellite remote sensing, MRI, ultrasound, elastography and scanning impedance imaging.

As President and Chief Data Scientist of Continuum Analytics, Travis fosters the open source community and is dedicated to furthering the company’s open source projects. He also engages customers in all industries and helps guide technical direction of the company. He has served as a director of the Python Software Foundation and as a director of NumFOCUS. 
