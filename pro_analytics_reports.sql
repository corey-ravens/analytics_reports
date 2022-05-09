


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

v1 is just a work file with lots of info, you can dump it
v2 is when you start adding structure to the tables
v3 is when you start adding in report_id and evaluation_id dynamically
v4 is the almost finalized version where dunamic ids are done at the end, and added into Analytics tables
v5 is just a slight tweak on v4, where you are manually inserting grades and summaries because those auto tables aren't ready yet. Can loook back at v4 once those are done.
v6 adds burst.
v7 adds sorting position alignment by snap count high to low.
V8 updates the new skill ids
v9 orders positions from most to least played
v10 adds skill codes
v11 adds model grades
v12
v13 adds ss and fs 
v14 fills in blank grades for players who don't have enough snaps to get one
v15 fills in the blank grade text with a statement.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(1)


Create a table with all the positions a player played in a season. You need the overall position along with all the percentages (for the alignment field).

Defense and offense positions are kept in different tables, so do defense then append offense to it.

Order the positions played from most to least so they look good in the alignment variable.

Since you need a position to do a report, make this table the basis for the reports and evaluations to follow, so everything can join together.


OUTPUT TABLES:
#temp_season_positions

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_season_positions_all exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions_all') IS NOT NULL
	DROP TABLE #temp_season_positions_all

	SELECT pl.id AS bane_player_id
		,nfl_player_id
		,season
		,season_type_adjusted
		,CASE WHEN position_blt IN ('IB','MIKE','WILL') AND po.translation = 'DS' THEN 'DS'
			ELSE position_blt
		END AS position_blt
		,CASE WHEN position_blt IN ('NT','DT3T') THEN 'DT'
			WHEN position_blt IN ('OB34','RUSH','SAM','DE43') THEN 'EDGE'
			WHEN position_blt IN ('IB','MIKE','WILL') AND po.translation = 'DS' THEN 'DS'
			WHEN position_blt IN ('IB','MIKE','WILL') THEN 'IB'
			--WHEN position_blt IN ('CB','NB','FS','SS','DS') THEN 'DB'
			WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS') THEN 'DS'
			WHEN position_blt IN ('LOT','LOG','OC','ROG','ROT') THEN 'OL'
			ELSE position_blt
		END AS position_group_blt
		,snap_count_all
		,snap_count_nt
		,snap_count_dt3t
		,snap_count_de5t
		,snap_count_de43
		,snap_count_rush
		,snap_count_sam
		--,snap_count_ob34
		,snap_count_mike
		,snap_count_will
		--,snap_count_ib
		,snap_count_cb
		,snap_count_nb
		--,snap_count_ds
		,snap_count_fs
		,snap_count_ss
		,NULL AS snap_count_qb
		,NULL AS snap_count_rb
		,NULL AS snap_count_fb
		,NULL AS snap_count_wide
		,NULL AS snap_count_te
		,NULL AS snap_count_slot
		,NULL AS snap_count_lot
		,NULL AS snap_count_log
		,NULL AS snap_count_oc
		,NULL AS snap_count_rog
		,NULL AS snap_count_rot
	INTO #temp_season_positions_all
	FROM Analytics.dbo.analysis_players_season_position_defense de
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON de.nfl_player_id = pl.nfl_id
		AND pl.is_deleted = 0
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON pl.position_id = po.id
	WHERE po.[team] = 'defense'
		AND defense_type = 'ALL'
		AND snap_count_all > 0


	INSERT INTO #temp_season_positions_all
	SELECT pl.id AS bane_player_id
		,nfl_player_id
		,season
		,season_type_adjusted
		,position_blt
		,CASE WHEN position_blt IN ('NT','DT3T') THEN 'DT'
			WHEN position_blt IN ('OB34','RUSH','SAM','DE43') THEN 'EDGE'
			WHEN position_blt IN ('IB','MIKE','WILL') AND po.translation = 'DS' THEN 'DS'
			WHEN position_blt IN ('IB','MIKE','WILL') THEN 'IB'
			--WHEN position_blt IN ('CB','NB','FS','SS','DS') THEN 'DB'
			WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS') THEN 'DS'
			WHEN position_blt IN ('LOT','LOG','OC','ROG','ROT') THEN 'OL'
			ELSE position_blt
		END AS position_group_blt
		,snap_count_all
		,NULL AS snap_count_nt
		,NULL AS snap_count_dt3t
		,NULL AS snap_count_de5t
		,NULL AS snap_count_de43
		,NULL AS snap_count_rush
		,NULL AS snap_count_sam
		--,NULL AS snap_count_ob34
		,NULL AS snap_count_mike
		,NULL AS snap_count_will
		--,NULL AS snap_count_ib
		,NULL AS snap_count_cb
		,NULL AS snap_count_nb
		--,NULL AS snap_count_ds
		,NULL AS snap_count_fs
		,NULL AS snap_count_ss
		,snap_count_qb
		,snap_count_rb
		,snap_count_fb
		,snap_count_wide
		,snap_count_te
		,snap_count_slot
		,snap_count_lot
		,snap_count_log
		,snap_count_oc
		,snap_count_rog
		,snap_count_rot
	FROM Analytics.dbo.analysis_players_season_position_offense de
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON de.nfl_player_id = pl.nfl_id
		AND pl.is_deleted = 0
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON pl.position_id = po.id
	WHERE po.[team] = 'offense'
		AND snap_count_all > 0


