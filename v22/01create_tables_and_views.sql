/* table avec mails établissement */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel
(
    code_apprenant character varying(255) COLLATE pg_catalog."default",
    mail character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT etab_mail_institutionnel_pkey PRIMARY KEY (code_apprenant)
)
TABLESPACE pg_default;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel'; END; $$;



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
			OR quote_ident(r.tablename) LIKE 'ins_%'
			OR quote_ident(r.tablename) LIKE 'pai_%'
			OR quote_ident(r.tablename) LIKE 'coc_%'
			OR quote_ident(r.tablename) LIKE 'odf_%'
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
			OR quote_ident(r.viewname) LIKE 'ins_%'
			OR quote_ident(r.viewname) LIKE 'pai_%'
			OR quote_ident(r.tablename) LIKE 'coc_%'
			OR quote_ident(r.tablename) LIKE 'odf_%'
		THEN
			RAISE NOTICE 'Supprime la VIEW %', quote_ident(r.viewname);
			EXECUTE 'DROP VIEW IF EXISTS schema_pilotage.' || quote_ident(r.viewname) || ' CASCADE';
		END IF;
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : suppression des vues'; END; $$;





/* ************************************************************************** */
/* données du référentiel nécesaires */


CREATE TABLE schema_pilotage.ref_bourse_aide_financiere AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'BourseAideFinanciere'::text);




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
   FROM schema_ref.domaine_formation;




CREATE TABLE schema_pilotage.ref_mention_bac AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'MentionBac'::text);




CREATE TABLE schema_pilotage.ref_pays_nationalite AS
 SELECT pays_nationalite.code,
    pays_nationalite.libelle_court,
    pays_nationalite.libelle_long
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
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'TypeDernierDiplomeObtenu'::text);




CREATE TABLE schema_pilotage.ref_type_diplome AS
 SELECT type_diplome.code,
    type_diplome.libelle_court,
    type_diplome.libelle_long
   FROM schema_ref.type_diplome;




CREATE TABLE schema_pilotage.ref_etablissement_francais AS
 SELECT etablissement_francais.code,
    etablissement_francais.libelle_affichage
   FROM schema_ref.etablissement_francais;




CREATE TABLE schema_pilotage.ref_situation_militaire AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'SituationMilitaire'::text);




CREATE TABLE schema_pilotage.ref_situation_familiale AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'SituationFamiliale'::text);




CREATE TABLE schema_pilotage.ref_quotite_activite AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'QuotiteActivite'::text);




CREATE TABLE schema_pilotage.ref_specialites_bac AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'SpecialitesBacGeneral'::text);




CREATE TABLE schema_pilotage.ref_situation_annee_precedente AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'SituationAnneePrecedente'::text);




CREATE TABLE schema_pilotage.ref_cursus_parallele AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'CursusParallele'::text);




CREATE TABLE schema_pilotage.ref_programme_echange AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'ProgrammeEchange'::text);




CREATE TABLE schema_pilotage.ref_ecole_doctorale AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'EcoleDoctorale'::text);




CREATE TABLE schema_pilotage.ref_canal_de_communication AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'CanalCommunication'::text);




CREATE TABLE schema_pilotage.ref_regime_special_etudes AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'RegimeSpecialEtudes'::text);




CREATE TABLE schema_pilotage.ref_profil_exonerant AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'ProfilExonerant'::text);




CREATE TABLE schema_pilotage.ref_type_resultat AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'TypeResultat'::text);




CREATE TABLE schema_pilotage.ref_mention_honorifique AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'MentionHonorifique'::text);




CREATE TABLE schema_pilotage.ref_notation_ects AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'NotationEcts'::text);




CREATE TABLE schema_pilotage.ref_grade_point_average AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'GradePointAverage'::text);




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
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'NiveauDiplome'::text);




CREATE TABLE schema_pilotage.ref_champ_formation AS
 SELECT val.id,
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
  WHERE ((nom.code_nomenclature)::text = 'ChampsFormation'::text);




CREATE TABLE schema_pilotage.ref_mention_diplome AS
 SELECT id,
    code,
    libelle_court,
    libelle_long
   FROM schema_ref.mention_diplome;


--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.ref_xxxxxxxxxxxxxxxxx'; END; $$;



/* ************************************************************************** */
/* vues concernant l'offre de formation */


/* liste des formations */
CREATE TABLE schema_pilotage.odf_formation AS
SELECT 
    F.id,
	PER.code AS "code_periode",
	PER.libelle_long AS "libelle_periode",
    F.code,
    F.libelle_court,
    F.libelle_long,
    F.type_code AS "code_type",
    F.type_libelle_court AS "libelle_type",
    F.code_type_diplome,
    RTD.libelle_long AS "libelle_type_diplome",
    F.code_cursus,
    RCF.libelle_long AS "libelle_cursus",
    CF.code_bcn AS "cursus_formation_bcn",
    F.code_niveau_formation,
    RNF.libelle_long AS "libelle_niveau_formation",
    NF.code_bcn AS "niveau_formation_bcn",
    F.code_nature_diplome,
    RNaD.libelle_long AS "libelle_nature_diplome",
    F.code_niveau_diplome,
    RNiD.libelle_long AS "libelle_niveau_diplome",
    F.code_champ_formation,
    RChF.libelle_long AS "libelle_champ_formation",
    F.code_domaine_formation,
    RDF.libelle_long AS "libelle_domaine_formation",
    F.code_mention,
    RMD.libelle_long AS "libelle_mention",
    --string_agg(FRI.code_regime_inscription, '/') AS codes_regime_inscription,
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
    M.structure_principale AS "code_structure",
    S.code_referentiel_externe AS "code_structure_externe",
    ESE.libelle_structure_externe_web AS "libelle_structure_externe",
    F.date_contexte

FROM schema_mof.formation F
LEFT JOIN schema_mof.periode PER ON PER.id = F.id_periode
LEFT JOIN schema_pilotage.ref_type_diplome RTD ON RTD.code = F.code_type_diplome
LEFT JOIN schema_pilotage.ref_cursus_formation RCF ON RCF.code = F.code_cursus
LEFT JOIN schema_pilotage.ref_niveau_formation RNF ON RNF.code = F.code_niveau_formation
LEFT JOIN schema_pilotage.ref_nature_diplome RNaD ON RNaD.code = F.code_nature_diplome
LEFT JOIN schema_pilotage.ref_niveau_diplome RNiD ON RNiD.code_metier = F.code_niveau_diplome
LEFT JOIN schema_pilotage.ref_champ_formation RChF ON RChF.code_metier = F.code_champ_formation
LEFT JOIN schema_pilotage.ref_domaine_formation RDF ON RDF.code = F.code_domaine_formation
LEFT JOIN schema_pilotage.ref_mention_diplome RMD ON RMD.code = F.code_mention
LEFT JOIN schema_ref.cursus_formation CF ON CF.code = F.code_cursus 
LEFT JOIN schema_mof.maquette M ON F.id_maquette = M.id
LEFT JOIN schema_ref.structure S ON S.code = M.structure_principale
LEFT JOIN schema_ref.niveau_formation NF ON F.code_niveau_formation = NF.code
LEFT JOIN schema_pilotage.etab_structure_externe ESE ON ESE.code_structure_externe = S.code_referentiel_externe
--LEFT JOIN schema_mof.formation_regime_inscription FRI ON FRI.id_formation = F.id
;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_formation'; END; $$;





/* liste des régimes d'inscriptions pour formations */
CREATE TABLE schema_pilotage.odf_formation_regime_inscription AS
SELECT 
    FRI.*,
    RI.libelle_long

FROM schema_mof.formation_regime_inscription FRI
LEFT JOIN schema_pilotage.ref_regime_inscription RI ON RI.code =FRI.code_regime_inscription
;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_formation_regime_inscription'; END; $$;







/* liste des chemins (sans les racines) */
CREATE TABLE schema_pilotage.temp_odf_objet_formation_individuel_chemin AS
SELECT *
FROM schema_mof.objet_formation_chemin OFC
ORDER BY chemin;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.temp_odf_objet_formation_individuel_chemin'; END; $$;




