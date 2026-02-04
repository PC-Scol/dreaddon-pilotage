
/* TODO v28 */

/* tables pour les autres INE */

/* CHC */

/* Revoir le script pour les comptes temporaires SINAPS */

/* dire à Fred que :
	schema_pilotage.ins_inscription a bien évolué (nouveaux attributs, donc refaire le tour ...)
	
*/


/* table avec mails établissement */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel
(
    code_apprenant character varying(255) COLLATE pg_catalog."default",
    mail character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT etab_mail_institutionnel_pkey PRIMARY KEY (code_apprenant)
)
TABLESPACE pg_default;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel'; END; $$;



/* table avec uid, mail établissement, etc. */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_apprenant
(
    id_apprenant character varying(255) COLLATE pg_catalog."default",
    uid character varying(50) COLLATE pg_catalog."default",
    mail character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT etab_apprenant_pkey PRIMARY KEY (id_apprenant)
)
TABLESPACE pg_default;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_apprenant'; END; $$;



/* table avec libellés structures externes */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_structure_externe
(
    code_structure_externe character varying(11) COLLATE pg_catalog."default",
    libelle_structure_externe_10 character varying(10) COLLATE pg_catalog."default",
    libelle_structure_externe_20 character varying(20) COLLATE pg_catalog."default",
    libelle_structure_externe_40 character varying(40) COLLATE pg_catalog."default",
    libelle_structure_externe_60 character varying(60) COLLATE pg_catalog."default",
    libelle_structure_externe_100 character varying(100) COLLATE pg_catalog."default",
    libelle_structure_externe_web character varying(105) COLLATE pg_catalog."default",
    libelle_structure_externe_juridique character varying(105) COLLATE pg_catalog."default"
)
TABLESPACE pg_default;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_structure_externe'; END; $$;



/* suppression des tables */
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'schema_pilotage') LOOP
		IF quote_ident(r.tablename) LIKE 'temp_%'
			OR quote_ident(r.tablename) LIKE 'ref_%'
			OR quote_ident(r.tablename) LIKE 'idt_%'
			OR quote_ident(r.tablename) LIKE 'ins_%'
			OR quote_ident(r.tablename) LIKE 'pai_%'
			OR quote_ident(r.tablename) LIKE 'coc_%'
			OR quote_ident(r.tablename) LIKE 'chc_%'
			OR quote_ident(r.tablename) LIKE 'odf_%'
			OR quote_ident(r.tablename) LIKE 'app_%'
			OR quote_ident(r.tablename) LIKE 'piece_%'
		THEN
			RAISE NOTICE 'Supprime la TABLE %', quote_ident(r.tablename);
			EXECUTE 'DROP TABLE IF EXISTS schema_pilotage.' || quote_ident(r.tablename) || ' CASCADE';
		END IF;
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : suppression des tables'; END; $$;


/* suppression des vues */
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT viewname FROM pg_views WHERE schemaname = 'schema_pilotage') LOOP
		IF quote_ident(r.viewname) LIKE 'ref_%'
			OR quote_ident(r.viewname) LIKE 'idt_%'
			OR quote_ident(r.viewname) LIKE 'ins_%'
			OR quote_ident(r.viewname) LIKE 'pai_%'
			OR quote_ident(r.viewname) LIKE 'coc_%'
			OR quote_ident(r.viewname) LIKE 'chc_%'
			OR quote_ident(r.viewname) LIKE 'odf_%'
			OR quote_ident(r.viewname) LIKE 'app_%'
			OR quote_ident(r.viewname) LIKE 'piece_%'
		THEN
			RAISE NOTICE 'Supprime la VIEW %', quote_ident(r.viewname);
			EXECUTE 'DROP VIEW IF EXISTS schema_pilotage.' || quote_ident(r.viewname) || ' CASCADE';
		END IF;
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : suppression des vues'; END; $$;




/* ************************************************************************** */
/* fonctions */


CREATE OR REPLACE function clean_string(value character varying)
returns character varying
language plpgsql
as
$$
declare
   tmp_value character varying;
begin
	tmp_value = value;
	
	/*
	tmp_value = regexp_replace(tmp_value, '\u0100', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0101', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0102', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0103', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0104', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0105', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0106', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0107', 'c', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0108', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0109', 'c', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010A', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010B', 'c', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010C', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010D', 'c', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010E', 'D', 'g');
	tmp_value = regexp_replace(tmp_value, '\u010F', 'd', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0110', 'D', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0111', 'd', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0112', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0113', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0114', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0115', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0116', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0117', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0118', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0119', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011A', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011B', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011C', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011D', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011E', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u011F', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0120', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0121', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0122', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0123', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0124', 'H', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0125', 'h', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0126', 'H', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0127', 'h', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0128', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0129', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012A', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012B', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012C', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012D', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012E', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u012F', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0130', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0131', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0132', 'IJ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0133', 'ij', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0134', 'J', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0135', 'j', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0136', 'K', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0137', 'k', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0138', 'k', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0139', 'L', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013A', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013B', 'L', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013C', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013D', 'L', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013E', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u013F', 'L', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0140', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0141', 'L', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0142', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0143', 'N', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0144', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0145', 'N', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0146', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0147', 'N', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0148', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0149', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014A', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014B', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014C', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014D', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014E', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u014F', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0150', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0151', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0152', 'OE', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0153', 'oe', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0154', 'R', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0155', 'r', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0156', 'R', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0157', 'r', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0158', 'R', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0159', 'r', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015A', 'S', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015B', 's', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015C', 'S', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015D', 's', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015E', 'S', 'g');
	tmp_value = regexp_replace(tmp_value, '\u015F', 's', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0160', 'S', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0161', 's', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0162', 'T', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0163', 't', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0164', 'T', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0165', 't', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0166', 'T', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0167', 't', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0168', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0169', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016A', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016B', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016C', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016D', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016E', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u016F', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0170', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0171', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0172', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0173', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0174', 'W', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0175', 'w', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0176', 'Y', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0177', 'y', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0178', 'Y', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0179', 'Z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u017A', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u017B', 'Z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u017C', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u017D', 'Z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u017E', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0180', 'b', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0181', 'B', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0184', 'b', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0185', 'b', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0186', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0187', 'C', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0188', 'c', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0189', 'D', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018A', 'D', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018B', 'd', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018C', 'd', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018D', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018E', 'E', 'g');
	tmp_value = regexp_replace(tmp_value, '\u018F', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0191', 'F', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0192', 'f', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0193', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0194', 'V', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0195', 'h', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0196', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0197', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0198', 'K', 'g');
	tmp_value = regexp_replace(tmp_value, '\u0199', 'k', 'g');
	tmp_value = regexp_replace(tmp_value, '\u019A', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u019C', 'm', 'g');
	tmp_value = regexp_replace(tmp_value, '\u019D', 'N', 'g');
	tmp_value = regexp_replace(tmp_value, '\u019E', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u019F', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A0', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A1', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A4', 'P', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A5', 'p', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A6', 'R', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A7', 'S', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01A8', 's', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AA', 'l', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AB', 't', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AC', 'T', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AD', 't', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AE', 'T', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01AF', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B0', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B1', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B2', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B3', 'Y', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B4', 'y', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B5', 'Z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B6', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B7', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B8', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01B9', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01BA', 'z', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C3', '!', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C4', 'DZ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C5', 'Dz', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C6', 'dz', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C7', 'LJ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C8', 'Lj', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01C9', 'lj', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CA', 'NJ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CB', 'Nj', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CC', 'nj', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CD', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CE', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01CF', 'I', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D0', 'i', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D1', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D2', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D3', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D4', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D5', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D6', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D7', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D8', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01D9', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DA', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DB', 'U', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DC', 'u', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DD', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DE', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01DF', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E0', 'A', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E1', 'a', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E2', 'AE', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E3', 'ae', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E4', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E5', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E6', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E7', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E8', 'K', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01E9', 'k', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01EA', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01EB', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01EC', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01ED', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F0', 'j', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F1', 'DZ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F2', 'Dz', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F3', 'dz', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F4', 'G', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F5', 'g', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F6', 'H', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F7', 'P', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F8', 'N', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01F9', 'n', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FA', 'AE', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FB', 'AE', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FC', 'AE', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FD', 'ae', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FE', 'O', 'g');
	tmp_value = regexp_replace(tmp_value, '\u01FF', 'o', 'g');
	tmp_value = regexp_replace(tmp_value, '\u1D49', 'e', 'g');
	tmp_value = regexp_replace(tmp_value, '\u043E', 'o', 'g');

	tmp_value = regexp_replace(tmp_value, '\u0082', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u202f', ' ', 'g');
	
	tmp_value = regexp_replace(tmp_value, '\u2000', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2001', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2002', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2003', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2004', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2005', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2006', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2007', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2008', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u2009', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200A', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200B', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200C', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200D', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200E', ' ', 'g');
	tmp_value = regexp_replace(tmp_value, '\u200F', ' ', 'g');
	
	tmp_value = regexp_replace(tmp_value, '\uFFFD', ' ', 'g');
	*/
	
	return tmp_value;
end;
$$;




/* ************************************************************************** */
/* données liées à l'application */


CREATE TABLE IF NOT EXISTS schema_pilotage.app_dre AS 
   SELECT
      NOW() AS "date_creation",
      version_instance.majeure||'.'||version_instance.mineure AS "version",
      version_instance.majeure AS "version_majeure",
      version_instance.mineure AS "version_mineure"
   FROM schema_ins_piste.version_instance;





/* ************************************************************************** */
/* données du référentiel nécesaires */


CREATE TABLE schema_pilotage.ref_bourse_aide_financiere AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn,
    val.col2 AS type_bourse,
    (val.col3)::boolean AS temoin_exoneration,
    val.col4 AS exoins_com,
    val.col5 AS exoins_extra
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'BourseAideFinanciere'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_categorie_socioprofessionnelle AS
 SELECT categorie_socioprofessionnelle.code,
    categorie_socioprofessionnelle.libelle_court,
    categorie_socioprofessionnelle.libelle_long
   FROM schema_ref.categorie_socioprofessionnelle;




CREATE TABLE schema_pilotage.ref_commune AS
 SELECT commune.libelle_long,
    commune.code_insee,
    commune.code_postal
   FROM schema_ref.commune;




CREATE TABLE schema_pilotage.ref_commune_insee AS
 SELECT libelle_long, code_insee
   FROM schema_pilotage.ref_commune
   GROUP BY libelle_long, code_insee;




CREATE TABLE schema_pilotage.ref_cursus_formation AS
 SELECT cursus_formation.code,
    cursus_formation.libelle_court,
    cursus_formation.libelle_long
   FROM schema_ref.cursus_formation;




CREATE TABLE schema_pilotage.ref_departement AS
 SELECT departement.code,
    departement.code_academie,
    departement.libelle_court,
    departement.libelle_long,
    departement.libelle_affichage    
   FROM schema_ref.departement;




CREATE TABLE schema_pilotage.ref_domaine_formation AS
 SELECT domaine_formation.code,
    domaine_formation.libelle_court,
    domaine_formation.libelle_long
   FROM schema_ref.domaine_formation
   WHERE code_bcn IS NOT NULL;




CREATE TABLE schema_pilotage.ref_mention_bac AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'MentionBac'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_pays_nationalite AS
 SELECT pays_nationalite.code,
    pays_nationalite.libelle_court,
    pays_nationalite.libelle_long,
    pays_nationalite.libelle_affichage,
    CASE  
		WHEN pays_nationalite.libelle_nationalite IS NOT NULL THEN pays_nationalite.libelle_nationalite
		ELSE pays_nationalite.libelle_long
	END AS "libelle_nationalite",
    pays_nationalite.code_drapeau,
    pays_nationalite.temoin_union_europeenne,
    pays_nationalite.temoin_accords,
    pays_nationalite.code_iso_3611
   FROM schema_ref.pays_nationalite;




CREATE TABLE schema_pilotage.ref_regime_inscription AS
 SELECT regime_inscription.code,
    regime_inscription.libelle_court,
    regime_inscription.libelle_long
   FROM schema_ref.regime_inscription;




CREATE TABLE schema_pilotage.ref_serie_bac AS
 SELECT serie_bac.code,
    serie_bac.libelle_court,
    serie_bac.libelle_long,
    serie_bac.id_type_bac
   FROM schema_ref.serie_bac;




CREATE TABLE schema_pilotage.ref_type_bac AS
 SELECT type_bac.id,
    type_bac.code,
    type_bac.libelle_court,
    type_bac.libelle_long
   FROM schema_ref.type_bac;




CREATE TABLE schema_pilotage.ref_type_dernier_diplome_obtenu AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'TypeDernierDiplomeObtenu'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_type_diplome AS
 SELECT type_diplome.code,
    type_diplome.libelle_court,
    type_diplome.libelle_long,
    type_diplome.libelle_affichage,
    type_diplome.echelle_sise,
    type_diplome.temoin_diplome_national_aglae,
    type_diplome.temoin_diplome_habilite_aglae,
    
    type_diplome.id_cursus_formation,
    RCF.code AS "cursus_formation_code",
    RCF.code_bcn AS "cursus_formation_code_bcn",
    RCF.libelle_court AS "cursus_formation_libelle_court",
    RCF.libelle_long AS "cursus_formation_libelle_long",
    
    type_diplome.id_nature_diplome,
    RND.code AS "nature_diplome_code",
    RND.code_bcn AS "nature_diplome_code_bcn",
    RND.libelle_court AS "nature_diplome_libelle_court",
    RND.libelle_long AS "nature_diplome_libelle_long",
    
    type_diplome.id_niveau_formation,
    RNF.code AS "niveau_formation_code",
    RNF.code_bcn AS "niveau_formation_code_bcn",
    RNF.libelle_court AS "niveau_formation_libelle_court",
    RNF.libelle_long AS "niveau_formation_libelle_long"
    
   FROM schema_ref.type_diplome
   LEFT JOIN schema_ref.cursus_formation RCF ON RCF.id = type_diplome.id_cursus_formation
   LEFT JOIN schema_ref.nature_diplome RND ON RND.id = type_diplome.id_nature_diplome
   LEFT JOIN schema_ref.niveau_formation RNF ON RNF.id = type_diplome.id_niveau_formation;