-- Check if #temp_season_positions_unpivot exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions_unpivot') IS NOT NULL
		DROP TABLE #temp_season_positions_unpivot

	SELECT bane_player_id
		,season
		,season_type_adjusted
		,CAST(UPPER(REPLACE(position_name,'snap_count_','')) AS NVARCHAR(4)) AS position_snaps
		,value AS snap_count
		,RANK() OVER (PARTITION BY bane_player_id, season, season_type_adjusted ORDER BY value DESC) AS position_rank
	INTO #temp_season_positions_unpivot
	FROM #temp_season_positions_all
	UNPIVOT (value FOR position_name IN (snap_count_nt
										,snap_count_dt3t
										,snap_count_de5t
										,snap_count_de43
										,snap_count_rush
										,snap_count_sam
										--,snap_count_ob34
										,snap_count_mike
										,snap_count_will
										--,snap_count_ib
										,snap_count_cb
										,snap_count_nb
										--,snap_count_ds
										,snap_count_ss
										,snap_count_fs
										,snap_count_qb
										,snap_count_rb
										,snap_count_fb
										,snap_count_wide
										,snap_count_te
										,snap_count_slot
										,snap_count_lot
										,snap_count_log
										,snap_count_oc
										,snap_count_rog
										,snap_count_rot
							)) AS me


-- Check if #temp_season_positions_display exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions_display') IS NOT NULL
		DROP TABLE #temp_season_positions_display

	SELECT up.*
		,CONCAT(', ',position_snaps,' (',CAST(ROUND(CAST(snap_count AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') AS position_display
	INTO #temp_season_positions_display
	FROM #temp_season_positions_unpivot up
	INNER JOIN #temp_season_positions_all sp
		ON up.bane_player_id = sp.bane_player_id
		AND up.season = sp.season
		AND up.season_type_adjusted = sp.season_type_adjusted
	WHERE snap_count > 0
		AND position_rank <= 5
		AND (CAST(snap_count AS FLOAT) / NULLIF(snap_count_all,0)) >= 0.05


-- Check if #temp_season_positions_pivot exists, if it does drop it
IF OBJECT_ID('tempdb..#temp_season_positions_pivot') IS NOT NULL
	DROP TABLE #temp_season_positions_pivot

	SELECT bane_player_id
		,season
		,season_type_adjusted
		,SUBSTRING(CONCAT([1],[2],[3],[4],[5]),3,255) AS alignment
	INTO #temp_season_positions_pivot
	FROM (
	SELECT bane_player_id
		,season
		,season_type_adjusted
		,position_rank
		,position_display
	FROM #temp_season_positions_display) up
	PIVOT(MAX(position_display) FOR position_rank IN ([1],[2],[3],[4],[5])) AS pvt
	ORDER BY bane_player_id


-- Check if #temp_season_positions exists, if it does drop it
IF OBJECT_ID('tempdb..#temp_season_positions') IS NOT NULL
	DROP TABLE #temp_season_positions

	SELECT sp.bane_player_id
		,sp.nfl_player_id
		,sp.season
		,sp.season_type_adjusted
		,position_blt
		,position_group_blt
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(alignment,'LOT','LT'),'LOG','LG'),'ROT','RT'),'ROG','RG'),'WR','WIDE'),'SLT','SLOT') AS alignment
	INTO #temp_season_positions
	FROM #temp_season_positions_all sp
	INNER JOIN #temp_season_positions_pivot pv
		ON sp.bane_player_id = pv.bane_player_id
		AND sp.season = pv.season
		AND sp.season_type_adjusted = pv.season_type_adjusted
	WHERE sp.season = 2020
		AND sp.season_type_adjusted = 'REGPOST'
		AND snap_count_all >= 50
	

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(a)

