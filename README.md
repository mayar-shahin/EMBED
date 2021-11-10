# EMBED
EMBED is a method that produces low dimensional representations of multi-subject longitudinal microbiome data.
EMBED learns are time-specific latents (z) that are shared by all OTUs and subjects, and OTU-and subject-specific loadings (θ) that are shared across all time points. EMBED reorients th elatents z into Ecological Normal Modes (ECNs) (y) that represent the indpendent directions of fluctuations in the data. 

The steps are as follows:
1) For each subject, prepare the abundance data in a matrix of dimensions O x T with O being the number of Operational Taxonomical Units (OTUs) or bacteria and T is the number of samples taken over a period of time.
2) Stack different matrices for each subject horizontally to end up with a data matrix of dimensions N * O x T, where N is the number of subjects. 
4) RUN the function TMI.m to get latents z and loadings θ matrices learned from fitting the data on a Gibbs-Boltzmann distribution (Thermodynamic Manifold Inference [1])
    - To avoid numerical divergences due to random initilization run TMI multiple time and keep runs lowest in KL-divergence (i.e. closer to the global minimum)
    - For data sets that have a lot of zero data points, avoid over fitting the zero data by setting the minimum of the model predictions (min_fitting) to be on the same order of       the the minimum non-zero data points. 
5) RUN the function Rotating.m on the infered z and theta to get independent ECNs Y and loadings Phi 
    - For sanity check, you can run it  on two different sets of learned z and theta (not necessarily similar) and check if the rotated ECNs Y are unique.

The learned ECNs are the temporal bases for the dynamics.

Reference:
[1] P. Dixit, Physical Review Research 2, (2020).
