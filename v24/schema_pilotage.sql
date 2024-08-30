-- ****************************************************************************************************************************
-- suppression des tables et des vues
-- ****************************************************************************************************************************
DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'schema_pilotage') LOOP
		RAISE NOTICE 'Supprime la TABLE %', quote_ident(r.tablename);
        EXECUTE 'DROP TABLE IF EXISTS schema_pilotage.' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT viewname FROM pg_views WHERE schemaname = 'schema_pilotage') LOOP
		RAISE NOTICE 'Supprime la VIEW %', quote_ident(r.viewname);
        EXECUTE 'DROP VIEW IF EXISTS schema_pilotage.' || quote_ident(r.viewname) || ' CASCADE';
    END LOOP;
END $$;

-- ****************************************************************************************************************************

/* table avec mails établissement */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel
(
    code_apprenant character varying(255) COLLATE pg_catalog."default",
    mail character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT etab_mail_institutionnel_pkey PRIMARY KEY (code_apprenant)
);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_mail_institutionnel'; END; $$;



/* table avec uid, mail établissement, etc. */
CREATE TABLE IF NOT EXISTS schema_pilotage.etab_apprenant
(
    id_apprenant character varying(255) COLLATE pg_catalog."default",
    uid character varying(50) COLLATE pg_catalog."default",
    mail character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT etab_apprenant_pkey PRIMARY KEY (id_apprenant)
);
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
);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE IF NOT EXISTS schema_pilotage.etab_structure_externe'; END; $$;




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
   FROM schema_ref.domaine_formation
   WHERE code_bcn IS NOT NULL;




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
  WHERE ((nom.code_nomenclature)::text = 'ModaliteEnseignement'::text);




CREATE TABLE schema_pilotage.ref_type_heure AS
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
    val.col1 AS equivalent_hetd
   FROM (schema_ref.valeurs_nomenclature val
     JOIN schema_ref.nomenclature nom ON ((val.id_nomenclature = nom.id_nomenclature)))
  WHERE ((nom.code_nomenclature)::text = 'TypeHeure'::text);




CREATE TABLE schema_pilotage.ref_finalite_formation AS
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
  WHERE ((nom.code_nomenclature)::text = 'FinaliteFormation'::text);




CREATE TABLE schema_pilotage.ref_demande_piece AS
 SELECT
    code AS "code_metier",
    libelle_affichage,
    description,
    temoin_primo,
    temoin_reins,
    mode_televersement,
    temoin_obligatoire,
    code_piece_a_fournir,
    date_debut_validite,
    date_fin_validite,
    priorite_affichage,
    temoin_livre,
    temoin_photo
   FROM schema_gestion.param_demande_piece;


--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE TABLE schema_pilotage.ref_xxxxxxxxxxxxxxxxx'; END; $$;



/* ************************************************************************** */
/* vues concernant l'offre de formation */


/* liste des formations */
CREATE TABLE schema_pilotage.odf_formation AS
SELECT 
    F.id,
	ESP.code AS "code_periode",
	ESP.libelle_long AS "libelle_periode",
    F.code,
    F.libelle_court,
    F.libelle_long,
	F.description,
    F.code_type_formation AS "code_type",
    RTF.libelle_court AS "libelle_type",
    F.code_type_diplome,
    RTD.libelle_long AS "libelle_type_diplome",
	F.code_diplome_sise,
	F.niveau_diplome_sise,
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
    NULL AS "code_structure_budgetaire",-- TODO F.code_structure_budgetaire,
    NULL AS "code_uai_structure_budgetaire",-- TODO F.code_uai_structure_budgetaire,
    NULL AS "code_referentiel_externe_structure_budgetaire",-- TODO F.code_referentiel_externe_structure_budgetaire,
    NULL AS "denomination_principale_structure_budgetaire",-- TODO F.denomination_principale_structure_budgetaire,
    NULL AS "code_tarification",-- TODO F.code_tarification,
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

WHERE F.type_objet_maquette = 'F'
	AND ESP.type_espace = 'P'
    AND CON.temoin_valide=TRUE
	
	--AND F.code='A3CCA-351-V1'
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
    OM.libelle_court,
    OM.libelle_long,
    OM.description,
	OM.code_diplome_sise,
	OM.niveau_diplome_sise,
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
    OM.niveau_diplome_sise as "niveau_sise",
    NULL AS "nb_inscriptions_autorisees",-- TODO OM.nb_inscriptions_autorisees,
    OM.coefficient,
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
CREATE INDEX odf_objet_formation_chemin_chemin_uuid_idx ON schema_pilotage.odf_objet_formation_chemin (chemin_uuid);
CREATE INDEX odf_objet_formation_chemin_chemin_idx ON schema_pilotage.odf_objet_formation_chemin (chemin);
CREATE INDEX odf_objet_formation_chemin_chemin_parent_idx ON schema_pilotage.odf_objet_formation_chemin (chemin_parent);
--DO $$ BEGIN RAISE NOTICE 'DONE : CREATE INDEX xxx ON schema_pilotage.odf_objet_formation_chemin'; END; $$;




/* calcule le chemin et chemin_parent */
DO $$ DECLARE
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