Create the evaluations table.  It takes a few steps because the data that goes into evaluations lives in multiple different tables.

First insert blank evaluation rows for every player - so that players that don't have enough snaps to get one of the grades still have a row, they aren't just missing
in the reports.

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_evaluations, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_evaluations') IS NOT NULL
	DROP TABLE #temp_analytics_evaluations

	CREATE TABLE #temp_analytics_evaluations (
		bane_player_id INT
		,season INT
		,season_type_adjusted NVARCHAR(7)
		,skill_id INT
		,skill_code NVARCHAR(50)
		,grade_id INT
		,explanation NVARCHAR(MAX)
	)


-- First the regressed stat evaluations
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,ma.skill_id
		,sk.code AS skill_code
		,NULL AS grade_id
		,NULL AS explanation
	FROM #temp_season_positions rp
	INNER JOIN Analytics.dbo.map_regressed_statistics_to_skill_ids ma
		ON CASE WHEN rp.position_blt = 'DS' THEN 'SS' ELSE rp.position_blt END = ma.position_code
	INNER JOIN BaneProductionAnalytics.dbo.skills sk
		ON ma.skill_id = sk.id
	WHERE NOT (ma.position_code = 'TE' AND ma.skill_id = 1601)

-- Next the endurance grade
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1586 AS skill_id
		,'A-END' AS skill_code
		,NULL AS grade_id
		,NULL AS explanation
	FROM #temp_season_positions rp

-- Next the strength and explosion grade (not used now, still being worked on, this is just a placeholder)
/*
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1609 AS skill_id
		,'A-STR/EXPL' AS skill_code
		,NULL AS grade_id
		,NULL AS explanation
	FROM #temp_season_positions rp
*/

-- Next the play speed/projected 40 grades
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1610 AS skill_id
		,'A-PLYSPD' AS skill_code
		,NULL AS grade_id
		,NULL AS explanation
	FROM #temp_season_positions rp

-- Next the burst/close on ball grade
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1615 AS skill_id
		,'A-CLSONBALL/RNG' AS skill_code
		,NULL AS grade_id
		,NULL AS explanation
	FROM #temp_season_positions rp
	WHERE rp.position_blt IN ('DS','SS','FS')


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(b)

Create the evaluations table.  It takes a few steps because the data that goes into evaluations lives in multiple different tables.

Join in the regressed statistics.

OUTPUT TABLES:
#temp_analytics_regressed_statistics

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_regressed_statistics, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_regressed_statistics') IS NOT NULL
	DROP TABLE #temp_analytics_regressed_statistics

	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,ma.skill_id
		,sk.code AS skill_code
		,gr.id AS grade_id
		,CONCAT(ex.explanation_start
			,' '
			,CASE WHEN LEFT(RIGHT(CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)),2),1) <> '.' THEN CONCAT(CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)),'.0') ELSE CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)) END
			,CASE WHEN LEFT(explanation_end,1) = '%' THEN '' ELSE ' ' END
			,CASE WHEN statistic_value < 0 THEN REPLACE(explanation_end,'more','less') ELSE explanation_end END --hard to change this in the map table because sometimes '%' goes before 'more', sometimes it doesn't
			,' ('
			,CONCAT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3))
				,CASE WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),2) IN (11,12,13) THEN 'th'
					WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st'
					WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd'
					WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' 
					ELSE 'th' 
				END,' percentile).')
		) AS explanation
	INTO #temp_analytics_regressed_statistics
	FROM #temp_season_positions rp
	INNER JOIN Analytics.dbo.r_output_regressed_statistics rs
		ON rp.nfl_player_id = rs.nfl_player_id
		AND rp.season = rs.season
		AND rp.season_type_adjusted = rs.season_type_adjusted
		And rs.rolling_game_stats = 0
	INNER JOIN Analytics.dbo.map_regressed_statistic_type ty
		ON rs.statistic_id = ty.id
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON rs.statistic_grade = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1
	INNER JOIN Analytics.dbo.map_regressed_statistics_to_skill_ids ma
		ON rs.statistic_id = ma.regressed_statistic_type_id
		AND CASE WHEN rp.position_blt = 'DS' THEN 'SS' ELSE rp.position_blt END = ma.position_code
	INNER JOIN Analytics.dbo.map_regressed_statistic_report_explanations ex
		ON rs.statistic_id = ex.regressed_statistic_type_id
	INNER JOIN BaneProductionAnalytics.dbo.skills sk
		ON ma.skill_id = sk.id


	UPDATE #temp_analytics_evaluations
	SET grade_id = rs.grade_id
		,explanation = rs.explanation
	FROM #temp_analytics_regressed_statistics rs
	WHERE #temp_analytics_evaluations.bane_player_id = rs.bane_player_id
		AND #temp_analytics_evaluations.season = rs.season
		AND #temp_analytics_evaluations.season_type_adjusted = rs.season_type_adjusted
		AND #temp_analytics_evaluations.skill_id = rs.skill_id


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(c)

