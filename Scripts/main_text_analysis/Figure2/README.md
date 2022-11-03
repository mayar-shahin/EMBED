#Figure 2 is produced on matlab using the results from 'python_directory\Results\'. 
For details on simulation data and analyses performed, see SI sections 2 and 4. Simulation data is produced using run_glv_sim.py files in 'python_directory\Scripts' 

## Figure 2a-2f
- 'Fig2a_to_2c_plotter.m' loads basetruth real data together with the three methods' results
to compare their performance and plot the bar plots. 
The file calls the function Evaluate_reconstruction from 'source codes'
- you can set K=3 or 4 or 5
- 'Fig2d_to_2f_plotter.m' does the same for simulation data. 
- you can change between oscillating and constant carrying capacities and set K=3, 4 or 5.

## Figure 2g
- 'Fig2g_plotter.m' loads glv simulations to produce figure 2g.
- you can change state = 'constant' to 'oscillating' to run on glv simulations with oscillating carrying capacities

## Figure 2h
- first we use 'embed_on_glv_sim_for_fig2h.m' to load EMBED reults pre rotation and save the reoriented latents and loadings
- 'Fig2h_plotter.m' loads EMBED results and produces the bar plot.
## Figure 2i 
- 'Fig2i_plotter.m' loads precision analysis results from 'python_directory\Results\precision_results'
- Precision results are produced using the python file 'python_directory\Scripts\fig2i_precision_analysis.py'