UPDATE schema_pilotage.odf_objet_formation_chemin SET chemin_parent = reverse(SUBSTRING(reverse(chemin), STRPOS(reverse(chemin), '>')+1, CHAR_LENGTH(reverse(chemin)))) WHERE STRPOS(chemin, '>')>0;



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
        UPDATE schema_pilotage.odf_objet_formation_chemin SET id_ancetre_ouvert_aux_ia = r.id, chemin_ancetre_ouvert_aux_ia = r.chemin WHERE r.id_objet_formation=ANY(chemin_uuid) AND objet_formation_ouvert_aux_ia = FALSE AND id_ancetre_ouvert_aux_ia IS NULL AND chemin_ancetre_ouvert_aux_ia IS NULL;
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
    OFC.id_formation,
	OFC.id_formation_porteuse AS "id_formation_porteuse_charge",
    FE.id_objet_maquette AS "id_objet_formation",
    FE.type_heure AS "code_format",
    RTH.libelle_court AS "libelle_court_format",
    RTH.libelle_long AS "libelle_long_format",
	
    CAST (RTH.equivalent_hetd AS NUMERIC),
	
	FE.volume_horaire,
	CAST (FE.volume_horaire/60/60 AS INTEGER) AS volume_horaire_heure,
	CAST (FE.volume_horaire - (FE.volume_horaire/60/60)*(60*60) AS INTEGER) AS volume_horaire_minute,
    FE.nombre_theorique_groupe AS "nombre_theorique_groupes",
    FE.seuil_dedoublement,
    FE.modalite AS "code_modalite",
    RME.libelle_court AS "libelle_court_modalite",
    RME.libelle_long AS "libelle_long_modalite"
	
FROM schema_odf.formats_enseignement FE,
	schema_pilotage.ref_modalite_enseignement RME,
	schema_pilotage.ref_type_heure RTH,
	schema_pilotage.odf_objet_formation_chemin OFC
	
WHERE  FE.modalite = RME.code_metier
AND FE.type_heure = RTH.code_metier
AND OFC.id_objet_formation = FE.id_objet_maquette;
    
    



/* ************************************************************************** */
/* vues concernant les inscriptions administratives */