Insert endurance grade and strength/explosion grade (based on work rate) into the evaluations table.

Skill IDs of 06/13/2020:
1586 - endurance (A-END)
1609 - strength/explosion (A-STR/EXPL)

Strength/Explosion not ready yet as of 09/10/2020, taking it out.

OUTPUT TABLES:
#temp_analytics_endurance

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_regressed_statistics, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_endurance') IS NOT NULL
	DROP TABLE #temp_analytics_endurance

	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1586 AS skill_id
		,'A-END' AS skill_code
		,gr.id AS grade_id
		,CONCAT(projected_reps
			,' reps before fatigue sets in ('
				,CONCAT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3))
					,CASE WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),2) IN (11,12,13) THEN 'th'
						WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st'
						WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd'
						WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' 
						ELSE 'th' 
					END,' percentile).')	
		) AS explanation
	INTO #temp_analytics_endurance
	FROM #temp_season_positions rp
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON rp.bane_player_id = pl.id
		AND pl.is_deleted = 0
	INNER JOIN Analytics.dbo.analysis_players_season_endurance_work_rates en
		ON pl.id = en.bane_player_id
		AND rp.season = en.season
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON en.endurance_grade = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


	UPDATE #temp_analytics_evaluations
	SET grade_id = rs.grade_id
		,explanation = rs.explanation
	FROM #temp_analytics_endurance rs
	WHERE #temp_analytics_evaluations.bane_player_id = rs.bane_player_id
		AND #temp_analytics_evaluations.season = rs.season
		AND #temp_analytics_evaluations.season_type_adjusted = rs.season_type_adjusted
		AND #temp_analytics_evaluations.skill_id = rs.skill_id

/*
	INSERT INTO #temp_analytics_evaluations 	
	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1609 AS skill_id
		,'A-STR/EXPL' AS skill_code
		,gr.id AS grade_id
		,CONCAT(reps_to_start
			,' reps to reach full strength ('
			,CONCAT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile work rate).')
		) AS explanation
	FROM #temp_season_positions rp
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON rp.bane_player_id = pl.id
		AND pl.is_deleted = 0
	INNER JOIN Analytics.dbo.analysis_players_season_endurance_work_rates en
		ON pl.id = en.bane_player_id
		AND rp.season = en.season
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON en.work_rate_grade = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1
*/

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(d)

Insert playing speed grade (based on projected 40) into the evaluations table.

The projected 40s table doesn't have grades, so you have to turn the values into grades first.

Skill IDs of 06/13/2020:
1610 - playing speed (A-PLYSPD)

