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
* [Reviews, Overviews, Protocols](#sim-reviews)
* [Building SIM microscopes](#building)
* _direct/classic_ SIM [reconstruction algorithms](#reconstruction)
  * [Parameter estimation](#parameter)
  * [Noise filtering approaches](#filters)
  * [Optical sectioning](#sectioning)
* Software packages
  * [SIM reconstruction](#software-reconstruction)
  * [Analysis and quality checks](#software-checks)
  * [general image processing](#software-image-processing)
  * [localization microscopy](#software-localization)
* [Non-linear SIM](#non-linear-sim)

I do not try to cover application of SIM to biological problems here, there are just too
many papers out there that use SIM as a method for me to really keep track.


I'll try to update the list on an as-needed basis, but I've failed before.
If you think anything is missing, or my comments are wrong / off / incomplete, 
just let me know ([main page](../index.html) with contact info, or open an issue on github).

I also try to maintain a [bibtex file](resources/literature.bib) up to date with this list,
to make is easier to integrate citations.

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

# Reviews and Overview <a name="sim-reviews">

Certainly not a complete list, but the following are reviews, overview articles and protocols
that might be helpful:

* A practical guide on how to perform SIM measurements, and how to assess their quality, 
from the Schermelleh lab. These guys have lots of experience with running OMX microscopes,
taking calibration measurements (OTFs, etc.) and checking for / avoiding SIM artifacts.
> Demmerle, Justin, Cassandravictoria Innocent, Alison J. North, Graeme Ball, 
> Marcel Müller, Ezequiel Miron, Atsushi Matsuda, Ian M. Dobbie, Yolanda Markaki, 
> and Lothar Schermelleh. _Strategic and practical guidelines for successful structured illumination microscopy._
> Nat. Protoc, 2017. [doi:10.1038/nprot.2017.019](https://doi.org/10.1038/nprot.2017.019)




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

# _direct_ reconstruction algorithms <a name="reconstruction">

This describes the _direct_ (now almost somewhat _classic_) reconstruction approach as introduces 
by the Gustafsson-Heitzmann-papers, i.e.: The sample is illuminated with a finite number
of overlapping sinusoidal intensity patterns, these become a finite number of delta-peaks
in Fourier space, which in turn allows for a direct (non-iterative) solution to a set of
linear equation. In contrast, newer algorithms use iterative solvers and what could be
called deconvolution-like approaches to SIM, with different advantages and drawbacks over
the classic methods.

The direct SIM reconstruction is a multi-step process:
1. _Parameter estimation_: Obtaining pattern orientation and frequency, obtaining (global and
something pattern-individual) phase offsets. This can in principle be done
through different algorithms, with varying performance and sometimes hard-to-find documentation.

2. _Reconstruction_: (2a) Band separation, shift and (2b) recombination through filters. This step is usually 
rather straight-forward to implement, though the choice of filters (or _regularization_) can make a huge
difference in image quality.

## Parameter estimation <a name="parameter">

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
the raw data. It seems like a very sound approach, but it probably takes some time to implement correctly.
> Kai Wicker, Ondrej Mandula, Gerrit Best, Reto Fiolka, and Rainer Heintzmann. _Phase
> optimisation for structured illumination microscopy._ Optics express, 21(2):2032–2049, 2013.
> [doi:10.1364/OE.21.002032](http://dx.doi.org/10.1364/OE.21.002032)

* Non-Iterative phase optimization<a name="phase2013"/>: A follow-up to the last paper, this performs phase 
optimization in a single step. The algorithm is easy to understand and implement, the paper
provides comparisons to the iterative method (performance similar for realistic SNRs). 
[fairSIM](http://www.fairsim.org) has some code to run this optimization, though it is currently
not accessible directly through the GUI.
> Kai Wicker. _Non-iterative determination of pattern phase in structured illumination 
> microscopy using auto-correlations in fourier space._ Optics express, 21(21):24692–24701, 2013.
> [doi:10.1364/OE.21.024692](http://dx.doi.org/10.1364/OE.21.024692)

## Filters <a name="filters"/>

The last step of a SIM reconstruction is the recombination of frequency bands. Since the bands
are OTF-corrected, a suitable filter needs to be applied. Typically (i.e., in the original publications), 
this is a modified/generalized Wiener-type filter, however other regularization methods can be applied.

There is often some discussion about "linearity" of filters, i.e. if they can change relative intensities,
which might be seen as a disadvantage of e.g. Richardson-Lucy-like iterative deconvolution methods.


* Optimization of modulation depth, spatially varying illumination intensity and such. A very
early paper (2004), I don't know if any if and where any of this has been implemented.
> LH Schaefer, D Schuster, and J Schaffer. _Structured illumination microscopy: artefact analysis
> and reduction utilizing a parameter optimization approach._ Journal of microscopy, 216(2):165–
> 174, 2004. [doi:10.1111/j.0022-2720.2004.01411.x](http://dx.doi.org/10.1111/j.0022-2720.2004.01411.x)

* For good cameras, photon counts are highly dominated by Poisson noise (photon count statistics)
compared to Gaussian noise (electron read-out noise). Since the Wiener filter is not tuned to
that, other filter approaches might yield better results. Again, I am not aware of any implementation
of this in use.
> Kaiqin Chu, Paul J McMillan, Zachary J Smith, Jie Yin, Jeniffer Atkins, Paul Goodwin, Sebastian 
> Wachsmann-Hogiu, and Stephen Lane. _Image reconstruction for structured-illumination
> microscopy with low signal level._ Optics express, 22(7):8687–8702, 2014. 
> [doi:10.1364/OE.22.008687](http://dx.doi.org/10.1364/OE.22.008687)

* Using [Richardson-Lucy](#richardson-lucy) for both sectioning and also filtering.

# Optical sectioning (in single-slice / 2D SIM) <a name="sectioning" />

SIM reconstructions can be done in either 2D (single slice, one focal plane) or 3D (requires z-stack
and 3D OTF). Single slice reconstructions are independent of the illumination mode (2-beam or
3-beam interference), and even profit of 3-beam illumination for the following trick:
To reduce the out-of-focus light, i.e. to introduce optical sectioning, the 2D OTF is re-weighted
in such a way that SIM bands do not contribute around their missing cone. To use this trick,
one either needs three-beam data (which has the medium band overlapping all missing cones) or
two-beam data set to less than the maximum resolution improvement. The idea is mentioned in
the appendix of [the non-iterative phase optimization paper](#phase2013), and documented in two more papers:

* The approach itself:
> Kevin O’Holleran and Michael Shaw. _Optimized approaches for optical sectioning and resolution
> enhancement in 2d structured illumination microscopy._ Biomedical optics express, 5(8):2580–2590,
> 2014.
> [doi:10.1364/BOE.5.002580](http://dx.doi.org/10.1364/BOE.5.002580)

* Application to high-speed single-slice SIM:
> Michael Shaw, Lydia Zajiczek, and Kevin O’Holleran. _High speed structured illumination 
> microscopy in optically thick samples._ Methods, 88:11–19, 2015. 
> [doi:10.1364/OL.37.004603](http://dx.doi.org/10.1364/OL.37.004603)

Another more recent approach is to use Richardson-Lucy filtering on both the SIM raw input
data, and as a replacement of the Wiener filtering step in the results. This allows for
sectioning even without the OTF overlap, and in my experience yields very nice result
as long as the SNR is good enough (i.e. it can remove out-of-focus background, but relies
on data with good signal / low noise).

* <a name="richardson-lucy" /> Using Richardson-Lucy filtering
> Perez, Victor, Bo-Jui Chang, and Ernst Hans Karl Stelzer. 
> _Optimal 2D-SIM reconstruction by two filtering steps with Richardson-Lucy deconvolution._
>  Scientific reports 6, 37149, 2016. [doi:10.1038/srep37149](http://dx.doi.org/10.1038/srep37149)

# Software

## SIM image reconstruction <a name="software-reconstruction">

* Of course [fairSIM](http://www.fairsim.org). Currently single-slice (3D is in progress), 
with cross-correlation parameter estimation, handles two-beam and three-beam data 
(more bands work, but not through GUI), and offers optical sectioning through both
OTF attenuation and [RL-deconvolution](#richardson-lucy).
> Marcel Müller, Viola Mönkemöller, Simon Hennig, Wolfgang Hübner, and Thomas Huser.
> _Open-source image reconstruction of super-resolution structured illumination microscopy data
> in ImageJ_. Nature Communications, 7, 2016 [doi:10.1038/ncomms10980](http://dx.doi.org/10.1038/ncomms10980).

* Also, there is [OpenSIM](https://github.com/LanMai/OpenSIM), 
a collection of Matlab functions to build and test SIM reconstructions:
> Amit Lal, Chunyan Shan, and Peng Xi. _Structured illumination microscopy image reconstruction algorithm._
> IEEE Journal of Selected Topics in Quantum Electronics, 22(4), 2016.
> [doi:10.1109/JSTQE.2016.2521542](http://dx.doi.org/0.1109/JSTQE.2016.2521542)


* And another, bigger Matlab-based software, where however the direct "stardard" SIM 
reconstruction approach does not seem not to be their main focus: 
> Pavel Křížek, Tomáš Lukeš, Martin Ovesnỳ, Karel Fliegel, and Guy M
> Hagen. _Simtoolbox: a matlab toolbox for structured illumination fluorescence microscopy._
> Bioinformatics, 32(2):318–320, 2016. 
> [doi:10.1093/bioinformatics/btv576](http://dx.doi.org/10.1093/bioinformatics/btv576)


## SIM analysis / quality checks <a name="software-checks" />

* The "SIMcheck" plugin. Thorough analysis of the input data quality. Last time I’ve checked, mainly for 3D SIM:
> Graeme Ball, Justin Demmerle, Rainer Kaufmann, Ilan Davis, Ian M Dobbie, and Lothar Schermelleh. 
> _Simcheck: a toolbox for successful super-resolution structured illumination microscopy._
> Scientific reports, 5, 2015. doi:10.1038/srep15915

## General image processing for microscopy <a name="software-image-processing" /> 

The publications to cite when using ImageJ and Fiji:

* ImageJ:
> Caroline A Schneider, Wayne S Rasband, and Kevin W Eliceiri. _NIH image to ImageJ: 25 years
> of image analysis._ Nature methods, 9(7):671–675, 2012. 
> [doi:10.1038/nmeth.2089](http://dx.doi.org/10.1038/nmeth.2089)

* Fiji:
> Johannes Schindelin, Ignacio Arganda-Carreras, Erwin Frise, Verena Kaynig, Mark Longair,
> Tobias Pietzsch, Stephan Preibisch, Curtis Rueden, Stephan Saalfeld, Benjamin Schmid, et al.
> _Fiji: an open-source platform for biological-image analysis._ Nature methods, 9(7):676–682, 2012. 
> [doi:10.1038/nmeth.2019](http://dx.doi.org/10.1038/nmeth.2019)

## Localization microscopy <a name="software-localization" />

Not related to SIM, but included here for (my) convenience, popular papers around software
packages for localization microscopy:

* [QuickPALM](http://imagej.net/QuickPALM): 
([github](https://github.com/fiji/QuickPALM/releases/tag/QuickPALM_-1.1.2) as part of FIJI)
> Ricardo Henriques, Mickael Lelek, Eugenio F Fornasiero, Flavia Valtorta, Christophe Zimmer,
> and Musa M Mhlanga. _Quickpalm: 3d real-time photoactivation nanoscopy image processing
> in ImageJ._ Nature methods, 7(5):339–340, 2010. 
> [doi:10.1038/nmeth0510-339](http://dx.doi.org/10.1038/nmeth0510-339)

* [rapidSTORM](http://www.super-resolution.biozentrum.uni-wuerzburg.de/archiv/rapidstorm/) 
([github](https://github.com/stevewolter/rapidSTORM) by maintainer / first author):
> Steve Wolter, Anna Löschberger, Thorge Holm, Sarah Aufmkolk, Marie-Christine Dabauvalle,
> Sebastian van de Linde, and Markus Sauer. _RapidSTORM: accurate, fast open-source software for
> localization microscopy._ Nature methods, 9(11):1040–1041, 2012. 
> [doi:10.1038/nmeth.2224](http://dx.doi.org/10.1038/nmeth.2224)

* [ThunderSTORM](http://zitmen.github.io/thunderstorm/):
> Martin Ovesnỳ, Pavel Křížek, Josef Borkovec, Zdeněk Švindrych, and Guy M Hagen. 
> _Thunderstorm: a comprehensive ImageJ plug-in for PALM and STORM data analysis and super-resolution
> imaging._ Bioinformatics, 30(16):2389–2390, 2014. 
> [doi:10.1093/bioinformatics/btu202](http://dx.doi.org/10.1093/bioinformatics/btu202)

* Comparison of localization microscopy software packages (with a [comprehensive list](http://bigwww.epfl.ch/smlm/software/)):
> Daniel Sage, Hagai Kirshner, Thomas Pengo, Nico Stuurman, Junhong Min, Suliana Manley,
> and Michael Unser. _Quantitative evaluation of software packages for single-molecule 
> localization microscopy._ Nature methods, 2015. 
> [doi:10.1038/nmeth.3442](http://dx.doi.org/10.1038/nmeth.3442)


# Non-linear SIM <a name="non-linear-sim" />

This is not a very complete list, but the milestone papers on extending SIM with "non-linear
techniques" towards more than the 2× resolution enhancement:

* Arguably among the first papers that promoted the idea
> Rainer Heintzmann, Thomas M Jovin, and Christoph Cremer. _Saturated patterned excitation
> microscopy—a concept for optical resolution improvement._ JOSA A, 19(8):1599–1609, 2002.
> [doi:10.1364/JOSAA.19.001599](http://dx.doi.org/10.1364/JOSAA.19.001599)

* Early work on non-linear SIM by Gustaffson 
> Mats GL Gustafsson. Nonlinear structured-illumination microscopy: wide-field fluorescence
> imaging with theoretically unlimited resolution. Proceedings of the National Academy of
> Sciences of the United States of America, 102(37):13081–13086, 2005. 
> [doi:10.1073/pnas.0406877102](http://dx.doi.org/10.1073/pnas.0406877102)

* One of the main papers on non-linear by Gustaffson
> E Hesper Rego, Lin Shao, John J Macklin, Lukman Winoto, Göran A Johansson, Nicholas
> Kamps-Hughes, Michael W Davidson, and Mats GL Gustafsson. _Nonlinear structured-illumination
> microscopy with a photoswitchable protein reveals cellular structures at 50-nm resolution._
> Proceedings of the National Academy of Sciences, 109(3):E135–E143, 2012.
> [doi:10.1073/pnas.1107547108](http://dx.doi.org/10.1073/pnas.1107547108)

* Betzig’s 2015 big (see length of supplementals) Science paper on non-linear SIM: 
> Dong Li, Lin Shao, Bi-Chang Chen, Xi Zhang,
> Mingshu Zhang, Brian Moses, Daniel E Milkie, Jordan R Beach, John A Hammer, Mithun
> Pasham, et al. _Extended-resolution structured illumination imaging of endocytic and cy-
> toskeletal dynamics._ Science, 349(6251):aab3500, 2015.
> [doi:10.1126/science.aab3500](http://dx.doi.org/10.1126/science.aab3500)


  
