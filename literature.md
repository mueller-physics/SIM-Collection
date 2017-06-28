--- 
layout: default
title: SIM publications
description: Fundamental and/or technical SIM papers
--- 

# Introduction

This page contains a commented collection of publications around super-resolution structured
illumination microscopy. This is mostly for me to keep track on where 
to find certain aspects written down and published, but might also be useful to others.


The publications listed here are on the technical side
of things, including
* [Fundamental papers](#fundamentals)
* [Building SIM microscopes](#building)
* SIM reconstruction algorithms
  * Parameter estimation
  * Filtering approaches
* Non-linear SIM

I do not try to cover application of SIM to biological problems here, there are just too
many papers out there that use SIM as a method for me to really keep track.


I'll try to update the list on an as-needed basis, but I've failed before.
If you think anything is missing, or my comments are wrong / off / incomplete, 
just let me know ([main page](../index.html) with contact info, or open an issue on github). 

# Fundamental papers <a name="fundamentals" />

The _standard_ SR-SIM microscope and reconstruction algorithm,
in use by all commercial systems and various home-built setups, 
is often attributed to and referred to as __Gustaffson-Heintzmann__-SIM:


* Conference proceeding by __R. Heintzmann__ (1999)
> Rainer Heintzmann and Christoph G Cremer. _Laterally modulated excitation microscopy:
> improvement of resolution by using a diffraction grating._ In BiOS Europe’98, pages 185–196.
> International Society for Optics and Photonics, 1999. [doi:10.1117/12.336833](http://dx.doi.org/10.1117/12.336833)

* 2D SIM by __M. Gustaffson__ (2000):
> Mats GL Gustafsson. Surpassing the lateral resolution limit by a factor of two using struc-
> tured illumination microscopy. Journal of microscopy, 198(2):82–87, 2000. 
> [doi:10.1046/j.1365-2818.2000.00710.x](http://dx.doi.org/10.1046/j.1365-2818.2000.00710.x)

* 3D SIM by __M. Gustaffson__ (2008):
> Mats GL Gustafsson, Lin Shao, Peter M Carlton, CJ Rachel Wang, Inna N Golubovskaya,
> W Zacheus Cande, David A Agard, and John W Sedat. _Three-dimensional resolution doubling 
> in wide-field fluorescence microscopy by structured illumination._ Biophysical journal,
> 94(12):4957–4970, 2008. [doi:10.1529/biophysj.107.120345](http://dx.doi.org/10.1529/biophysj.107.120345)

* There is also this __PhD thesis__ (2000):
> Jan Tillman Frohn. _Super-resolution fluorescence microscopy by structured ligth illumination._
> PhD thesis, Technische Wissenschaften ETH Zürich, 2000. Nr. 13916. 
> [doi:10.3929/ethz-a-004064016](http://dx.doi.org/10.3929/ethz-a-004064016)

More precisely, Gustaffson-Heintzmann-SIM typically refers to sinusoidal SIM illumination pat-
tern, which are amenable to a direct reconstruction approach.

# Building microscopes <a name="building" />

There are a few papers with details on how groups created home-built SIM setups.

* Setup based on a Hamamatsu SLM (thus, non-binary phase control), 2-beam SIM, 4 pattern
orientations (0, 45, 90, 135, easy pattern generation). I think this might be first SLM-based
SIM paper (2009):
> Bo-Jui Chang, Li-Jun Chou, Yun-Ching Chang, and Su-Yu Chiang. _Isotropic image in structured 
> illumination microscopy patterned with a spatial light modulator._ Optics express,
> 17(17):14710–14721, 2009. [doi:10.1364/OE.17.014710](http://dx.doi.org/10.1364/OE.17.014710)

* Setup based on a TI DMD (thus binary), and using incoherent (LED) light. Keep in mind that using
incoherent light will not give a full 2x resolution improvement.
> Dan Dan, Ming Lei, Baoli Yao, Wen Wang, Martin Winterhalder, Andreas Zumbusch, Yujiao
> Qi, Liang Xia, Shaohui Yan, Yanlong Yang, et al. _DMD-based led-illumination super-resolution
> and optical sectioning microscopy._ 
> Scientific reports, 3, 2013. [doi:10.1038/srep01116](http://dx.doi.org/10.1038/srep01116)

* Setup based on the Forth-DD ferro-electric SLM (binary, phase shift), device also in use by
Betzig, setup very fast:
> Hui-Wen Lu-Walther, Martin Kielhorn, Ronny Förster, Aurélie Jost, Kai Wicker, and Rainer
> Heintzmann. _fastsim: a practical implementation of fast structured illumination microscopy._
> Methods and Applications in Fluorescence, 3(1):014001, 2015. 
> [doi:10.1088/2050-6120/3/1/014001](http://dx.doi.org/10.1088/2050-6120/3/1/014001)

* Also interesting: This paper has calculations (ray-tracing) on how the polarization of the inter-
fering light influences pattern contrast:
> Kevin O’Holleran and Michael Shaw. _Polarization effects on contrast in structured illumination
> microscopy._ Optics letters, 37(22):4603–4605, 2012. [doi:10.1364/OL.37.004603](http://dx.doi.org/10.1364/OL.37.004603)

# Reconstruction / Algorithms

SIM reconstruction is usually a two-step process:
1. _Parameter estimation_: Obtaining pattern orientation and frequency, obtaining (global and
something pattern-individual) phase offsets. This can in principle be done
through different algorithms, with varying performance and sometimes hard-to-find documentation.

2. _Reconstruction_: Band separation, shift and recombination through filters. This step is usually 
rather straight-forward to implement.

## Parameter estimation

* The SIM pattern causes a peak in the Fourier spectrum of a raw data frame under structured
illumination. That peak can in principle be used to obtain pattern orientation, frequency
(position of the peak) and phase of the patter (complex phase of the peak).
From the analysis in the paper and my experience, this method will work o.k. if the resolution
enhancement is not too high, i.e. if the peak associated with the illumination pattern is not
dampened too much by the OTF. As an advantage, it is easy to implement.
> Sapna A Shroff, James R Fienup, and David R Williams. _Phase-shift estimation in sinusoidally
> illuminated images for lateral superresolution_. JOSA A, 26(2):413–424, 2009. 
> [doi:10.1364/JOSAA.26.000413](http://dx.doi.org/10.1364/JOSAA.26.000413)

* Approach by cross-correlation of separated bands. The idea here is that the separated
spectra have overlapping regions, so the correct shift (angle, frequency, global phase, modulation depth) 
can be found by maximizing the cross-correlation of these bands in respect to a
complex shift vector. 
To my knowledge, this is the method of choice to obtain SIM reconstruction parameters,
in use e.g. even for the current work of non-linear SIM. It is also the only method I know to
obtain pattern frequency and angle, while the phases can be refined by further means.
The idea is already explained in one paragraph in _Gustafsson 2008_, but not written
down in detail. A quite detailed description can however be found in this review:
>   Qiang Yang, Liangcai Cao, Hua Zhang, Hao Zhang, and Guofan Jin. 
>   _Method of lateral image reconstruction in structured illumination microscopy with super resolution._
>   Journal of Innovative Optical Health Sciences, page 1630002, 2015. 
>   [doi:10.1142/S1793545816300020](http://dx.doi.org/10.1142/S1793545816300020)


* Iterative phase optimization: The cross-correlation will only yield one global phase, with phase
differences between patterns assumed as fixed (and set in the band separation matrix). The
iterative approach optimizes these phases by analyzing their shift through cross-correlation in
the raw data. It seems like a very sound approach, but it takes some time to implement correctly.
> Kai Wicker, Ondrej Mandula, Gerrit Best, Reto Fiolka, and Rainer Heintzmann. _Phase
> optimisation for structured illumination microscopy._ Optics express, 21(2):2032–2049, 2013.
> [doi:10.1364/OE.21.002032](http://dx.doi.org/10.1364/OE.21.002032)

* Non-Iterative phase optimization: A follow-up to the last paper, this performs phase 
optimization in a single step. The algorithm is easy to understand and implement, the paper
provides comparisons to the iterative method (performance similar for realistic SNRs):
> Kai Wicker. _Non-iterative determination of pattern phase in structured illumination 
> microscopy using auto-correlations in fourier space._ Optics express, 21(21):24692–24701, 2013.
> [doi:10.1364/OE.21.024692](http://dx.doi.org/10.1364/OE.21.024692)