OUTPUT TABLES:
#temp_analytics_play_speeds

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	-- Check if #temp_projected_forty_times, if it does drop it
	IF OBJECT_ID('tempdb..#temp_projected_forty_times') IS NOT NULL
	DROP TABLE #temp_projected_forty_times

	SELECT bane_player_id
		,season
		,AVG(projected_forty) AS projected_forty
	INTO #temp_projected_forty_times
	FROM Analytics.dbo.analysis_players_projected_forty_times
	GROUP BY bane_player_id
		,season


	-- Check if #temp_projected_forties, if it does drop it
	IF OBJECT_ID('tempdb..#temp_projected_forties') IS NOT NULL
	DROP TABLE #temp_projected_forties

	SELECT po.bane_player_id
		,po.season
		,position_group_blt
		,projected_forty
		,RANK() OVER (PARTITION BY po.season, position_group_blt ORDER BY projected_forty DESC) AS projected_forty_rank
	INTO #temp_projected_forties
	FROM #temp_season_positions po
	INNER JOIN #temp_projected_forty_times p40
		ON po.bane_player_id = p40.bane_player_id
		AND po.season = p40.season
	WHERE po.season_type_adjusted = 'REGPOST'


	-- Check if #temp_projected_forty_counts, if it does drop it
	IF OBJECT_ID('tempdb..#temp_projected_forty_counts') IS NOT NULL
	DROP TABLE #temp_projected_forty_counts

	SELECT season
		,position_group_blt
		,COUNT(*) AS position_count
	INTO #temp_projected_forty_counts
	FROM #temp_projected_forties
	GROUP BY season
		,position_group_blt


	-- Check if #temp_analytics_play_speeds, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_play_speeds') IS NOT NULL
	DROP TABLE #temp_analytics_play_speeds
		
	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1610 AS skill_id
		,'A-PLYSPD' AS skill_code
		,gr.id AS grade_id
		,CASE WHEN LEN(CAST(ROUND(projected_forty,2) AS VARCHAR(255))) = 1 THEN CONCAT(LEFT(CAST(ROUND(projected_forty,2) AS VARCHAR(255)),4),'.00 projected 40 based on NGS.') 
			WHEN LEN(CAST(ROUND(projected_forty,2) AS VARCHAR(255))) = 3 THEN CONCAT(LEFT(CAST(ROUND(projected_forty,2) AS VARCHAR(255)),4),'0 projected 40 based on NGS.') 
			ELSE CONCAT(LEFT(CAST(ROUND(projected_forty,2) AS VARCHAR(255)),4),' projected 40 based on NGS.') 
		END AS explanation
	INTO #temp_analytics_play_speeds
	FROM #temp_season_positions rp
	INNER JOIN #temp_projected_forties fo
		ON rp.bane_player_id = fo.bane_player_id
		AND rp.season = fo.season
	INNER JOIN #temp_projected_forty_counts fc
		ON fo.season = fc.season
		AND fo.position_group_blt = fc.position_group_blt
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON (CASE WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.90 THEN 7
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.75 THEN 6
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.40 THEN 5
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.10 THEN 4
				ELSE 3 
			END) = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


	UPDATE #temp_analytics_evaluations
	SET grade_id = rs.grade_id
		,explanation = rs.explanation
	FROM #temp_analytics_play_speeds rs
	WHERE #temp_analytics_evaluations.bane_player_id = rs.bane_player_id
		AND #temp_analytics_evaluations.season = rs.season
		AND #temp_analytics_evaluations.season_type_adjusted = rs.season_type_adjusted
		AND #temp_analytics_evaluations.skill_id = rs.skill_id


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(e)

Insert close on the ball/range (based on burst) into the evaluations table.

The burst table doesn't have grades or percentiles, so you have to turn the values into grades first.

Skill IDs of 06/13/2020:
1615 - close on the ball/range (A-CLSONBALL/RNG)

