


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(1)


Create the report position table. You need the overall position along with all the percentages (for the alignment field).

Defense and offense positions are kept in different tables, so do defense then append offense to it.

Since you need position data for any report, just make this the starting point that the reports and evaluations build off of.
You're only going to have one report per player season (and season type), so assign the report id here.  

OUTPUT TABLES:
#temp_report_positions

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_season_positions exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions') IS NOT NULL
	DROP TABLE #temp_season_positions

	CREATE TABLE #temp_season_positions (
		bane_player_id INT
		,nfl_player_id INT
		,season INT
		,season_type_adjusted NVARCHAR(7)
		,position_blt NVARCHAR(10)
		,position_group_blt NVARCHAR(10)
		,display_nt NVARCHAR(20)
		,display_dt3t NVARCHAR(20)
		,display_de5t NVARCHAR(20)
		,display_de43 NVARCHAR(20)
		,display_rush NVARCHAR(20)
		,display_sam  NVARCHAR(20)
		,display_ob34 NVARCHAR(20)
		,display_mike NVARCHAR(20)
		,display_will NVARCHAR(20)
		,display_ib NVARCHAR(20)
		,display_cb NVARCHAR(20)
		,display_nb NVARCHAR(20)
		,display_ds NVARCHAR(20)
		,display_qb NVARCHAR(20)
		,display_rb NVARCHAR(20)
		,display_fb NVARCHAR(20)
		,display_wr NVARCHAR(20)
		,display_te NVARCHAR(20)
		,display_slot NVARCHAR(20)
		,display_lot NVARCHAR(20)
		,display_log NVARCHAR(20)
		,display_oc NVARCHAR(20)
		,display_rog NVARCHAR(20)
		,display_rot NVARCHAR(20)
	)

	INSERT INTO #temp_season_positions
	SELECT pl.id AS bane_player_id
		,nfl_player_id
		,season
		,season_type_adjusted
		,position_blt
		,CASE WHEN position_blt IN ('NT','DT3T') THEN 'DT'
			WHEN position_blt IN ('OB34','RUSH','SAM','DE43') THEN 'EDGE'
			WHEN position_blt IN ('IB','MIKE','WILL') THEN 'IB'
			WHEN position_blt IN ('CB','NB','FS','SS','DS') THEN 'DB'
			WHEN position_blt IN ('LOT','LOG','OC','ROG','ROT') THEN 'OL'
			ELSE position_blt
		END AS position_group_blt
		,CASE WHEN CAST(snap_count_nt AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', NT (',CAST(ROUND(CAST(snap_count_nt AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_nt
		,CASE WHEN CAST(snap_count_dt3t AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', DT3T (',CAST(ROUND(CAST(snap_count_dt3t AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_dt3t
		,CASE WHEN CAST(snap_count_de5t AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', DE5T (',CAST(ROUND(CAST(snap_count_de5t AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_de5t
		,CASE WHEN CAST(snap_count_de43 AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', DE43 (',CAST(ROUND(CAST(snap_count_de43 AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_de43
		,CASE WHEN CAST(snap_count_rush AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', RUSH (',CAST(ROUND(CAST(snap_count_rush AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rush
		,CASE WHEN CAST(snap_count_sam AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', SAM (',CAST(ROUND(CAST(snap_count_sam AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_sam
		,CASE WHEN CAST(snap_count_ob34 AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', OB34 (',CAST(ROUND(CAST(snap_count_ob34 AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ob34
		,CASE WHEN CAST(snap_count_mike AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', MIKE (',CAST(ROUND(CAST(snap_count_mike AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_mike
		,CASE WHEN CAST(snap_count_will AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', WILL (',CAST(ROUND(CAST(snap_count_will AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_will
		,CASE WHEN CAST(snap_count_ib AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', IB (',CAST(ROUND(CAST(snap_count_ib AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ib
		,CASE WHEN CAST(snap_count_cb AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', CB (',CAST(ROUND(CAST(snap_count_cb AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_cb
		,CASE WHEN CAST(snap_count_nb AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', NB (',CAST(ROUND(CAST(snap_count_nb AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_nb
		,CASE WHEN CAST(snap_count_ds AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', DS (',CAST(ROUND(CAST(snap_count_ds AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ds
		,'' AS display_qb
		,'' AS display_rb
		,'' AS display_fb
		,'' AS display_wr
		,'' AS display_te
		,'' AS display_slot
		,'' AS display_lot
		,'' AS display_log
		,'' AS display_oc
		,'' AS display_rog
		,'' AS display_rot
	FROM Analytics.dbo.analysis_players_season_position_defense de
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON de.nfl_player_id = pl.nfl_id
		AND pl.is_deleted = 0
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON pl.position_id = po.id
	WHERE po.[team] = 'defense'
		AND defense_type = 'ALL'
		AND snap_count_all >= 0


	INSERT INTO #temp_season_positions
	SELECT pl.id AS bane_player_id
		,nfl_player_id
		,season
		,season_type_adjusted
		,position_blt
		,CASE WHEN position_blt IN ('NT','DT3T') THEN 'DT'
			WHEN position_blt IN ('OB34','RUSH','SAM','DE43') THEN 'EDGE'
			WHEN position_blt IN ('IB','MIKE','WILL') THEN 'IB'
			WHEN position_blt IN ('CB','NB','FS','SS','DS') THEN 'DB'
			WHEN position_blt IN ('LOT','LOG','OC','ROG','ROT') THEN 'OL'
			ELSE position_blt
		END AS position_group_blt
		,'' AS display_nt
		,'' AS display_dt3t
		,'' AS display_de5t
		,'' AS display_de43
		,'' AS display_rush
		,'' AS display_sam
		,'' AS display_ob34
		,'' AS display_mike
		,'' AS display_will
		,'' AS display_ib
		,'' AS display_cb
		,'' AS display_nb
		,'' AS display_ds
		,CASE WHEN CAST(snap_count_qb AS FLOAT)  / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', QB (',CAST(ROUND(CAST(snap_count_qb AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_qb
		,CASE WHEN CAST(snap_count_rb AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', RB (',CAST(ROUND(CAST(snap_count_rb AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rb
		,CASE WHEN CAST(snap_count_fb AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', FB (',CAST(ROUND(CAST(snap_count_fb AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_fb
		,CASE WHEN CAST(snap_count_wr AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', WR (',CAST(ROUND(CAST(snap_count_wr AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_wr
		,CASE WHEN CAST(snap_count_te AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', TE (',CAST(ROUND(CAST(snap_count_te AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_te
		,CASE WHEN CAST(snap_count_slot AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', SLOT (',CAST(ROUND(CAST(snap_count_slot AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_slot
		--,CASE WHEN CAST((snap_count_inside + snap_count_slot + snap_count_flex) AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', SLOT (',CAST(ROUND(CAST((snap_count_inside + snap_count_slot + snap_count_flex) AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_slot
		,CASE WHEN CAST(snap_count_lot AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', LT (',CAST(ROUND(CAST(snap_count_lot AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_lot
		,CASE WHEN CAST(snap_count_log AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', LG (',CAST(ROUND(CAST(snap_count_log AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_log
		,CASE WHEN CAST(snap_count_oc AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', OC (',CAST(ROUND(CAST(snap_count_oc AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_oc
		,CASE WHEN CAST(snap_count_rog AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', RG (',CAST(ROUND(CAST(snap_count_rog AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rog
		,CASE WHEN CAST(snap_count_rot AS FLOAT) / NULLIF(snap_count_all ,0) >= 0.05 THEN CONCAT(', RT (',CAST(ROUND(CAST(snap_count_rot AS FLOAT) / NULLIF(snap_count_all ,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rot
	FROM Analytics.dbo.analysis_players_season_position_offense de
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON de.nfl_player_id = pl.nfl_id
		AND pl.is_deleted = 0
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON pl.position_id = po.id
	WHERE po.[team] = 'offense'
		AND snap_count_all >= 0



--
-- Update the next id table to 299999
-- THIS IS JUST FOR TESTING, WHEN YOU GO LIVE REMOVE THIS
--
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = 299999
	WHERE table_name = 'test_reports'

-- Find the next unique report id 
DECLARE @next_id INT
EXEC Analytics.dbo.sp_get_next_surrogate_key 'test_reports', @next_id OUTPUT

	-- Check if #temp_report_positions exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_report_positions') IS NOT NULL
	DROP TABLE #temp_report_positions

	SELECT bane_player_id
		,nfl_player_id
		,season
		,season_type_adjusted
		,@next_id  + ROW_NUMBER() OVER (ORDER BY nfl_player_id, season, season_type_adjusted) AS report_id
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,position_blt
		,po.id AS bane_position_id
		,SUBSTRING(CONCAT(display_nt,display_dt3t,display_de5t,display_de43,display_rush,display_sam,display_ob34,display_mike,display_will,display_ib,display_cb,display_nb,display_ds,display_qb,display_rb,display_fb,display_wr,display_te,display_slot,display_lot,display_log,display_oc,display_rog,display_rot),3,255) AS alignment
	INTO #temp_report_positions
	FROM #temp_season_positions se
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON se.position_blt = po.code
	WHERE nfl_player_id = 38589
		AND season = 2019
		AND season_type_adjusted = 'REGPOST'


-- Update the next id table with all the ones you just wrote in
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = (SELECT MAX(report_id) FROM #temp_report_positions)
	WHERE table_name = 'test_reports'



/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(a)

Create the evaluations table.  It takes a few steps because the data that goes into evaluations lives in multiple different tables.

First insert the regressed statistics into the evaluations table.

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
		,grade_id INT
		,report_id INT
		,explanation NVARCHAR(MAX)
	)

	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,ma.skill_id
		,gr.id AS grade_id
		,report_id
		,CONCAT(ex.explanation_start
			,' '
			,CAST(ROUND(statistic_value*multiply_by,1) AS NVARCHAR(10))
			,CASE WHEN LEFT(explanation_end,1) = '%' THEN '' ELSE ' ' END
			,explanation_end
			,' ('
			,CONCAT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile).')
		) AS explanation
	FROM #temp_report_positions rp
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
		AND rp.position_blt = ma.position_code
	INNER JOIN Analytics.dbo.map_regressed_statistic_report_explanations ex
		ON rs.statistic_id = ex.regressed_statistic_type_id


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(b)

Insert endurance grade and strength/explosion grade (based on work rate) into the evaluations table.

Skill IDs of 06/13/2020:
9000 - endurance
1367 - strength/explosion

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,9000 AS skill_id
		,gr.id AS grade_id
		,rp.report_id
		,CONCAT(projected_reps
			,' reps before fatigue sets in ('
			,CONCAT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile).')
		) AS explanation
	FROM #temp_report_positions rp
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON rp.bane_player_id = pl.id
		AND pl.is_deleted = 0
	INNER JOIN AnalyticsWork.dbo.endurance_work_rate_grades_summarized en
		ON pl.nfl_gsis_id = en.gsis_id
		AND rp.season = en.season
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON en.endurance_grade = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1
	

	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1367 AS skill_id
		,gr.id AS grade_id
		,rp.report_id
		,CONCAT(reps_to_start
			,' reps to reach full strength ('
			,CONCAT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile work rate).')
		) AS explanation
	FROM #temp_report_positions rp
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON rp.bane_player_id = pl.id
		AND pl.is_deleted = 0
	INNER JOIN AnalyticsWork.dbo.endurance_work_rate_grades_summarized en
		ON pl.nfl_gsis_id = en.gsis_id
		AND rp.season = en.season
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON en.work_rate_grade = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(c)

Insert playing speed grade (based on projected 40) into the evaluations table.

The projected 40s table doesn't have grades, so you have to turn the values into grades first.

Skill IDs of 06/13/2020:
1368 - playing speed

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	-- Check if #temp_projected_forties, if it does drop it
	IF OBJECT_ID('tempdb..#temp_projected_forties') IS NOT NULL
	DROP TABLE #temp_projected_forties

	SELECT bane_player_id
		,po.season
		,position_group_blt
		,p40.[value] AS projected_forty
		,RANK() OVER (PARTITION BY po.season, position_group_blt ORDER BY p40.[value]) AS projected_forty_rank
	INTO #temp_projected_forties
	FROM #temp_season_positions po
	INNER JOIN (SELECT *, RANK() OVER (PARTITION BY player_id ORDER BY season DESC, rep_category DESC) AS forty_rank FROM [BaneProductionAnalytics].dbo.projected_forty_times) AS p40
		ON po.bane_player_id = p40.player_id
		AND po.season = p40.season
		AND p40.forty_rank = 1
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


	INSERT INTO #temp_analytics_evaluations 	
	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1368 AS skill_id
		,gr.id AS grade_id
		,rp.report_id
		,CONCAT(LEFT(CAST(ROUND(projected_forty,2) AS VARCHAR(255)),4),' projected 40 based on NGS.') AS explanation
	FROM #temp_report_positions rp
	INNER JOIN #temp_projected_forties fo
		ON rp.bane_player_id = fo.bane_player_id
		AND rp.season = fo.season
	INNER JOIN #temp_projected_forty_counts fc
		ON fo.season = fc.season
		AND fo.position_group_blt = fc.position_group_blt
	INNER JOIN BaneProductionAnalytics.dbo.grades gr
		ON (CASE WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.90 THEN 7
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.75 THEN 6
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.25 THEN 5
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.10 THEN 4
				ELSE 3 
			END) = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(d)

Insert final summaries into the evaluations table.

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
--put in final summary row
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1379 AS skill_id
		,NULL AS grade_id
		,rp.report_id
		,'Vinny is a potential low cost signing with some pass rush upside.  in 2019, he was a 6 pass rusher by both stats and NGS and was a 6 tackler to go along with it.  He isn''t a consistently good tackler - he was only a 4 in 2018.' AS explanation
	FROM #temp_report_positions rp


--put in final summary update row
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1380 AS skill_id
		,NULL AS grade_id
		,rp.report_id
		,'' AS explanation
	FROM #temp_report_positions rp


--put in revised final summary row
	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1454 AS skill_id
		,NULL AS grade_id
		,rp.report_id
		,'' AS explanation
	FROM #temp_report_positions rp


--put in misc notes row
	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1381 AS skill_id
		,NULL AS grade_id
		,rp.report_id
		,'' AS explanation
	FROM #temp_report_positions rp


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(e)

Add in the unique evaluation ids.

OUTPUT TABLES:
#temp_analytics_evaluations_with_ids

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

--
-- Update the next id table to 299999
-- THIS IS JUST FOR TESTING, WHEN YOU GO LIVE REMOVE THIS
--
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = 299999
	WHERE table_name = 'test_evals'

-- Find the next unique report id 
DECLARE @next_eval_id INT
EXEC Analytics.dbo.sp_get_next_surrogate_key 'test_evals', @next_eval_id OUTPUT

	-- Check if #temp_analytics_evaluations_with_ids exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_evaluations_with_ids') IS NOT NULL
	DROP TABLE #temp_analytics_evaluations_with_ids

	SELECT *
		,@next_eval_id  + ROW_NUMBER() OVER (ORDER BY bane_player_id, season, season_type_adjusted, skill_id) AS evaluation_id
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,0 AS is_deleted
		,NULL AS interview_id
		,NULL AS advance_id
	INTO #temp_analytics_evaluations_with_ids
	FROM #temp_analytics_evaluations


-- Update the next id table with all the ones you just wrote in
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = (SELECT MAX(report_id) FROM #temp_report_positions)
	WHERE table_name = 'test_evals'



/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(3)


Create the reports table.

OUTPUT TABLES:
#temp_analytics_reports

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_reports exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_reports') IS NOT NULL
	DROP TABLE #temp_analytics_reports

	SELECT rp.report_id AS id
		,70 AS author_id
		,47 AS grade_id
		,rp.bane_position_id AS position_id
		,'analytics-pro' AS [type]
		,0 AS submitted
		,rp.created_at
		,rp.updated_at
		,rp.bane_player_id AS player_id
		,rp.alignment
		,0 AS [imported_with_errors]
		,0 AS [is_deleted]
		,'' AS [exposure]
		,NULL [import_key]
		,NULL AS [revised_overall_grade_id]
		,'5.9' AS [legacy_grade]
		,NULL [stratbridge_season_id]
		,0 AS [incomplete]
		,NULL AS [all_star_game_id]
	INTO #temp_analytics_reports
	FROM #temp_report_positions rp





	SELECT *
	FROM #temp_analytics_reports

	SELECT *
	FROM #temp_analytics_evaluations_with_ids