CREATE TABLE schema_pilotage.ref_etablissement_francais AS
 SELECT etablissement_francais.code,
    etablissement_francais.libelle_affichage
   FROM schema_ref.etablissement_francais;




CREATE TABLE schema_pilotage.ref_situation_militaire AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'SituationMilitaire'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_situation_familiale AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'SituationFamiliale'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_quotite_activite AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'QuotiteActivite'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_specialites_bac AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'SpecialitesBacGeneral'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_situation_annee_precedente AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'SituationAnneePrecedente'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_cursus_parallele AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'CursusParallele'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_programme_echange AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'ProgrammeEchange'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_ecole_doctorale AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'EcoleDoctorale'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_canal_de_communication AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'CanalCommunication'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_regime_special_etudes AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'RegimeSpecialEtudes'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_profil_exonerant AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn,
    val.col2 AS exoins_extra
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'ProfilExonerant'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_type_resultat AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'TypeResultat'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_mention_honorifique AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'MentionHonorifique'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_notation_ects AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'NotationEcts'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_grade_point_average AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'GradePointAverage'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_niveau_formation AS
 SELECT id,
    code,
    code_bcn,
    libelle_court,
    libelle_long
   FROM schema_ref.niveau_formation;




CREATE TABLE schema_pilotage.ref_nature_diplome AS
 SELECT id,
    code,
    code_bcn,
    libelle_court,
    libelle_long
   FROM schema_ref.nature_diplome;




CREATE TABLE schema_pilotage.ref_niveau_diplome AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'NiveauDiplome'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_champ_formation AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS code_bcn
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'ChampsFormation'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_mention_diplome AS
 SELECT id,
    code,
    libelle_court,
    libelle_long
   FROM schema_ref.mention_diplome;




CREATE TABLE schema_pilotage.ref_type_objet_formation AS
 SELECT id,
    code,
    libelle_court,
    libelle_long,
    libelle_affichage,
    categorie_objet
   FROM schema_ref.type_objet_formation;




CREATE TABLE schema_pilotage.ref_type_formation AS
 SELECT id,
    code,
    libelle_court,
    libelle_long,
    libelle_affichage
   FROM schema_ref.type_formation;




CREATE TABLE schema_pilotage.ref_modalite_enseignement AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'ModaliteEnseignement'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_type_heure AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible,
    val.col1 AS equivalent_hetd
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'TypeHeure'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;




CREATE TABLE schema_pilotage.ref_finalite_formation AS
 SELECT DISTINCT ON (val.code_metier) val.id,
    val.code_metier,
    val.libelle_affichage,
    val.libelle_court,
    val.libelle_long,
    val.date_debut_validite,
    val.date_fin_validite,
    val.priorite_affichage,
    val.temoin_livre,
    val.temoin_visible
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'FinaliteFormation'::text)
  
  ORDER BY code_metier, date_debut_validite DESC;





CREATE TABLE schema_pilotage.ref_titre_acces AS
 SELECT id,
    code,
    libelle_court,
    libelle_long,
    libelle_affichage
   FROM schema_ref.titre_acces;





CREATE TABLE schema_pilotage.ref_structure AS
 SELECT id,
    code,
    code_referentiel_externe,
    code_uai,
    denomination_principale,
    denomination_complementaire,
    appellation_officielle,
    commentaire,
    date_debut_validite,
    date_fin_validite,
    temoin_visible,
    sigle_uai,
    type_uai_code,
    type_uai_libelle,
    categorie_juridique_code,
    categorie_juridique_libelle,
    id_parent,
    temoin_est_structure_mere

   FROM schema_ref.structure;

--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.ref_xxxxxxxxxxxxxxxxx'; END; $$;



/* ************************************************************************** */
/* vues concernant l'offre de formation */

   
   
   
/* espaces / periodes */
CREATE TABLE schema_pilotage.odf_espace AS
SELECT 
    id,
    type_espace,
    code_structure,
    code,
    libelle_court,
    libelle_affichage,
    libelle_long,
    version,
    annee_universitaire,
    temoin_active,
    date_debut_validite,
    date_fin_validite
    
FROM schema_odf.espace;



   

/* liste des formations */
CREATE TABLE schema_pilotage.odf_formation AS
SELECT 
    F.id,
	ESP.code AS "code_periode",
	ESP.libelle_long AS "libelle_periode",
    F.code,
    clean_string(F.libelle_court) AS "libelle_court",
    clean_string(F.libelle_long) AS "libelle_long",
	clean_string(F.description) AS "description",
    F.code_type_formation AS "code_type",
    RTF.libelle_court AS "libelle_type",
    F.code_type_diplome,
    RTD.libelle_long AS "libelle_type_diplome",
	F.code_diplome_sise,
    CASE  
		WHEN F.niveau_diplome_sise LIKE '0%' THEN split_part(F.niveau_diplome_sise, '0', 2)
		ELSE F.niveau_diplome_sise
	END AS "niveau_diplome_sise",
	F.code_parcours_type_sise,

    RTD.cursus_formation_code AS "code_cursus",
    RTD.cursus_formation_libelle_long AS "libelle_cursus",
    RTD.cursus_formation_code_bcn AS "cursus_formation_bcn",
    RTD.niveau_formation_code AS "code_niveau_formation",
    RTD.niveau_formation_libelle_long AS "libelle_niveau_formation",
    RTD.niveau_formation_code_bcn AS "niveau_formation_bcn",
    RTD.nature_diplome_code AS "code_nature_diplome",
    RTD.nature_diplome_libelle_long AS "libelle_nature_diplome",
    F.code_niveau_diplome,
    RNiD.libelle_long AS "libelle_niveau_diplome",
    F.code_champ_formation,
    RChF.libelle_long AS "libelle_champ_formation",
    F.code_domaine_formation,
    RDF.libelle_long AS "libelle_domaine_formation",
    F.code_mention,
    RMD.libelle_long AS "libelle_mention",
    NULL AS "nb_inscriptions_autorisees",-- TODO F.nb_inscriptions_autorisees,
    NULL AS "temoin_ouverte_a_inscription",-- TODO F.temoin_ouverte_a_inscription,
    NULL AS "temoin_titre_acces_necessaire",-- TODO F.temoin_titre_acces_necessaire,
    F.temoin_tele_enseignement,
    NULL AS "temoin_jamais_ouverte_a_inscription",-- TODO F.temoin_jamais_ouverte_a_inscription,
    NULL AS "temoin_envoyee_a_inscription",-- TODO F.temoin_envoyee_a_inscription,
    NULL AS "temoin_ouverte_choix_cursus",-- TODO F.temoin_ouverte_choix_cursus,
    NULL AS "temoin_jamais_ouverte_choix_cursus",-- TODO F.temoin_jamais_ouverte_choix_cursus,
    F.credit_ects,
    SB.code AS "code_structure_budgetaire",-- TODO F.code_structure_budgetaire,
    SB.code_uai AS "code_uai_structure_budgetaire",-- TODO F.code_uai_structure_budgetaire,
    NULL AS "code_referentiel_externe_structure_budgetaire",-- TODO F.code_referentiel_externe_structure_budgetaire,
    SB.denomination_principale AS "denomination_principale_structure_budgetaire",-- TODO F.denomination_principale_structure_budgetaire,
    TAR.code AS "code_tarification",-- TODO F.code_tarification,
    F.code_structure_principale AS "code_structure",
    S.code_referentiel_externe AS "code_structure_externe",
    ESE.libelle_structure_externe_web AS "libelle_structure_externe",
    NULL AS "date_contexte"-- TODO F.date_contexte

FROM schema_odf.objet_maquette F
LEFT JOIN schema_odf.espace ESP ON ESP.id = F.id_espace
LEFT JOIN schema_odf.contexte CON ON CON.id_objet_maquette = F.id
LEFT JOIN schema_pilotage.ref_type_diplome RTD ON RTD.code = F.code_type_diplome
LEFT JOIN schema_pilotage.ref_niveau_diplome RNiD ON RNiD.code_metier = F.code_niveau_diplome
LEFT JOIN schema_pilotage.ref_champ_formation RChF ON RChF.code_metier = F.code_champ_formation
LEFT JOIN schema_pilotage.ref_domaine_formation RDF ON RDF.code = F.code_domaine_formation
LEFT JOIN schema_pilotage.ref_mention_diplome RMD ON RMD.code = F.code_mention
LEFT JOIN schema_pilotage.ref_type_formation RTF ON RTF.code = F.code_type_formation
LEFT JOIN schema_ref.structure S ON S.code = F.code_structure_principale
LEFT JOIN schema_pilotage.etab_structure_externe ESE ON ESE.code_structure_externe = S.code_referentiel_externe

LEFT JOIN schema_pai.formation PAIF ON (PAIF.code = F.code AND PAIF.code_periode=ESP.code)
LEFT JOIN schema_pai.structure_budgetaire SB ON SB.id = PAIF.ref
LEFT JOIN schema_pai.tarification TAR ON TAR.id = PAIF.id_tarification

WHERE F.type_objet_maquette = 'F'
	AND ESP.type_espace = 'P'
    AND CON.temoin_valide=TRUE
	
	--AND F.code='A3CCA-351-V1'
	--AND ESP.code='PER-2025'
;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_formation'; END; $$;





/* liste des régimes d'inscriptions pour formations TODO faire table pour avoir lien objet de formation / régimes */
/*CREATE TABLE schema_pilotage.odf_formation_regime_inscription AS
SELECT 
    FRI.*,
    RI.libelle_long

FROM schema_mof.formation_regime_inscription FRI
LEFT JOIN schema_pilotage.ref_regime_inscription RI ON RI.code =FRI.code_regime_inscription
;*/
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_formation_regime_inscription'; END; $$;




/* liste des objets de formations */
CREATE TABLE schema_pilotage.odf_objet_formation AS
SELECT 
    OM.id,
	ESP.code AS "code_periode",
	ESP.libelle_long AS "libelle_periode",
    OM.code,
    clean_string(OM.libelle_court) AS "libelle_court",
    clean_string(OM.libelle_long) AS "libelle_long",
    clean_string(OM.description) AS "description",
    OM.code_diplome_sise,
    CASE  
		WHEN OM.niveau_diplome_sise LIKE '0%' THEN split_part(OM.niveau_diplome_sise, '0', 2)
		ELSE OM.niveau_diplome_sise
	END AS "niveau_diplome_sise",
    OM.code_parcours_type_sise,
    CASE  
		WHEN OM.code_type_objet_formation='FORMATION' THEN code_type_formation
		ELSE OM.code_type_objet_formation
	END AS "code_type",
    CASE  
		WHEN OM.code_type_objet_formation='FORMATION' THEN RTF.libelle_court
        WHEN OM.code_type_objet_formation='GROUPEMENT' THEN 'GROUPEMENT'
		ELSE RTOF.libelle_court
	END AS "libelle_type",
    CASE  
		WHEN RTOF.categorie_objet='OBJET_TEMPOREL_THEORIQUE' THEN 'OTT'
		WHEN RTOF.categorie_objet='OBJET_PEDAGOGIQUE' THEN 'OP'
		WHEN RTOF.categorie_objet='OBJET_ORGANISATIONNEL' THEN 'OO'
		WHEN OM.code_type_objet_formation='FORMATION' THEN 'FORMATION'
		WHEN OM.code_type_objet_formation='GROUPEMENT' THEN 'GROUPEMENT'
		ELSE NULL
	END AS "code_categorie",
    CASE  
		WHEN RTOF.categorie_objet='OBJET_TEMPOREL_THEORIQUE' THEN 'Objet temporel théorique'
		WHEN RTOF.categorie_objet='OBJET_PEDAGOGIQUE' THEN 'Objet pédagogique'
		WHEN RTOF.categorie_objet='OBJET_ORGANISATIONNEL' THEN 'Objet organisationnel'
		WHEN OM.code_type_objet_formation='FORMATION' THEN 'Formation'
        WHEN OM.code_type_objet_formation='0' THEN 'Formation'
        WHEN OM.code_type_objet_formation='1' THEN 'Formation'
		WHEN OM.code_type_objet_formation='GROUPEMENT' THEN 'Groupement'
		ELSE NULL
	END AS "libelle_categorie",
    CASE  
		WHEN OM.niveau_diplome_sise LIKE '0%' THEN split_part(OM.niveau_diplome_sise, '0', 2)
		ELSE OM.niveau_diplome_sise
	END AS "niveau_sise",
    NULL AS "nb_inscriptions_autorisees",-- TODO OM.nb_inscriptions_autorisees,
    OM.coefficient,
    
    
    OM.credit_ects,
    OM.nature,
    OM.autres_informations,
    OM.bibliographie,
    OM.contacts,
    OM.langue_enseignement,
    OM.modalite_enseignement,
    OM.objectifs,
    OM.temoin_ouverture_mobilite_entrante,
    OM.prerequis_pedagogique,
    OM.version,
    OM.plage_min,
    OM.plage_max,
    OM.volume_horaire_par_type_de_cours,
    OM.modalites_evaluation,
    OM.temoin_habilite_pour_bourses_aglae,
    OM.niveau_aglae,
    OM.numero_fresq_niveau_1,
    OM.numero_fresq_niveau_2,
    
    
    
    OM.temoin_mutualise,
    NULL AS "temoin_titre_acces_necessaire",-- TODO OM.temoin_titre_acces_necessaire,
    OM.temoin_tele_enseignement,
    OM.temoin_stage,
    OM.capacite_accueil,
    OM.code_structure_principale AS "code_structure",
    S.code_referentiel_externe AS "code_structure_externe",
    ESE.libelle_structure_externe_web AS "libelle_structure_externe",
    OM.id_formation_porteuse,
    NULL AS "date_contexte"-- TODO OM.date_contexte