OUTPUT TABLES:
#temp_analytics_bursts

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	-- Check if #temp_ranked_bursts, if it does drop it
	IF OBJECT_ID('tempdb..#temp_ranked_bursts') IS NOT NULL
	DROP TABLE #temp_ranked_bursts

	SELECT po.bane_player_id
		,po.season
		,po.season_type_adjusted
		,CASE WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS','DIME') THEN 'DS'
		END AS position_group_blt
		,AVG(bu.burst_speed) AS burst_average
		,RANK() OVER (PARTITION BY po.season, po.season_type_adjusted, CASE WHEN position_blt IN ('CB','NB') THEN 'CB' WHEN position_blt IN ('FS','SS','DS','DIME') THEN 'DS' END ORDER BY AVG(bu.burst_speed)) AS burst_average_rank
	INTO #temp_ranked_bursts
	FROM #temp_season_positions po
	INNER JOIN (SELECT pl.id AS bane_player_id, 2020 AS season, 'REGPOST' AS season_type_adjusted, bu2.burst_speed, RANK() OVER (PARTITION BY gsis_player_id ORDER BY burst_speed DESC) AS burst_rank FROM AnalyticsWork.dbo.analysis_players_safety_bursts bu2 INNER JOIN BaneProductionAnalytics.dbo.players pl ON bu2.gsis_player_id = pl.nfl_id AND pl.is_deleted = 0) AS bu
		ON po.bane_player_id = bu.bane_player_id
		AND po.season = bu.season
		AND po.season_type_adjusted = bu.season_type_adjusted
		AND bu.burst_rank BETWEEN 3 AND 7
	WHERE po.season_type_adjusted = 'REGPOST'
		AND position_blt IN ('FS','SS','DS','DIME')
	GROUP BY po.bane_player_id
		,po.season
		,po.season_type_adjusted
		,CASE WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS','DIME') THEN 'DS'
		END


	-- Check if #temp_burst_counts, if it does drop it
	IF OBJECT_ID('tempdb..#temp_burst_counts') IS NOT NULL
	DROP TABLE #temp_burst_counts

	SELECT season
		,season_type_adjusted
		,position_group_blt
		,COUNT(*) AS position_count
	INTO #temp_burst_counts
	FROM #temp_ranked_bursts
	GROUP BY season
		,season_type_adjusted
		,position_group_blt


	-- Check if #temp_analytics_bursts, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_bursts') IS NOT NULL
	DROP TABLE #temp_analytics_bursts
	
	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1615 AS skill_id
		,'A-CLSONBALL/RNG' AS skill_code
		,gr.id AS grade_id
		,CONCAT(LEFT(CAST(ROUND(burst_average,2) AS VARCHAR(255)),4),' yards covered in first second of burst.') AS explanation
	INTO #temp_analytics_bursts
	FROM #temp_season_positions rp
	INNER JOIN #temp_ranked_bursts bu
		ON rp.bane_player_id = bu.bane_player_id
		AND rp.season = bu.season
		AND rp.season_type_adjusted = bu.season_type_adjusted
	INNER JOIN #temp_burst_counts bc
		ON bu.season = bc.season
		AND bu.season_type_adjusted = bc.season_type_adjusted
		AND bu.position_group_blt = bc.position_group_blt
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON (CASE WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.90 THEN 7
				WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.75 THEN 6
				WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.40 THEN 5
				WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.15 THEN 4
				ELSE 3 
			END) = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


	UPDATE #temp_analytics_evaluations
	SET grade_id = rs.grade_id
		,explanation = rs.explanation
	FROM #temp_analytics_bursts rs
	WHERE #temp_analytics_evaluations.bane_player_id = rs.bane_player_id
		AND #temp_analytics_evaluations.season = rs.season
		AND #temp_analytics_evaluations.season_type_adjusted = rs.season_type_adjusted
		AND #temp_analytics_evaluations.skill_id = rs.skill_id


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(3)


Create the overall grades table.  This will ultimately just be a pull from an updated model grades table, but for now (06/14/2020)

OUTPUT TABLES:
#temp_analytics_grades

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_grades, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_grades') IS NOT NULL
	DROP TABLE #temp_analytics_grades

	SELECT bane_player_id
		,season
		,'REGPOST' AS season_type_adjusted
		,70 AS author_id
		,grade_id
	INTO #temp_analytics_grades
	FROM Analytics.dbo.analysis_players_pro_model_grades
	WHERE season = 2020
		AND created_date = (SELECT MAX(created_date) FROM Analytics.dbo.analysis_players_pro_model_grades)


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(4)

Insert blank final summaries into the evaluations table that you can fill in with text later.

As of 06/14/2020 skill ids:
1611 - final summary (A-FINAL)
1612 - final summary update (A-FINALUPD)
1613 - revised final summary (A-RFS)
1614 - workout/misc. notes (A-MISCNOTES)

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,season
		,'REGPOST' AS season_type_adjusted
		,1611 AS skill_id
		,'A-FINAL' AS skill_code
		,NULL AS grade_id
		,'' AS explanation
	FROM Analytics.dbo.analysis_players_pro_model_grades
	WHERE season = 2020
		AND created_date = (SELECT MAX(created_date) FROM Analytics.dbo.analysis_players_pro_model_grades)


UPDATE #temp_analytics_evaluations
SET explanation = 'Vinny is a potential low cost signing with some pass rush upside.  In 2019, he was a very good pass rusher by both stats and NGS and was a very good tackler to go along with it.  He is typically inconsistent in both tackling and run defense, sometimes showing very good performance but not holding it through year to year.'
WHERE bane_player_id = 7037
	AND skill_id = 1611