/* ADMIS avec inscription en cours */
/* TODO DONE la modifier pour aller compléter les infos depuis ins_piste ! */
CREATE TABLE schema_pilotage.ins_admis AS
 SELECT admis.id AS "id",
	admis.numero_admis AS "numero_candidat",
    APP.id::varchar(255) AS "id_apprenant",
	CASE  
		WHEN APP.code_apprenant IS NOT NULL THEN APP.code_apprenant
		ELSE IPAPP.code_apprenant
	END AS "code_apprenant",
    admis.ine,
    admis.ine_statut AS "statut_ine",
	CASE  
		WHEN IPAPP.nom_famille IS NOT NULL THEN IPAPP.nom_famille
		ELSE admis.nom_naissance
	END AS "nom_famille",
	CASE  
		WHEN IPAPP.nom_usuel IS NOT NULL THEN IPAPP.nom_usuel
		ELSE admis.nom_usuel
	END AS "nom_usuel",
	CASE  
		WHEN IPAPP.prenom IS NOT NULL THEN IPAPP.prenom
		ELSE admis.prenom
	END AS "prenom",
	CASE  
		WHEN IPAPP.prenom2 IS NOT NULL THEN IPAPP.prenom2
		ELSE admis.prenom2
	END AS "prenom2",
	CASE  
		WHEN IPAPP.prenom3 IS NOT NULL THEN IPAPP.prenom3
		ELSE admis.prenom3
	END AS "prenom3",
	CASE  
		WHEN IPAPP.sexe IS NOT NULL THEN IPAPP.sexe
		ELSE admis.genre
	END AS "sexe",
    admis.date_naissance,
    admis.code_pays_naissance,
    P1.libelle_long AS "libelle_pays_naissance",
    admis.code_commune_naissance,
    schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune_naissance",
	IPAPP.libelle_commune_naissance_etranger,
    admis.code_nationalite,
    P2.libelle_long AS "libelle_nationalite",
    IPAPP.annee_obtention_bac,
    IPAPP.code_type_ou_serie_bac,
    IPAPP.code_mention_bac,
    IPAPP.type_etablissement_bac,
    IPAPP.code_pays_bac,
    IPAPP.code_departement_bac,
    IPAPP.code_etablissement_bac,
    IPAPP.etablissement_libre_bac,
    IPAPP.precisions_titre_dispense_bac,
    IPAPP.annee_entree_enseignement_superieur,
    IPAPP.annee_entree_universite,
    IPAPP.annee_entree_etablissement,
    IPAPP.code_categorie_socioprofessionnelle,
    IPAPP.code_quotite_travaillee,
    IPAPP.code_categorie_socioprofessionnelle_parent1,
    IPAPP.code_categorie_socioprofessionnelle_parent2,
    IPAPP.code_situation_familiale,
    IPAPP.nombre_enfants,
    IPAPP.code_situation_militaire,
    IPAPP.code_premiere_specialite_bac,
    IPAPP.code_deuxieme_specialite_bac,
    IPAPP.temoin_neo_bachelier,
    ADMS.statut AS "statut_admission",
	CASE  
		WHEN IPC.adresse_annuelle_code_pays IS NOT NULL THEN IPC.adresse_annuelle_code_pays
		ELSE admis.adresse_code_pays
	END AS "adresse_code_pays",
	CASE  
		WHEN IPC.adresse_annuelle_ligne1_ou_etage IS NOT NULL THEN IPC.adresse_annuelle_ligne1_ou_etage
		ELSE admis.adresse_ligne1_etage
	END AS "adresse_ligne1_etage",
	CASE  
		WHEN IPC.adresse_annuelle_ligne2_ou_batiment IS NOT NULL THEN IPC.adresse_annuelle_ligne2_ou_batiment
		ELSE admis.adresse_ligne2_batiment
	END AS "adresse_ligne2_batiment",
	CASE  
		WHEN IPC.adresse_annuelle_ligne3_ou_voie IS NOT NULL THEN IPC.adresse_annuelle_ligne3_ou_voie
		ELSE admis.adresse_ligne3_voie
	END AS "adresse_ligne3_voie",
	CASE  
		WHEN IPC.adresse_annuelle_ligne4_ou_complement IS NOT NULL THEN IPC.adresse_annuelle_ligne4_ou_complement
		ELSE admis.adresse_ligne4_complement
	END AS "adresse_ligne4_complement",
	CASE  
		WHEN IPC.adresse_annuelle_code_postal IS NOT NULL THEN IPC.adresse_annuelle_code_postal
		ELSE admis.adresse_code_postal
	END AS "adresse_code_postal",
	CASE  
		WHEN IPC.adresse_annuelle_code_commune IS NOT NULL THEN IPC.adresse_annuelle_code_commune
		ELSE admis.adresse_code_commune
	END AS "adresse_code_commune",
	CASE  
		WHEN IPC.adresse_annuelle_ligne5_etranger IS NOT NULL THEN IPC.adresse_annuelle_ligne5_etranger
		ELSE admis.adresse_ligne5_etranger
	END AS "adresse_ligne5_etranger",
    
    IPC.adresse_fixe_code_postal,
    IPC.adresse_fixe_code_commune,
    IPC.adresse_fixe_libelle_commune,
    IPC.adresse_fixe_ligne1_ou_etage,
    IPC.adresse_fixe_ligne2_ou_batiment,
    IPC.adresse_fixe_ligne3_ou_voie,
    IPC.adresse_fixe_ligne4_ou_complement,
    IPC.adresse_fixe_ligne5_etranger,
    IPC.adresse_fixe_code_pays,
    IPC.adresse_fixe_libelle_pays,

    IPC.adresse_annuelle_code_postal,
    IPC.adresse_annuelle_code_commune,
    IPC.adresse_annuelle_libelle_commune,
    IPC.adresse_annuelle_ligne1_ou_etage,
    IPC.adresse_annuelle_ligne2_ou_batiment,
    IPC.adresse_annuelle_ligne3_ou_voie,
    IPC.adresse_annuelle_ligne4_ou_complement,
    IPC.adresse_annuelle_ligne5_etranger,
    IPC.adresse_annuelle_code_pays,
    IPC.adresse_annuelle_libelle_pays,
    
	CASE  
		WHEN IPC.telephone_urgence IS NOT NULL THEN IPC.telephone_urgence
		ELSE admis.telephone1
	END AS "telephone1",
	CASE  
		WHEN IPC.telephone_perso IS NOT NULL THEN IPC.telephone_perso
		ELSE admis.telephone2
	END AS "telephone2",
	CASE  
		WHEN IPC.mail_perso IS NOT NULL THEN IPC.mail_perso
		ELSE admis.mail
	END AS "mail",
    admis.date_creation AS "date_de_creation",
    admis.date_modification AS "date_de_modification"

   FROM schema_inscription.admis
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = admis.code_pays_naissance
   LEFT JOIN schema_pilotage.ref_pays_nationalite P2 ON P2.code = admis.code_nationalite
   LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = admis.code_commune_naissance
   LEFT JOIN schema_inscription.admission ADMS ON ADMS.id_admis = admis.id
   LEFT JOIN schema_gestion.apprenant APP ON APP.ine = admis.ine
   LEFT JOIN schema_ins_piste.apprenant IPAPP ON (IPAPP.ine = admis.ine OR IPAPP.code_apprenant=APP.code_apprenant)
   LEFT JOIN schema_ins_piste.contacts IPC ON IPC.code_apprenant = IPAPP.code_apprenant
   
--   WHERE admis.ine = '233170970FF'
   
   GROUP BY admis.id,"numero_candidat",APP.id,APP.code_apprenant,IPAPP.code_apprenant,admis.ine,admis.ine_statut,IPAPP.nom_famille,admis.nom_naissance,
