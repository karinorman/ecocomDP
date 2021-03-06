-- copied from ~/BON/db_bon_data_packages/schema_mini_metabase/create_7_tables_schema.sql  
--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.19
-- Dumped by pg_dump version 9.2.2
-- Started on 2016-12-16 15:28:07 PST
/*
created original from pgdump, edited. see personal notes.
*/

/*
table population order - suggested (ie, parents first).
1. location
2. taxon
3. observation (refs location, taxon)
4. location_ancillary (refs location)
5. taxon_ancillary (refs taxon)
6. observation_ancillary (refs observation)
7. dataset_summary (refs observation)

*/
/*
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = "ecocom_dp", pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;
*/

/*
-- Create 7 tables:
*/


-- DROP TABLE "ecocom_dp".location;
CREATE TABLE "ecocom_dp".location (
	location_id character varying(100) NOT NULL,
	location_name character varying(500),
	latitude float,
	longitude float,
	elevation float, -- relative to sealevel
	parent_location_id character varying(100) 
);

-- DROP TABLE "ecocom_dp".taxon;
CREATE TABLE "ecocom_dp".taxon (
	taxon_id character varying(100) NOT NULL,
	taxon_rank character varying(200),
	taxon_name character varying(200) NOT NULL,
	authority_system character varying(200),
	authority_taxon_id character varying(200)
);

-- DROP TABLE "ecocom_dp".observation;
CREATE TABLE "ecocom_dp".observation (
	observation_id character varying(100) NOT NULL,
	event_id character varying(100),
	package_id character varying(100) NOT NULL,
	location_id character varying(100) NOT NULL,
	observation_datetime timestamp without time zone,
	taxon_id character varying(100) NOT NULL,
	variable_name character varying(200) NOT NULL,
	value character varying(200) NOT NULL,
	unit character varying(200) NOT NULL
);

-- DROP TABLE "ecocom_dp".location_ancillary;
CREATE TABLE "ecocom_dp".location_ancillary (
    location_ancillary_id character varying(100) NOT NULL,
    location_id character varying(100) NOT NULL,
    datetime timestamp without time zone NOT NULL, -- e.g. experimental treatment
    variable_name  character varying(200) NOT NULL,
    value  character varying(200) NOT NULL,
    unit  character varying(200)
);

-- DROP TABLE "ecocom_dp".taxon_ancillary;
CREATE TABLE "ecocom_dp".taxon_ancillary (
    taxon_ancillary_id character varying(100) NOT NULL,
	  taxon_id character varying(100) NOT NULL,
	  datetime timestamp without time zone NOT NULL,  
    variable_name  character varying(200) NOT NULL,
    value character varying(200) NOT NULL,
	  author character varying(200)
);

-- DROP TABLE "ecocom_dp".observation_ancillary; 
CREATE TABLE "ecocom_dp".observation_ancillary (
  observation_ancillary_id character varying(100) NOT NULL,
  event_id character varying(100),
--	observation_id character varying(100) NOT NULL,
	variable_name character varying(200),
	value character varying(200),
	unit character varying(200)
);


-- DROP TABLE "ecocom_dp".dataset_summary;
CREATE TABLE "ecocom_dp".dataset_summary (
	package_id character varying(100) NOT NULL,
	original_package_id character varying(200),
	length_of_survey_years integer,
	number_of_years_sampled integer,
	std_dev_interval_betw_years float,
	max_num_taxa integer, 
	geo_extent_bounding_box_m2 float

);

/* the event table is a stub, which will not appear in CSV implementations
it could hold the description of a sampling event */
-- DROP TABLE "ecocom_dp".event; 
CREATE TABLE "ecocom_dp".event (
  event_id character varying(100) NOT NULL,
  event_name character varying(100)
);




ALTER TABLE "ecocom_dp".observation OWNER TO mob;
COMMENT ON TABLE "ecocom_dp".observation IS 'table holds all the primary obs, with links to taxa, locations, event, summary';

ALTER TABLE "ecocom_dp".location OWNER TO mob;
COMMENT ON TABLE "ecocom_dp".location IS 'self-referencing; parent of a loc can be another loc';

ALTER TABLE "ecocom_dp".taxon OWNER TO mob;

ALTER TABLE "ecocom_dp".observation_ancillary OWNER TO mob;
COMMENT ON TABLE "ecocom_dp".observation_ancillary IS 'holds other info about a sampling event, eg, conditions, weather, observers, etc';

ALTER TABLE "ecocom_dp".taxon_ancillary OWNER TO mob;

ALTER TABLE "ecocom_dp".location_ancillary OWNER TO mob;

ALTER TABLE "ecocom_dp".dataset_summary OWNER TO mob;

ALTER TABLE "ecocom_dp".event OWNER TO mob;

/* add PK constraints */
ALTER TABLE ONLY "ecocom_dp".observation
    ADD CONSTRAINT observation_pk PRIMARY KEY (observation_id);

ALTER TABLE ONLY "ecocom_dp".location
    ADD CONSTRAINT location_pk PRIMARY KEY (location_id);

ALTER TABLE ONLY "ecocom_dp".taxon
    ADD CONSTRAINT taxon_pk PRIMARY KEY (taxon_id);

ALTER  TABLE ONLY "ecocom_dp".location_ancillary
    ADD CONSTRAINT location_ancillary_pk PRIMARY KEY (location_ancillary_id);

