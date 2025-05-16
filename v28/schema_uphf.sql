

/*
	****************************************************************
	TEMPORAIRE - correction de données
	****************************************************************
	*/


/* force le code sise pour cet objet mal renseigné dans la table cible */
-- UPDATE schema_gestion.cible SET niveau_sise='01' WHERE code_chemin LIKE '%B3LGEGCA-A1-REM';







/*
	****************************************************************
	REMPLISSAGE DE DONNÉES SPÉCIFIQUES UPHF
	****************************************************************
	*/




/* complète le niveau sise */
UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau_sise_objet_formation = '1'
WHERE objet_formation_ouvert_aux_ia = TRUE
    AND (libelle_court_objet_formation ILIKE '%BUT 1%'
    OR libelle_court_objet_formation ILIKE '%BUT1%'
    OR libelle_court_objet_formation ILIKE '%MASTER1%'
    OR libelle_court_objet_formation ILIKE '%MASTER 1%'
    OR libelle_court_objet_formation ILIKE '%M1%'
    OR libelle_court_objet_formation ILIKE '%LGE1%'
    OR libelle_court_objet_formation ILIKE '%CPES1%'
    OR libelle_court_objet_formation ILIKE 'ING3%'
    OR libelle_court_objet_formation ILIKE 'DEUST1%'
    OR libelle_court_objet_formation ILIKE 'PREPA%'
    OR libelle_court_objet_formation ILIKE 'DNA%'
    OR libelle_court_objet_formation ILIKE 'DNSEP1%'
    OR libelle_court_objet_formation ILIKE 'DNSEP2%'
    OR libelle_court_objet_formation ILIKE 'CAPACITE%1'
    OR libelle_court_objet_formation ILIKE 'DU %'
    OR libelle_court_objet_formation ILIKE 'IFMS%1'
    OR libelle_court_objet_formation ILIKE 'ECTS %'
    OR libelle_court_objet_formation ILIKE 'STAGIAIRES %'
    OR libelle_court_objet_formation ILIKE 'AUDITEUR %'
    OR libelle_court_objet_formation ILIKE 'HABILITATION %'
    OR libelle_court_objet_formation ILIKE '1ER CYCLE INGENIEUR % 1ERE ANNEE'
    OR cursus_formation_bcn='D'
    OR code_type_diplome='TYD020'
    OR code_type_diplome='TYD043'
    OR code_type_diplome='UPHF01'
    OR code_objet_formation= 'S3LGESHN-A1'
    );

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau_sise_objet_formation = '2'
WHERE  objet_formation_ouvert_aux_ia = TRUE
    AND (libelle_court_objet_formation ILIKE '%BUT 2%'
    OR libelle_court_objet_formation ILIKE '%BUT2%'
    OR libelle_court_objet_formation ILIKE '%MASTER2%'
    OR libelle_court_objet_formation ILIKE '%MASTER 2%'
    OR libelle_court_objet_formation ILIKE '%M2%'
    OR libelle_court_objet_formation ILIKE '%LGE2%'
    OR libelle_court_objet_formation ILIKE '%CPES2%'
    OR libelle_court_objet_formation ILIKE 'ING4%'
    OR libelle_court_objet_formation ILIKE 'DEUST2%'
    OR libelle_court_objet_formation ILIKE 'CAPACITE%2'
    OR libelle_court_objet_formation ILIKE 'IFMS%2'
    OR libelle_court_objet_formation ILIKE '1ER CYCLE INGENIEUR % 2E% ANNEE'
    );

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau_sise_objet_formation = '3'
WHERE  objet_formation_ouvert_aux_ia = TRUE
    AND (libelle_court_objet_formation ILIKE '%BUT 3%'
    OR libelle_court_objet_formation ILIKE '%BUT3%'
    OR libelle_court_objet_formation ILIKE '%LGE3%'
    OR libelle_court_objet_formation ILIKE '%CPES3%'
    OR libelle_court_objet_formation ILIKE 'ING5%'
    );
--DO $$ BEGIN RAISE NOTICE 'DONE : UPDATE schema_pilotage.odf_objet_formation_chemin OFC SET niveau_sise_objet_formation'; END; $$;