FROM schema_odf.objet_maquette OM
LEFT JOIN schema_odf.espace ESP ON ESP.id = OM.id_espace
LEFT JOIN schema_odf.contexte CON ON CON.id_objet_maquette = OM.id
LEFT JOIN schema_pilotage.ref_type_objet_formation RTOF ON RTOF.code = OM.code_type_objet_formation
LEFT JOIN schema_pilotage.ref_type_formation RTF ON RTF.code = OM.code_type_formation
--LEFT JOIN schema_mof.objet_formation_categorie FC ON FC.id = OFT.id_categorie
LEFT JOIN schema_ref.structure S ON S.code = OM.code_structure_principale
LEFT JOIN schema_pilotage.etab_structure_externe ESE ON ESE.code_structure_externe = S.code_referentiel_externe

WHERE ESP.type_espace = 'P'
    AND CON.temoin_valide=TRUE
    
    AND ESP.code NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
    
GROUP BY
    OM.id,
	ESP.code,
	ESP.libelle_long,
    OM.code,
    OM.libelle_court,
    OM.libelle_long,
    OM.description,
	OM.code_diplome_sise,
	OM.niveau_diplome_sise,
	OM.code_parcours_type_sise,
    "code_type",
    "libelle_type",
    "code_categorie",
    "libelle_categorie",
    OM.niveau_diplome_sise,
-- TODO    OM.nb_inscriptions_autorisees,
    OM.coefficient,
    
    OM.credit_ects,
    OM.nature,
    OM.autres_informations,
    OM.bibliographie,
    OM.contacts,
    OM.langue_enseignement,
    OM.modalite_enseignement,
    OM.objectifs,
    OM.temoin_ouverture_mobilite_entrante,
    OM.prerequis_pedagogique,
    OM.version,
    OM.plage_min,
    OM.plage_max,
    OM.volume_horaire_par_type_de_cours,
    OM.modalites_evaluation,
    OM.temoin_habilite_pour_bourses_aglae,
    OM.niveau_aglae,
    OM.numero_fresq_niveau_1,
    OM.numero_fresq_niveau_2,
    
    OM.temoin_mutualise,
-- TODO    OM.temoin_titre_acces_necessaire,
    OM.temoin_tele_enseignement,
    OM.temoin_stage,
    OM.capacite_accueil,
    OM.code_structure_principale,
    S.code_referentiel_externe,
    ESE.libelle_structure_externe_web,
    OM.id_formation_porteuse/*,
    TODO OM.date_contexte*/

ORDER BY ESP.code;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_objet_formation'; END; $$;

CREATE UNIQUE INDEX odf_objet_formation_id_idx ON schema_pilotage.odf_objet_formation (id);





/* liste des objets, chemins et formations consolidées */
CREATE TABLE schema_pilotage.odf_objet_formation_chemin AS
SELECT 	
	CON.id,
	NULL AS id_parent,
	OM.code_periode,
	OM.libelle_periode,
    CON.chemin AS "chemin_uuid",
    NULL AS "chemin",
    NULL AS "chemin_parent",
	
	OM.id AS "id_objet_formation",
	OM.code AS "code_objet_formation",
    CON.temoin_inscription_administrative AS "objet_formation_ouvert_aux_ia",
    CON.temoin_inscription_administrative_active AS "objet_formation_ouvert_aux_ia_actif",
    
	NULL AS id_ancetre_ouvert_aux_ia,
	NULL AS "chemin_ancetre_ouvert_aux_ia",
    
	OM.libelle_court AS "libelle_court_objet_formation",
	OM.libelle_long AS "libelle_long_objet_formation",
	OM.description AS "description_objet_formation",
	OM.code_diplome_sise AS "code_diplome_sise_objet_formation",
	OM.niveau_diplome_sise AS "niveau_diplome_sise_objet_formation",
	OM.code_parcours_type_sise AS "code_parcours_type_sise_objet_formation",
	OM.code_type AS "code_type_objet_formation",
	OM.libelle_type AS "libelle_type_objet_formation",
	OM.code_categorie AS "code_categorie_objet_formation",
	OM.niveau_diplome_sise AS "niveau_sise_objet_formation",
	OM.libelle_categorie AS "libelle_categorie_objet_formation",
	OM.nb_inscriptions_autorisees AS "nb_inscriptions_autorisees_objet_formation",
	OM.coefficient AS "coefficient_objet_formation",
	
	
	
	
	
	OM.credit_ects AS "credit_ects_objet_formation",
	OM.nature AS "nature_objet_formation",
	OM.autres_informations AS "autres_informations_objet_formation",
	OM.bibliographie AS "bibliographie_objet_formation",
	OM.contacts AS "contacts_objet_formation",
	OM.langue_enseignement AS "langue_enseignement_objet_formation",
	OM.modalite_enseignement AS "modalite_enseignement_objet_formation",
	OM.objectifs AS "objectifs_objet_formation",
	OM.temoin_ouverture_mobilite_entrante AS "temoin_ouverture_mobilite_entrante_objet_formation",
	OM.prerequis_pedagogique AS "prerequis_pedagogique_objet_formation",
	OM.version AS "version_objet_formation",
	OM.plage_min AS "plage_min_objet_formation",
	OM.plage_max AS "plage_max_objet_formation",
	OM.volume_horaire_par_type_de_cours AS "volume_horaire_par_type_de_cours_objet_formation",
	OM.modalites_evaluation AS "modalites_evaluation_objet_formation",
	OM.temoin_habilite_pour_bourses_aglae AS "temoin_habilite_pour_bourses_aglae_objet_formation",
	OM.niveau_aglae AS "niveau_aglae_objet_formation",
	OM.numero_fresq_niveau_1 AS "numero_fresq_niveau_1_objet_formation",
	OM.numero_fresq_niveau_2 AS "numero_fresq_niveau_2_objet_formation",
	
	
	
	
	OM.temoin_mutualise AS "temoin_mutualise_objet_formation",
	OM.temoin_titre_acces_necessaire AS "temoin_titre_acces_necessaire_objet_formation",
	OM.temoin_tele_enseignement AS "temoin_tele_enseignement_objet_formation",
	OM.temoin_stage AS "temoin_stage_objet_formation",
	OM.capacite_accueil AS "capacite_accueil_objet_formation",
	OM.code_structure AS "code_structure_objet_formation",
    S1.code_referentiel_externe AS "code_structure_externe_objet_formation",
    ESE1.libelle_structure_externe_web AS "libelle_structure_externe_objet_formation",
	
    OM.id_formation_porteuse,
	F.id AS "id_formation",
	F.code AS "code_formation",
	F.libelle_court AS "libelle_court_formation",
	F.libelle_long AS "libelle_long_formation",
	F.description AS "description_formation",
	F.code_diplome_sise AS "code_diplome_sise_formation",
	F.niveau_diplome_sise AS "niveau_diplome_sise_formation",
	F.code_parcours_type_sise AS "code_parcours_type_sise_formation",
	F.code_type AS "code_type_formation",
	F.libelle_type AS "libelle_type_formation",
	F.code_type_diplome,
	F.libelle_type_diplome,
	F.code_cursus,
	F.libelle_cursus,
    F.cursus_formation_bcn,
	F.code_niveau_formation,
	F.libelle_niveau_formation,
    F.niveau_formation_bcn,
    NULL AS "niveau",
	F.code_nature_diplome,
	F.libelle_nature_diplome,
	F.code_niveau_diplome,
	F.libelle_niveau_diplome,
	F.code_champ_formation,
	F.libelle_champ_formation,
	F.code_domaine_formation,
	F.libelle_domaine_formation,
	F.code_mention,
	F.libelle_mention,
    
    FALSE AS "sous_convention",
    NULL AS "sous_convention_etablissement",
    
	F.nb_inscriptions_autorisees AS "nb_inscriptions_autorisees_formation",
	F.temoin_ouverte_a_inscription AS "temoin_ouverte_a_inscription",
	F.temoin_titre_acces_necessaire AS "temoin_titre_acces_necessaire",
	F.temoin_tele_enseignement AS "temoin_tele_enseignement",
	F.temoin_jamais_ouverte_a_inscription AS "temoin_jamais_ouverte_a_inscription",
	F.temoin_envoyee_a_inscription AS "temoin_envoyee_a_inscription",
	F.temoin_ouverte_choix_cursus AS "temoin_ouverte_choix_cursus",
	F.temoin_jamais_ouverte_choix_cursus AS "temoin_jamais_ouverte_choix_cursus",
	F.credit_ects AS "credit_ects_formation",
	F.code_structure_budgetaire AS "code_structure_budgetaire_formation",
	F.code_uai_structure_budgetaire AS "code_uai_structure_budgetaire_formation",
	F.code_referentiel_externe_structure_budgetaire AS "code_referentiel_externe_structure_budgetaire_formation",
	F.denomination_principale_structure_budgetaire AS "denomination_principale_structure_budgetaire_formation",
	F.code_tarification AS "code_tarification_formation",
	F.code_structure AS "code_structure_formation",
    S2.code_referentiel_externe AS "code_structure_externe_formation",
    ESE2.libelle_structure_externe_web AS "libelle_structure_externe_formation"
	
FROM schema_pilotage.odf_objet_formation OM
LEFT JOIN schema_odf.contexte CON ON CON.id_objet_maquette = OM.id
LEFT JOIN schema_pilotage.odf_formation F ON F.id = CON.chemin[1]
LEFT JOIN schema_ref.structure S1 ON S1.code = OM.code_structure
LEFT JOIN schema_ref.structure S2 ON S2.code = F.code_structure
LEFT JOIN schema_pilotage.etab_structure_externe ESE1 ON ESE1.code_structure_externe = S1.code_referentiel_externe
LEFT JOIN schema_pilotage.etab_structure_externe ESE2 ON ESE2.code_structure_externe = S2.code_referentiel_externe
GROUP BY 
    CON.id,
    OM.code_periode,
    OM.libelle_periode,
    CON.chemin,
    OM.id,
    OM.code,
    CON.temoin_inscription_administrative,
    CON.temoin_inscription_administrative_active,
    OM.libelle_court,
    OM.libelle_long,
    OM.description,
	OM.code_diplome_sise,
	OM.niveau_diplome_sise,
	OM.code_parcours_type_sise,
    OM.code_type,
    OM.libelle_type,
    OM.code_categorie,
    OM.libelle_categorie,
    OM.nb_inscriptions_autorisees,
    OM.coefficient,
    
    OM.credit_ects,
    OM.nature,
    OM.autres_informations,
    OM.bibliographie,
    OM.contacts,
    OM.langue_enseignement,
    OM.modalite_enseignement,
    OM.objectifs,
    OM.temoin_ouverture_mobilite_entrante,
    OM.prerequis_pedagogique,
    OM.version,
    OM.plage_min,
    OM.plage_max,
    OM.volume_horaire_par_type_de_cours,
    OM.modalites_evaluation,
    OM.temoin_habilite_pour_bourses_aglae,
    OM.niveau_aglae,
    OM.numero_fresq_niveau_1,
    OM.numero_fresq_niveau_2,
    
    OM.temoin_mutualise,
    OM.temoin_titre_acces_necessaire,
    OM.temoin_tele_enseignement,
    OM.temoin_stage,
    OM.capacite_accueil,
    OM.code_structure,
    S1.code_referentiel_externe,
    ESE1.libelle_structure_externe_web,
    OM.id_formation_porteuse,
    F.id,
    F.code,
    F.libelle_court,
    F.libelle_long,
	F.description,
	F.code_diplome_sise,
	F.niveau_diplome_sise,
	F.code_parcours_type_sise,
    F.code_type,
    F.libelle_type,
    F.code_type_diplome,
    F.libelle_type_diplome,
    F.code_cursus,
    F.libelle_cursus,
    F.cursus_formation_bcn,
    F.code_niveau_formation,
    F.libelle_niveau_formation,
    F.niveau_formation_bcn,
    F.code_nature_diplome,
    F.libelle_nature_diplome,
    F.code_niveau_diplome,
    F.libelle_niveau_diplome,
    F.code_champ_formation,
    F.libelle_champ_formation,
    F.code_domaine_formation,
    F.libelle_domaine_formation,
    F.code_mention,
    F.libelle_mention,
    F.nb_inscriptions_autorisees,
    F.temoin_ouverte_a_inscription,
    F.temoin_titre_acces_necessaire,
    F.temoin_tele_enseignement,
    F.temoin_jamais_ouverte_a_inscription,
    F.temoin_envoyee_a_inscription,
    F.temoin_ouverte_choix_cursus,
    F.temoin_jamais_ouverte_choix_cursus,
    F.credit_ects,
    F.code_structure_budgetaire,
    F.code_uai_structure_budgetaire,
    F.code_referentiel_externe_structure_budgetaire,
    F.denomination_principale_structure_budgetaire,
    F.code_tarification,
    F.code_structure,
    S2.code_referentiel_externe,
    ESE2.libelle_structure_externe_web
ORDER BY OM.code_periode, chemin;
ALTER TABLE schema_pilotage.odf_objet_formation_chemin ALTER COLUMN id_parent TYPE uuid USING (id_parent::uuid);
ALTER TABLE schema_pilotage.odf_objet_formation_chemin ALTER COLUMN id_ancetre_ouvert_aux_ia TYPE uuid USING (id_ancetre_ouvert_aux_ia::uuid);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_objet_formation_chemin'; END; $$;



