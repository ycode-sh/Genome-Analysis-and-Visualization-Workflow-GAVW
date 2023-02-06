# Genome-Analysis-and-Visualization-Workflow-Project (Work in Progress!)
Genome Analysis and Visualization Workflow Project is an ambitious endeavour to create an automated, open source, contextualized framework for a complete characterization of infectious pathogens' genomic complexity using whole genome sequencing datasets integrated with different molecular and phenotypic data.

In line with our mission to contribute significantly to a reduced burden of infectious diseases in Africa, this project is aimed at making available to the scientific community a highly contextualized, portable, scalable, and reproducible genome analysis and visualization workflow incorporating carefully chosen and widely used genome analysis software and visualization tools.

The GAVW project provides pathogen-by-pathogen analysis pipeline that accepts Next-generation sequencing datasets together with other meta data (e.g epidemiological information) to provide:
1. Real-time, accurate, and fast prediction of pathogens' drug resistance profiles
2. Strain identification, lineage assignments, and robust phylogeny to make association of pathogens'
genetic markers with important clinical identities, such as high transmissiblity, treament failure, or elevated propensity to acquire drug resistance.
3. Real-time identification and tracking of transmission clusters for tailored contact investigation startegies.

The set of workflows available allow automated computational analysis by stringing together individual data processing tasks into cohesive pipelines. We used Nextflow as the workflow management framework to enable abstracting away the issues of orchestrating data movement and processing, managing task dependencies, and allocating resources within the compute infrastructure. The workflows available are shared in docker images, one image per pathogen species, ensuring interopability across different operating infrastracture and also ensuring that analysis parameters and constants are optimal for each pathogen chosen for analysis.

Below is a visual representation of the major functionalities for the first workflow created to anlayze _mycobacteria tuberculosis_ WGS data sets. The first Module checks for contamination and provides a robust taxonomic classification of the pathogen(s) represented by the data. The second module uses at least three different variant callers to profile drug-resistance conferring SNPs and INDELs in genome data aligned to the h37rv reference. In the third module, snps derived from WGS data aligned to _mycobacteria tuberculosis_ pangenome is used to reconstruct the transmission dynamics (who infected whom) of isolates represented in the data supplied. The fourth module provides quality control and visualization for all analyses stages. The results from each module are parsed with custom python, R, and bash scripts and rendered in accessible formats.

All the modules can run in parallel and or individually.

![Genome_Analysis_workflow](https://user-images.githubusercontent.com/96795505/216915526-cbbf3570-7d8a-4bff-b1bd-ae69a3896a2c.png)