/* liste des objets de formations (sans les racines) */
CREATE TABLE schema_pilotage.odf_objet_formation AS
SELECT 
    OBF.id,
	PER.code AS "code_periode",
	PER.libelle_long AS "libelle_periode",
    OBF.code,
    OBF.libelle_court,
    OBF.libelle_long,
    OBF.description,
	OFT.code AS "code_type",
	OFT.libelle_court AS "libelle_type",
	FC.code AS "code_categorie",
	FC.libelle_court AS "libelle_categorie",
    NULL as "niveau_sise",
    OBF.nb_inscriptions_autorisees,
    OBF.coefficient,
    OBF.temoin_mutualise,
    OBF.temoin_titre_acces_necessaire,
    OBF.temoin_tele_enseignement,
    OBF.temoin_stage,
    OBF.capacite_accueil,
    OBF.structure_principale AS "code_structure",
    S.code_referentiel_externe AS "code_structure_externe",
    ESE.libelle_structure_externe_web AS "libelle_structure_externe",
    OBF.date_contexte

FROM schema_mof.objet_formation OBF
LEFT JOIN schema_mof.periode PER ON PER.id = OBF.id_periode
LEFT JOIN schema_mof.objet_formation_type OFT ON OFT.id = OBF.id_objet_formation_type
LEFT JOIN schema_mof.objet_formation_categorie FC ON FC.id = OFT.id_categorie
LEFT JOIN schema_ref.structure S ON S.code = OBF.structure_principale
LEFT JOIN schema_pilotage.etab_structure_externe ESE ON ESE.code_structure_externe = S.code_referentiel_externe;
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_objet_formation'; END; $$;




/* ajoute les racines dans les objets de formations et les chemins */
ALTER TABLE schema_pilotage.odf_objet_formation ALTER COLUMN code_structure TYPE character varying(10), ALTER COLUMN libelle_court TYPE character varying(100), ALTER COLUMN libelle_long TYPE character varying(200);
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT * FROM schema_pilotage.odf_formation WHERE code NOT IN (SELECT code FROM schema_pilotage.odf_objet_formation)) LOOP
		--RAISE NOTICE 'INSERT INTO schema_pilotage.odf_objet_formation VALUES (%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%)', 90000000000+r.id,r.code_periode,r.libelle_periode,r.code,r.libelle_court,r.libelle_long,'',r.code_type,r.libelle_type,'FORMATION','Formation',r.nb_inscriptions_autorisees,r.code_structure,NULL,FALSE,r.temoin_titre_acces_necessaire,r.temoin_tele_enseignement,FALSE,NULL,r.date_contexte;
		INSERT INTO schema_pilotage.odf_objet_formation (id,code_periode,libelle_periode,code,libelle_court,libelle_long,description,code_type,libelle_type,code_categorie,libelle_categorie,nb_inscriptions_autorisees,code_structure,coefficient,temoin_mutualise,temoin_titre_acces_necessaire,temoin_tele_enseignement,temoin_stage,capacite_accueil,date_contexte) VALUES (90000000000+r.id,r.code_periode,r.libelle_periode,r.code,r.libelle_court,r.libelle_long,NULL,r.code_type,r.libelle_type,'FORMATION','Formation',r.nb_inscriptions_autorisees,r.code_structure,NULL,FALSE,r.temoin_titre_acces_necessaire,r.temoin_tele_enseignement,FALSE,NULL,r.date_contexte);
		--RAISE NOTICE 'INSERT INTO schema_pilotage.temp_odf_objet_formation_individuel_chemin VALUES (%,%,%,%,%,%,%,%,%)', 90000000000+r.id,r.id,90000000000+r.id,r.code,FALSE,NULL,FALSE,FALSE,r.coefficient;
		INSERT INTO schema_pilotage.temp_odf_objet_formation_individuel_chemin (id,id_formation,id_objet_formation,chemin,temoin_ouverture_inscription_impossible,id_of_chemin_bloquant,temoin_ouvert_choix_cursus,temoin_jamais_ouvert_choix_cursus,coefficient) VALUES (90000000000+r.id,r.id,90000000000+r.id,r.code,FALSE,NULL,FALSE,FALSE,NULL);
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : ajoute les racines dans les objets de formations et les chemins'; END; $$;




/* ajoute les groupements dans les objets de formations */
DO $$ DECLARE
    r RECORD;
    position integer;
BEGIN
    position := 1;
    FOR r IN (SELECT MG.code, MG.libelle_court, MG.libelle_long, MG.temoin_mutualise, F.code_periode, F.libelle_periode, F.code_structure
                     FROM schema_mof.maquette_groupement MG,
                         schema_pilotage.temp_odf_objet_formation_individuel_chemin OFC,
                         schema_pilotage.odf_formation F
                     WHERE OFC.chemin ILIKE CONCAT('%>', MG.code, '>%')
                         AND MG.code NOT IN (SELECT code FROM schema_pilotage.odf_objet_formation)
                         AND F.id = OFC.id_formation
                         --AND MG.id=250
                         AND F.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
					GROUP BY MG.code, MG.libelle_court, MG.libelle_long, MG.temoin_mutualise, F.code_periode, F.libelle_periode, F.code_structure
                  ) LOOP
		--RAISE NOTICE 'INSERT INTO schema_pilotage.odf_objet_formation VALUES (%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%,%)', 80000000000+r.id,r.code_periode,r.libelle_periode,r.code,r.libelle_court,r.libelle_long,'','GRP','Groupement','GRP','Groupement',NULL,r.code_structure,NULL,r.temoin_mutualise,FALSE,FALSE,FALSE,NULL,NULL;
		INSERT INTO schema_pilotage.odf_objet_formation (id,code_periode,libelle_periode,code,libelle_court,libelle_long,description,code_type,libelle_type,code_categorie,libelle_categorie,nb_inscriptions_autorisees,code_structure,coefficient,temoin_mutualise,temoin_titre_acces_necessaire,temoin_tele_enseignement,temoin_stage,capacite_accueil,date_contexte) VALUES (70000000000+position,r.code_periode,r.libelle_periode,r.code,r.libelle_court,r.libelle_long,NULL,'GRP','Groupement','GRP','Groupement',NULL,r.code_structure,NULL,r.temoin_mutualise,FALSE,FALSE,FALSE,NULL,NULL);
        
        position := position + 1;
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : ajoute les groupements dans les objets de formations '; END; $$;




/* ajoute les groupements dans les chemins */
DO $$ DECLARE
    r RECORD;
    position integer;
BEGIN
    position := 1;
    FOR r IN (SELECT OOF.id, OOF.code, reverse(SUBSTRING(reverse(OFC.chemin), STRPOS(reverse(OFC.chemin), reverse(OOF.code)), CHAR_LENGTH(reverse(OFC.chemin)))) AS "chemin_split", OOF.libelle_court, OOF.libelle_long, OOF.temoin_mutualise, F.code_periode, F.libelle_periode, F.code_structure, F.id AS "id_formation"
                     FROM schema_pilotage.odf_objet_formation OOF,
                         schema_pilotage.temp_odf_objet_formation_individuel_chemin OFC,
                         schema_pilotage.odf_formation F
                     WHERE OOF.code_type='GRP'
                         AND OFC.chemin ILIKE CONCAT('%>', OOF.code, '>%')
                         AND F.id = OFC.id_formation
						 AND F.code_periode = OOF.code_periode
						 AND F.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
					GROUP BY OOF.id, OOF.code, "chemin_split", OOF.libelle_court, OOF.libelle_long, OOF.temoin_mutualise, F.code_periode, F.libelle_periode, F.code_structure, F.id
                  ) LOOP
		--RAISE NOTICE 'INSERT INTO schema_pilotage.temp_odf_objet_formation_individuel_chemin VALUES (%,%,%,%,%,%,%,%,%)', 80000000000+r.id,r.id_formation,80000000000+r.id,r.chemin_split,FALSE,NULL,FALSE,FALSE,NULL;
		INSERT INTO schema_pilotage.temp_odf_objet_formation_individuel_chemin (id,id_formation,id_objet_formation,chemin,temoin_ouverture_inscription_impossible,id_of_chemin_bloquant,temoin_ouvert_choix_cursus,temoin_jamais_ouvert_choix_cursus,coefficient) VALUES (80000000000+position,r.id_formation,r.id,r.chemin_split,FALSE,NULL,FALSE,FALSE,NULL);
        
        position := position + 1;
    END LOOP;