/* complète le cursus_formation_bcn (L, M, etc.) si pas rempli */
UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET cursus_formation_bcn = 'L'
WHERE objet_formation_ouvert_aux_ia = TRUE
    AND libelle_court_objet_formation ILIKE '%LGE%';
    
UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET cursus_formation_bcn = 'M'
WHERE objet_formation_ouvert_aux_ia = TRUE
    AND libelle_court_objet_formation ILIKE '%MASTER%';



/* complète le niveau de formation */
UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = 'L3' -- LP
WHERE  objet_formation_ouvert_aux_ia = TRUE 
    AND (code_type_diplome='TYD020');

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = 'D2' -- HDR
WHERE  objet_formation_ouvert_aux_ia = TRUE 
    AND (code_type_diplome='TYD182' OR libelle_court_objet_formation LIKE '%HABILITATION A DIRIGER DES RECHERCHES%');

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = NULL WHERE code_type_diplome='TYD038';

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = 'M2' -- DU MEEF
WHERE  objet_formation_ouvert_aux_ia = TRUE 
    AND (libelle_court_objet_formation LIKE 'DU MEEF%' OR libelle_court_objet_formation LIKE 'PREPA AVOCATS');

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = 'L3' -- Autres DU
WHERE  objet_formation_ouvert_aux_ia = TRUE AND niveau IS NULL
    AND (code_type_diplome='TYD038') AND libelle_court_objet_formation!='DIU HEES';

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = concat('L', niveau_sise_objet_formation) -- 1ER CYCLE INGENIEUR
WHERE  objet_formation_ouvert_aux_ia = TRUE 
    AND (code_type_diplome='TYD122')
    AND libelle_court_objet_formation LIKE '%1ER CYCLE INGENIEUR%';

UPDATE schema_pilotage.odf_objet_formation_chemin OFC
SET niveau = concat(cursus_formation_bcn, niveau_sise_objet_formation)
WHERE  objet_formation_ouvert_aux_ia = TRUE AND niveau IS NULL
    AND (cursus_formation_bcn IS NOT NULL AND niveau_sise_objet_formation IS NOT NULL);





/* complète les objets sous convention */
UPDATE schema_pilotage.odf_objet_formation_chemin
SET sous_convention = TRUE, sous_convention_etablissement = 'ICL'
WHERE id IN (
   SELECT OFC.id
   FROM schema_pilotage.odf_objet_formation_chemin OFC
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_FORMATION ON OFC_FORMATION.code_objet_formation = OFC.code_formation AND OFC_FORMATION.code_periode = OFC.code_periode
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_ANCETRE_IA ON OFC_ANCETRE_IA.id = OFC.id_ancetre_ouvert_aux_ia
   WHERE OFC.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
   AND (
       OFC_FORMATION.code_objet_formation LIKE '%-IC'
       OR OFC_FORMATION.code_objet_formation LIKE '%-ICL'
       OR OFC_FORMATION.libelle_court_objet_formation LIKE '% ICL'
       OR OFC_FORMATION.libelle_long_objet_formation LIKE '% ICL'
       
       OR OFC_ANCETRE_IA.code_objet_formation LIKE '%-IC'
       OR OFC_ANCETRE_IA.code_objet_formation LIKE '%-ICL'
       OR OFC_ANCETRE_IA.libelle_court_objet_formation LIKE '% ICL'
       OR OFC_ANCETRE_IA.libelle_long_objet_formation LIKE '% ICL'
   )
   ORDER BY OFC.chemin
);