/* création de plusieurs index */
CREATE UNIQUE INDEX odf_objet_formation_chemin_id_idx ON schema_pilotage.odf_objet_formation_chemin (id);
--CREATE UNIQUE INDEX odf_objet_formation_chemin_id_objet_formation_idx ON schema_pilotage.odf_objet_formation_chemin (id_objet_formation);
CREATE INDEX odf_objet_formation_chemin_chemin_uuid_idx ON schema_pilotage.odf_objet_formation_chemin USING GIN (chemin_uuid);
CREATE INDEX odf_objet_formation_chemin_chemin_idx ON schema_pilotage.odf_objet_formation_chemin (chemin);
CREATE INDEX odf_objet_formation_chemin_chemin_parent_idx ON schema_pilotage.odf_objet_formation_chemin (chemin_parent);

--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE INDEX xxx ON schema_pilotage.odf_objet_formation_chemin'; END; $$;




/* calcule le chemin et chemin_parent */
/*DO $$ DECLARE
    r RECORD;
	uuid_chemin_item uuid;
BEGIN
	FOR r IN (SELECT * FROM schema_pilotage.odf_objet_formation_chemin) LOOP
    --FOR r IN (SELECT * FROM schema_pilotage.odf_objet_formation_chemin LIMIT 200) LOOP
		FOREACH uuid_chemin_item in array r.chemin_uuid LOOP
			--raise info '% - %', uuid_chemin_item, r.id;
			UPDATE schema_pilotage.odf_objet_formation_chemin
			SET chemin = 
				CASE
					WHEN chemin IS NULL OR chemin = '' THEN (SELECT code FROM schema_odf.objet_maquette WHERE id=uuid_chemin_item)
					ELSE CONCAT(chemin, '>', (SELECT code FROM schema_odf.objet_maquette WHERE id=uuid_chemin_item))
				END
			WHERE id = r.id;
		END LOOP;

    END LOOP;
END $$;

UPDATE schema_pilotage.odf_objet_formation_chemin SET chemin_parent = reverse(SUBSTRING(reverse(chemin), STRPOS(reverse(chemin), '>')+1, CHAR_LENGTH(reverse(chemin)))) WHERE STRPOS(chemin, '>')>0;*/
UPDATE schema_pilotage.odf_objet_formation_chemin c
SET chemin = sub.chemin
FROM (
    SELECT
        oc.id,
        string_agg(om.code, '>' ORDER BY u.ordinality) AS chemin
    FROM schema_pilotage.odf_objet_formation_chemin oc
    CROSS JOIN LATERAL unnest(oc.chemin_uuid) WITH ORDINALITY AS u(uuid, ordinality)
    JOIN schema_odf.objet_maquette om ON om.id = u.uuid
    GROUP BY oc.id
) sub
WHERE sub.id = c.id;

UPDATE schema_pilotage.odf_objet_formation_chemin SET chemin_parent = left(chemin, length(chemin) - strpos(reverse(chemin), '>')) WHERE chemin LIKE '%>%';




/* complète le parent - note : passe par une boucle FOR car l'UPDATE en masse bloque tout le script ? */
UPDATE schema_pilotage.odf_objet_formation_chemin OFC_FILS
SET id_parent = ENF.id_objet_maquette_parent
FROM schema_odf.enfant ENF
WHERE OFC_FILS.id_objet_formation = ENF.id_objet_maquette;
--DO $$ BEGIN RAISE NOTICE 'DONE : UPDATE schema_pilotage.odf_objet_formation_chemin SET id_parent'; END; $$;


/* complète l'ancêtre qui porte l'IA */
--UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = NULL, chemin_ancetre_ouvert_aux_ia = NULL;
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT *
                              FROM  schema_pilotage.odf_objet_formation_chemin
                              WHERE objet_formation_ouvert_aux_ia = TRUE
                              --AND code_type_diplome='TYD020'
                              --AND code_periode='PER-2023'
                              ORDER BY code_periode, code_formation, chemin DESC) LOOP
        --UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = r.id, chemin_ancetre_ouvert_aux_ia = r.chemin WHERE objet_formation_ouvert_aux_ia = FALSE AND chemin LIKE r.chemin||'>%' AND code_periode = r.code_periode AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL;
        --UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = r.id, chemin_ancetre_ouvert_aux_ia = r.chemin WHERE r.id_objet_formation=ANY(chemin_uuid) AND objet_formation_ouvert_aux_ia = FALSE AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL;
        UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = r.id, chemin_ancetre_ouvert_aux_ia = r.chemin WHERE chemin_uuid @> ARRAY[r.id_objet_formation] AND objet_formation_ouvert_aux_ia = FALSE AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL;
    END LOOP;
END $$;




/* complète le niveau de formation */
/*UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = NULL;

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = concat(cursus_formation_bcn, niveau_sise_objet_formation)
WHERE  objet_formation_ouvert_aux_ia = TRUE AND niveau IS NULL
    AND (cursus_formation_bcn IS NOT NULL AND niveau_sise_objet_formation IS NOT NULL);*/






/* formats d'enseignement */
CREATE TABLE schema_pilotage.odf_format_enseignement AS
SELECT
    FE.id,
	--OFC.id_formation,
	OFC.id_formation_porteuse AS "id_formation_porteuse_charge",
    FE.id_objet_maquette AS "id_objet_formation",
    FE.type_heure AS "code_format",
    RTH.libelle_court AS "libelle_court_format",
    RTH.libelle_long AS "libelle_long_format",
	
    CAST (RTH.equivalent_hetd AS NUMERIC),
	
	FE.volume_horaire,
	FLOOR(FE.volume_horaire / 3600)::INTEGER AS volume_horaire_heure,
	CAST ((FE.volume_horaire - (FLOOR(FE.volume_horaire / 3600)::INTEGER)*3600)/60 AS INTEGER) AS volume_horaire_minute,
    FE.nombre_theorique_groupe AS "nombre_theorique_groupes",
    FE.seuil_dedoublement,
    
    CASE  
		WHEN FE.modalite='' THEN NULL
		ELSE FE.modalite
	END AS "code_modalite",
    
    RME.libelle_court AS "libelle_court_modalite",
    RME.libelle_long AS "libelle_long_modalite"
	
FROM schema_odf.formats_enseignement FE
JOIN schema_pilotage.ref_type_heure RTH ON FE.type_heure = RTH.code_metier
JOIN schema_pilotage.odf_objet_formation_chemin OFC ON OFC.id_objet_formation = FE.id_objet_maquette
LEFT JOIN schema_pilotage.ref_modalite_enseignement RME ON FE.modalite = RME.code_metier

GROUP BY FE.id,
	--OFC.id_formation,
	OFC.id_formation_porteuse,
    FE.id_objet_maquette,
    FE.type_heure,
    RTH.libelle_court,
    RTH.libelle_long,
	RTH.equivalent_hetd,
	FE.volume_horaire,
    FE.nombre_theorique_groupe,
    FE.seuil_dedoublement,
    FE.modalite,
    RME.libelle_court,
    RME.libelle_long;




/* ************************************************************************** */
/* vues concernant les apprenants */


/* apprenants */
CREATE TABLE schema_pilotage.idt_apprenant AS
 SELECT APP.id::varchar(255),
    APP.identifiant_apprenant_pegase AS "identifiant_pegase",
    APP.code_apprenant,
    APP.ine_maitre,
    APP.etat_ine_maitre AS "statut_ine_maitre",
    array_to_string(APP.liste_ines_alternatifs, ',') AS "liste_ine",
    ARRAY[APP.ine_maitre] || APP.liste_ines_alternatifs AS "liste_ines_complete",
	
    clean_string(IDT.nom_naissance) AS "nom_famille",
    clean_string(APP.nom_usage) AS "nom_usuel",
    clean_string(IDT.prenom) AS "prenom",
    clean_string(APP.prenom2) AS "prenom2",
    clean_string(APP.prenom3) AS "prenom3",
    APP.sexe AS "sexe",
    APP.date_naissance,
    APP.code_pays_naissance,
    P1.libelle_long AS "libelle_pays_naissance",
    APP.code_commune_naissance,
    C.libelle_long AS "libelle_commune_naissance",
    APP.libelle_commune_naissance_etranger,
    APP.code_nationalite,
    P2.libelle_nationalite AS "libelle_nationalite",
    APP.code_nationalite2,
    P3.libelle_nationalite AS "libelle_nationalite2",
    APP.date_obtention_nationalite2,
    APP.annee_obtention_bac,
    APP.code_serie_bac AS "code_type_ou_serie_bac",
    SB.libelle_long AS "libelle_type_ou_serie_bac",
    APP.code_mention_bac,
    MB.libelle_long AS "libelle_mention_bac",
    APP.type_etablissement_bac,
    APP.code_pays_bac,
    P4.libelle_long AS "libelle_pays_bac",
    APP.code_departement_bac,
    UPPER(D.libelle_affichage) AS "libelle_departement_bac",
    APP.code_etablissement_bac,
    UPPER(EF.libelle_affichage) AS "libelle_etablissement_bac",
    clean_string(APP.libelle_etablissement_bac_etranger) AS "etablissement_libre_bac",
    APP.complement_titre_dispense_bac AS "precision_titre_dispense_bac",
    APP.annee_entree_ens_sup AS "annee_entree_enseignement_superieur",
    
    APP.code_titre_acces_esr_fr AS "code_titre_acces_esr_francais",
    AEF.libelle_long AS "libelle_titre_acces_esr_francais",
    
    APP.annee_entree_universite,
    APP.annee_entree_etablissement,
    APP.code_categorie_socio_professionnelle AS "code_categorie_socioprofessionnelle",
    CSP1.libelle_long AS "libelle_categorie_socioprofessionnelle",
    APP.code_quotite_travaillee,
    QA.libelle_long AS "libelle_quotite_travaillee",
    APP.code_categorie_socio_prof_parent1 AS "code_categorie_socioprofessionnelle_parent1",
    CSP2.libelle_long AS "libelle_socioprofessionnelle_parent1",
    APP.code_categorie_socio_prof_parent2 AS "code_categorie_socioprofessionnelle_parent2",
    CSP3.libelle_long AS "libelle_socioprofessionnelle_parent2",
    APP.code_situation_familiale,
    SF.libelle_long AS "libelle_situation_familiale",
    APP.nombre_enfants,
    APP.code_situation_militaire,
    SM.libelle_long AS "libelle_situation_militaire",
    APP.code_premiere_specialite_bac,
    SP1.libelle_long AS "libelle_premiere_specialite_bac",
    APP.code_deuxieme_specialite_bac,
    SP2.libelle_long AS "libelle_deuxieme_specialite_bac",
    
    APP.id_appr_lie AS "id_identite_liee",
    APP.temoin_doublon_potentiel AS "temoin_doublon_potentiel",
    IDT.date_creation AS "date_de_creation",
    IDT.date_modification AS "date_de_modification"

FROM schema_idt.apprenant APP
   
LEFT JOIN schema_idt.identite IDT ON APP.id=IDT.id
LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = APP.code_pays_naissance
LEFT JOIN schema_pilotage.ref_pays_nationalite P2 ON P2.code = APP.code_nationalite
LEFT JOIN schema_pilotage.ref_pays_nationalite P3 ON P3.code = APP.code_nationalite2
LEFT JOIN schema_pilotage.ref_pays_nationalite P4 ON P4.code = APP.code_pays_bac
LEFT JOIN schema_pilotage.ref_specialites_bac SP1 ON SP1.code_metier = APP.code_premiere_specialite_bac
LEFT JOIN schema_pilotage.ref_specialites_bac SP2 ON SP2.code_metier = APP.code_deuxieme_specialite_bac
LEFT JOIN schema_pilotage.ref_commune_insee C ON C.code_insee = APP.code_commune_naissance
LEFT JOIN schema_pilotage.ref_departement D ON D.code = APP.code_departement_bac
LEFT JOIN schema_pilotage.ref_serie_bac SB ON SB.code = APP.code_serie_bac
LEFT JOIN schema_pilotage.ref_mention_bac MB ON MB.code_metier = APP.code_mention_bac
LEFT JOIN schema_pilotage.ref_titre_acces AEF ON AEF.code = APP.code_titre_acces_esr_fr
LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP1 ON CSP1.code = APP.code_categorie_socio_professionnelle
LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP2 ON CSP2.code = APP.code_categorie_socio_prof_parent1
LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP3 ON CSP3.code = APP.code_categorie_socio_prof_parent2
LEFT JOIN schema_pilotage.ref_etablissement_francais EF ON EF.code = APP.code_etablissement_bac
LEFT JOIN schema_pilotage.ref_quotite_activite QA ON QA.code_metier = APP.code_quotite_travaillee
LEFT JOIN schema_pilotage.ref_situation_familiale SF ON SF.code_metier = APP.code_situation_familiale
LEFT JOIN schema_pilotage.ref_situation_militaire SM ON SM.code_metier = APP.code_situation_militaire
   

WHERE APP.code_apprenant IS NOT NULL

--AND username LIKE '%.%'
--LIMIT 500
;

ALTER TABLE schema_pilotage.idt_apprenant ADD PRIMARY KEY (id);
CREATE UNIQUE INDEX idt_apprenant_id_idx ON schema_pilotage.idt_apprenant (id);
CREATE INDEX idt_apprenant_code_apprenant_idx ON schema_pilotage.idt_apprenant (code_apprenant);
CREATE INDEX idt_apprenant_liste_ines_complete_idx ON schema_pilotage.idt_apprenant USING GIN (liste_ines_complete);

UPDATE schema_pilotage.idt_apprenant SET ine_maitre = NULL WHERE ine_maitre = 'N/A';

/*SELECT * FROM schema_pilotage.idt_apprenant;*/









/* ******************* */
/* contacts */