IPAPP.nom_usuel,admis.nom_usuel,IPAPP.prenom,admis.prenom,IPAPP.prenom2,admis.prenom2,IPAPP.prenom3,admis.prenom3,IPAPP.sexe,admis.genre,admis.date_naissance,admis.code_pays_naissance,"libelle_pays_naissance",admis.code_commune_naissance,schema_pilotage.ref_commune_insee.libelle_long,IPAPP.libelle_commune_naissance_etranger,
admis.code_nationalite,"libelle_nationalite",IPAPP.annee_obtention_bac,IPAPP.code_type_ou_serie_bac,IPAPP.code_mention_bac,IPAPP.type_etablissement_bac,IPAPP.code_pays_bac,IPAPP.code_departement_bac,IPAPP.code_etablissement_bac,IPAPP.etablissement_libre_bac,IPAPP.precisions_titre_dispense_bac,IPAPP.annee_entree_enseignement_superieur,IPAPP.annee_entree_universite,
IPAPP.annee_entree_etablissement,IPAPP.code_categorie_socioprofessionnelle,IPAPP.code_quotite_travaillee,IPAPP.code_categorie_socioprofessionnelle_parent1,IPAPP.code_categorie_socioprofessionnelle_parent2,IPAPP.code_situation_familiale,IPAPP.nombre_enfants,IPAPP.code_situation_militaire,IPAPP.code_premiere_specialite_bac,IPAPP.code_deuxieme_specialite_bac,
IPAPP.temoin_neo_bachelier,"statut_admission",IPC.adresse_fixe_code_postal,IPC.adresse_fixe_code_commune,IPC.adresse_fixe_libelle_commune,IPC.adresse_fixe_ligne1_ou_etage,IPC.adresse_fixe_ligne2_ou_batiment,IPC.adresse_fixe_ligne3_ou_voie,IPC.adresse_fixe_ligne4_ou_complement,
IPC.adresse_fixe_ligne5_etranger,IPC.adresse_fixe_code_pays,IPC.adresse_fixe_libelle_pays,IPC.adresse_annuelle_code_pays,adresse_code_pays,IPC.adresse_annuelle_ligne1_ou_etage,adresse_ligne1_etage,IPC.adresse_annuelle_ligne2_ou_batiment,adresse_ligne2_batiment,IPC.adresse_annuelle_ligne3_ou_voie,adresse_ligne3_voie,IPC.adresse_annuelle_ligne4_ou_complement,adresse_ligne4_complement,IPC.adresse_annuelle_code_postal,adresse_code_postal,
IPC.adresse_annuelle_code_commune,IPC.adresse_annuelle_libelle_pays,IPC.adresse_annuelle_libelle_commune,adresse_code_commune,IPC.adresse_annuelle_ligne5_etranger,adresse_ligne5_etranger,IPC.telephone_urgence,telephone1,IPC.telephone_perso,telephone2,IPC.mail_perso,mail,"date_de_creation","date_de_modification";
   
   


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
		ELSE ins_admis.id::varchar(255)
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
    libelle_commune_naissance_etranger,
    code_nationalite,
    libelle_nationalite,
    NULL AS "code_nationalite2",
    NULL AS "libelle_nationalite2",
    annee_obtention_bac,
    code_type_ou_serie_bac,
    ref_serie_bac.libelle_long AS "libelle_type_ou_serie_bac",
    code_mention_bac,
    schema_pilotage.ref_mention_bac.libelle_long AS "libelle_mention_bac",
    type_etablissement_bac,
    code_pays_bac,
    P4.libelle_long AS "libelle_pays_bac",
    code_departement_bac,
    UPPER(D.libelle_affichage) AS "libelle_departement_bac",
    code_etablissement_bac,
    UPPER(EF.libelle_affichage) AS "libelle_etablissement_bac",
    etablissement_libre_bac,
    NULL AS "precision_titre_dispense_bac",
    annee_entree_enseignement_superieur,
    annee_entree_universite,
    annee_entree_etablissement,
    code_categorie_socioprofessionnelle,
    CSP1.libelle_long AS "libelle_categorie_socioprofessionnelle",
    code_quotite_travaillee,
    QA.libelle_long AS "libelle_quotite_travaillee",
    code_categorie_socioprofessionnelle_parent1,
    CSP2.libelle_long AS "libelle_socioprofessionnelle_parent1",
    code_categorie_socioprofessionnelle_parent2,
    CSP3.libelle_long AS "libelle_socioprofessionnelle_parent2",
    code_situation_familiale,
    SF.libelle_long AS "libelle_situation_familiale",
    nombre_enfants,
    code_situation_militaire,
    SM.libelle_long AS "libelle_situation_militaire",
    code_premiere_specialite_bac,
    SP1.libelle_long AS "libelle_premiere_specialite_bac",
    code_deuxieme_specialite_bac,
    SP2.libelle_long AS "libelle_deuxieme_specialite_bac",
    date_de_creation,
    date_de_modification

   FROM schema_pilotage.ins_admis
   
   LEFT JOIN schema_pilotage.ref_serie_bac ON schema_pilotage.ref_serie_bac.code = ins_admis.code_type_ou_serie_bac
   LEFT JOIN schema_pilotage.ref_mention_bac ON schema_pilotage.ref_mention_bac.code_metier = ins_admis.code_mention_bac
   LEFT JOIN schema_pilotage.ref_pays_nationalite P4 ON P4.code = ins_admis.code_pays_bac
   LEFT JOIN schema_pilotage.ref_departement D ON D.code = ins_admis.code_departement_bac
   LEFT JOIN schema_pilotage.ref_etablissement_francais EF ON EF.code = ins_admis.code_etablissement_bac
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP1 ON CSP1.code = ins_admis.code_categorie_socioprofessionnelle
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP2 ON CSP2.code = ins_admis.code_categorie_socioprofessionnelle_parent1
   LEFT JOIN schema_pilotage.ref_categorie_socioprofessionnelle CSP3 ON CSP3.code = ins_admis.code_categorie_socioprofessionnelle_parent2
   LEFT JOIN schema_pilotage.ref_situation_militaire SM ON SM.code_metier = ins_admis.code_situation_militaire
   LEFT JOIN schema_pilotage.ref_situation_familiale SF ON SF.code_metier = ins_admis.code_situation_familiale
   LEFT JOIN schema_pilotage.ref_quotite_activite QA ON QA.code_metier = ins_admis.code_quotite_travaillee
   LEFT JOIN schema_pilotage.ref_specialites_bac SP1 ON SP1.code_metier = ins_admis.code_premiere_specialite_bac
   LEFT JOIN schema_pilotage.ref_specialites_bac SP2 ON SP2.code_metier = ins_admis.code_deuxieme_specialite_bac
   
   WHERE (
      --statut_admission= 'AU' OR temoin_neo_bachelier IS NOT NULL)
      --AND code_apprenant NOT IN (SELECT code_apprenant FROM schema_gestion.apprenant)
      code_apprenant IS NULL OR code_apprenant NOT IN (SELECT code_apprenant FROM schema_gestion.apprenant)
   )
   );