UPDATE schema_pilotage.odf_objet_formation_chemin
SET sous_convention = TRUE, sous_convention_etablissement = 'CPGE'
WHERE id IN (
   SELECT OFC.id
   FROM schema_pilotage.odf_objet_formation_chemin OFC
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_FORMATION ON OFC_FORMATION.code_objet_formation = OFC.code_formation AND OFC_FORMATION.code_periode = OFC.code_periode
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_ANCETRE_IA ON OFC_ANCETRE_IA.id = OFC.id_ancetre_ouvert_aux_ia
   WHERE OFC.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
   AND (
       OFC_FORMATION.code_objet_formation LIKE '%-CP'
       OR OFC_FORMATION.libelle_court_objet_formation LIKE '% CPGE'
       OR OFC_FORMATION.libelle_long_objet_formation LIKE '% CPGE'
       
       OR OFC_ANCETRE_IA.code_objet_formation LIKE '%-CP'
       OR OFC_ANCETRE_IA.libelle_court_objet_formation LIKE '% CPGE'
       OR OFC_ANCETRE_IA.libelle_long_objet_formation LIKE '% CPGE'
   )
   ORDER BY OFC.chemin
);

UPDATE schema_pilotage.odf_objet_formation_chemin
SET sous_convention = TRUE, sous_convention_etablissement = 'IFSI'
WHERE id IN (
   SELECT OFC.id
   FROM schema_pilotage.odf_objet_formation_chemin OFC
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_FORMATION ON OFC_FORMATION.code_objet_formation = OFC.code_formation AND OFC_FORMATION.code_periode = OFC.code_periode
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_ANCETRE_IA ON OFC_ANCETRE_IA.id = OFC.id_ancetre_ouvert_aux_ia
   WHERE OFC.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
   AND (
       OFC_FORMATION.code_objet_formation LIKE 'I%'
       
       OR OFC_ANCETRE_IA.code_objet_formation LIKE 'I%'
   )
   ORDER BY OFC.chemin
);

UPDATE schema_pilotage.odf_objet_formation_chemin
SET sous_convention = TRUE, sous_convention_etablissement = 'MEEF'
WHERE id IN (
   SELECT OFC.id
   FROM schema_pilotage.odf_objet_formation_chemin OFC
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_FORMATION ON OFC_FORMATION.code_objet_formation = OFC.code_formation AND OFC_FORMATION.code_periode = OFC.code_periode
   LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_ANCETRE_IA ON OFC_ANCETRE_IA.id = OFC.id_ancetre_ouvert_aux_ia
   WHERE OFC.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
   AND (
       OFC_FORMATION.code_objet_formation LIKE 'M%'
       
       OR OFC_ANCETRE_IA.code_objet_formation LIKE 'M%'
   )
   ORDER BY OFC.chemin
);



/*
SELECT OFC_FORMATION.id, OFC_FORMATION.chemin, OFC_FORMATION.code_objet_formation, OFC_ANCETRE_IA.id, OFC_ANCETRE_IA.chemin, OFC_ANCETRE_IA.code_objet_formation, OFC.id, OFC.chemin, OFC.code_objet_formation
FROM schema_pilotage.odf_objet_formation_chemin OFC
LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_FORMATION ON OFC_FORMATION.code_objet_formation = OFC.code_formation AND OFC_FORMATION.code_periode = OFC.code_periode
LEFT JOIN schema_pilotage.odf_objet_formation_chemin OFC_ANCETRE_IA ON OFC_ANCETRE_IA.id = OFC.id_ancetre_ouvert_aux_ia
WHERE OFC.code_periode NOT IN ('PER-2014','PER-2015','PER-2016','PER-2017','PER-2018','PER-2019','PER-2020','PER-2021')
AND (
	OFC_FORMATION.code_objet_formation LIKE '%-IC'
	OR OFC_FORMATION.code_objet_formation LIKE '%-ICL'
	OR OFC_FORMATION.libelle_court_objet_formation LIKE '% ICL'
	OR OFC_FORMATION.libelle_long_objet_formation LIKE '% ICL'
	
	OR OFC_ANCETRE_IA.code_objet_formation LIKE '%-IC'
	OR OFC_ANCETRE_IA.code_objet_formation LIKE '%-ICL'
	OR OFC_ANCETRE_IA.libelle_court_objet_formation LIKE '% ICL'
	OR OFC_ANCETRE_IA.libelle_long_objet_formation LIKE '% ICL'
)
ORDER BY OFC.chemin;
*/