/* adresse fixe */
CREATE TABLE schema_pilotage.idt_contact_adresse_fixe AS
 SELECT id::varchar(255) AS "id_apprenant",
    clean_string(adresse_fixe_proprietaire) AS "adresse_fixe_proprietaire",
    code_postal_fixe AS "adresse_fixe_code_postal",
    code_commune_fixe AS "adresse_fixe_code_commune",
    C.libelle_long AS "adresse_fixe_libelle_commune",
    clean_string(adresse_fixe_ligne1_etage) AS "adresse_fixe_ligne1_ou_etage",
    clean_string(adresse_fixe_ligne2_batiment) AS "adresse_fixe_ligne2_ou_batiment",
    clean_string(adresse_fixe_ligne3_voie) AS "adresse_fixe_ligne3_ou_voie",
    clean_string(adresse_fixe_ligne4_complement) AS "adresse_fixe_ligne4_ou_complement",
    clean_string(adresse_fixe_ligne5_etranger) AS "adresse_fixe_ligne5_etranger",
    code_pays_fixe AS "adresse_fixe_code_pays",
    P1.libelle_long AS "adresse_fixe_libelle_pays"

FROM schema_idt.apprenant

LEFT JOIN schema_pilotage.ref_commune_insee C ON C.code_insee = apprenant.code_commune_fixe
LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = apprenant.code_pays_fixe;


CREATE UNIQUE INDEX idt_contact_adresse_fixe_id_idx ON schema_pilotage.idt_contact_adresse_fixe (id_apprenant);


    


/* adresse annuelle */
CREATE TABLE schema_pilotage.idt_contact_adresse_annuelle AS
 SELECT id::varchar(255) AS "id_apprenant",
    code_postal_periode_universitaire AS "adresse_annuelle_code_postal",
    code_commune_periode_universitaire AS "adresse_annuelle_code_commune",
    C.libelle_long AS "adresse_annuelle_libelle_commune",
    clean_string(adresse_periode_universitaire_ligne1_etage)AS "adresse_annuelle_ligne1_ou_etage",
    clean_string(adresse_periode_universitaire_ligne2_batiment)AS "adresse_annuelle_ligne2_ou_batiment",
    clean_string(adresse_periode_universitaire_ligne3_voie)AS "adresse_annuelle_ligne3_ou_voie",
    clean_string(adresse_periode_universitaire_ligne4_complement)AS "adresse_annuelle_ligne4_ou_complement",
    clean_string(adresse_periode_universitaire_ligne5_etranger)AS "adresse_annuelle_ligne5_etranger",
    code_pays_periode_universitaire AS "adresse_annuelle_code_pays",
    P1.libelle_long AS "adresse_annuelle_libelle_pays"

FROM schema_idt.apprenant

LEFT JOIN schema_pilotage.ref_commune_insee C ON C.code_insee = apprenant.code_commune_periode_universitaire
LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = apprenant.code_pays_periode_universitaire;


CREATE UNIQUE INDEX idt_contact_adresse_annuelle_id_idx ON schema_pilotage.idt_contact_adresse_annuelle (id_apprenant);





/* mail perso */
CREATE TABLE schema_pilotage.idt_contact_mail_perso AS
 SELECT id::varchar(255) AS "id_apprenant",
    mail AS "mail_perso"

   FROM schema_idt.identite;
CREATE UNIQUE INDEX idt_contact_mail_perso_id_idx ON schema_pilotage.idt_contact_mail_perso (id_apprenant);



/* mail institutionnel */
CREATE TABLE schema_pilotage.idt_contact_mail_institutionnel AS
 SELECT id::varchar(255) AS "id_apprenant",
    mail_institutionnel AS "mail_institutionnel"

   FROM schema_idt.apprenant;
CREATE UNIQUE INDEX idt_contact_mail_institutionnel_id_idx ON schema_pilotage.idt_contact_mail_institutionnel (id_apprenant);



/* mail de secours */
CREATE TABLE schema_pilotage.idt_contact_mail_secours AS
 SELECT id::varchar(255) AS "id_apprenant",
    clean_string(mail_secours_proprietaire) AS "mail_secours_proprietaire",
    mail_secours AS "mail_secours"

FROM  schema_idt.apprenant;
CREATE UNIQUE INDEX idt_contact_mail_secours_id_idx ON schema_pilotage.idt_contact_mail_secours (id_apprenant);




/* telephone perso */
CREATE TABLE schema_pilotage.idt_contact_telephone_perso AS
 SELECT id::varchar(255) AS "id_apprenant",
    telephone_portable_personnel AS "telephone_perso"

FROM schema_idt.identite;
CREATE UNIQUE INDEX idt_contact_telephone_perso_id_idx ON schema_pilotage.idt_contact_telephone_perso (id_apprenant);



/* telephone contact d'urgence */
CREATE TABLE schema_pilotage.idt_contact_telephone_urgence AS
 SELECT id::varchar(255) AS "id_apprenant",
    clean_string(telephone_urgence_proprietaire) AS "telephone_urgence_proprietaire",
    telephone_urgence AS "telephone_urgence"

FROM  schema_idt.apprenant;
CREATE UNIQUE INDEX idt_contact_telephone_urgence_id_idx ON schema_pilotage.idt_contact_telephone_urgence (id_apprenant);











/* vue avec toutes les methodes de contact */
CREATE VIEW schema_pilotage.idt_contacts AS
 SELECT APP.id AS "id_apprenant",
    ETAB.mail AS "mail_etab",
    
    ICMI.mail_institutionnel,
    ICMP.mail_perso,
    ICMS.mail_secours_proprietaire,
    ICMS.mail_secours,
    
    
    ICTP.telephone_perso,
    ICTU.telephone_urgence_proprietaire,
    ICTU.telephone_urgence,
    
    ICAF.adresse_fixe_proprietaire,
    ICAF.adresse_fixe_code_postal,
    ICAF.adresse_fixe_code_commune,
    ICAF.adresse_fixe_libelle_commune,
    ICAF.adresse_fixe_ligne1_ou_etage,
    ICAF.adresse_fixe_ligne2_ou_batiment,
    ICAF.adresse_fixe_ligne3_ou_voie,
    ICAF.adresse_fixe_ligne4_ou_complement,
    ICAF.adresse_fixe_ligne5_etranger,
    ICAF.adresse_fixe_code_pays,
    ICAF.adresse_fixe_libelle_pays,
    
    ICAA.adresse_annuelle_code_postal,
    ICAA.adresse_annuelle_code_commune,
    ICAA.adresse_annuelle_libelle_commune,
    ICAA.adresse_annuelle_ligne1_ou_etage,
    ICAA.adresse_annuelle_ligne2_ou_batiment,
    ICAA.adresse_annuelle_ligne3_ou_voie,
    ICAA.adresse_annuelle_ligne4_ou_complement,
    ICAA.adresse_annuelle_ligne5_etranger,
    ICAA.adresse_annuelle_code_pays,
    ICAA.adresse_annuelle_libelle_pays

   FROM schema_pilotage.idt_apprenant APP
   LEFT JOIN schema_pilotage.etab_apprenant ETAB ON ETAB.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_mail_institutionnel ICMI ON ICMI.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_mail_perso ICMP ON ICMP.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_mail_secours ICMS ON ICMS.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_telephone_perso ICTP ON ICTP.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_telephone_urgence ICTU ON ICTU.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_adresse_fixe ICAF ON ICAF.id_apprenant = APP.id
   LEFT JOIN schema_pilotage.idt_contact_adresse_annuelle ICAA ON ICAA.id_apprenant = APP.id;
    
    





/* ************************************************************************** */
/* vues concernant les pieces justificatives */


/* TODO v28 vérifier */
CREATE TABLE schema_pilotage.ins_demande_piece AS
 SELECT 
	demande_piece.id,
	demande_piece.version,
	piece_justificative.code AS "code_metier",
	periode.code AS "code_periode",
	piece_justificative.libelle_affichage,
	demande_piece.description,
    /*temoin_primo,
    temoin_reins,*/
	demande_piece.temoin_televersement,
	demande_piece.temoin_obligatoire,
	demande_piece.temoin_validation_gestionnaire,
    /*code_piece_a_fournir,*/
	demande_piece.date_debut_validite,
	demande_piece.date_fin_validite,
	piece_justificative.priorite_affichage,
    /*temoin_livre,*/
	piece_justificative.temoin_photo
	
FROM schema_piece.demande_piece,
	schema_piece.periode,
	schema_piece.piece_justificative
WHERE demande_piece.id_periode = periode.id
AND demande_piece.id_piece_justificative = piece_justificative.id

ORDER BY periode.code, piece_justificative.code;





/* TODO v28 pas bon : ticket en cours, je ne récupère pas les pièces de Magalie */
CREATE TABLE schema_pilotage.ins_depot_piece AS
 SELECT 
	depot_piece.id,
	depot_piece.version,
	
	idt_apprenant.id AS "id_apprenant",
	depot_piece.code_apprenant,
	
	inscription.id AS "id_inscription",
	depot_piece.date_depot,
	depot_piece.statut,
	depot_piece.motif_rejet,
	
	odf_objet_formation_chemin.id AS "id_objet_formation_chemin",
	depot_piece.code_chemin,
	
	
	ins_demande_piece.code_metier,
	ins_demande_piece.code_periode,
	ins_demande_piece.libelle_affichage,
	ins_demande_piece.description,
	ins_demande_piece.temoin_televersement,
	ins_demande_piece.temoin_obligatoire,
	ins_demande_piece.temoin_validation_gestionnaire,
	ins_demande_piece.date_debut_validite,
	ins_demande_piece.date_fin_validite,
	ins_demande_piece.priorite_affichage,
	ins_demande_piece.temoin_photo
	
FROM schema_piece.depot_piece


LEFT JOIN schema_pilotage.ins_demande_piece ON ins_demande_piece.id = depot_piece.id_demande_piece
LEFT JOIN schema_pilotage.idt_apprenant ON idt_apprenant.code_apprenant = depot_piece.code_apprenant
LEFT JOIN schema_pilotage.odf_objet_formation_chemin ON odf_objet_formation_chemin.chemin = depot_piece.code_chemin AND odf_objet_formation_chemin.code_periode = ins_demande_piece.code_periode
LEFT JOIN schema_ins.inscription ON odf_objet_formation_chemin.id = inscription.id_odf_chemin AND idt_apprenant.id = inscription.id_apprenant::varchar


ORDER BY code_periode, code_metier;


   



/* ************************************************************************** */
/* vues concernant les inscriptions administratives */


/* Tables en majuscule pour optimiser les comparaisons de chaines */
/*CREATE TABLE schema_pilotage.temp_schema_ins_admis_maj AS 
SELECT id,
	UPPER(mail) AS "mail",
	UPPER(nom_naissance) AS "nom_naissance",
	UPPER(prenom) AS "prenom",
	date_fin_csv_job
FROM schema_ins.admis;


/* Tables en majuscule pour optimiser les comparaisons de chaines */
CREATE TABLE schema_pilotage.temp_schema_ins_apprenant_maj AS 
SELECT IAPP.id::varchar AS "id", 
	UPPER(IAPP.mail) AS "mail",
	UPPER(IAPP.nom_naissance) AS "nom_naissance",
	UPPER(IAPP.prenom) AS "prenom"
FROM schema_ins.apprenant IAPP;*/




/* ADMIS avec ou sans inscription en cours ou terminée */
CREATE TABLE schema_pilotage.ins_admis AS
 SELECT ADMIS.id AS "id",
	NULL AS "numero_candidat",
	APP.id AS "id_apprenant",
	APP.code_apprenant,
	CASE  
		WHEN APP.ine_maitre!='N/A' THEN APP.ine_maitre
		ELSE NULL
	END AS "ine",
	APP.statut_ine_maitre AS "statut_ine",
	APP.nom_famille,
	APP.nom_usuel,
	APP.prenom,
	APP.prenom2,
	APP.prenom3,
	APP.sexe,
	APP.date_naissance,
	APP.code_pays_naissance,
	APP.libelle_pays_naissance,
	APP.code_commune_naissance,
	APP.libelle_commune_naissance,
	APP.libelle_commune_naissance_etranger,
	APP.code_nationalite,
	APP.libelle_nationalite,
	APP.annee_obtention_bac,
	APP.code_type_ou_serie_bac,
	APP.code_mention_bac,
	APP.type_etablissement_bac,
	APP.code_pays_bac,
	APP.code_departement_bac,
	APP.code_etablissement_bac,
	APP.etablissement_libre_bac,
	APP.precision_titre_dispense_bac AS "precisions_titre_dispense_bac",
	APP.annee_entree_enseignement_superieur,
	APP.annee_entree_universite,
	APP.annee_entree_etablissement,
	APP.code_categorie_socioprofessionnelle,
	APP.code_quotite_travaillee,
	APP.code_categorie_socioprofessionnelle_parent1,
	APP.code_categorie_socioprofessionnelle_parent2,
	APP.code_situation_familiale,
	APP.nombre_enfants,
	APP.code_situation_militaire,
	APP.code_premiere_specialite_bac,
	APP.code_deuxieme_specialite_bac,
	NULL AS temoin_neo_bachelier, -- bascule dans l'inscription en v28
	NULL AS "statut_admission",-- disparu en v28
	CONT.adresse_annuelle_code_pays AS "adresse_code_pays",
	CONT.adresse_annuelle_ligne1_ou_etage AS "adresse_ligne1_etage",
	CONT.adresse_annuelle_ligne2_ou_batiment AS "adresse_ligne2_batiment",
	CONT.adresse_annuelle_ligne3_ou_voie AS "adresse_ligne3_voie",
	CONT.adresse_annuelle_ligne4_ou_complement AS "adresse_ligne4_complement",
	CONT.adresse_annuelle_code_postal AS "adresse_code_postal",
	CONT.adresse_annuelle_code_commune AS "adresse_code_commune",
	CONT.adresse_annuelle_ligne5_etranger AS "adresse_ligne5_etranger",
	CONT.adresse_fixe_code_postal AS "adresse_fixe_code_postal",
	CONT.adresse_fixe_code_commune AS "adresse_fixe_code_commune",
	CONT.adresse_fixe_libelle_commune AS "adresse_fixe_libelle_commune",
	CONT.adresse_fixe_ligne1_ou_etage AS "adresse_fixe_ligne1_ou_etage",
	CONT.adresse_fixe_ligne2_ou_batiment AS "adresse_fixe_ligne2_ou_batiment",
	CONT.adresse_fixe_ligne3_ou_voie AS "adresse_fixe_ligne3_ou_voie",
	CONT.adresse_fixe_ligne4_ou_complement AS "adresse_fixe_ligne4_ou_complement",
	CONT.adresse_fixe_ligne5_etranger AS "adresse_fixe_ligne5_etranger",
	CONT.adresse_fixe_code_pays AS "adresse_fixe_code_pays",
	CONT.adresse_fixe_libelle_pays AS "adresse_fixe_libelle_pays",
	CONT.adresse_annuelle_code_postal AS "adresse_annuelle_code_postal",
	CONT.adresse_annuelle_code_commune AS "adresse_annuelle_code_commune",
	CONT.adresse_annuelle_libelle_commune AS "adresse_annuelle_libelle_commune",
	CONT.adresse_annuelle_ligne1_ou_etage AS "adresse_annuelle_ligne1_ou_etage",
	CONT.adresse_annuelle_ligne2_ou_batiment AS "adresse_annuelle_ligne2_ou_batiment",
	CONT.adresse_annuelle_ligne3_ou_voie AS "adresse_annuelle_ligne3_ou_voie",
	CONT.adresse_annuelle_ligne4_ou_complement AS "adresse_annuelle_ligne4_ou_complement",
	CONT.adresse_annuelle_ligne5_etranger AS "adresse_annuelle_ligne5_etranger",
	CONT.adresse_annuelle_code_pays AS "adresse_annuelle_code_pays",
	CONT.adresse_annuelle_libelle_pays AS "adresse_annuelle_libelle_pays",
	CONT.telephone_urgence AS "telephone1",
	CONT.telephone_perso AS "telephone2",
	CONT.mail_perso AS "mail",
	ADMIS.date_fin_csv_job AS "date_de_creation",
	ADMIS.date_fin_csv_job AS "date_de_modification"

   FROM schema_ins.admis ADMIS,
	--schema_pilotage.temp_schema_ins_admis_maj ADMIS,
	--schema_pilotage.temp_schema_ins_apprenant_maj IAPP,
	schema_pilotage.idt_apprenant APP,
	schema_pilotage.idt_contacts CONT

   WHERE APP.liste_ines_complete @> ARRAY[admis.INE]
   --IAPP.mail = ADMIS.mail AND IAPP.nom_naissance = ADMIS.nom_naissance AND IAPP.prenom = ADMIS.prenom
   --AND IAPP.id::varchar = APP.id
	AND CONT.id_apprenant = APP.id;
   
   