END $$;
--DO $$ BEGIN RAISE NOTICE 'DONE : ajoute les groupements dans les chemins'; END; $$;






/* liste des objets, chemins et formations consolidées */
CREATE TABLE schema_pilotage.odf_objet_formation_chemin AS
SELECT 	
	OFC.id,
	NULL AS id_parent,
	F.code_periode,
	F.libelle_periode,
	OFC.chemin,
    CASE  
		WHEN STRPOS(OFC.chemin, '>')>0 THEN reverse(SUBSTRING(reverse(OFC.chemin), STRPOS(reverse(OFC.chemin), '>')+1, CHAR_LENGTH(reverse(OFC.chemin))))
		ELSE NULL
	END AS "chemin_parent",
	
	OFC.id_objet_formation,
	OFI.code AS "code_objet_formation",
    
    CASE  
		WHEN PEM.pegase_code_etape IS NULL THEN FALSE
		ELSE TRUE
	END AS "objet_formation_ouvert_aux_ia",
    
	NULL AS id_ancetre_ouvert_aux_ia,
	NULL AS "chemin_ancetre_ouvert_aux_ia",
    
	OFI.libelle_court AS "libelle_court_objet_formation",
	OFI.libelle_long AS "libelle_long_objet_formation",
	OFI.description AS "description_objet_formation",
	OFI.code_type AS "code_type_objet_formation",
	OFI.libelle_type AS "libelle_type_objet_formation",
	OFI.code_categorie AS "code_categorie_objet_formation",
    NULL AS "niveau_sise_objet_formation",
	OFI.libelle_categorie AS "libelle_categorie_objet_formation",
	OFI.nb_inscriptions_autorisees AS "nb_inscriptions_autorisees_objet_formation",
	OFI.coefficient AS "coefficient_objet_formation",
	OFI.temoin_mutualise AS "temoin_mutualise_objet_formation",
	OFI.temoin_titre_acces_necessaire AS "temoin_titre_acces_necessaire_objet_formation",
	OFI.temoin_tele_enseignement AS "temoin_tele_enseignement_objet_formation",
	OFI.temoin_stage AS "temoin_stage_objet_formation",
	OFI.capacite_accueil AS "capacite_accueil_objet_formation",
	OFI.code_structure AS "code_structure_objet_formation",
    S1.code_referentiel_externe AS "code_structure_externe_objet_formation",
    ESE1.libelle_structure_externe_web AS "libelle_structure_externe_objet_formation",
	
	OFC.id_formation,
	F.code AS "code_formation",
	F.libelle_court AS "libelle_court_formation",
	F.libelle_long AS "libelle_long_formation",
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
	
FROM schema_pilotage.temp_odf_objet_formation_individuel_chemin OFC
LEFT JOIN schema_pilotage.odf_formation F ON F.id = OFC.id_formation
LEFT JOIN schema_pilotage.odf_objet_formation OFI ON OFI.id = OFC.id_objet_formation
LEFT JOIN schema_uphf.pegase_etapes_mof PEM ON PEM.pegase_code_etape = OFI.code AND PEM.code_periode = F.code_periode
LEFT JOIN schema_ref.structure S1 ON S1.code = OFI.code_structure
LEFT JOIN schema_ref.structure S2 ON S2.code = F.code_structure
LEFT JOIN schema_pilotage.etab_structure_externe ESE1 ON ESE1.code_structure_externe = S1.code_referentiel_externe
LEFT JOIN schema_pilotage.etab_structure_externe ESE2 ON ESE2.code_structure_externe = S2.code_referentiel_externe
GROUP BY 
    OFC.id,
    F.code_periode,
    F.libelle_periode,
    OFC.chemin,
    OFC.id_objet_formation,
    OFI.code,
    "objet_formation_ouvert_aux_ia",
    OFI.libelle_court,
    OFI.libelle_long,
    OFI.description,
    OFI.code_type,
    OFI.libelle_type,
    OFI.code_categorie,
    OFI.libelle_categorie,
    OFI.nb_inscriptions_autorisees,
    OFI.coefficient,
    OFI.temoin_mutualise,
    OFI.temoin_titre_acces_necessaire,
    OFI.temoin_tele_enseignement,
    OFI.temoin_stage,
    OFI.capacite_accueil,
    OFI.code_structure,
    S1.code_referentiel_externe,
    ESE1.libelle_structure_externe_web,
    OFC.id_formation,
    F.code,
    F.libelle_court,
    F.libelle_long,
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
ORDER BY F.code_periode, chemin;
ALTER TABLE schema_pilotage.odf_objet_formation_chemin ALTER COLUMN id_parent TYPE bigint USING (id_parent::bigint);
ALTER TABLE schema_pilotage.odf_objet_formation_chemin ALTER COLUMN id_ancetre_ouvert_aux_ia TYPE bigint USING (id_ancetre_ouvert_aux_ia::bigint);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.odf_objet_formation_chemin'; END; $$;


/* complète le parent - note : passe par une boucle FOR car l'UPDATE en masse bloque tout le script ? */
CREATE UNIQUE INDEX odf_objet_formation_chemin_id_idx ON schema_pilotage.odf_objet_formation_chemin (id);
CREATE INDEX odf_objet_formation_chemin_chemin_idx ON schema_pilotage.odf_objet_formation_chemin (chemin);
CREATE INDEX odf_objet_formation_chemin_chemin_parent_idx ON schema_pilotage.odf_objet_formation_chemin (chemin_parent);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE INDEX xxx ON schema_pilotage.odf_objet_formation_chemin'; END; $$;

/*DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT OFC_PERE.id AS "id_pere", OFC_FILS.id AS "id_fils"
                              FROM  schema_pilotage.odf_objet_formation_chemin OFC_FILS,
                                    schema_pilotage.odf_objet_formation_chemin OFC_PERE
                              WHERE OFC_FILS.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
                                 AND OFC_PERE.code_periode = OFC_FILS.code_periode
                                 AND OFC_FILS.chemin_parent IS NOT NULL
                                 AND OFC_PERE.chemin = OFC_FILS.chemin_parent
                              GROUP BY OFC_PERE.id, OFC_FILS.id) LOOP
		RAISE NOTICE 'UPDATE schema_pilotage.odf_objet_formation_chemin SET id_parent = % WHERE id = %', r.id_pere, r.id_fils;
		UPDATE schema_pilotage.odf_objet_formation_chemin SET id_parent = r.id_pere WHERE id = r.id_fils;
    END LOOP;
END $$;*/

UPDATE schema_pilotage.odf_objet_formation_chemin OFC_FILS
SET id_parent = OFC_PERE.id
FROM schema_pilotage.odf_objet_formation_chemin OFC_PERE
WHERE OFC_FILS.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
   AND OFC_PERE.code_periode = OFC_FILS.code_periode
   AND OFC_FILS.chemin_parent IS NOT NULL
   AND OFC_PERE.chemin = OFC_FILS.chemin_parent;

--DO $$ BEGIN RAISE NOTICE 'DONE : UPDATE schema_pilotage.odf_objet_formation_chemin SET id_parent'; END; $$;


/* complète l'ancêtre qui porte l'IA */
--UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = NULL, chemin_ancetre_ouvert_aux_ia = NULL;
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT *
                              FROM  schema_pilotage.odf_objet_formation_chemin
                              WHERE code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
                              AND objet_formation_ouvert_aux_ia = TRUE
                              --AND code_type_diplome='TYD020'
                              --AND code_periode='PER-2023'
                              ORDER BY code_periode, code_formation, chemin DESC) LOOP
		--RAISE NOTICE 'UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = %, chemin_ancetre_ouvert_aux_ia = % WHERE chemin LIKE % AND code_periode = % AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL', r.id, r.chemin, r.chemin||'%', r.code_periode;
        UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = r.id, chemin_ancetre_ouvert_aux_ia = r.chemin WHERE objet_formation_ouvert_aux_ia = FALSE AND chemin LIKE r.chemin||'>%' AND code_periode = r.code_periode AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL;
    END LOOP;