/* TODO DONE TESTER la modifier pour aller compléter les infos depuis ins_piste ! */
CREATE TABLE schema_pilotage.ins_bourse_aide_financiere AS
 (SELECT bourse_ou_aide_financiere.id_inscription::varchar(255),
    bourse_ou_aide_financiere.code,
    bourse_ou_aide_financiere.code_bcn,
    /*bourse_ou_aide_financiere.libelle_court,
    bourse_ou_aide_financiere.libelle_long,*/
    BAF.libelle_court,
    BAF.libelle_long,
    '' AS type
   FROM schema_gestion.bourse_ou_aide_financiere
   LEFT JOIN schema_pilotage.ref_bourse_aide_financiere BAF ON BAF.code_metier=bourse_ou_aide_financiere.code)
   
   UNION
   
   (SELECT bourse_ou_aide_financiere.id_inscription::varchar(255),
    bourse_ou_aide_financiere.code,
    bourse_ou_aide_financiere.code_bcn,
    /*bourse_ou_aide_financiere.libelle_court,
    bourse_ou_aide_financiere.libelle_long,*/
    BAF.libelle_court,
    BAF.libelle_long,
    '' AS type
   FROM schema_ins_piste.bourse_ou_aide_financiere
   LEFT JOIN schema_pilotage.ref_bourse_aide_financiere BAF ON BAF.code_metier=bourse_ou_aide_financiere.code)
   ;





/* TODO DONE TESTER la modifier pour aller compléter les infos depuis ins_piste ! */
CREATE TABLE schema_pilotage.ins_amenagement_specifique AS
 (SELECT amenagement_specifique.id_inscription::varchar(255),
    amenagement_specifique.code,
    RSE.libelle_court,
    RSE.libelle_long
   FROM schema_gestion.amenagement_specifique
   LEFT JOIN schema_pilotage.ref_regime_special_etudes RSE ON RSE.code_metier=amenagement_specifique.code)
   
   UNION

 (SELECT amenagement_specifique.id_inscription::varchar(255),
    amenagement_specifique.code,
    RSE.libelle_court,
    RSE.libelle_long
   FROM schema_ins_piste.amenagement_specifique
   LEFT JOIN schema_pilotage.ref_regime_special_etudes RSE ON RSE.code_metier=amenagement_specifique.code)
   ;



/* TODO DONE TESTER la modifier pour aller compléter les infos depuis ins_piste ! */
CREATE TABLE schema_pilotage.ins_profil_specifique AS
 (SELECT profil_specifique.id_inscription::varchar(255),
    profil_specifique.code,
    PRF.libelle_court,
    PRF.libelle_long
   FROM schema_gestion.profil_specifique
   LEFT JOIN schema_pilotage.ref_profil_exonerant PRF ON PRF.code_metier=profil_specifique.code)
   
   UNION

 (SELECT profil_specifique.id_inscription::varchar(255),
    profil_specifique.code,
    PRF.libelle_court,
    PRF.libelle_long
   FROM schema_ins_piste.profil_specifique
   LEFT JOIN schema_pilotage.ref_profil_exonerant PRF ON PRF.code_metier=profil_specifique.code)
   ;







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
	
	WHERE adresse_code_postal IS NOT NULL OR adresse_code_commune IS NOT NULL OR adresse_ligne1_etage IS NOT NULL OR adresse_ligne2_batiment IS NOT NULL OR adresse_ligne3_voie IS NOT NULL OR adresse_ligne4_complement IS NOT NULL OR adresse_ligne5_etranger IS NOT NULL OR adresse_code_pays IS NOT NULL)
	
UNION

