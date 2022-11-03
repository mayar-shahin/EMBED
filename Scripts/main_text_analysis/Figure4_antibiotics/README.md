These codes are for reproducing figure 3. 

## Figure 3a
- 'Fig3a.m' loads the data from the parent folder and performs the learning and saves results into a data file to be used for analysis. The learning is performed twice to check for uniqueness (an extra convergence check).
Running on a regular computer should be close to 7 minutes. Hyperparameters are included in the file. Note that ECNs are reproducable up to a minus sign.
The file performs two runs of the learning to check for reproducability (SI Fig 1)


## Figures 3b and c
- 'Fig3bc.m' reproduces the clustergram in Figure 3b. The cluster grouping should change based on the run. 

**NEED TO CHANGE CLUSTER NUMBERS IN THE CODE TO GET PROPER RESULTS**

If you change clusters accordingly, you should be able to reproduce individual groups plots shown in figure 3c. Alternaticely, you can just use the abundance data stored in variable 'x'. 

## Figure 3d
- 'Fig3d.m' loads fig3c clustering results and idenified behaviors similar/dissimilar across subjects.