CREATE INDEX ins_admis_id_idx ON schema_pilotage.ins_admis (id);
CREATE INDEX ins_admis_id_apprenant_idx ON schema_pilotage.ins_admis (id_apprenant);




/* TEMP VIEW DEPRECATED tous les apprenants avec inscription validée ou en cours */
CREATE VIEW schema_pilotage.ins_apprenant AS
 SELECT * FROM schema_pilotage.idt_apprenant;




/* ins_bourse_aide_financiere */
CREATE TABLE schema_pilotage.ins_bourse_aide_financiere (
	id_inscription varchar(255),
	code varchar,
	code_bcn varchar,
	libelle_court varchar(50),
	libelle_long varchar(150));
	

DO $$ DECLARE
    r RECORD;
    _elem varchar;
BEGIN
    FOR r IN (SELECT id, codes_bourses FROM  schema_ins.inscription) LOOP
    
		FOREACH _elem IN ARRAY r.codes_bourses
		LOOP 
			INSERT INTO schema_pilotage.ins_bourse_aide_financiere(id_inscription, code) VALUES (r.id, _elem);
		END LOOP;
	
    END LOOP;
END $$;


UPDATE schema_pilotage.ins_bourse_aide_financiere
SET code_bcn = ref_bourse_aide_financiere.code_bcn, libelle_court = ref_bourse_aide_financiere.libelle_court, libelle_long = ref_bourse_aide_financiere.libelle_long
FROM schema_pilotage.ref_bourse_aide_financiere
WHERE ins_bourse_aide_financiere.code = ref_bourse_aide_financiere.code_metier; 


CREATE INDEX ins_bourse_aide_financiere_id_inscription_idx ON schema_pilotage.ins_bourse_aide_financiere (id_inscription);




/* ins_amenagement_specifique */
CREATE TABLE schema_pilotage.ins_amenagement_specifique (
	id_inscription varchar(255),
	code varchar,
	libelle_court varchar(50),
	libelle_long varchar(150));
	

DO $$ DECLARE
    r RECORD;
    _elem varchar;
BEGIN
    FOR r IN (SELECT id, codes_amenagements_specifiques FROM  schema_ins.inscription) LOOP
    
		FOREACH _elem IN ARRAY r.codes_amenagements_specifiques
		LOOP 
			INSERT INTO schema_pilotage.ins_amenagement_specifique(id_inscription, code) VALUES (r.id, _elem);
		END LOOP;
	
    END LOOP;
END $$;


UPDATE schema_pilotage.ins_amenagement_specifique
SET libelle_court = ref_regime_special_etudes.libelle_court, libelle_long = ref_regime_special_etudes.libelle_long
FROM schema_pilotage.ref_regime_special_etudes
WHERE ins_amenagement_specifique.code = ref_regime_special_etudes.code_metier; 


CREATE INDEX ins_amenagement_specifique_id_inscription_idx ON schema_pilotage.ins_amenagement_specifique (id_inscription);



/* ins_profil_specifique */
CREATE TABLE schema_pilotage.ins_profil_specifique (
	id_inscription varchar(255),
	code varchar,
	libelle_court varchar(50),
	libelle_long varchar(150));
	

DO $$ DECLARE
    r RECORD;
    _elem varchar;
BEGIN
    FOR r IN (SELECT id, codes_profils_specifiques FROM  schema_ins.inscription) LOOP
    
		FOREACH _elem IN ARRAY r.codes_profils_specifiques
		LOOP 
			INSERT INTO schema_pilotage.ins_profil_specifique(id_inscription, code) VALUES (r.id, _elem);
		END LOOP;
	
    END LOOP;
END $$;


UPDATE schema_pilotage.ins_profil_specifique
SET libelle_court = ref_profil_exonerant.libelle_court, libelle_long = ref_profil_exonerant.libelle_long
FROM schema_pilotage.ref_profil_exonerant
WHERE ins_profil_specifique.code = ref_profil_exonerant.code_metier; 


CREATE INDEX ins_profil_specifique_id_inscription_idx ON schema_pilotage.ins_profil_specifique (id_inscription);

/* ******************************************* */




/*  INSCRIPTIONS en cours, annulees ou validees */
CREATE TABLE schema_pilotage.ins_inscription AS
   SELECT inscription.id::varchar(255),
    OOFC.id AS "id_objet_formation_chemin",
    inscription.id_apprenant::varchar(255),
    OOFC.code_periode,
    OOFC.libelle_periode,
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    inscription.origine_admission AS "origine",
    inscription.canal_admission AS "canal_admission",
    inscription.contexte_inscription,
    NULL AS "numero_candidat", -- disparu en v28
    inscription.date_creation AS "date_inscription",
    inscription.statut_inscription,
    inscription.statut_paiement,
    /*inscription.statut_pieces*/ -- TODO v28
    inscription.code_regime AS "code_regime_inscription",
    RI.libelle_long AS "libelle_regime_inscription",
    inscription.numero_cvec,
    inscription.temoin_cvec_validee,
    inscription.temoin_principale,
    inscription.cesure,
    inscription.mobilite,
    inscription.temoin_neo_bachelier AS "neo_bachelier",
    inscription.temoin_souhait_amenagement AS "souhait_amenagement",
    
    NULL AS "admission_voie", -- TODO v28 introuvable
    CON.annee_concours AS "admission_annee_concours",
    CON.concours AS "admission_concours",
    CON.rang_concours AS "admission_rang_concours",
    CON.annee_precedente AS "admission_annee_precedente",
    CON.type_classe_preparatoire AS "admission_type_classe_preparatoire",
    CON.puissance_classe_preparatoire AS "admission_puissance_classe_preparatoire",
    CON.pays_etablissement_precedent AS "admission_pays_etablissement_precedent",
    CON.etablissement_precedent AS "admission_etablissement_precedent",
    CON.temoin_classe_prepa AS "admission_temoin_classe_prepa",
    CON.type_etablissement_precedent AS "admission_type_etablissement_precedent",
    CON.departement_etablissement_precedent AS "admission_departement_etablissement_precedent",
    CON.etablissement_precedent_etranger AS "admission_etablissement_precedent_etranger",
    
    inscription.annee_precedente,
    inscription.code_situation_annee_precedente AS "code_situation_annee_precedente",
    SAP.code_bcn AS "situation_annee_precedente_code_bcn",
    SAP.libelle_long AS "libelle_situation_annee_precedente",
    inscription.annee_obtention_dernier_diplome,
    inscription.code_type_du_dernier_diplome AS "code_type_dernier_diplome_obtenu",
    DDO.libelle_long AS "libelle_type_dernier_diplome_obtenu",
    inscription.motif_annulation,
    inscription.temoin_avec_remboursement AS "avec_remboursement",
    inscription.code_ecole_doctorale AS "code_ecole_doctorale",
    ED.libelle_long AS "libelle_ecole_doctorale",
    inscription.code_filiere AS "code_filiere",
    CUP.libelle_long AS "libelle_filiere",
    inscription.temoin_convention_etablissement,
    inscription.code_programme_echange AS "code_programme_echange",
    ECH.libelle_long AS "libelle_programme_echange",
    inscription.code_pays_echange AS "code_programme_echange_pays",
    P1.libelle_long AS "libelle_programme_echange_pays",
    inscription.temoin_enseignement_distance_depuis_france,
    inscription.date_creation AS "date_de_creation",
    inscription.date_modification AS "date_de_modification"

   FROM schema_ins.inscription
   
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.id = inscription.id_odf_chemin 
   LEFT JOIN schema_pilotage.ref_regime_inscription RI ON RI.code = inscription.code_regime
   LEFT JOIN schema_pilotage.ref_situation_annee_precedente SAP ON SAP.code_metier = inscription.code_situation_annee_precedente
   LEFT JOIN schema_pilotage.ref_type_dernier_diplome_obtenu DDO ON DDO.code_metier = inscription.code_type_du_dernier_diplome
   LEFT JOIN schema_pilotage.ref_cursus_parallele CUP ON CUP.code_metier = inscription.code_filiere
   LEFT JOIN schema_pilotage.ref_programme_echange ECH ON ECH.code_metier = inscription.code_programme_echange
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = inscription.code_pays_echange
   LEFT JOIN schema_pilotage.ref_ecole_doctorale ED ON ED.code_metier = inscription.code_ecole_doctorale
   LEFT JOIN schema_ins.infos_concours CON ON CON.id_inscription = inscription.id
   
--WHERE CON.annee_concours IS NOT NULL

   ORDER BY code_periode, inscription.id;
   
   
   
   
   

CREATE INDEX ins_inscription_id_idx ON schema_pilotage.ins_inscription (id);
CREATE INDEX ins_inscription_id_apprenant_idx ON schema_pilotage.ins_inscription (id_apprenant);
CREATE INDEX ins_inscription_id_objet_formation_chemin_idx ON schema_pilotage.ins_inscription (id_objet_formation_chemin);
   
   
   



/* inscriptions validées */
CREATE TABLE schema_pilotage.ins_inscription_validee AS
 SELECT *
   FROM schema_pilotage.ins_inscription
   WHERE statut_inscription='VALIDEE';

   
   
/* inscriptions validées */
CREATE TABLE schema_pilotage.ins_inscription_annulee AS
 SELECT *

   FROM schema_pilotage.ins_inscription
   
   WHERE statut_inscription='ANNULEE';



/* admissions */
CREATE TABLE schema_pilotage.ins_admission AS
 SELECT admission.id::varchar(255),
    OOFC.id AS "id_objet_formation_chemin",
    admission.id_admis AS "id_admis",
	CASE  
		WHEN AD.id_apprenant IS NOT NULL THEN AD.id_apprenant::varchar(255)
		ELSE AD.id::varchar(255)
	END AS "id_apprenant",
	INS.id AS "id_inscription",
    OOFC.code_periode,
    OOFC.libelle_periode,
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    admission.origine_admission AS "origine",
	AD.numero_candidat AS "numero_candidat",
    NULL AS "admission_voie",-- disparu en v28
    admission.annee_concours AS "admission_annee_concours",
	NULL AS "statut",-- disparu en v28
    AD.date_de_creation,
    AD.date_de_modification

   FROM schema_ins.admission
   
   LEFT JOIN schema_pilotage.ins_admis AD ON AD.id = admission.id_admis
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.code_objet_formation = admission.code_voeu AND OOFC.code_periode = admission.code_periode
   LEFT JOIN schema_pilotage.ins_inscription INS ON INS.id_objet_formation_chemin = OOFC.id AND INS.id_apprenant = AD.id_apprenant
   
   WHERE AD.id_apprenant IS NOT NULL OR AD.id IS NOT NULL
   GROUP BY admission.id, OOFC.id, AD.id_apprenant, AD.id, INS.id, OOFC.code_periode, OOFC.libelle_periode, OOFC.code_objet_formation, OOFC.libelle_court_objet_formation, admission.origine_admission, AD.numero_candidat,
   admission.annee_concours,AD.date_de_creation, AD.date_de_modification
   ORDER BY code_periode, admission.id;

CREATE INDEX ins_admission_id_admis_idx ON schema_pilotage.ins_admission (id_admis);