ALTER TABLE ONLY "ecocom_dp".taxon_ancillary
    ADD CONSTRAINT taxon_ancillary_pk PRIMARY KEY (taxon_ancillary_id);

ALTER TABLE ONLY "ecocom_dp".dataset_summary
    ADD CONSTRAINT dataset_summary_pk PRIMARY KEY (package_id);

ALTER TABLE ONLY "ecocom_dp".observation_ancillary
    ADD CONSTRAINT observation_ancillary_pk PRIMARY KEY (observation_ancillary_id);

ALTER TABLE ONLY "ecocom_dp".event
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


/* add FK constraints
*/
-- observation refs sampling_loc, taxon
ALTER TABLE ONLY "ecocom_dp".observation
    ADD CONSTRAINT observation_location_fk FOREIGN KEY (location_id) REFERENCES "ecocom_dp".location (location_id) MATCH SIMPLE     
    ON UPDATE CASCADE;
ALTER TABLE ONLY "ecocom_dp".observation
    ADD CONSTRAINT observation_taxon_fk FOREIGN KEY (taxon_id) REFERENCES "ecocom_dp".taxon (taxon_id) MATCH SIMPLE     
    ON UPDATE CASCADE;
-- obs:event relationship is only for the sql implementation. needed for the many:many    
ALTER TABLE ONLY "ecocom_dp".observation
   ADD CONSTRAINT observation_event_fk FOREIGN KEY (event_id) REFERENCES "ecocom_dp".event (event_id) MATCH SIMPLE
   ON UPDATE CASCADE;
-- observation refs  summary
ALTER TABLE ONLY "ecocom_dp".observation
    ADD CONSTRAINT observation_package_fk FOREIGN KEY (package_id) REFERENCES "ecocom_dp".dataset_summary (package_id) MATCH SIMPLE
    ON UPDATE CASCADE;
    
--location (self-referencing)
ALTER TABLE ONLY "ecocom_dp".location
    ADD CONSTRAINT parent_location_fk FOREIGN KEY (parent_location_id) REFERENCES "ecocom_dp".location (location_id) MATCH SIMPLE     
    ON UPDATE CASCADE;  

-- location_ancillary refs sampling_loc
ALTER TABLE ONLY "ecocom_dp".location_ancillary
    ADD CONSTRAINT location_ancillary_fk FOREIGN KEY (location_id) REFERENCES "ecocom_dp".location (location_id) MATCH SIMPLE     
    ON UPDATE CASCADE;
  
-- taxon_ancillary refs taxon
ALTER TABLE ONLY "ecocom_dp".taxon_ancillary
    ADD CONSTRAINT taxon_ancillary_fk FOREIGN KEY (taxon_id) REFERENCES "ecocom_dp".taxon (taxon_id) MATCH SIMPLE     
    ON UPDATE CASCADE;

-- observation_ancillary refs observation
-- ALTER TABLE ONLY "ecocom_dp".observation_ancillary
--     ADD CONSTRAINT observation_ancillary_fk FOREIGN KEY (observation_id) REFERENCES "ecocom_dp".observation (observation_id) MATCH SIMPLE     
--     ON UPDATE CASCADE;

-- obs_ancillary:event relationship is only for the sql implementation. needed for the many:many    
ALTER TABLE ONLY "ecocom_dp".observation_ancillary
   ADD CONSTRAINT observation_ancillary_event_fk FOREIGN KEY (event_id) REFERENCES "ecocom_dp".event (event_id) MATCH SIMPLE
   ON UPDATE CASCADE;

-- uniq constraints:
ALTER TABLE ONLY "ecocom_dp".observation_ancillary
   ADD CONSTRAINT observation_ancillary_uniq UNIQUE (event_id, variable_name);

ALTER TABLE ONLY "ecocom_dp".location_ancillary
   ADD CONSTRAINT location_ancillary_uniq UNIQUE (location_id, datetime, variable_name);

ALTER TABLE ONLY "ecocom_dp".taxon_ancillary
   ADD CONSTRAINT taxon_ancillary_uniq UNIQUE (taxon_id, datetime, variable_name);

/*
set perms
*/

REVOKE ALL ON SCHEMA "ecocom_dp" FROM PUBLIC;
GRANT ALL ON SCHEMA "ecocom_dp" TO mob;
GRANT USAGE ON SCHEMA "ecocom_dp" TO read_only_user;

GRANT SELECT ON TABLE "ecocom_dp".observation TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".location TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".taxon TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".location_ancillary TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".taxon_ancillary TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".dataset_summary TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".observation_ancillary TO read_only_user;
GRANT SELECT ON TABLE "ecocom_dp".event TO read_only_user;

GRANT ALL ON TABLE "ecocom_dp".observation TO mob;
GRANT ALL ON TABLE "ecocom_dp".location TO mob;
GRANT ALL ON TABLE "ecocom_dp".taxon TO mob;
GRANT ALL ON TABLE "ecocom_dp".location_ancillary TO mob;
GRANT ALL ON TABLE "ecocom_dp".taxon_ancillary TO mob;
GRANT ALL ON TABLE "ecocom_dp".dataset_summary TO mob;
GRANT ALL ON TABLE "ecocom_dp".observation_ancillary TO mob;
GRANT ALL ON TABLE "ecocom_dp".event TO mob;