/*
SELECT *
FROM schema_pilotage.odf_objet_formation_chemin
WHERE sous_convention = TRUE
AND objet_formation_ouvert_aux_ia = TRUE
ORDER BY chemin;
*/





/*
	****************************************************************
	FORMATIONS NOUVELLE VERSION
	****************************************************************
	*/
	
/* formations avec type de public VT */
DROP TABLE IF EXISTS schema_uphf.formations_vt CASCADE;
CREATE TABLE schema_uphf.formations_vt AS   
SELECT  
    code_periode AS "pegase_code_periode",
    libelle_periode AS "pegase_libelle_periode",
    libelle_court_formation AS "pegase_libelle_formation",
    libelle_long_formation AS "pegase_libelle_long_formation",
    code_formation AS "pegase_code_formation",
    CASE  
		WHEN code_type_diplome IS NULL THEN 'UPHF01'
		ELSE code_type_diplome
	END AS "pegase_type_diplome",
    libelle_type_diplome AS "pegase_libelle_type_diplome",
    libelle_court_objet_formation AS "pegase_libelle_etape",
    libelle_long_objet_formation AS "pegase_libelle_long_etape",
    code_objet_formation AS "pegase_code_etape",
    cursus_formation_bcn AS "pegase_cursus_formation_bcn",
    niveau_sise_objet_formation AS "pegase_niveau_sise",
    NULL AS "pegase_calcul_niveau",
    NULL AS "manuel_niveau",
    niveau AS "pegase_niveau",
    niveau_formation_bcn AS "pegase_niveau_formation_bcn",
    'FI/FC/FA' AS "code_regime_inscription_vt",-- TODO CRIPV.code_vt AS "code_regime_inscription_vt",
    code_domaine_formation AS "pegase_code_domaine_formation",
    libelle_domaine_formation AS "pegase_libelle_domaine_formation",
    code_structure_objet_formation AS "pegase_code_structure",
    code_structure_externe_objet_formation AS "pegase_code_structure_externe",
    CMPA.apogee_code_etape AS "apogee_code_etape",
    CMPA.apogee_code_version AS "apogee_code_version",
    RAEC.libelle_etape AS "apogee_libelle_etape",
    RAEC.code_composante AS "apogee_code_composante",
    RAEC.libelle_composante AS "apogee_libelle_composante",
    NULL AS "sinaps_code_composante_manuel",
    RC."Code_SINAPS" AS "sinaps_code_composante_apogee",
	CASE
		WHEN code_objet_formation LIKE 'O8DOC%' THEN 'EDPHFV'
		ELSE 
			CASE
				WHEN code_structure_externe_objet_formation='' OR code_structure_externe_objet_formation IS NULL OR code_structure_externe_objet_formation NOT IN (SELECT "Code_SINAPS" FROM schema_uphf.ref_composantes) THEN RC."Code_SINAPS"
				ELSE code_structure_externe_objet_formation
			END
	END AS "sinaps_code_composante"
	
FROM schema_pilotage.odf_objet_formation_chemin F

LEFT JOIN schema_uphf.correspondance_manuelle_pegase_apogee CMPA ON CMPA.pegase_code_etape = F.code_objet_formation
LEFT JOIN schema_uphf.ref_apogee_etapes_composantes RAEC ON CMPA.apogee_code_etape = RAEC.code_etape AND CMPA.apogee_code_version = RAEC.code_version
-- TODO LEFT JOIN schema_mof.formation_regime_inscription FRI1 ON FRI1.id_formation = F.id_formation
-- TODO LEFT JOIN schema_uphf.correspondance_regime_inscription_pegase_vt CRIPV ON CRIPV.code_pegase = FRI1.code_regime_inscription
LEFT JOIN schema_uphf.ref_composantes RC ON RAEC.code_composante = RC."Code_APOGEE"

WHERE F.objet_formation_ouvert_aux_ia = TRUE