/* inscriptions en cours */
CREATE TABLE schema_pilotage.ins_inscription_en_cours AS
 SELECT *

   FROM schema_pilotage.ins_inscription
   
   WHERE statut_inscription IN ('DEBUTEE', 'TERMINEE');





CREATE TABLE schema_pilotage.ins_inscription_en_cours_pieces AS
    SELECT
        DP.id,
        DP.id_inscription::varchar,
        DP.code_metier AS "code",
        RDP.libelle_affichage AS "libelle",
        DP.temoin_obligatoire AS "obligatoire",
        DP.temoin_photo,
        --DP.temoin_primo,
        --DP.temoin_reins,
        DP.statut AS "statut_piece"
    FROM schema_pilotage.ins_depot_piece DP,
	schema_pilotage.ins_demande_piece RDP,
	schema_pilotage.ins_inscription_en_cours IEC
    WHERE RDP.code_metier = DP.code_metier
    AND DP.id_inscription::varchar = IEC.id
    
    GROUP BY 
        DP.id,
        DP.id_inscription,
        DP.code_metier,
        RDP.libelle_affichage,
        DP.temoin_obligatoire,
        DP.temoin_photo,
        DP.statut
    
	ORDER BY DP.id_inscription,DP.code_metier;


ALTER TABLE schema_pilotage.ins_inscription_en_cours_pieces ADD PRIMARY KEY (id, id_inscription);  
CREATE INDEX ins_inscription_en_cours_pieces_id_inscription_idx ON schema_pilotage.ins_inscription_en_cours_pieces (id_inscription);  
   
   




/* ************************************************************************** */
/* PAI */




CREATE TABLE schema_pilotage.pai_structure_budgetaire AS
 SELECT SB.id,
    SB.code,
    SB.code_uai,
    SB.denomination_principale AS "libelle"

   FROM schema_pai.structure_budgetaire SB;





CREATE TABLE schema_pilotage.pai_compte_marchand AS
 SELECT CM.id, 
    CM.identifiant

   FROM schema_pai.compte_marchand CM;





CREATE TABLE schema_pilotage.pai_compte_marchand_structure_budgetaire AS
 SELECT SB.id AS "id_structure_budgetaire",
    CMSB.compte_marchand_id

   FROM schema_pai.compte_marchand_structures_budgetaires CMSB
   LEFT JOIN schema_pilotage.pai_structure_budgetaire SB ON SB.code = CMSB.code;






CREATE TABLE schema_pilotage.pai_element_de_droit_compte AS
 SELECT EDDC.id_element_droit AS "id_element_de_droit",
    EDDC.numero_compte_imputation,
    EDDC.sens

   FROM schema_pai.element_droit_compte EDDC
   --LEFT JOIN schema_pai.element_de_droit_compte_structures_budgetaire EDDCSB ON EDDCSB.element_de_droit_compte_id = EDDC.id
   
   GROUP BY id_element_de_droit, numero_compte_imputation, sens
   ORDER BY id_element_de_droit;






CREATE TABLE schema_pilotage.pai_facture AS
 SELECT F.id::varchar,
    F.numero,
    F.date_et_heure_emission,
    APP.id AS "id_apprenant",
    F.temoin_ue,
    F.temoin_accords,
    SB.id AS "id_structure_budgetaire",
    F.quittance_numero,
    F.quittance_date_generation,
    F.quittance_date_cloture,
    OOFC.id AS "id_objet_formation_chemin",
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    F.code_periode,
    F.formation_ref AS "formation_tarification_id",
    F.statut,
    F.temoin_annulee AS "annulee"

   FROM schema_pai.facture F
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.chemin = F.code_chemin AND OOFC.code_periode = F.code_periode
   LEFT JOIN schema_pilotage.idt_apprenant APP ON APP.code_apprenant = F.code_apprenant
   LEFT JOIN schema_pilotage.pai_structure_budgetaire SB ON SB.id = F.structure_budgetaire_ref
   
   GROUP BY F.id,F.numero,F.date_et_heure_emission,APP.id,F.temoin_ue,F.temoin_accords,SB.id,F.quittance_numero,F.quittance_date_generation,F.quittance_date_cloture,OOFC.id,OOFC.code_objet_formation,OOFC.libelle_court_objet_formation,F.code_periode,F.formation_ref,F.statut,F.temoin_annulee
   ORDER BY F.code_periode, F.date_et_heure_emission;





CREATE TABLE schema_pilotage.pai_ligne_facture AS
 SELECT LF.id,
    LF.id_facture,
    EDD.code_periode,
    F.id_structure_budgetaire,
    LF.temoin_annulation,
    LF.titre_charge,
    LF.montant_charge,
    LF.titre_exo,
    LF.montantapayer_apres_exo,
    LF.numero_compte_imputation_personnalise,
    EDDC.sens AS "element_de_droit_sens",
    EDD.code AS "element_de_droit_code",
    EDD.libelle_court AS "element_de_droit_libelle_court",
    EDD.libelle_long AS "element_de_droit_libelle_long",
    EDD.libelle_affichage AS "element_de_droit_libelle_affichage",
    EDD.code_structure AS "element_de_droit_code_structure",
    EDD.date_effet AS "element_de_droit_date_effet",
    EDD.montant AS "element_de_droit_montant",
    EDD.description AS "element_de_droit_description",
    EDD.temoin_actif AS "element_de_droit_actif",
    EDD.temoin_remboursable_sur_annulation AS "element_de_droit_remboursable_sur_annulation",
    EDD.date_inactivation AS "element_de_droit_date_inactivation"

   FROM schema_pai.ligne_facture LF
   LEFT JOIN schema_pai.element_droit EDD ON EDD.id = LF.element_droit_ref
   LEFT JOIN schema_pilotage.pai_element_de_droit_compte EDDC ON EDDC.id_element_de_droit = EDD.id
   LEFT JOIN schema_pilotage.pai_facture F ON F.id = LF.id_facture::varchar;
   
   
   
   


CREATE TABLE schema_pilotage.pai_formation_tarification AS
 SELECT F.id::varchar,
    OOFC.id AS "id_objet_formation_chemin",
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    F.code_periode,
    F.temoin_jamais_ouverte_inscription AS "jamais_ouverteainscription",
    T.code AS "tarification_code",
    T.libelle_court AS "tarification_libelle_court",
    T.libelle_long AS "tarification_libelle_long",
    T.description AS "tarification_description"
    

   FROM schema_pai.formation F
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.code_objet_formation = F.code AND OOFC.code_periode = F.code_periode
   LEFT JOIN schema_pai.tarification T ON T.id = F.id_tarification AND T.code_periode = F.code_periode;






CREATE TABLE schema_pilotage.pai_paiement AS
 SELECT P.id::varchar,
    P.id_facture,
    P.temoin_premier AS "premier",
    P.date_choix_mode_paiement,
    P.date_reception,
    P.date_encaissement,
    P.montant_paye,
    P.montant_paye_origine,
    P.reference,
    P.numero_compte_imputation_personnalise,
    P.numero_autorisation,
    P.numero_transaction,
    P.code_erreur,
    P.modalite_paiement_code AS "modalite_de_paiement_code",
    P.modalite_paiement_libelle_affichage AS "modalite_de_paiement_libelle",
    P.modalite_paiement_numero_compte_imputation AS "modalite_de_paiement_numero_compte_imputation",
    P.mode_confirmation_paiement,
    --P.modalite_de_paiement_ref AS "id_modalite_de_paiement",
    P.modalite_paiement_nombre_occurences AS "modalite_de_paiement_nombre_occurences"
    
   FROM schema_pai.paiement P
   --LEFT JOIN schema_pai.modalite_de_paiement MDP ON MDP.id = P.modalite_de_paiement_ref
   ;







CREATE TABLE schema_pilotage.pai_ventilation AS
 SELECT V.id,
    V.numero,
    V.date_cloture,
    V.date_debut,
    V.date_fin,
    V.numero_quittance_debut,
    V.numero_quittance_fin,
    SB.id AS "id_structure_budgetaire"
    
   FROM schema_pai.ventilation V
   LEFT JOIN schema_pilotage.pai_structure_budgetaire SB ON SB.code = V.structure_budgetaire_code
   ;











/* ************************************************************************** */
/* COC */





/* notes et résultats */
CREATE TABLE schema_pilotage.coc_note_resultat AS
SELECT 
    NR.id,
    APP.id AS "id_apprenant",
    CA.code AS "code_apprenant",
    OOF.id AS "id_objet_formation",
    OOF.code_periode,
    OOF.code AS "code_objet_formation",
    OOF.libelle_court AS "libelle_objet_formation",
    NR.id_formation,
    NR.note_session1,
    NR.resultat_session1 AS "code_resultat_session1",
    RTR1.libelle_long AS "libelle_resultat_session1",
    NR.note_session2,
    NR.resultat_session2 AS "code_resultat_session2",
    RTR2.libelle_long AS "libelle_resultat_session2",
    NR.note_retenue AS "note_retenue",
    NR.point_jury_retenu AS "point_jury_retenu",
    NR.note_finale,
    NR.resultat_final AS "code_resultat_final",
    RTR3.libelle_long AS "libelle_resultat_final",
    NR.mention AS "code_mention_honorifique",
    RMH.libelle_long AS "libelle_mention_honorifique",
    NR.gpa AS "code_gpa",
    RGPA.code_bcn AS "libelle_gpa",
    NR.grade_ects AS "code_grade_ects",
    RNE.code_bcn AS "libelle_grade_ects",
    NR.date_consommation_referentiel,
    NR.etat_note_session1,
    NR.etat_note_session2,
    NR.etat_resultat_session1,
    NR.etat_resultat_session2,
    NR.absence_session1,
    NR.absence_session2,
    NR.absence_finale,
    NR.credit_ects_final AS "credit_ects_final",
    NR.id_note_resultat_passe,
    NR.temoin_concerne_session2,
    NR.etat_absence_session1,
    NR.etat_absence_session2,
    NR.etat_note_retenue AS "etat_note_retenue",
    NR.etat_point_jury_retenu AS "etat_point_jury_retenu",
    NR.etat_note_finale,
    NR.etat_resultat_final,
    NR.etat_absence_finale,
    NR.etat_credit_ects_final AS "etat_credit_ects_final",
    NR.etat_grade_ects AS "etat_grade_ects",
    NR.etat_gpa,
    NR.etat_mention AS "etat_mention",
    NR.rang_final,
    NR.etat_rang_final,
    NR.point_jury_session1,
    NR.etat_point_jury_session1,
    NR.note_avec_point_jury_session1,
    NR.etat_note_avec_point_jury_session1,
    NR.point_jury_session2,
    NR.etat_point_jury_session2,
    NR.note_avec_point_jury_session2,
    NR.etat_note_avec_point_jury_session2,
    NR.credit_ects_session1,
    NR.etat_credit_ects_session1,
    NR.rang_session1,
    NR.etat_rang_session1,
    NR.numero_session_retenue

FROM schema_coc.note_resultat NR
LEFT JOIN schema_coc.apprenant CA ON CA.id = NR.id_apprenant
LEFT JOIN schema_pilotage.idt_apprenant APP ON APP.code_apprenant = CA.code
LEFT JOIN schema_coc.objet_formation OBF ON OBF.id = NR.id_objet_formation
LEFT JOIN schema_pilotage.odf_objet_formation OOF ON OOF.code = OBF.code AND OOF.code_periode=OBF.code_periode
LEFT JOIN schema_pilotage.ref_type_resultat RTR1 ON RTR1.code_metier = NR.resultat_session1
LEFT JOIN schema_pilotage.ref_type_resultat RTR2 ON RTR2.code_metier = NR.resultat_session2
LEFT JOIN schema_pilotage.ref_type_resultat RTR3 ON RTR3.code_metier = NR.resultat_final
LEFT JOIN schema_pilotage.ref_mention_honorifique RMH ON RMH.code_metier = NR.mention
LEFT JOIN schema_pilotage.ref_notation_ects RNE ON RNE.code_metier = NR.grade_ects
LEFT JOIN schema_pilotage.ref_grade_point_average RGPA ON RGPA.code_metier = NR.gpa

WHERE APP.id IS NOT NULL;


ALTER TABLE schema_pilotage.coc_note_resultat ADD PRIMARY KEY (id, id_apprenant);



/* diplômes evaluation */
CREATE TABLE schema_pilotage.coc_diplome_evaluation AS
SELECT 
    id,
    id_diplome,
    id_apprenant,
    note,
    etat_note,
    point_jury,
    etat_point_jury,
    note_finale,
    etat_note_finale,
    resultat,
    etat_resultat,
    mention,
    etat_mention,
    rang,
    etat_rang,
    grade_ects,
    etat_grade_ects,
    gpa,
    etat_gpa,
    date_deliberation
FROM schema_coc.diplome_evaluation;