UPDATE #temp_analytics_evaluations
SET explanation = 'Matt is a solid starter who flashes playmaking ability.  He has been a very good or outstanding pass rusher the last two seasons, but it is important to note he leads the NFL in unblocked pressures the last two seasons.  This could indicate schemed up pressure moreso than personally generated pressure.  Matt is an inconsistent tackler and run defender.  He is an outstanding playmaker.'
WHERE bane_player_id = 203146
	AND skill_id = 1611

UPDATE #temp_analytics_evaluations
SET explanation = 'Ha Ha is a capable safety who should provide good value for a low cost.  He has a history of very good and sometimes outstanding coverage.  He has been an inconsistent tackler most of his career, but has had some very good seasons.  In 2019 he showed inconsistent ball skills, but had historically been very good in that area.'
WHERE bane_player_id = 2698
	AND skill_id = 1611

UPDATE #temp_analytics_evaluations
SET explanation = 'Dak is a high impact, potential Pro Bowl QB.  He has been very good at completing more passes than we''d expect for his entire career.  He was oustanding at making plays in 2019.'
WHERE bane_player_id = 197847
	AND skill_id = 1611

UPDATE #temp_analytics_evaluations
SET explanation = 'Antoine is a capable starter. He has a history of being an outstanding tackler. - both were large improvements over 2018.  He looks like a hard worker.'
WHERE bane_player_id = 35287
	AND skill_id = 1611


	--INSERT INTO #temp_analytics_evaluations VALUES
	--([bane_player_id],[season],[season_type_adjusted],[skill_id],[skill_code],[grade_id],[explanation])
	--,(61386,2019,'REGPOST',1611,'A-FINAL',NULL,'Joey is the top DE in the league.  He is consistently at the top of the league in pressure rate, and in 3 of the last 4 years was also one of the most active DEs in the league in terms of making extra tackles.  While not a consistent top tier run defender, he has never been worst than inconsistent, and was oustanding in 2019.')
	--,(3957,2019,'REGPOST',1611,'A-FINAL',NULL,'Byron is a solid starter who seems to be improving his coverage skills.  After three years of inconsistent coverage, he was very good in 2018 and oustanding in 2019.  Byron is inconsistent at both playing the ball and tackling. He is one of the fastest DBs in the league. While the improving coverage skills are promising, he does not look to be worth a top tier contract.')
	--,(64417,2019,'REGPOST',1611,'A-FINAL',NULL,'Maliek is a potential low cost signing with interior pass rush upside.  He was a very good pass rusher in 2019, but had been inconsistent or worse in his previous seasons.  He is a poor tackler and a poor run defender.')
	--,(58798,2019,'REGPOST',1611,'A-FINAL',NULL,'Derrick is a capabale starting running back.  Our statistics do not like Derrick as much as traditional measures do.  He was inconsistent at avoiding tackles and poor as both as pass catcher and pass protector.  It looks like a lot of his raw rushing totals came as a result of a good offensive line.  He does have very good endurance.')
	--,(35702,2019,'REGPOST',1611,'A-FINAL',NULL,'Keenan a high impact player.  He has had very good or outstanding receivng production and outstanding hands his entire career.  He is inconsistent after the catch and as a run blocker.  He is slow, so his production likely comes from route skills rather than speed.')
	--,(4376,2019,'REGPOST',1611,'A-FINAL',NULL,'Nick is a solid starter. He is an outstanding run blocker year in and year out.  He is inconsistent as a receiver and after the catch.')
	--,(2606,2019,'REGPOST',1611,'A-FINAL',NULL,'Todd is a hgh impact player. He has always been a very good or outstanding tackler and was outstanding in coverage last year. He was also very good at making plays, but was an inconsistent run defender.')
	--,(71767,2019,'REGPOST',1611,'A-FINAL',NULL,'Brad is a solid starter. He was a very good run blocker and an inconsistent pass blocker in 2019 - both were large improvements over 2018.  He looks like a hard worker.')

/*
	select ev.*,gr.[value]
	from #temp_analytics_evaluations ev
	inner join BaneProductionAnalytics.dbo.grades gr
	on ev.grade_id = gr.id
	where bane_player_id = 2606
	and season_type_adjusted = 'regpost'
	order by skill_id,season
*/


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(5)


