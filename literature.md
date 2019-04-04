--- 
layout: default
title: SIM publications
description: Fundamental and/or technical SIM papers
bibtex:
 - literature.bib
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
  * [Multi-focal: diffractive](#building-multifocal-diffractive)
  * [Multi-plane: beam-splitting](#building-multifocal-pathlength)
* _direct/classic_ SIM [reconstruction algorithms](#reconstruction)
  * [Parameter estimation](#parameter)
  * [Noise filtering approaches](#filters)
  * [Optical sectioning](#sectioning)
  * [Optimization & checks](#optimization)
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

All citations are auto-generated from a [bibtex file](resources/literature.bib) 
(using [bibtex-js](https://github.com/pcooksey/bibtex-js)),
which can be imported to citation managers.
An [XML version](resources/literature_word.xml) compatible with 
current WORD version is semi-automatically generated from it.

# Fundamental papers <a name="fundamentals" />

The _standard_ SR-SIM microscope and reconstruction algorithm,
in use by all commercial systems and various home-built setups, 
is often attributed to and referred to as __Gustaffson-Heintzmann__-SIM:


* Conference proceeding by __R. Heintzmann__ (1999)
<div class="bibtex_display" bibtexkeys="heintzmann1999laterally"></div>

* 2D SIM by __M. Gustafsson__ (2000):
<div class="bibtex_display" bibtexkeys="gustafsson2000"></div>

* 3D SIM by __M. Gustafsson__ (2008).  
<div class="bibtex_display" bibtexkeys="gustafsson2008"></div>

* There is also this __PhD thesis__ (2000):
<div class="bibtex_display" bibtexkeys="frohn2000super"></div>

More precisely, Gustaffson-Heintzmann-SIM typically refers to sinusoidal SIM illumination 
pattern, which are amenable to a direct reconstruction approach.

# Reviews and Overview <a name="sim-reviews">

Certainly not a complete list, but the following are reviews, overview articles and protocols
that might be helpful:

* A practical guide on how to perform SIM measurements, and how to assess their quality, 
from the Schermelleh lab. These guys have lots of experience with running OMX microscopes,
taking calibration measurements (OTFs, etc.) and checking for / avoiding SIM artifacts.

<div class="bibtex_display" bibtexkeys="demmerle2017strategic"></div>

* An overview focussing on the technical development of SIM microsocpes and
reconstruction algorithms

<div class="bibtex_display" bibtexkeys="heintzmannhuser2017"></div>


# Building microscopes <a name="building" />

There are a few papers with details on how groups created home-built SIM setups.

* Setup based on a Hamamatsu SLM (thus, non-binary phase control), 2-beam SIM, 4 pattern
orientations (0, 45, 90, 135, easy pattern generation). I think this might be first SLM-based
SIM paper (2009):

<div class="bibtex_display" bibtexkeys="chang2009isotropic"></div>

* Setup based on a TI DMD (thus binary), and using incoherent (LED) light. Keep in mind that using
incoherent light will not give a full 2x resolution improvement.

<div class="bibtex_display" bibtexkeys="dan2013dmd"></div>

* Setup based on the Forth-DD ferro-electric SLM (binary, phase shift), device also in use by
Betzig, setup very fast:

<div class="bibtex_display" bibtexkeys="walther2015fastsim"></div>

* Prequel(?) to the fastSIM, giving some more detail on the system

<div class="bibtex_display" bibtexkeys="forster2014simple"></div>

* Addition to the fastSIM paper, making it faster by working with the rolling shutter

<div class="bibtex_display" bibtexkeys="song2016fast"></div>

* Also interesting: This paper has calculations (ray-tracing) on how the polarization of the inter-
fering light influences pattern contrast:

<div class="bibtex_display" bibtexkeys="o2012polarization"></div>

* A video-guide on how to build / align a TIRF-SIM based on the
ForthDD SLM, by the Kaminsky group:

<div class="bibtex_display" bibtexkeys="young2016guide"></div>


## Multi-focal approaches: Diffractive elements <a name="building-multifocal-diffractive">

* SIM with multi-focal detection, first paper combining the two, by Sara Abrahamssom. This was build
by adding her multi-focal detection (a lithographed diffractive element, see papers below) with a Zeiss
Elysa (commercial) SIM.

<div class="bibtex_display" bibtexkeys="abrahamsson2017multifocus"></div>

* I would assume this is where the idea of producing a phase mask to create a multi-focal detection system
started, but I am not completely certain:

<div class="bibtex_display" bibtexkeys="abrahamsson2006new"></div>

* This is the main publication featuring the principle...

<div class="bibtex_display" bibtexkeys="abrahamsson2013fast"></div>

* ... and this paper has nice details on how the elements are actually created, and how to circumvent
the problem of chromatic aberration

<div class="bibtex_display" bibtexkeys="abrahamsson2016multifocus"></div>


## Multi-focal approaches: Changing the detection path length <a name="building-multifocal-pathlength">

* The 'beam splitter' approach, changing optical path length, here applied to SOFI...

<div class="bibtex_display" bibtexkeys="geissbuehler2014live"></div>

* ... which sparked the development of the prism-based realization of the same idea. The publication also
merges it with quantitative phase imaging

<div class="bibtex_display" bibtexkeys="descloux2018combined"></div>


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

<div class="bibtex_display" bibtexkeys="shroff2009phase"></div>

* Approach by cross-correlation of separated bands. The idea here is that the separated
spectra have overlapping regions, so the correct shift (angle, frequency, global phase, modulation depth) 
can be found by maximizing the cross-correlation of these bands in respect to a
complex shift vector. 
To my knowledge, this is the method of choice to obtain SIM reconstruction parameters,
in use e.g. even for the current work of non-linear SIM. It is also the only method I know to
obtain pattern frequency and angle, while the phases can be refined by further means.
The idea is already explained in one paragraph in _Gustafsson 2008_, but not written
down in detail. A quite detailed description can however be found in this review:


<div class="bibtex_display" bibtexkeys="yang2015method"></div>

* Iterative phase optimization: The cross-correlation will only yield one global phase, with phase
differences between patterns assumed as fixed (and set in the band separation matrix). The
iterative approach optimizes these phases by analyzing their shift through cross-correlation in
the raw data. It seems like a very sound approach, but it probably takes some time to implement correctly.

<div class="bibtex_display" bibtexkeys="wicker2013phase"></div>

* Non-Iterative phase optimization<a name="phase2013"/>: A follow-up to the last paper, this performs phase 
optimization in a single step. The algorithm is easy to understand and implement, the paper
provides comparisons to the iterative method (performance similar for realistic SNRs). 
[fairSIM](http://www.fairsim.org) has some code to run this optimization, though it is currently
not accessible directly through the GUI.

<div class="bibtex_display" bibtexkeys="wicker2013noniterative"></div>

## Filters <a name="filters"/>

The last step of a SIM reconstruction is the recombination of frequency bands. Since the bands
are OTF-corrected, a suitable filter needs to be applied. Typically (i.e., in the original publications), 
this is a modified/generalized Wiener-type filter, however other regularization methods can be applied.

There is often some discussion about "linearity" of filters, i.e. if they can change relative intensities,
which might be seen as a disadvantage of e.g. Richardson-Lucy-like iterative deconvolution methods.


* For good cameras, photon counts are highly dominated by Poisson noise (photon count statistics)
compared to Gaussian noise (electron read-out noise). Since the Wiener filter is not tuned to
that, other filter approaches might yield better results. Again, I am not aware of any implementation
of this in use.

<div class="bibtex_display" bibtexkeys="chu2014image"></div>

* Using [Richardson-Lucy](#richardson-lucy) for both sectioning and also filtering.

<div class="bibtex_display" bibtexkeys="perez2016optimal"></div>

* A Hessian-based (2nd derivative) based regularization filter that offers an impressive
cleanup of noise, as it promotes "smoothness" in the result. Especially useful in combination
with video-imaging, as the smoothness criterion can also be used along the time axis.

<div class="bibtex_display" bibtexkeys="huang2018hessian"></div>

## Optical sectioning (in single-slice / 2D SIM) <a name="sectioning" />

SIM reconstructions can be done in either 2D (single slice, one focal plane) or 3D (requires z-stack
and 3D OTF). Single slice reconstructions are independent of the illumination mode (2-beam or
3-beam interference), and even profit of 3-beam illumination for the following trick:
To reduce the out-of-focus light, i.e. to introduce optical sectioning, the 2D OTF is re-weighted
in such a way that SIM bands do not contribute around their missing cone. To use this trick,
one either needs three-beam data (which has the medium band overlapping all missing cones) or
two-beam data set to less than the maximum resolution improvement. The idea is mentioned in
the appendix of [the non-iterative phase optimization paper](#phase2013), and documented in two more papers:

* The approach itself:

<div class="bibtex_display" bibtexkeys="o2014optimized"></div>

* Application to high-speed single-slice SIM:

<div class="bibtex_display" bibtexkeys="shaw2015high"></div>

Another more recent approach is to use Richardson-Lucy filtering on both the SIM raw input
data, and as a replacement of the Wiener filtering step in the results. This allows for
sectioning even without the OTF overlap, and in my experience yields very nice result
as long as the SNR is good enough (i.e. it can remove out-of-focus background, but relies
on data with good signal / low noise).

* <a name="richardson-lucy" /> Using Richardson-Lucy filtering

<div class="bibtex_display" bibtexkeys="perez2016optimal"></div>


## <a name="optimization" /> Optimization and checks 

Work that deals with aspects of optimizing and checking the quality of the SIM
reconstruction process, but does not fit the other categories:

* Optimization of modulation depth, spatially varying illumination intensity and such. A very
early paper (2004), I don't know if and where any of this has been implemented.

<div class="bibtex_display" bibtexkeys="schaefer2004structured"></div>

* Detecting motion artifacts in SIM reconstructions 

<div class="bibtex_display" bibtexkeys="forster2016motion"></div>

# Software

## SIM image reconstruction <a name="software-reconstruction">

* Of course [fairSIM](http://www.fairsim.org). Currently single-slice (3D is in progress), 
with cross-correlation parameter estimation, handles two-beam and three-beam data 
(more bands work, but not through GUI), and offers optical sectioning through both
OTF attenuation and [RL-deconvolution](#richardson-lucy).

<div class="bibtex_display" bibtexkeys="mueller2016open"></div>

* Also, there is [OpenSIM](https://github.com/LanMai/OpenSIM), 

<div class="bibtex_display" bibtexkeys="lal2016structured"></div>

* And another, bigger Matlab-based software, where however the direct "stardard" SIM 
reconstruction approach does not seem not to be their main focus: 

<div class="bibtex_display" bibtexkeys="kvrivzek2016simtoolbox"></div>


## SIM analysis / quality checks <a name="software-checks" />

* The "SIMcheck" plugin. Thorough analysis of the input data quality. Last time I’ve checked, mainly for 3D SIM:

<div class="bibtex_display" bibtexkeys="ball2015simcheck"></div>

## General image processing for microscopy <a name="software-image-processing" /> 

The publications to cite when using ImageJ and Fiji:

* ImageJ:

<div class="bibtex_display" bibtexkeys="schneider2012nih"></div>

* Fiji:

<div class="bibtex_display" bibtexkeys="schindelin2012fiji"></div>

* MicroManager (2014)

<div class="bibtex_display" bibtexkeys="edelstein2014advanced"></div>

* MicroManager (2010)

<div class="bibtex_display" bibtexkeys="edelstein2010computer"></div>

* StackReg / TurboReg are based on:

<div class="bibtex_display" bibtexkeys="thevenaz1998pyramid"></div>

* bUnwarpJ

<div class="bibtex_display" bibtexkeys="arganda2008bunwarpj"></div>

# Localization microscopy <a name="software-localization" />

Not related to SIM, but included here for (my) convenience, popular papers around software
packages for localization microscopy:

* [QuickPALM](http://imagej.net/QuickPALM): 
([github](https://github.com/fiji/QuickPALM/releases/tag/QuickPALM_-1.1.2) as part of FIJI)

<div class="bibtex_display" bibtexkeys="henriques2010quickpalm"></div>

* [rapidSTORM](http://www.super-resolution.biozentrum.uni-wuerzburg.de/archiv/rapidstorm/) 
([github](https://github.com/stevewolter/rapidSTORM) by maintainer / first author):

<div class="bibtex_display" bibtexkeys="wolter2012rapidstorm"></div>

* [ThunderSTORM](http://zitmen.github.io/thunderstorm/):

<div class="bibtex_display" bibtexkeys="ovesny2014thunderstorm"></div>

* Comparison of localization microscopy software packages (with a [comprehensive list](http://bigwww.epfl.ch/smlm/software/)):

<div class="bibtex_display" bibtexkeys="sage2015quantitative"></div>


# Non-linear SIM <a name="non-linear-sim" />

This is not a very complete list, but the milestone papers on extending SIM with "non-linear
techniques" towards more than the 2× resolution enhancement:

* Arguably among the first papers that promoted the idea

<div class="bibtex_display" bibtexkeys="heintzmann2002saturated"></div>

* Early work on non-linear SIM by Gustaffson 

<div class="bibtex_display" bibtexkeys="gustafsson2005nonlinear"></div>

* One of the main papers on non-linear by Gustaffson

<div class="bibtex_display" bibtexkeys="rego2012nonlinear"></div>

* Betzig’s 2015 big (see length of supplementals) Science paper on non-linear SIM: 

<div class="bibtex_display" bibtexkeys="li2015extended"></div>


  
