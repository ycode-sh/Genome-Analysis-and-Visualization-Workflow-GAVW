# Genome-Analysis-and-Visualization-Workflow-Project
Genome Analysis and Visualization Workflow Project is an ambitious endeavour to create an automated, open source, contextualized framework for a complete characterization of infectious pathogens' biology using whole genome sequencing datasets integrated with different molecular and phenotypic data.

In line with our mission to contribute significantly to a reduced burden of infectious diseases in Africa, this project is aimed at making available to the scientific community a highly contextualized, portable, scalable, and reproducible genome analysis and visualization workflow incorporating carefully chosen and widely used genome analysis software and visualization tools.

The following goals are in view:
1. Real-time, accurate, and fast prediction of pathogens' drug resistance profiles
2. Strain identification, lineage assignments, and robust phylogeny to make association of pathogens'
genetic markers with important clinical consequencies, such as high transmissiblity, treament failure, or elevated propensity to acquire drug resistance.
3. Real-time identification and tracking of transmission clusters for tailored contact investigation startegies.

The set of workflows available allow automated computational analysis by stringing together individual data processing tasks into cohesive pipelines. The use of as the workflow management framework enables abstracting away the issues of orchestrating data movement and processing, managing task dependencies, and allocating resources within the compute infrastructure. The workflows available are shared in docker images, one image per pathogen, ensuring interopability across different operating infrastracture and also ensuring that analysis parameters and constants are optimal for each pathogen chosen for analysis.