(SELECT id::varchar(255) AS "id_apprenant",
	'ADR-002' AS "id_demande",
	'CDC001' AS "type",
    'ADRESSE POSTALE' AS "libelle_type",
	NULL AS "proprietaire",
	NULL AS "mail",
	NULL AS "telephone",
	adresse_annuelle_code_postal AS "code_postal",
	adresse_annuelle_code_commune AS "code_commune",
	schema_pilotage.ref_commune_insee.libelle_long AS "libelle_commune",
	adresse_annuelle_ligne1_ou_etage AS "ligne1_ou_etage",
	adresse_annuelle_ligne2_ou_batiment AS "ligne2_ou_batiment",
	adresse_annuelle_ligne3_ou_voie AS "ligne3_ou_voie",
	adresse_annuelle_ligne4_ou_complement AS "ligne4_ou_complement",
	adresse_annuelle_ligne5_etranger AS "ligne5_etranger",
	adresse_annuelle_code_pays AS "code_pays",
	P1.libelle_long AS "libelle_pays"
	
	FROM schema_pilotage.ins_admis
	
	LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = ins_admis.adresse_annuelle_code_pays
	LEFT JOIN schema_pilotage.ref_commune_insee ON schema_pilotage.ref_commune_insee.code_insee = ins_admis.adresse_annuelle_code_commune
	
	WHERE adresse_annuelle_code_postal IS NOT NULL OR adresse_annuelle_code_commune IS NOT NULL OR adresse_annuelle_ligne1_ou_etage IS NOT NULL OR adresse_annuelle_ligne2_ou_batiment IS NOT NULL OR adresse_annuelle_ligne3_ou_voie IS NOT NULL OR adresse_annuelle_ligne4_ou_complement IS NOT NULL OR adresse_annuelle_ligne5_etranger IS NOT NULL OR adresse_annuelle_code_pays IS NOT NULL);

   
   




CREATE VIEW schema_pilotage.ins_contacts AS
 SELECT ins_contact.id_apprenant,
    ETAB.mail AS "mail_etab",
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
    max(libelle_pays) filter (where id_demande = 'ADR-002') as "adresse_annuelle_libelle_pays"

   FROM schema_pilotage.ins_contact
   LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.id = ins_contact.id_apprenant
   LEFT JOIN schema_pilotage.etab_apprenant ETAB ON ETAB.id_apprenant = APP.id

   GROUP BY ins_contact.id_apprenant, ETAB.uid, ETAB.mail;


   
   
   
   



/* inscriptions validées */
CREATE TABLE schema_pilotage.ins_inscription_validee AS
 SELECT inscription.id::varchar(255),
    OOFC.id AS "id_objet_formation_chemin",
    inscription.id_apprenant::varchar(255),
    OOFC.code_periode,
    OOFC.libelle_periode,
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
   
   WHERE inscription.statut_inscription='V'
   
   ORDER BY code_periode, inscription.id;
   
   
   
/* inscriptions validées */
CREATE TABLE schema_pilotage.ins_inscription_annulee AS
 SELECT inscription.id::varchar(255),
    OOFC.id AS "id_objet_formation_chemin",
    inscription.id_apprenant::varchar(255),
    OOFC.code_periode,
    OOFC.libelle_periode,
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
   
   WHERE inscription.statut_inscription='A'
   
   ORDER BY code_periode, inscription.id;



/* admissions */
CREATE TABLE schema_pilotage.ins_admission AS
 SELECT admission.id::varchar(255),
    OOFC.id AS "id_objet_formation_chemin",
    admission.id_admis AS "id_admis",
	CASE  
		WHEN AD.id_apprenant IS NOT NULL THEN AD.id_apprenant::varchar(255)
		ELSE AD.id::varchar(255)
	END AS "id_apprenant",
	
	CASE  
		WHEN INSV.id IS NOT NULL THEN INSV.id
		WHEN INSA.id IS NOT NULL THEN INSA.id
		ELSE NULL
	END AS "id_inscription",
    OOFC.code_periode,
    OOFC.libelle_periode,
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
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.code_objet_formation = admission.code_cible AND OOFC.code_periode = admission.code_periode
   LEFT JOIN schema_pilotage.ins_inscription_validee INSV ON INSV.id_objet_formation_chemin = OOFC.id AND INSV.id_apprenant = AD.id_apprenant
   LEFT JOIN schema_pilotage.ins_inscription_annulee INSA ON INSA.id_objet_formation_chemin = OOFC.id AND INSA.id_apprenant = AD.id_apprenant
   
   WHERE AD.id_apprenant IS NOT NULL OR AD.id IS NOT NULL
   GROUP BY admission.id, OOFC.id, AD.id_apprenant, AD.id, INSV.id, INSA.id, OOFC.code_periode, OOFC.libelle_periode, OOFC.code_objet_formation, OOFC.libelle_court_objet_formation, admission.origine_admission, AD.numero_candidat, admission.voie_admission, admission.annee_concours, admission.statut, AD.date_de_creation, AD.date_de_modification
   ORDER BY code_periode, admission.id;




