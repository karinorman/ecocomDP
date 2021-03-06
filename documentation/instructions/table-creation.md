# How to create tables in the design pattern ecocomDP 

Introduction
---

This document contains guidelines for creating tables in this design pattern.

General guidelines
---

1. Our goal is to provide data in regular formats to simplify querying and synthesis. DO NOT calculate values or aggregate primary observations (in the observation table). Users (e.g., data synthesis working groups) will perform these calcluations for their own needs. 
2. Conversion requires a basic understanding of the data. You will need to assemble available metadata, and spend time exploring.
3. If L0 data are already in the EDI repository, the entities and some medata can be accessed via the autogenerated code web services.
4. The three ancillary tables (taxon_ancillary, location_ancillary, observation_ancillary) may have aggregated data. If you aggreagate values in these tables, include a copy of the raw data table (L0) with the final L1 data package so that additional details are easy to find. A situation where this might happen is when the ancillary data have more structure than the primary observation data, e.g., a plankton tow (through a water column) is accompanied by a profile (with a discrete value at each depth). The profile values could be averaged for the observation_ancillary table, but the profile structure may be of interest as well, so include it (e.g., as an 8th table). Keep in mind: in a design pattern for biogeochemistry data, data in the profile would be the 'primary observations', and values would not be averaged! 
5. To be flexible, this design pattern uses a long format, with key-value pairs (plus a "unit"), where key = the variable name. We have observed this format used in a variety of applications where data from mulitple sources are combined. There is a drawback to this format however, mainly that the definition of the key (variable_name) is generally uncontrolled and with little typing. Including a unit field helps aleviate this to some extent, and we are exploring ways to add semantic meaning to measurement fields. We recommend that the EML metadata for variable fields be constructed as code-definition pairs (an EML "enumeratedList"), so that every variable_name is accompanied by a definition. If L0 data already have EML metadata, these definitions can be found at this XPath: //dataset/dataTable/attributeList/attribute/defininition
6. Use column names of the L0 as variable names of the L1 when possible. This automates definition of key-value pairs.
7. Reference the best practices documentation for challenging edge cases ([Best Practices](https://github.com/EDIorg/ecocomDP/tree/master/documentation/practices)).


Table list 
---
Tables are listed here in suggested population order, i.e., parents first. 
The location and taxon tables are most likely to come first, but could be in either order, as they are equal parents of observation. A minimum of 4 tables is required (e.g., if there is no ancillary information to include).

|  order | table name 	|   required?	|   references tables    | description            | 
|--------|--------------|---------------|------------------------|------------------------|
|1.|location              |yes|NA              |basic info to identify a place    |  
|2.|taxon                 |yes|NA              |basic info to identify an organism | 
|3.|observation           |yes|location, taxon |observations about taxa that will be analyzed (organism abundance or density, or the data to compute these, e.g., count) |  
|4.|location_ancillary    |no |location        |additional info about a place that does not change, in long format. |
|5.|taxon_ancillary       |no |taxon           |additonal info about an organism that does not change, in long format |
|6.|observation_ancillary |no |observation     |additional info to contextualize the observation (not specific to the taxon or locations) in long-format  |  
|7.|dataset_summary       |yes|observation     |summary info calculated from incoming data. This is a one-line table |
|8.|variable_mapping      |no| observation, observation_ancillary, location_ancillary, taxon_ancillary | table variables and definitions|