/* diplômes */
CREATE TABLE schema_pilotage.coc_diplome AS
SELECT 
	AD.id,	
	APP.id AS "id_apprenant",
	APP.code_apprenant,
	P.code AS "code_periode",
	P.libelle_long AS "libelle_periode",
	CASE  
		WHEN DLOM.code_objet_maquette IS NOT NULL THEN DLOM.code_objet_maquette
		ELSE ''
	END AS "code_objet_maquette",
	AD.id_diplome,
	AD.temoin_annulation_autorisation_impossible,
	
	CDE.id AS "id_diplome_evaluation",
	CDE.mention AS "code_mention_honorifique",
	RMH.libelle_court AS "libelle_court_mention_honorifique",
	RMH.libelle_long AS "libelle_long_mention_honorifique",
	RMH.libelle_affichage AS "libelle_affichage_mention_honorifique",
	CDE.etat_mention AS "etat_mention_honorifique",
	NULL AS "date_consommation_referentiel", --disparu en v28
    
	AD.date_autorisation,
	AD.utilisateur_autorisation,
	AD.date_annulation_apres_edition,
	AD.utilisateur_annulation_apres_edition,
	AD.motif_annulation_apres_edition,    
    
	D.code_uai_etablissement_delivrant_le_diplome AS "diplome_code_structure_etablissement",
	D.code AS "diplome_code",
	NULL AS "diplome_version", /* après v26 : disparu ?*/
	D.type_finalite_formation_code AS "diplome_type_finalite_formation_code",
	RFF.libelle_court AS "diplome_type_finalite_formation_libelle_court",
	RFF.libelle_long AS "diplome_type_finalite_formation_libelle_long",
	RFF.libelle_affichage AS "diplome_type_finalite_formation_libelle_affichage",
	D.libelle_court AS "diplome_libelle_court",
	D.intitule AS "diplome_intitule",
	D.temoin_actif AS "diplome_temoin_actif",
	D.etat AS "diplome_etat",
	NULL AS "parchemin_date_edition",--PAR.date_edition AS "parchemin_date_edition",
	PAR.numero_edition AS "parchemin_numero_edition",
	ADPS.date_signature AS "parchemin_date_signature_recteur",
	NULL AS "parchemin_libelle_parcours_type_original", /* après v26 : disparu ? */
	
	MP.libelle_court AS "parchemin_libelle_court",
	MP.description AS "parchemin_description",
	MP.denomination_diplome AS "parchemin_denomination_diplome",
	MP.libelle_parcours_type AS "parchemin_libelle_parcours_type",
	
	M.contenu_reference AS "modele_contenu_reference",
	M.libelle_court AS "modele_libelle_court",
	M.type_template AS "modele_type_template"
	
FROM schema_coc.apprenant_diplome AD
LEFT JOIN schema_coc.diplome D ON D.id = AD.id_diplome
LEFT JOIN schema_coc.periode P ON P.id = D.id_periode
LEFT JOIN schema_coc.apprenant CA ON CA.id = AD.id_apprenant
LEFT JOIN schema_pilotage.idt_apprenant APP ON APP.code_apprenant = CA.code
LEFT JOIN schema_pilotage.coc_diplome_evaluation CDE ON CDE.id_diplome = D.id AND CDE.id_apprenant = CA.id
LEFT JOIN schema_pilotage.ref_mention_honorifique RMH ON RMH.code_metier = CDE.mention

LEFT JOIN schema_pilotage.ref_finalite_formation RFF ON RFF.code_metier = D.type_finalite_formation_code
LEFT JOIN schema_coc.diplome_lien_objet_maquette DLOM ON DLOM.id_diplome = D.id
LEFT JOIN schema_coc.apprenant_diplome_parchemin PAR ON PAR.id_apprenant_diplome = AD.id
LEFT JOIN schema_coc.diplome_modele_parchemin_asso PPAR ON PPAR.id_diplome = D.id
LEFT JOIN schema_coc.modele M ON M.id = PPAR.id_modele_parchemin
LEFT JOIN schema_coc.modele_parchemin MP ON MP.id = PPAR.id_modele_parchemin
LEFT JOIN schema_coc.apprenant_diplome_parchemin_sauvegarde ADPS ON M.id = PAR.id_apprenant_diplome_parchemin_sauvegarde

GROUP BY AD.id, APP.id,APP.code_apprenant,P.code,P.libelle_long,
--DLOM.code_objet_maquette,
"code_objet_maquette",
AD.id_diplome,AD.temoin_annulation_autorisation_impossible,CDE.id,
CDE.mention,RMH.libelle_court,RMH.libelle_long,RMH.libelle_affichage,CDE.etat_mention,
AD.date_autorisation,AD.utilisateur_autorisation,AD.date_annulation_apres_edition,AD.utilisateur_annulation_apres_edition,AD.motif_annulation_apres_edition,D.code_uai_etablissement_delivrant_le_diplome,D.code,/*D.version,*/D.type_finalite_formation_code,RFF.libelle_court,RFF.libelle_long,RFF.libelle_affichage,
D.libelle_court,D.intitule,D.temoin_actif,D.etat,
--PAR.date_edition,
PAR.numero_edition,ADPS.date_signature,
MP.libelle_court,MP.description,MP.denomination_diplome,MP.libelle_parcours_type,M.contenu_reference,M.libelle_court,M.type_template
;


ALTER TABLE schema_pilotage.coc_diplome ADD PRIMARY KEY (id, code_periode, code_objet_maquette);








/* ************************************************************************** */
/* CHC */



/* cursus */
CREATE TABLE schema_pilotage.chc_cursus AS 
	SELECT 
		cursus.uuid::varchar AS "id",
		APP.id AS "id_apprenant",
		APP.code_apprenant,
		INS.id AS "id_inscription",
		OOFC.id AS "id_objet_formation_chemin",
		COM.code_chemin AS "chemin",
		PER.code AS "code_periode",
		PER.libelle_long AS "libelle_periode",
		cursus.date_creation_brouillon,
		cursus.date_derniere_modification_brouillon,
		cursus.proprietaire_identifiant_brouillon,
		cursus.version

	FROM schema_chc.cursus

	LEFT JOIN schema_chc.apprenant CHCA ON CHCA.uuid = cursus.uuid_apprenant
	LEFT JOIN schema_pilotage.idt_apprenant APP ON APP.id = CHCA.uuid_keycloak::varchar
	LEFT JOIN schema_chc.periode PER ON PER.uuid = cursus.uuid_periode

	LEFT JOIN schema_chc.inscription CHCINS ON CHCINS.uuid = cursus.uuid_inscription
	LEFT JOIN schema_chc.chemin_objet_maquette COM ON COM.uuid = CHCINS.uuid_chemin_objet_maquette

	LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON (OOFC.chemin = COM.code_chemin AND PER.code = OOFC.code_periode)
	LEFT JOIN schema_pilotage.ins_inscription INS ON (INS.id_objet_formation_chemin = OOFC.id AND INS.id_apprenant = APP.id)

	--WHERE INS.id IS NULL
	--AND chemin = 'HL3DDL-201>H3DDL1-221'
	--LIMIT 2000
	;




/* acquis_par_amenagements */
CREATE TABLE schema_pilotage.chc_acquis_par_amenagements AS
	SELECT 
		uuid::varchar AS "id",
		version,
		note,
		bareme
	FROM schema_chc.acquis_par_amenagements;




/* acquis */
CREATE TABLE schema_pilotage.chc_acquis AS 
	SELECT
		acquis.uuid::varchar AS "id",
		APP.id AS "id_apprenant",
		APP.code_apprenant,

		OOF.id AS "id_objet_formation",
		OOF.code AS "code",
		PER.code AS "code_periode",
		PER.libelle_long AS "libelle_periode",
		
		acquis.temoin_revoque,
		
		--acquis.uuid_note_resultat,
		CNR.note_finale,
		
		acquis.uuid_acquis_par_amenagements::varchar AS "id_acquis_par_amenagements",
		acquis.version

	FROM schema_chc.acquis

	LEFT JOIN schema_chc.apprenant CHCA ON CHCA.uuid = acquis.uuid_apprenant
	LEFT JOIN schema_pilotage.idt_apprenant APP ON APP.id = CHCA.uuid_keycloak::varchar

	LEFT JOIN schema_chc.objet_formation COF ON COF.uuid = acquis.uuid_objet_formation
	LEFT JOIN schema_chc.periode PER ON PER.uuid = COF.uuid_periode
	LEFT JOIN schema_pilotage.odf_objet_formation OOF ON (OOF.code = COF.code AND PER.code = OOF.code_periode)

	LEFT JOIN schema_chc.note_resultat CNR ON CNR.uuid = acquis.uuid_note_resultat
	LEFT JOIN schema_pilotage.coc_note_resultat NR ON (NR.id_apprenant = APP.id AND NR.code_periode = PER.code AND NR.id_objet_formation = OOF.id)

	--WHERE acquis.uuid_acquis_par_amenagements IS NULL
	--LIMIT 250
	;






/* choix_pedagogique */
CREATE TABLE schema_pilotage.chc_choix_pedagogique AS 
	SELECT 
		CP.uuid::varchar AS "id",
		CUR.id AS "id_cursus",
		OOFC.id AS "id_objet_formation_chemin",
		CP.code,
		CP.code_chemin AS "chemin",
		CHP.ouverture_au_chc,
		CP.temoin_brouillon,
		CP.type_choix_pedagogique,
		CP.version,
		CP.uuid_acquis_utilise::varchar AS "id_acquis"
	
	FROM schema_chc.choix_pedagogique CP
	
	LEFT JOIN schema_pilotage.chc_cursus CUR ON CUR.id = CP.uuid_cursus::varchar
	
	LEFT JOIN schema_chc.chemin_pedagogique CHP ON CHP.uuid = CP.uuid_chemin_pedagogique
	LEFT JOIN schema_chc.chemin_objet_maquette COM ON COM.uuid = CHP.uuid_chemin_objet_maquette
	LEFT JOIN schema_chc.periode PER ON PER.uuid = COM.uuid_periode
	
	LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON (OOFC.chemin = COM.code_chemin AND PER.code = OOFC.code_periode)

	LEFT JOIN schema_pilotage.chc_acquis ACQ ON ACQ.id = CP.uuid_acquis_utilise::varchar

	--WHERE uuid_acquis_utilise IS NOT NULL
	--LIMIT 250
	;






/* composition */
CREATE TABLE schema_pilotage.chc_composition AS 
	SELECT 
		COMP.uuid::varchar AS "id",
		COMP.code,
		COMP.description,
		COMP.libelle_court,
		COMP.libelle_long,
		PER.code AS "code_periode",
		PER.libelle_long AS "libelle_periode",
		COMP.liste_diffusion,
		COMP.version
		
	FROM schema_chc.composition COMP
	
	LEFT JOIN schema_chc.periode PER ON PER.uuid = COMP.uuid_periode
	;
	
	
	

CREATE TABLE schema_pilotage.chc_composition_lie_formation_asso AS 
	SELECT 
		COMP.uuid_composition::varchar AS "id_composition",
		FORM.id AS "id_formation"	
	
	FROM schema_chc.composition_lie_formation_asso COMP
	
	LEFT JOIN schema_chc.formation CFORM ON CFORM.uuid = COMP.uuid_formation
	LEFT JOIN schema_chc.periode PER ON PER.uuid = CFORM.uuid_periode
	LEFT JOIN schema_pilotage.odf_formation FORM ON (PER.code = FORM.code_periode AND FORM.code = CFORM.code)
	;
	
	


CREATE TABLE schema_pilotage.chc_composition_lie_objet_formation_asso AS 
	SELECT 
		COMP.uuid_composition::varchar AS "id_composition",
		OOF.id AS "id_objet_formation"
	
	FROM schema_chc.composition_lie_objet_formation_asso COMP
	
	LEFT JOIN schema_chc.objet_formation COF ON COF.uuid = COMP.uuid_objet_formation
	LEFT JOIN schema_chc.periode PER ON PER.uuid = COF.uuid_periode
	LEFT JOIN schema_pilotage.odf_objet_formation OOF ON (OOF.code = COF.code AND PER.code = OOF.code_periode)
	;



/* completude */
CREATE TABLE schema_pilotage.chc_completude AS 
	SELECT 
		completude.uuid::varchar AS "id",
		OOFC.id AS "id_objet_formation_chemin",
		COM.code_chemin AS "chemin",
		CUR.id AS "id_cursus",
		PER.code AS "code_periode",
		PER.libelle_long AS "libelle_periode",
		
		completude.etat_completude,
		completude.temoin_descendant_incomplet,
		completude.version

	FROM schema_chc.completude

	LEFT JOIN schema_pilotage.chc_cursus CUR ON CUR.id = completude.uuid_cursus::varchar
	LEFT JOIN schema_chc.chemin_objet_maquette COM ON COM.uuid = completude.uuid_chemin_objet_maquette
	LEFT JOIN schema_chc.periode PER ON PER.uuid = COM.uuid_periode

	LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON (OOFC.chemin = COM.code_chemin AND PER.code = OOFC.code_periode)

	--WHERE INS.id IS NULL
	--AND chemin = 'HL3DDL-201>H3DDL1-221'
	--LIMIT 2000
	;



/* groupe */
CREATE TABLE schema_pilotage.chc_groupe AS 
	SELECT 
		GRP.uuid::varchar AS "id",
		COMP.id AS "id_composition",
		GRP.code,
		GRP.description,
		GRP.libelle_court,
		GRP.libelle_long,
		
		GRP.code_type,
		
		GRP.capacite,
		GRP.temoin_actif,
		GRP.temoin_capacite_bloquante,
		GRP.temoin_hors_offre_formation,
		GRP.temoin_planifiable,
		GRP.liste_diffusion,
		GRP.ordre,
		GRP.places_reservees,
		
		COMP.code_periode,
		COMP.libelle_periode,
		GRP.version
		
	
	FROM schema_chc.groupe GRP
	
	LEFT JOIN schema_pilotage.chc_composition COMP ON COMP.id = GRP.uuid_composition::varchar
	;




/* groupement */
CREATE TABLE schema_pilotage.chc_groupement AS 
	SELECT 
		GRP.uuid::varchar AS "id",
		GRP.code,
		GRP.libelle_court,
		GRP.libelle_long,
		PER.code AS "code_periode",
		PER.libelle_long AS "libelle_periode",
		GRP.temoin_mutualise,
		GRP.version
		
	
	FROM schema_chc.groupement GRP
	
	LEFT JOIN schema_chc.periode PER ON PER.uuid = GRP.uuid_periode
	;



/* ************************************************************************** */
/* suppression des tables temporaires */
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'schema_pilotage') LOOP
		IF quote_ident(r.tablename) LIKE 'temp_%'
		THEN
			RAISE NOTICE 'Supprime la TABLE %', quote_ident(r.tablename);
			EXECUTE 'DROP TABLE IF EXISTS schema_pilotage.' || quote_ident(r.tablename) || ' CASCADE';
		END IF;
    END LOOP;
END $$;



