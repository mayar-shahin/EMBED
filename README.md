# EMBED

## Overview

EMBED is a method that produces low dimensional representations of multi-subject longitudinal microbiome data.
EMBED learns are time-specific latents (z) that are shared by all OTUs and subjects, and OTU-and subject-specific loadings (θ) that are shared across all time points. 
EMBED reorients th elatents z into Ecological Normal Modes (ECNs) (y) that represent the indpendent directions of fluctuations in the data. The learned ECNs are the temporal bases for the dynamics.

## System Requirements

The code is written in Matlab Release R2019b. A python version will soon be provided. 

## Demo

* The data set called 'Carmody_diet_multi_subject.mat' can be used as a demo data set. The data is from an oscillating diet experiment (Carmody et al. [2]) The experiment and the data preprocessing is described in the methods section in the Supplementary Information. 

* Variables in the file:
 - 'diet_data' = The OTU table of size (74 OTUs*5 subjects) x 31 days. 
 - 'days' = days on which the data is present (not consecutive)
 - 'N' = number of subjects  

* The file titled 'run_demo.m' does the following:
	- loads the data set, runs the TMI to infer Z's and θ's and rotates them into independent ECNs Y and loadings Phi.
	- it repeats the process to check for uniqueness of inference for two different runs. A plot of the Y values for Run1 vs Run2 is shown.
	- It plots the inferred ECNs Y 
 
* The typical run time is on a 16gb ram computer is ~ 10 minutes.

##  Instructions to run on your own Data

1) For each subject, prepare the abundance data in a matrix of dimensions O x T with O being the number of Operational Taxonomical Units (OTUs) or bacteria and T is the number of samples taken over a period of time.

2) Stack different matrices for each subject horizontally to end up with a data matrix of dimensions N * O x T, where N is the number of subjects. 

3) RUN the function TMI.m to get latents z and loadings θ matrices learned from fitting the data on a Gibbs-Boltzmann distribution (Thermodynamic Manifold Inference [1])
    - To avoid numerical divergences due to random initilization run TMI multiple time and keep runs lowest in KL-divergence (i.e. closer to the global minimum)
    - For data sets that have a lot of zero data points, avoid over fitting the zero data by setting the minimum of the model predictions (min_fitting) to be on the same order of       the the minimum non-zero data points. 

4) RUN the function Rotating.m on the infered z and theta to get independent ECNs Y and loadings Phi 
    - For sanity check, you can run it on two different sets of learned z and theta (not necessarily similar) and check if the rotated ECNs Y are unique.

5) Hyperparameters may need some tuning based on the data size and nature, they are described in the function code files (TMI.m and Rotating.m)
    - learn_z/the = The learning rate of updating Z/θ
    - minimum relative gradients = servies as a convergence criteria for the gradient ascent learning  
    - maximum number of steps 




### References:
[1] Dixit, P. D. Thermodynamic inference of data manifolds. Phys. Rev. Res. 2, 023201 (2020).

[2] Carmody, R. N. et al. Diet Dominates Host Genotype in Shaping the Murine Gut Microbiota. Cell Host Microbe 17, 72–84 (2015).