END $$;




/* complète le niveau de formation */
UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = NULL;

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = concat(cursus_formation_bcn, niveau_sise_objet_formation)
WHERE  objet_formation_ouvert_aux_ia = TRUE AND niveau IS NULL
    AND (cursus_formation_bcn IS NOT NULL AND niveau_sise_objet_formation IS NOT NULL);
    
    



/* ************************************************************************** */
/* vues concernant les inscriptions administratives */


/* ADMIS avec inscription en cours */
CREATE TABLE schema_pilotage.ins_admis AS
 SELECT admis.id AS "id",
	admis.numero_admis AS "numero_candidat",
    APP.id::varchar(255) AS "id_apprenant",
    APP.code_apprenant,
    admis.ine,
    admis.ine_statut AS "statut_ine",
    admis.nom_naissance AS "nom_famille",
    admis.nom_usuel,
    admis.prenom,
    admis.prenom2,
    admis.prenom3,
    admis.genre AS "sexe",
    admis.date_naissance,
    admis.code_pays_naissance,
    P1.libelle_long AS "libelle_pays_naissance",
    admis.code_commune_naissance,
    schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune_naissance",
    admis.code_nationalite,
    P2.libelle_long AS "libelle_nationalite",
    ADMS.statut AS "statut_admission",
    adresse_code_pays,
    adresse_ligne1_etage,
    adresse_ligne2_batiment,
    adresse_ligne3_voie,
    adresse_ligne4_complement,
    adresse_code_postal,
    adresse_code_commune,
    adresse_ligne5_etranger,
    telephone1,
    telephone2,
    mail,
    admis.date_creation AS "date_de_creation",
    admis.date_modification AS "date_de_modification"

   FROM schema_inscription.admis
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = admis.code_pays_naissance
   LEFT JOIN schema_pilotage.ref_pays_nationalite P2 ON P2.code = admis.code_nationalite
   LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = admis.code_commune_naissance
   LEFT JOIN schema_inscription.admission ADMS ON ADMS.id_admis = admis.id
   LEFT JOIN schema_gestion.apprenant APP ON APP.ine = admis.ine
   
   GROUP BY admis.id,"numero_candidat","id_apprenant",APP.code_apprenant,admis.ine,"statut_ine","nom_famille",
admis.nom_usuel,admis.prenom,admis.prenom2,admis.prenom3,"sexe",admis.date_naissance,admis.code_pays_naissance,"libelle_pays_naissance",admis.code_commune_naissance,schema_pilotage.ref_commune_insee.libelle_long,
admis.code_nationalite,"libelle_nationalite","statut_admission",adresse_code_pays,adresse_ligne1_etage,adresse_ligne2_batiment,adresse_ligne3_voie,adresse_ligne4_complement,adresse_code_postal,
adresse_code_commune,adresse_ligne5_etranger,telephone1,telephone2,mail,"date_de_creation","date_de_modification";
   
   


/* apprenants avec inscription validée */
CREATE TABLE schema_pilotage.ins_apprenant AS
 (SELECT apprenant.id::varchar(255),
    apprenant.code_apprenant,
    apprenant.ine AS "ine",
    apprenant.statut_ine,
    apprenant.nom_famille,
    apprenant.nom_usuel,
    apprenant.prenom,
    apprenant.prenom2,
    apprenant.prenom3,
    apprenant.sexe,
    apprenant.date_naissance,
    apprenant.code_pays_naissance,
    P1.libelle_long AS "libelle_pays_naissance",
    apprenant.code_commune_naissance,
    schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune_naissance",
    apprenant.libelle_commune_naissance_etranger,
    apprenant.code_nationalite,
    P2.libelle_long AS "libelle_nationalite",
    apprenant.code_nationalite2,
    P3.libelle_long AS "libelle_nationalite2",
    apprenant.annee_obtention_bac,
    apprenant.code_type_ou_serie_bac,
    ref_serie_bac.libelle_long AS "libelle_type_ou_serie_bac",
    apprenant.code_mention_bac,
    schema_pilotage.ref_mention_bac.libelle_long AS "libelle_mention_bac",
    apprenant.type_etablissement_bac,
    apprenant.code_pays_bac,
    P4.libelle_long AS "libelle_pays_bac",
    apprenant.code_departement_bac,
    UPPER(D.libelle_affichage) AS "libelle_departement_bac",
    apprenant.code_etablissement_bac,
    UPPER(EF.libelle_affichage) AS "libelle_etablissement_bac",
    apprenant.etablissement_libre_bac,
    apprenant.precisions_titre_dispense_bac AS "precision_titre_dispense_bac",
    apprenant.annee_entree_enseignement_superieur,
    apprenant.annee_entree_universite,
    apprenant.annee_entree_etablissement,
    apprenant.code_categorie_socioprofessionnelle,
    CSP1.libelle_long AS "libelle_categorie_socioprofessionnelle",
    apprenant.code_quotite_travaillee,
    QA.libelle_long AS "libelle_quotite_travaillee",
    apprenant.code_categorie_socioprofessionnelle_parent1,
    CSP2.libelle_long AS "libelle_socioprofessionnelle_parent1",
    apprenant.code_categorie_socioprofessionnelle_parent2,
    CSP3.libelle_long AS "libelle_socioprofessionnelle_parent2",
    apprenant.code_situation_familiale,
    SF.libelle_long AS "libelle_situation_familiale",
    apprenant.nombre_enfants,
    apprenant.code_situation_militaire,
    SM.libelle_long AS "libelle_situation_militaire",
    apprenant.code_premiere_specialite_bac,
    SP1.libelle_long AS "libelle_premiere_specialite_bac",
    apprenant.code_deuxieme_specialite_bac,
    SP2.libelle_long AS "libelle_deuxieme_specialite_bac",
    apprenant.date_creation AS "date_de_creation",
    apprenant.date_modification AS "date_de_modification"

   FROM schema_gestion.apprenant
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = apprenant.code_pays_naissance
   LEFT JOIN schema_pilotage.ref_pays_nationalite P2 ON P2.code = apprenant.code_nationalite
   LEFT JOIN schema_pilotage.ref_pays_nationalite P3 ON P3.code = apprenant.code_nationalite2
   LEFT JOIN schema_pilotage.ref_pays_nationalite P4 ON P4.code = apprenant.code_pays_bac
   LEFT JOIN schema_pilotage.ref_departement D ON D.code = apprenant.code_departement_bac
   LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = apprenant.code_commune_naissance
   LEFT JOIN schema_pilotage.ref_serie_bac ON schema_pilotage.ref_serie_bac.code = apprenant.code_type_ou_serie_bac
   LEFT JOIN schema_pilotage.ref_mention_bac ON schema_pilotage.ref_mention_bac.code_metier = apprenant.code_mention_bac
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP1 ON CSP1.code = apprenant.code_categorie_socioprofessionnelle
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP2 ON CSP2.code = apprenant.code_categorie_socioprofessionnelle_parent1
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP3 ON CSP3.code = apprenant.code_categorie_socioprofessionnelle_parent2
   LEFT JOIN schema_pilotage.ref_etablissement_francais EF ON EF.code = apprenant.code_etablissement_bac
   LEFT JOIN schema_pilotage.ref_situation_militaire SM ON SM.code_metier = apprenant.code_situation_militaire
   LEFT JOIN schema_pilotage.ref_situation_familiale SF ON SF.code_metier = apprenant.code_situation_familiale
   LEFT JOIN schema_pilotage.ref_quotite_activite QA ON QA.code_metier = apprenant.code_quotite_travaillee
   LEFT JOIN schema_pilotage.ref_specialites_bac SP1 ON SP1.code_metier = apprenant.code_premiere_specialite_bac
   LEFT JOIN schema_pilotage.ref_specialites_bac SP2 ON SP2.code_metier = apprenant.code_deuxieme_specialite_bac)
   
   UNION
   
   (SELECT 
	CASE  
		WHEN id_apprenant IS NOT NULL THEN id_apprenant::varchar(255)
		ELSE id::varchar(255)
	END AS "id",
    code_apprenant,
    ine,
    statut_ine,
    nom_famille,
    nom_usuel,
    prenom,
    prenom2,
    prenom3,
    sexe,
    date_naissance,
    code_pays_naissance,
    libelle_pays_naissance,
    code_commune_naissance,
    libelle_commune_naissance,
    NULL AS "libelle_commune_naissance_etranger",
    code_nationalite,
    libelle_nationalite,
    NULL AS "code_nationalite2",
    NULL AS "libelle_nationalite2",
    NULL AS "annee_obtention_bac",
    NULL AS "code_type_ou_serie_bac",
    NULL AS "libelle_type_ou_serie_bac",
    NULL AS "code_mention_bac",
    NULL AS "libelle_mention_bac",
    NULL AS "type_etablissement_bac",
    NULL AS "code_pays_bac",
    NULL AS "libelle_pays_bac",
    NULL AS "code_departement_bac",
    NULL AS "libelle_departement_bac",
    NULL AS "code_etablissement_bac",
    NULL AS "libelle_etablissement_bac",
    NULL AS "etablissement_libre_bac",
    NULL AS "precision_titre_dispense_bac",
    NULL AS "annee_entree_enseignement_superieur",
    NULL AS "annee_entree_universite",
    NULL AS "annee_entree_etablissement",
    NULL AS "code_categorie_socioprofessionnelle",
    NULL AS "libelle_categorie_socioprofessionnelle",
    NULL AS "code_quotite_travaillee",
    NULL AS "libelle_quotite_travaillee",
    NULL AS "code_categorie_socioprofessionnelle_parent1",
    NULL AS "libelle_socioprofessionnelle_parent1",
    NULL AS "code_categorie_socioprofessionnelle_parent2",
    NULL AS "libelle_socioprofessionnelle_parent2",
    NULL AS "code_situation_familiale",
    NULL AS "libelle_situation_familiale",
    NULL AS "nombre_enfants",
    NULL AS "code_situation_militaire",
    NULL AS "libelle_situation_militaire",
    NULL AS "code_premiere_specialite_bac",
    NULL AS "libelle_premiere_specialite_bac",
    NULL AS "code_deuxieme_specialite_bac",
    NULL AS "libelle_deuxieme_specialite_bac",
    date_de_creation,
    date_de_modification

   FROM schema_pilotage.ins_admis
   
   WHERE statut_admission= 'AU'/* Admission utilisée donc il existe un début de dossier dans CDI */
   AND code_apprenant NOT IN (SELECT code_apprenant FROM schema_gestion.apprenant));




