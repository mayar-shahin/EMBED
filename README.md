# EMBED

## Overview

[EMBED](https://www.biorxiv.org/content/10.1101/2021.03.18.436036v3) is a method that produces low dimensional representations of multi-subject longitudinal microbiome data.<sup>[1](https://www.biorxiv.org/content/10.1101/2021.03.18.436036v3)</sup>
EMBED learns time-specific latents (z) that are shared by all OTUs and subjects, and OTU-and subject-specific loadings (θ) that are shared across all time points. 
EMBED reorients the latents z into Ecological Normal Modes (ECNs) (y) that represent the indpendent directions of fluctuations in the data. The learned ECNs are the temporal bases for the dynamics.<sup>[1](https://www.biorxiv.org/content/10.1101/2021.03.18.436036v3),[2](https://journals.aps.org/prresearch/abstract/10.1103/PhysRevResearch.2.023201)</sup>

## System Requirements

The code is written in Matlab Release R2019b. No special hardware required.
Note: For recreating figure 1, we run CTF on python using the package [Gemelli](https://github.com/biocore/gemelli) provided by Martino et al.<sup>[3](https://www.nature.com/articles/s41587-020-0660-7)</sup> Some scripts in the package are edited to output extra information already calculated by the functions. 
To use that, you can move the folder '\python_directory\gemelli_env' into your environments directory and activate it.

## Contents 

* '\python_directory\Data' contains all data used to produce plots in the paper including GLV simulations results as matlab data file '.mat'
to import into python use the scipy.io.loadmat(<filename>)
* '\python_directory\Results' contains methods results (Lasso, EMBED and CTF for K=3,4,5) for different data sets. These are the inferred results used to produce 
plots in Figure 2.
to import into python use the scipy.io.loadmat(<filename>)
* '\python_directory\Scripts' has all python files we used to run EMBED, Lasso and CTF for Figure 2.


## Demo 

* The data set called 'Carmody_diet_multi_subject.mat' can be used as a demo data set. The data is from an oscillating diet experiment <sup>[4](https://www.sciencedirect.com/science/article/pii/S1931312814004260?via%3Dihub)</sup> The experiment and the data preprocessing is described in the methods section in the Supplementary Information. 

* Variables in the file:
	- 'diet_data' = The OTU table of size (74 OTUs*5 subjects) x 31 days. 
	- 'days' = days on which the data is present (not consecutive)
	- 'N' = number of subjects  
	
	

* The file titled 'run_demo.m' does the following:
	- loads the data set, runs the TMI to infer Z's and θ's and rotates them into independent ECNs Y and loadings Phi.
	- it repeats the process to check for uniqueness of inference for two different runs. A plot of the Y values for Run1 vs Run2 is shown.
	- It plots the inferred ECNs Y 
 
* The typical run time is on a 16gb ram computer is less than 10 minutes.

##  Instructions to run on your own Data

1) For each subject, prepare the abundance data in a matrix of dimensions O x T with O being the number of Operational Taxonomical Units (OTUs) or bacteria and T is the number of samples taken over a period of time.

2) Stack different matrices for each subject horizontally to end up with a data matrix of dimensions N * O x T, where N is the number of subjects. 

3) RUN the function TMI.m to get latents z and loadings θ matrices learned from fitting the data on a Gibbs-Boltzmann distribution (Thermodynamic Manifold Inference <sup>[2](https://journals.aps.org/prresearch/abstract/10.1103/PhysRevResearch.2.023201)</sup>)
    - To avoid numerical divergences due to random initilization run TMI multiple times and keep runs lowest in KL-divergence (i.e. closer to the global minimum)
    - For data sets that have a lot of zero data points, avoid over fitting the zero data by setting the minimum of the model predictions (min_fitting) to be on the same order of       the the minimum non-zero data points. 

4) RUN the function Rotating.m on the infered z and theta to get independent ECNs Y and loadings Phi 
    - For sanity check, you can run it on two different sets of learned z and theta (not necessarily similar) and check if the rotated ECNs Y are unique.

5) Hyperparameters may need some tuning based on the data size and nature, they are described in the function code files (TMI.m and Rotating.m)
    - learn_z/the = The learning rate of updating Z/θ
    - minimum relative gradients = serves as a convergence criteria for the gradient ascent learning  
    - maximum number of steps 




### References:
[1] Shahin, M., Ji, B. & Dixit, P. D. EMBED: Essential Microbiome Dynamics, a dimensionality reduction approach for longitudinal microbiome studies. bioRxiv 2021.03.18.436036 (2022) doi:10.1101/2021.03.18.436036.

[2] Dixit, P. D. Thermodynamic inference of data manifolds. Phys. Rev. Res. 2, 023201 (2020).

[3] Martino, C. et al. Context-aware dimensionality reduction deconvolutes gut microbial community dynamics. Nat Biotechnol 39, 165–168 (2021).

[4] Carmody, R. N. et al. Diet Dominates Host Genotype in Shaping the Murine Gut Microbiota. Cell Host Microbe 17, 72–84 (2015).