/* inscriptions en cours */
/* TODO DONE TESTER */
CREATE TABLE schema_pilotage.ins_inscription_en_cours AS
 SELECT
    inscription.id::varchar(255),
    inscription.code_apprenant,
	ADM.id_apprenant::varchar(255) AS id_apprenant,
    statut_inscription,
    statut_paiement,
    statut_pieces,
    code_structure,
    inscription.code_periode,
	OOFC.libelle_periode,
    inscription.code_objet_formation,
	OOFC.id AS "id_objet_formation_chemin",
	OOFC.libelle_court_objet_formation AS "libelle_objet_formation",	
    origine,
    numero_cvec,
    admission_voie,
    admission_annee_concours::integer,
    admission_concours,
    admission_rang_concours::integer,
    admission_annee_precedente::integer,
    admission_type_classe_preparatoire,
    admission_puissance_classe_preparatoire,
    admission_code_pays,
    admission_code_etablissement,
    cesure,
    mobilite,
    temoin_souhait_amenagement,
    admission_temoin_classe_prepa::boolean,
    admission_type_etablissement_precedent,
    admission_departement_etablissement_precedent,
    admission_code_etablissement_etranger,
    annee_precedente::integer,
    situation_annee_precedente_code,
	SAP.libelle_long AS "libelle_situation_annee_precedente",
    code_regime_inscription,
	RI.libelle_long AS "libelle_regime_inscription",
    inscription.date_creation::timestamp,
    inscription.date_modification::timestamp,
    annee_obtention_dernier_diplome::integer,
    code_type_dernier_diplome_obtenu,
	DDO.libelle_long AS "libelle_type_dernier_diplome_obtenu",
    situation_annee_precedente_code_bcn,
    date_contexte_situation_annee_precedente,
    situation_annee_precedente_libelle_affichage,
    inscription.numero_candidat,
    temoin_principale,
    date_contexte_admission_concours,
    date_contexte_admission_type_classe_preparatoire,
    date_contexte_etablissement_precedent,
    date_contexte_code_regime_inscription,
    date_contexte_type_dernier_diplome_obtenu,
    date_inscription,
    ecole_doctorale_code,
	ED.libelle_long AS "libelle_ecole_doctorale",
    date_contexte_ecole_doctorale,
    filiere_code,
	CUP.libelle_long AS "libelle_filiere",
    date_contexte_filiere,
    temoin_convention_etablissement,
    programme_echange_code,
	ECH.libelle_long AS "libelle_programme_echange",
    date_contexte_programme_echange,
    programme_echange_pays_code,
	P1.libelle_long AS "libelle_programme_echange_pays",
    temoin_enseignement_distance_depuis_france,
    contexte_inscription,
    inscription.temoin_neo_bachelier,
    paiement_reference
    
   FROM schema_ins_piste.inscription
   
   LEFT JOIN schema_ins_piste.apprenant IPAPP ON IPAPP.code_apprenant = inscription.code_apprenant
   LEFT JOIN schema_pilotage.ins_admis ADM ON ADM.ine = IPAPP.ine
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.code_objet_formation = inscription.code_objet_formation AND OOFC.code_periode = inscription.code_periode
   LEFT JOIN schema_pilotage.ref_regime_inscription RI ON RI.code = inscription.code_regime_inscription  
   LEFT JOIN schema_pilotage.ref_situation_annee_precedente SAP ON SAP.code_metier = inscription.situation_annee_precedente_code
   LEFT JOIN schema_pilotage.ref_type_dernier_diplome_obtenu DDO ON DDO.code_metier = inscription.code_type_dernier_diplome_obtenu
   LEFT JOIN schema_pilotage.ref_ecole_doctorale ED ON ED.code_metier = inscription.ecole_doctorale_code
   LEFT JOIN schema_pilotage.ref_cursus_parallele CUP ON CUP.code_metier = inscription.filiere_code
   LEFT JOIN schema_pilotage.ref_programme_echange ECH ON ECH.code_metier = inscription.programme_echange_code
   LEFT JOIN schema_pilotage.ref_pays_nationalite P1 ON P1.code = inscription.programme_echange_pays_code
   
   ORDER BY code_periode, inscription.id;



/* TODO INSCRIPTIONS en cours, annulees ou validees */
CREATE TABLE schema_pilotage.ins_inscription AS
   (SELECT * FROM schema_pilotage.ins_inscription_validee)
   
   UNION
   
   (SELECT * FROM schema_pilotage.ins_inscription_annulee)
   
   UNION

   (SELECT id,
    id_objet_formation_chemin,
	id_apprenant::varchar(255),
    code_periode,
    libelle_periode,
    code_objet_formation,
    libelle_objet_formation,
    origine,
    contexte_inscription,
	numero_candidat,
	NULL AS "date_inscription",
	statut_inscription,
    statut_paiement,
    statut_pieces,
    code_regime_inscription,
    libelle_regime_inscription,
    numero_cvec,
    temoin_principale,
    cesure,
    mobilite,
    temoin_souhait_amenagement AS "souhait_amenagement",
    admission_voie,
    admission_annee_concours,
    admission_concours,
    admission_rang_concours,
    admission_annee_precedente,
    admission_type_classe_preparatoire,
    admission_puissance_classe_preparatoire,
    NULL AS "admission_pays_etablissement_precedent",
    NULL AS "admission_etablissement_precedent",
    admission_temoin_classe_prepa,
    admission_type_etablissement_precedent,
    admission_departement_etablissement_precedent,
    NULL AS "admission_etablissement_precedent_etranger",
    annee_precedente,
    situation_annee_precedente_code AS "code_situation_annee_precedente",
    libelle_situation_annee_precedente,
    annee_obtention_dernier_diplome,
    code_type_dernier_diplome_obtenu,
    libelle_type_dernier_diplome_obtenu,
    NULL AS "motif_annulation",
    NULL AS "avec_remboursement",
    situation_annee_precedente_code_bcn,
    situation_annee_precedente_libelle_affichage,
    ecole_doctorale_code AS "code_ecole_doctorale",
    libelle_ecole_doctorale,
    filiere_code AS "code_filiere",
    libelle_filiere,
    temoin_convention_etablissement,
    programme_echange_code AS "code_programme_echange",
    libelle_programme_echange,
    programme_echange_pays_code AS "code_programme_echange_pays",
    libelle_programme_echange_pays,
    temoin_enseignement_distance_depuis_france,
    date_creation AS "date_de_creation",
    date_modification AS "date_de_modification"

   FROM schema_pilotage.ins_inscription_en_cours)

   /*(SELECT id,
    id_objet_formation_chemin,
	id_apprenant,
    code_periode,
    libelle_periode,
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
   AND ins_admission.id_inscription IS NULL)*/
   
   
   ORDER BY code_periode, id;