CREATE TABLE schema_pilotage.ins_cible AS /* TODO supprimer après s'être raccroché à ODF */
 SELECT cible.id,
    cible.libelle_long,
    cible.libelle_court,
    cible.code_chemin,
    reverse(split_part(reverse(cible.code_chemin), '>', 1)) AS code_feuille,
    cible.code_structure,
    cible.code_type,
    cible.code_categorie,
    cible.code_nature_diplome AS "code_nature",
    cible.version_maquette,
    cible.code_periode,
    cible.code_diplome_sise,
    cible.niveau_sise,
    
    F.libelle_periode AS "libelle_periode",
    F.libelle_court_formation AS "libelle_formation",
    F.code_formation AS "code_formation",
    F.code_type_diplome AS "type_diplome",
    F.libelle_type_diplome AS "libelle_type_diplome",
    F.code_objet_formation AS "code_objet_ia",
    F.libelle_court_objet_formation AS "libelle_objet_ia",
    F.cursus_formation_bcn AS "cursus_formation_bcn",
    F.niveau AS "niveau",
    F.niveau_formation_bcn AS "niveau_formation_bcn",
    NULL AS "type_public",
    F.code_domaine_formation AS "code_domaine_formation",
    F.libelle_domaine_formation AS "libelle_domaine_formation",
    F.code_structure_externe_objet_formation AS "sinaps_code_composante",
    F.libelle_structure_externe_objet_formation AS "sinaps_libelle_composante"
    
   FROM schema_gestion.cible
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin F ON F.chemin = cible.code_chemin AND F.code_periode = cible.code_periode;




CREATE TABLE schema_pilotage.ins_bourse_aide_financiere AS
 SELECT bourse_ou_aide_financiere.id_inscription::varchar(255),
    bourse_ou_aide_financiere.code,
    bourse_ou_aide_financiere.code_bcn,
    /*bourse_ou_aide_financiere.libelle_court,
    bourse_ou_aide_financiere.libelle_long,*/
    BAF.libelle_court,
    BAF.libelle_long,
    '' AS type
   FROM schema_gestion.bourse_ou_aide_financiere
   LEFT JOIN schema_pilotage.ref_bourse_aide_financiere BAF ON BAF.code_metier=bourse_ou_aide_financiere.code;




CREATE TABLE schema_pilotage.ins_amenagement_specifique AS
 SELECT amenagement_specifique.id_inscription::varchar(255),
    amenagement_specifique.code,
    RSE.libelle_court,
    RSE.libelle_long
   FROM schema_gestion.amenagement_specifique
   LEFT JOIN schema_pilotage.ref_regime_special_etudes RSE ON RSE.code_metier=amenagement_specifique.code;




CREATE TABLE schema_pilotage.ins_profil_specifique AS
 SELECT profil_specifique.id_inscription::varchar(255),
    profil_specifique.code,
    PRF.libelle_court,
    PRF.libelle_long
   FROM schema_gestion.profil_specifique
   LEFT JOIN schema_pilotage.ref_profil_exonerant PRF ON PRF.code_metier=profil_specifique.code;







CREATE TABLE schema_pilotage.ins_contact AS
 (SELECT contact.id_apprenant::varchar(255),
    contact.id_demande,
    contact.code_canal_communication AS "type",
    CDC.libelle_long AS "libelle_type",
    contact.proprietaire,
    contact.mail,
    contact.telephone,
    contact.code_postal,
    contact.code_commune,
    schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune",
    contact.adresse_ligne1_etage AS "ligne1_ou_etage",
    contact.adresse_ligne2_batiment AS "ligne2_ou_batiment",
    contact.adresse_ligne3_voie AS "ligne3_ou_voie",
    contact.adresse_ligne4_complement AS "ligne4_ou_complement",
    contact.adresse_ligne5_etranger AS "ligne5_etranger",
    contact.code_pays,
    P1.libelle_long AS "libelle_pays"

   FROM schema_gestion.contact
   
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = contact.code_pays
   LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = contact.code_commune
   LEFT JOIN schema_pilotage.ref_canal_de_communication CDC ON CDC.code_metier = contact.code_canal_communication
   
   ORDER BY id_apprenant)
   
   UNION
   
(SELECT id::varchar(255) AS "id_apprenant",
	'MEL-001' AS "id_demande",
	'CDC003' AS "type",
    'ADRESSE ELECTRONIQUE' AS "libelle_type",
	NULL AS "proprietaire",
	mail AS "mail",
	NULL AS "telephone",
	NULL AS "code_postal",
	NULL AS "code_commune",
	NULL AS "libelle_commune",
	NULL AS "ligne1_ou_etage",
	NULL AS "ligne2_ou_batiment",
	NULL AS "ligne3_ou_voie",
	NULL AS "ligne4_ou_complement",
	NULL AS "ligne5_etranger",
	NULL AS "code_pays",
	NULL AS "libelle_pays"
	
	FROM schema_pilotage.ins_admis
	
	WHERE mail IS NOT NULL)
	
UNION