Add the new reports into the reports table.  Create a temp one first so you have the report ids to join the evaluations to, because the official analytics_reports
table doesn't have enough info to match on.

OUTPUT TABLES:
#temp_analytics_reports_with_seasons
Analytics.dbo.analytics_reports

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

--
-- Update the next id table to 299999
-- THIS IS JUST FOR TESTING, WHEN YOU GO LIVE REMOVE THIS
--
	--UPDATE [Analytics].[dbo].surrogate_key
	--SET next_key = 299999
	--WHERE table_name = 'analytics_reports'

-- Find the next unique report id 
	DECLARE @next_report_id INT
	EXEC Analytics.dbo.sp_get_next_surrogate_key 'analytics_reports', @next_report_id OUTPUT


	-- Check if #temp_analytics_reports_with_seasons exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_reports_with_seasons') IS NOT NULL
	DROP TABLE #temp_analytics_reports_with_seasons

	SELECT @next_report_id  + ROW_NUMBER() OVER (ORDER BY rp.bane_player_id, rp.season, rp.season_type_adjusted) AS id
		,gr.author_id
		,gr.grade_id
		,po.id AS position_id
		,'analytics-pro' AS [type]
		,0 AS submitted
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,rp.bane_player_id AS player_id
		,alignment
		,0 AS [imported_with_errors]
		,0 AS [is_deleted]
		,'2020 Mid Season' AS [exposure]
		,NULL AS [import_key]
		,NULL AS [revised_overall_grade_id]
		,'' AS [legacy_grade]
		,NULL AS [stratbridge_season_id]
		,0 AS [incomplete]
		,NULL AS [all_star_game_id]
		,rp.season
		,rp.season_type_adjusted
	INTO #temp_analytics_reports_with_seasons
	FROM #temp_season_positions rp
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON rp.position_blt = po.code
	INNER JOIN #temp_analytics_grades gr
		ON rp.bane_player_id = gr.bane_player_id
		AND rp.season = gr.season
		AND rp.season_type_adjusted = gr.season_type_adjusted


	INSERT INTO Analytics.dbo.analytics_reports
	SELECT id
		,author_id
		,grade_id
		,position_id
		,[type]
		,submitted
		,created_at
		,updated_at
		,player_id
		,alignment
		,[imported_with_errors]
		,[is_deleted]
		,[exposure]
		,[import_key]
		,[revised_overall_grade_id]
		,[legacy_grade]
		,[stratbridge_season_id]
		,[incomplete]
		,[all_star_game_id]
	FROM #temp_analytics_reports_with_seasons rp


-- Update the next id table with all the ones you just wrote in
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = (SELECT MAX(id) FROM Analytics.dbo.analytics_reports)
	WHERE table_name = 'analytics_reports'


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(5)


Add the new evaluations into the evaluatons table.

OUTPUT TABLES:
Analytics.dbo.analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

--
-- Update the next id table to 299999
-- THIS IS JUST FOR TESTING, WHEN YOU GO LIVE REMOVE THIS
--
	--UPDATE [Analytics].[dbo].surrogate_key
	--SET next_key = 299999
	--WHERE table_name = 'analytics_evaluations'

-- Find the next unique report id 
	DECLARE @next_eval_id INT
	EXEC Analytics.dbo.sp_get_next_surrogate_key 'analytics_evaluations', @next_eval_id OUTPUT


	INSERT INTO Analytics.dbo.analytics_evaluations
	SELECT @next_eval_id  + ROW_NUMBER() OVER (ORDER BY ev.bane_player_id, ev.season, ev.season_type_adjusted, ev.skill_id) AS id
		,ev.skill_id
		,ev.grade_id
		,re.id AS report_id
		,CASE WHEN ev.skill_id NOT IN (1611) THEN ISNULL(explanation,'Not enough snaps to assign a grade.') ELSE explanation END AS explanation
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,0 AS is_deleted
		,NULL AS interview_id
		,NULL AS advance_id
		,ev.skill_code
	FROM #temp_analytics_reports_with_seasons re
	INNER JOIN #temp_analytics_evaluations ev
		ON re.player_id = ev.bane_player_id
		AND re.season = ev.season
		AND re.season_type_adjusted = ev.season_type_adjusted


-- Update the next id table with all the ones you just wrote in
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = (SELECT MAX(id) FROM Analytics.dbo.analytics_evaluations)
	WHERE table_name = 'analytics_evaluations'