CREATE TABLE schema_pilotage.ins_inscription_en_cours_pieces AS
    SELECT
        DP.id_inscription,
        DP.code,
		RDP.libelle_affichage AS "libelle",
        DP.obligatoire,
        DP.temoin_photo,
        DP.temoin_primo,
        DP.temoin_reins,
        DP.statut_piece
    FROM schema_ins_piste.demande_piece DP
	LEFT JOIN schema_pilotage.ref_demande_piece RDP ON RDP.code_metier = DP.code
	ORDER BY DP.id_inscription,DP.code;
   
   
   
    
CREATE TABLE schema_pilotage.ins_inscription_en_cours_paiements AS
    SELECT
        P.id,
		IEC.id AS "id_inscription",
        P.montant,
		P.date_heure,
		P.paiement_confirme,
		P.paiement_manuel_valide
		
    FROM schema_ins_piste.paiements P
	LEFT JOIN schema_pilotage.ins_inscription_en_cours IEC ON IEC.paiement_reference = P.id
	WHERE IEC.id IS NOT NULL;
   
   
   
    
CREATE TABLE schema_pilotage.ins_inscription_en_cours_paiements_paybox AS
    SELECT
        id_paiement,
        P.montant,
        P.date_heure,
        echeance1_montant,
        echeance1_date_recouvrement,
        echeance2_montant,
        echeance2_date_recouvrement,
        echeance3_montant,
        echeance3_date_recouvrement,
        echeance4_montant,
        echeance4_date_recouvrement,
        echeance5_montant,
        echeance5_date_recouvrement,
		reponse_paybox_code,
		reponse_paybox_transaction,
		reponse_paybox_autorisation,
		reference_paybox,
		identifiant_compte
		
    FROM schema_ins_piste.paiements_paybox P
	LEFT JOIN schema_pilotage.ins_inscription_en_cours_paiements IEP ON IEP.id = P.id_paiement
	WHERE P.id_paiement IS NOT NULL;
    
    
    


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
    OOFC.id AS "id_objet_formation_chemin",
    OOFC.code_objet_formation AS "code_objet_formation",
    OOFC.libelle_court_objet_formation AS "libelle_objet_formation",
    F.code_periode,
    F.formation_ref AS "formation_tarification_id",
    F.statut,
    F.temoin_annulee AS "annulee"

   FROM schema_pai.facture F
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OOFC ON OOFC.chemin = F.code_chemin AND OOFC.code_periode = F.code_periode
   LEFT JOIN schema_pilotage.ins_apprenant APP ON APP.code_apprenant = F.code_apprenant
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
   LEFT JOIN schema_pilotage.pai_facture F ON F.id = LF.id_facture;
   
   
   
   


CREATE TABLE schema_pilotage.pai_formation_tarification AS
 SELECT F.id,
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
	RFF.libelle_court AS "diplome_type_finalite_formation_libelle_court",
	RFF.libelle_long AS "diplome_type_finalite_formation_libelle_long",
	RFF.libelle_affichage AS "diplome_type_finalite_formation_libelle_affichage",
	--D.date_contexte AS "diplome_date_contexte",
	D.libelle_court AS "diplome_libelle_court",
	D.intitule AS "diplome_intitule",
	--D.validite AS "diplome_validite",
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
LEFT JOIN schema_pilotage.ref_finalite_formation RFF ON RFF.code_metier = D.type_finalite_formation_code
LEFT JOIN schema_coc.diplome_lien_objet_maquette DLOM ON DLOM.id_diplome = D.id
LEFT JOIN schema_coc.apprenant_diplome_parchemin PAR ON PAR.id_apprenant_diplome = AD.id
LEFT JOIN schema_coc.parametrage_parchemin PPAR ON PPAR.id_diplome = D.id
LEFT JOIN schema_coc.modele M ON M.id = PPAR.id_modele

GROUP BY APP.id,APP.code_apprenant,P.code,P.libelle_long,DLOM.code_objet_maquette,AD.id_diplome,AD.temoin_annulation_autorisation_impossible,AD.code_mention,AD.libelle_court_mention,AD.libelle_long_mention,AD.libelle_affichage_mention,AD.date_consommation_referentiel,
AD.date_autorisation,AD.utilisateur_autorisation,AD.date_annulation_apres_edition,AD.utilisateur_annulation_apres_edition,AD.motif_annulation_apres_edition,D.code_structure_etablissement,D.code,D.version,D.type_finalite_formation_code,RFF.libelle_court,RFF.libelle_long,RFF.libelle_affichage,
--D.date_contexte,
D.libelle_court,D.intitule,
--D.validite,
D.temoin_actif,D.etat,PAR.date_edition,PAR.numero_edition,PAR.date_signature_recteur,PAR.libelle_parcours_type_original,
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