(SELECT id::varchar(255) AS "id_apprenant",
	'TEL-001' AS "id_demande",
	'CDC002' AS "type",
    'N° DE TELEPHONE' AS "libelle_type",
	NULL AS "proprietaire",
	NULL AS "mail",
	telephone1 AS "telephone",
	NULL AS "code_postal",
	NULL AS "code_commune",
	NULL AS "libelle_commune",
	NULL AS "ligne1_ou_etage",
	NULL AS "ligne2_ou_batiment",
	NULL AS "ligne3_ou_voie",
	NULL AS "ligne4_ou_complement",
	NULL AS "ligne5_etranger",
	NULL AS "code_pays",
	NULL AS "libelle_pays"
	
	FROM schema_pilotage.ins_admis
	
	WHERE telephone1 IS NOT NULL)
	
UNION

(SELECT id::varchar(255) AS "id_apprenant",
	'TEL-002' AS "id_demande",
	'CDC002' AS "type",
    'N° DE TELEPHONE' AS "libelle_type",
	NULL AS "proprietaire",
	NULL AS "mail",
	telephone2 AS "telephone",
	NULL AS "code_postal",
	NULL AS "code_commune",
	NULL AS "libelle_commune",
	NULL AS "ligne1_ou_etage",
	NULL AS "ligne2_ou_batiment",
	NULL AS "ligne3_ou_voie",
	NULL AS "ligne4_ou_complement",
	NULL AS "ligne5_etranger",
	NULL AS "code_pays",
	NULL AS "libelle_pays"
	
	FROM schema_pilotage.ins_admis
	
	WHERE telephone2 IS NOT NULL)
	
UNION

(SELECT id::varchar(255) AS "id_apprenant",
	'ADR-001' AS "id_demande",
	'CDC001' AS "type",
    'ADRESSE POSTALE' AS "libelle_type",
	NULL AS "proprietaire",
	NULL AS "mail",
	NULL AS "telephone",
	adresse_code_postal AS "code_postal",
	adresse_code_commune AS "code_commune",
	schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune",
	adresse_ligne1_etage AS "ligne1_ou_etage",
	adresse_ligne2_batiment AS "ligne2_ou_batiment",
	adresse_ligne3_voie AS "ligne3_ou_voie",
	adresse_ligne4_complement AS "ligne4_ou_complement",
	adresse_ligne5_etranger AS "ligne5_etranger",
	adresse_code_pays AS "code_pays",
	P1.libelle_long AS "libelle_pays"
	
	FROM schema_pilotage.ins_admis
	
	LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = ins_admis.adresse_code_pays
	LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = ins_admis.adresse_code_commune
	
	WHERE adresse_code_postal IS NOT NULL OR adresse_code_commune IS NOT NULL OR adresse_ligne1_etage IS NOT NULL OR adresse_ligne2_batiment IS NOT NULL OR adresse_ligne3_voie IS NOT NULL OR adresse_ligne4_complement IS NOT NULL OR adresse_ligne5_etranger IS NOT NULL OR adresse_code_pays IS NOT NULL);

   
   





CREATE VIEW schema_pilotage.ins_contacts AS
 SELECT id_apprenant,
    MAIL.mail AS "mail_etab",
    max(ins_contact.mail) filter (where id_demande = 'MEL-001') as "mail_perso",
    max(ins_contact.mail) filter (where id_demande = 'MEL-002') as "mail_secours",
    
    max(telephone) filter (where id_demande = 'TEL-002') as "telephone_perso",
    max(telephone) filter (where id_demande = 'TEL-001') as "telephone_urgence",
    
    max(code_postal) filter (where id_demande = 'ADR-001') as "adresse_fixe_code_postal",
    max(code_commune) filter (where id_demande = 'ADR-001') as "adresse_fixe_code_commune",
    max(libelle_commune) filter (where id_demande = 'ADR-001') as "adresse_fixe_libelle_commune",
    max(ligne1_ou_etage) filter (where id_demande = 'ADR-001') as "adresse_fixe_ligne1_ou_etage",
    max(ligne2_ou_batiment) filter (where id_demande = 'ADR-001') as "adresse_fixe_ligne2_ou_batiment",
    max(ligne3_ou_voie) filter (where id_demande = 'ADR-001') as "adresse_fixe_ligne3_ou_voie",
    max(ligne4_ou_complement) filter (where id_demande = 'ADR-001') as "adresse_fixe_ligne4_ou_complement",
    max(ligne5_etranger) filter (where id_demande = 'ADR-001') as "adresse_fixe_ligne5_etranger",
    max(code_pays) filter (where id_demande = 'ADR-001') as "adresse_fixe_code_pays",
    max(libelle_pays) filter (where id_demande = 'ADR-001') as "adresse_fixe_libelle_pays",
    
    
    max(code_postal) filter (where id_demande = 'ADR-002') as "adresse_annuelle_code_postal",
    max(code_commune) filter (where id_demande = 'ADR-002') as "adresse_annuelle_code_commune",
    max(libelle_commune) filter (where id_demande = 'ADR-002') as "adresse_annuelle_libelle_commune",
    max(ligne1_ou_etage) filter (where id_demande = 'ADR-002') as "adresse_annuelle_ligne1_ou_etage",
    max(ligne2_ou_batiment) filter (where id_demande = 'ADR-002') as "adresse_annuelle_ligne2_ou_batiment",
    max(ligne3_ou_voie) filter (where id_demande = 'ADR-002') as "adresse_annuelle_ligne3_ou_voie",
    max(ligne4_ou_complement) filter (where id_demande = 'ADR-002') as "adresse_annuelle_ligne4_ou_complement",
    max(ligne5_etranger) filter (where id_demande = 'ADR-002') as "adresse_annuelle_ligne5_etranger",
    max(code_pays) filter (where id_demande = 'ADR-002') as "adresse_annuelle_code_pays",
    max(libelle_pays) filter (where id_demande = 'ADR-002') as "adresse_annuelle_libelle_pays_"

   FROM schema_pilotage.ins_contact
   LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.id = ins_contact.id_apprenant
   LEFT JOIN schema_pilotage.etab_mail_institutionnel MAIL ON MAIL.code_apprenant = APP.code_apprenant

   GROUP BY id_apprenant, MAIL.mail;


   
   
   
   



/* inscriptions */
CREATE TABLE schema_pilotage.ins_inscription_validee_ou_annulee AS
 SELECT inscription.id::varchar(255),
    inscription.id_cible, /* TODO supprimer après s'être raccroché à ODF */
    OOFC.id AS "id_objet_formation_chemin",
    inscription.id_apprenant::varchar(255),
    OOFC.code_periode,
    OOFC.libelle_periode,
    OOFC.code_objet_formation AS "code_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.libelle_court_objet_formation AS "libelle_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    inscription.origine,
    inscription.contexte_inscription,
    inscription.numero_candidat,
    inscription.date_inscription,
    CASE  
		WHEN inscription.statut_inscription='V' THEN 'VALIDE'
        WHEN inscription.statut_inscription='A' THEN 'ANNULEE'
		ELSE 'INCONNU'
	END AS "statut_inscription",
    inscription.statut_paiement,
    inscription.statut_pieces,
    inscription.code_regime_inscription AS "code_regime_inscription",
    RI.libelle_long AS "libelle_regime_inscription",
    inscription.numero_cvec,
    inscription.temoin_principale,
    inscription.cesure,
    inscription.mobilite,
    inscription.temoin_souhait_amenagement AS "souhait_amenagement",
    inscription.admission_voie,
    inscription.admission_annee_concours,
    inscription.admission_concours,
    inscription.admission_rang_concours,
    inscription.admission_annee_precedente,
    inscription.admission_type_classe_preparatoire,
    inscription.admission_puissance_classe_preparatoire,
    inscription.admission_code_pays AS "admission_pays_etablissement_precedent",
    inscription.admission_code_etablissement AS "admission_etablissement_precedent",
    inscription.admission_temoin_classe_prepa,
    inscription.admission_type_etablissement_precedent,
    inscription.admission_departement_etablissement_precedent,
    inscription.admission_code_etablissement_etranger AS "admission_etablissement_precedent_etranger",
    inscription.annee_precedente,
    inscription.situation_annee_precedente_code AS "code_situation_annee_precedente",
    SAP.libelle_long AS "libelle_situation_annee_precedente",
    inscription.annee_obtention_dernier_diplome,
    inscription.code_type_dernier_diplome_obtenu,
    DDO.libelle_long AS "libelle_type_dernier_diplome_obtenu",
    inscription.motif_annulation,
    inscription.temoin_avec_remboursement AS "avec_remboursement",
    inscription.situation_annee_precedente_code_bcn,
    inscription.situation_annee_precedente_libelle_affichage,
    inscription.ecole_doctorale_code AS "code_ecole_doctorale",
    ED.libelle_long AS "libelle_ecole_doctorale",
    inscription.filiere_code AS "code_filiere",
    CUP.libelle_long AS "libelle_filiere",
    inscription.temoin_convention_etablissement,
    inscription.programme_echange_code AS "code_programme_echange",
    ECH.libelle_long AS "libelle_programme_echange",
    inscription.programme_echange_pays_code AS "code_programme_echange_pays",
    P1.libelle_long AS "libelle_programme_echange_pays",
    inscription.temoin_enseignement_distance_depuis_france,
    inscription.date_creation AS "date_de_creation",
    inscription.date_modification AS "date_de_modification"

   FROM schema_gestion.inscription
   
   LEFT JOIN schema_pilotage.ref_situation_annee_precedente SAP ON SAP.code_metier = inscription.situation_annee_precedente_code
   LEFT JOIN schema_pilotage.ref_regime_inscription RI ON RI.code = inscription.code_regime_inscription
   LEFT JOIN schema_pilotage.ref_type_dernier_diplome_obtenu DDO ON DDO.code_metier = inscription.code_type_dernier_diplome_obtenu
   LEFT JOIN schema_pilotage.ref_cursus_parallele CUP ON CUP.code_metier = inscription.filiere_code
   LEFT JOIN schema_pilotage.ref_programme_echange ECH ON ECH.code_metier = inscription.programme_echange_code
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = inscription.programme_echange_pays_code
   LEFT JOIN schema_pilotage.ref_ecole_doctorale ED ON ED.code_metier = inscription.ecole_doctorale_code
   LEFT JOIN schema_gestion.cible C ON C.id = inscription.id_cible
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.chemin = C.code_chemin AND OOFC.code_periode = C.code_periode
   
   ORDER BY code_periode, inscription.id;










