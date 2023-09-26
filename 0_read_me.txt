*******************
CODES DESCRIPTION
*******************

- Code Languages:

	.py - python (interpreter Python 3.11)
	.m - matlab (version 2021b)

- Files:

	cross_direct.py - RF model for the cross/general case
	direct_FINAL.py - RF model for the regular case and robustness test
	features_correlation.m - detecting the correlation between features
	features_correlation2.m - selecting the features with high correlation and eliminating one of them
	plotBarStackGroups2.m - function for plotting group of stacked bars
	RF_summary_cross_direct.m - process the results from the RF models (both performance and feature importance)
	robustness_FI.m - analyze the robustness of the feature importance
	robustness_RF.m - analyze the robustness of the random forest perfomances on reproducing results of GHM/LSMs
	setting_csv_cross_direct.m - prepare the input files with predictors and target variables for the RF models
	spatial_influence.m - plot some results spatially (last figure of the article)
  