GROUP BY
    code_periode,
    libelle_periode,
    libelle_court_formation,
    libelle_long_formation,
    code_formation,
    code_type_diplome,
    libelle_type_diplome,
    libelle_court_objet_formation,
    libelle_long_objet_formation,
    code_objet_formation,
    cursus_formation_bcn,
    niveau_sise_objet_formation,
    niveau,
    niveau_formation_bcn,
    -- TODO CRIPV.code_vt,
    code_domaine_formation,
    libelle_domaine_formation,
    code_structure_objet_formation,
    code_structure_externe_objet_formation,
    CMPA.apogee_code_etape,
    CMPA.apogee_code_version,
    RAEC.libelle_etape,
    RAEC.code_composante,
    RAEC.libelle_composante,
    RC."Code_SINAPS"

ORDER BY code_periode,
	code_objet_formation
	--,
	-- TODO CRIPV.code_vt DESC
	;


/* formations avec type de public VT fusionne */
DROP TABLE IF EXISTS schema_uphf.formations CASCADE;
CREATE TABLE schema_uphf.formations AS   
SELECT  
   pegase_code_periode,
   pegase_libelle_periode,
   pegase_libelle_formation,
   pegase_libelle_long_formation,
   pegase_code_formation,
   pegase_type_diplome,
   pegase_libelle_type_diplome,
   pegase_libelle_etape,
   pegase_libelle_long_etape,
   F.pegase_code_etape,
   pegase_cursus_formation_bcn,
   pegase_niveau_sise,
   pegase_calcul_niveau,
   manuel_niveau,
   pegase_niveau,
   pegase_niveau_formation_bcn,
   string_agg(code_regime_inscription_vt, '/') AS "pegase_original_type_public",
   CMPTP.pegase_type_public AS manuel_type_public,
   CASE
           WHEN CMPTP.pegase_type_public IS NOT NULL AND CMPTP.pegase_type_public <> 'NC' THEN CMPTP.pegase_type_public
           ELSE string_agg(code_regime_inscription_vt, '/')
   END AS "pegase_type_public",
   pegase_code_domaine_formation,
   pegase_libelle_domaine_formation,
   pegase_code_structure,
   pegase_code_structure_externe,
   apogee_code_etape,
   apogee_code_version,
   apogee_libelle_etape,
   RC."Code_APOGEE" AS "apogee_code_composante",
   RC."Libelle_40" AS "apogee_libelle_composante",
   sinaps_code_composante_manuel,
   sinaps_code_composante_apogee,
   sinaps_code_composante,
   NULL AS "pegase_code_composante_correct",
   RC."Libelle_Web" AS "sinaps_libelle_composante"
    
FROM schema_uphf.formations_vt F

LEFT JOIN schema_uphf.correspondance_manuelle_pegase_type_public CMPTP ON CMPTP.pegase_code_etape = F.pegase_code_etape
LEFT JOIN schema_uphf.ref_composantes RC ON F.sinaps_code_composante = RC."Code_SINAPS"

GROUP BY
   pegase_code_periode,
   pegase_libelle_periode,
   pegase_libelle_formation,
   pegase_libelle_long_formation,
   pegase_code_formation,
   pegase_type_diplome,
   pegase_libelle_type_diplome,
   pegase_libelle_etape,
   pegase_libelle_long_etape,
   F.pegase_code_etape,
   pegase_cursus_formation_bcn,
   pegase_niveau_sise,
   pegase_calcul_niveau,
   manuel_niveau,
   pegase_niveau,
   pegase_niveau_formation_bcn,
   CMPTP.pegase_type_public,
   pegase_code_domaine_formation,
   pegase_libelle_domaine_formation,
   pegase_code_structure,
   pegase_code_structure_externe,
   apogee_code_etape,
   apogee_code_version,
   apogee_libelle_etape,
   RC."Code_APOGEE",
   RC."Libelle_40",
   sinaps_code_composante_manuel,
   sinaps_code_composante_apogee,
   sinaps_code_composante,
   pegase_code_composante_correct,
   sinaps_libelle_composante

ORDER BY pegase_code_periode, pegase_code_etape, "pegase_original_type_public";

DROP TABLE IF EXISTS schema_uphf.formations_vt CASCADE;

ALTER TABLE schema_uphf.formations OWNER TO pegaseuser;



	
	
	