/* admissions */
CREATE TABLE schema_pilotage.ins_admission AS
 SELECT admission.id::varchar(255),
	C.id AS "id_cible", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.id AS "id_objet_formation_chemin",
    admission.id_admis AS "id_admis",
	CASE  
		WHEN AD.id_apprenant IS NOT NULL THEN AD.id_apprenant::varchar(255)
		ELSE AD.id::varchar(255)
	END AS "id_apprenant",
	INS.id AS "id_inscription",
    OOFC.code_periode,
    OOFC.libelle_periode,
    OOFC.code_objet_formation AS "code_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.libelle_court_objet_formation AS "libelle_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    admission.origine_admission AS "origine",
	AD.numero_candidat AS "numero_candidat",
    admission.voie_admission AS "admission_voie",
    admission.annee_concours AS "admission_annee_concours",
	admission.statut,
    AD.date_de_creation,
    AD.date_de_modification

   FROM schema_inscription.admission
   
   LEFT JOIN schema_pilotage.ins_admis AD ON AD.id = admission.id_admis
   LEFT JOIN schema_pilotage.ins_cible C ON C.code_feuille ILIKE admission.code_cible AND C.code_periode = admission.code_periode /* TODO supprimer après s'être raccroché à ODF */
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.chemin = C.code_chemin AND OOFC.code_periode = C.code_periode
   LEFT JOIN schema_pilotage.ins_inscription_validee_ou_annulee INS ON INS.id_cible = C.id AND INS.id_apprenant = AD.id_apprenant
   
   WHERE AD.id_apprenant IS NOT NULL OR AD.id IS NOT NULL
   GROUP BY admission.id, C.id, OOFC.id, AD.id_apprenant, AD.id, INS.id, OOFC.code_periode, OOFC.libelle_periode, OOFC.code_objet_formation, OOFC.libelle_court_objet_formation, admission.origine_admission, AD.numero_candidat, admission.voie_admission, admission.annee_concours, admission.statut, AD.date_de_creation, AD.date_de_modification
   ORDER BY code_periode, admission.id;





/* INSCRIPTIONS en cours et validees */
CREATE TABLE schema_pilotage.ins_inscription AS
   (SELECT * FROM schema_pilotage.ins_inscription_validee_ou_annulee)
   
   UNION
   
   (SELECT id,
	id_cible, /* TODO supprimer après s'être raccroché à ODF */
    id_objet_formation_chemin,
	id_apprenant,
    code_periode,
    libelle_periode,
    code_objet_ia, /* TODO supprimer après s'être raccroché à ODF */
    libelle_objet_ia, /* TODO supprimer après s'être raccroché à ODF */
    code_objet_formation,
    libelle_objet_formation,
    origine,
    NULL AS "contexte_inscription",
	numero_candidat,
	NULL AS "date_inscription",
	'EN_COURS' AS "statut_inscription",
    NULL AS "statut_paiement",
    NULL AS "statut_pieces",
    NULL AS "code_regime_inscription",
    NULL AS "libelle_regime_inscription",
    NULL AS "numero_cvec",
    NULL AS "temoin_principale",
    NULL AS "cesure",
    NULL AS "mobilite",
    NULL AS "souhait_amenagement",
    admission_voie,
    admission_annee_concours,
    NULL AS "admission_concours",
    NULL AS "admission_rang_concours",
    NULL AS "admission_annee_precedente",
    NULL AS "admission_type_classe_preparatoire",
    NULL AS "admission_puissance_classe_preparatoire",
    NULL AS "admission_pays_etablissement_precedent",
    NULL AS "admission_etablissement_precedent",
    NULL AS "admission_temoin_classe_prepa",
    NULL AS "admission_type_etablissement_precedent",
    NULL AS "admission_departement_etablissement_precedent",
    NULL AS "admission_etablissement_precedent_etranger",
    NULL AS "annee_precedente",
    NULL AS "code_situation_annee_precedente",
    NULL AS "libelle_situation_annee_precedente",
    NULL AS "annee_obtention_dernier_diplome",
    NULL AS "code_type_dernier_diplome_obtenu",
    NULL AS "libelle_type_dernier_diplome_obtenu",
    NULL AS "motif_annulation",
    NULL AS "avec_remboursement",
    NULL AS "situation_annee_precedente_code_bcn",
    NULL AS "situation_annee_precedente_libelle_affichage",
    NULL AS "code_ecole_doctorale",
    NULL AS "libelle_ecole_doctorale",
    NULL AS "code_filiere",
    NULL AS "libelle_filiere",
    NULL AS "temoin_convention_etablissement",
    NULL AS "code_programme_echange",
    NULL AS "libelle_programme_echange",
    NULL AS "code_programme_echange_pays",
    NULL AS "libelle_programme_echange_pays",
    NULL AS "temoin_enseignement_distance_depuis_france",
    date_de_creation,
    date_de_modification

   FROM schema_pilotage.ins_admission
   
   WHERE ins_admission.statut = 'AU'
   AND ins_admission.id_inscription IS NULL)
   
   ORDER BY code_periode, id;








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
 SELECT F.id,
    F.numero,
    F.date_et_heure_emission,
    APP.id AS "id_apprenant",
    F.temoin_ue,
    F.temoin_accords,
    SB.id AS "id_structure_budgetaire",
    F.quittance_numero,
    F.quittance_date_generation,
    F.quittance_date_cloture,
    C.id AS "id_cible", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.id AS "id_objet_formation_chemin",
    OOFC.code_objet_formation AS "code_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.libelle_court_objet_formation AS "libelle_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    F.code_periode,
    F.formation_ref AS "formation_tarification_id",
    F.statut,
    F.temoin_annulee AS "annulee"

   FROM schema_pai.facture F
   LEFT JOIN schema_pilotage.ins_cible C ON C.code_chemin = F.code_chemin AND C.code_periode = F.code_periode /* TODO supprimer après s'être raccroché à ODF */
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.chemin = F.code_chemin AND OOFC.code_periode = F.code_periode
   LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.code_apprenant = F.code_apprenant
   LEFT JOIN schema_pilotage.pai_structure_budgetaire SB ON SB.id = F.structure_budgetaire_ref
   
   GROUP BY F.id,F.numero,F.date_et_heure_emission,APP.id,F.temoin_ue,F.temoin_accords,SB.id,F.quittance_numero,F.quittance_date_generation,F.quittance_date_cloture,C.id,OOFC.id,OOFC.code_objet_formation,OOFC.libelle_court_objet_formation,F.code_periode,F.formation_ref,F.statut,F.temoin_annulee
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
   LEFT JOIN schema_pilotage.pai_facture F ON F.id = LF.id_facture;
   
   
   
   


CREATE TABLE schema_pilotage.pai_formation_tarification AS
 SELECT F.id,
    C.id AS "id_cible", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.id AS "id_objet_formation_chemin",
    OOFC.code_objet_formation AS "code_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.libelle_court_objet_formation AS "libelle_objet_ia", /* TODO supprimer après s'être raccroché à ODF */
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    F.code_periode,
    F.temoin_jamais_ouverte_inscription AS "jamais_ouverteainscription",
    T.code AS "tarification_code",
    T.libelle_court AS "tarification_libelle_court",
    T.libelle_long AS "tarification_libelle_long",
    T.description AS "tarification_description"
    

   FROM schema_pai.formation F
   LEFT JOIN schema_pilotage.ins_cible C ON C.code_objet_ia = F.code AND C.code_periode = F.code_periode /* TODO supprimer après s'être raccroché à ODF */
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.code_objet_formation = F.code AND OOFC.code_periode = F.code_periode
   LEFT JOIN schema_pai.tarification T ON T.id = F.id_tarification AND T.code_periode = F.code_periode;






CREATE TABLE schema_pilotage.pai_paiement AS
 SELECT P.id,
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
    --NR.id,
	APP.id AS "id_apprenant",
	APP.code_apprenant,
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
LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.code_apprenant = CA.code
LEFT JOIN schema_coc.objet_formation OBF ON OBF.id = NR.id_objet_formation
LEFT JOIN schema_pilotage.odf_objet_formation OOF ON OOF.code = OBF.code AND OOF.code_periode=OBF.code_periode
LEFT JOIN schema_pilotage.ref_type_resultat RTR1 ON RTR1.code_metier = NR.resultat_session1
LEFT JOIN schema_pilotage.ref_type_resultat RTR2 ON RTR2.code_metier = NR.resultat_session2
LEFT JOIN schema_pilotage.ref_type_resultat RTR3 ON RTR3.code_metier = NR.resultat_final
LEFT JOIN schema_pilotage.ref_mention_honorifique RMH ON RMH.code_metier = NR.mention
LEFT JOIN schema_pilotage.ref_notation_ects RNE ON RNE.code_metier = NR.grade_ects
LEFT JOIN schema_pilotage.ref_grade_point_average RGPA ON RGPA.code_metier = NR.gpa;



/* diplômes */
CREATE TABLE schema_pilotage.coc_diplome AS
SELECT 
	APP.id AS "id_apprenant",
	APP.code_apprenant,
	P.code AS "code_periode",
	P.libelle_long AS "libelle_periode",
	DLOM.code_objet_maquette,
	AD.id_diplome,
	AD.temoin_annulation_autorisation_impossible,
	AD.code_mention AS "code_mention_honorifique",
	AD.libelle_court_mention AS "libelle_court_mention_honorifique",
	AD.libelle_long_mention AS "libelle_long_mention_honorifique",
	AD.libelle_affichage_mention AS "libelle_affichage_mention_honorifique",
	AD.date_consommation_referentiel,
    
    AD.date_autorisation,
    AD.utilisateur_autorisation,
    AD.date_annulation_apres_edition,
    AD.utilisateur_annulation_apres_edition,
    AD.motif_annulation_apres_edition,    
    
	D.code_structure_etablissement AS "diplome_code_structure_etablissement",
	D.code AS "diplome_code",
	D.version AS "diplome_version",
	D.type_finalite_formation_code AS "diplome_type_finalite_formation_code",
	D.type_finalite_formation_libelle_court AS "diplome_type_finalite_formation_libelle_court",
	D.type_finalite_formation_libelle_long AS "diplome_type_finalite_formation_libelle_long",
	D.type_finalite_formation_libelle_affichage AS "diplome_type_finalite_formation_libelle_affichage",
	D.date_contexte AS "diplome_date_contexte",
	D.libelle_court AS "diplome_libelle_court",
	D.denomination AS "diplome_denomination",
	D.validite AS "diplome_validite",
	D.temoin_actif AS "diplome_temoin_actif",
	D.etat AS "diplome_etat",
	PAR.date_edition AS "parchemin_date_edition",
	PAR.numero_edition AS "parchemin_numero_edition",
	PAR.date_signature_recteur AS "parchemin_date_signature_recteur",
	PAR.libelle_parcours_type_original AS "parchemin_libelle_parcours_type_original",
	
	PPAR.libelle_court AS "parchemin_libelle_court",
	PPAR.description AS "parchemin_description",
	PPAR.denomination_diplome AS "parchemin_denomination_diplome",
	PPAR.libelle_parcours_type AS "parchemin_libelle_parcours_type",
	
	M.contenu_reference AS "modele_contenu_reference",
	M.libelle_court AS "modele_libelle_court",
	M.type_template AS "modele_type_template"
	

FROM schema_coc.apprenant_diplome AD
LEFT JOIN schema_coc.apprenant CA ON CA.id = AD.id_apprenant
LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.code_apprenant = CA.code
LEFT JOIN schema_coc.periode P ON P.id = AD.id_periode
LEFT JOIN schema_coc.diplome D ON D.id = AD.id_diplome
LEFT JOIN schema_coc.diplome_lien_objet_maquette DLOM ON DLOM.id_diplome = D.id
LEFT JOIN schema_coc.apprenant_diplome_parchemin PAR ON PAR.id_apprenant_diplome = AD.id
LEFT JOIN schema_coc.parametrage_parchemin PPAR ON PPAR.id_diplome = D.id
LEFT JOIN schema_coc.modele M ON M.id = PPAR.id_modele

GROUP BY APP.id,APP.code_apprenant,P.code,P.libelle_long,DLOM.code_objet_maquette,AD.id_diplome,AD.temoin_annulation_autorisation_impossible,AD.code_mention,AD.libelle_court_mention,AD.libelle_long_mention,AD.libelle_affichage_mention,AD.date_consommation_referentiel,
AD.date_autorisation,AD.utilisateur_autorisation,AD.date_annulation_apres_edition,AD.utilisateur_annulation_apres_edition,AD.motif_annulation_apres_edition,D.code_structure_etablissement,D.code,D.version,D.type_finalite_formation_code,D.type_finalite_formation_libelle_court,D.type_finalite_formation_libelle_long,D.type_finalite_formation_libelle_affichage,D.date_contexte,D.libelle_court,D.denomination,D.validite,D.temoin_actif,D.etat,PAR.date_edition,PAR.numero_edition,PAR.date_signature_recteur,PAR.libelle_parcours_type_original,
PPAR.libelle_court,	PPAR.description,PPAR.denomination_diplome,PPAR.libelle_parcours_type,M.contenu_reference,M.libelle_court,M.type_template
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








/* ************************************************************************** */
/* Droits pegaseuser */

DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'schema_pilotage') LOOP
         RAISE NOTICE 'ALTER TABLE %', quote_ident(r.tablename);
         EXECUTE 'ALTER TABLE schema_pilotage.' || quote_ident(r.tablename) || ' OWNER TO pegaseuser';
    END LOOP;
END $$;

DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT viewname FROM pg_views WHERE schemaname = 'schema_pilotage') LOOP
         RAISE NOTICE 'ALTER VIEW %', quote_ident(r.viewname);
         EXECUTE 'ALTER VIEW schema_pilotage.' || quote_ident(r.viewname) || ' OWNER TO pegaseuser';
    END LOOP;
END $$;
