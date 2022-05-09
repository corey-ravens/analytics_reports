


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(1)


Create the season position table. You need the overall position along with all the percentages (for the alignment field).

Defense and offense positions are kept in different tables, so do defense then append offense to it.

Since you need a position to do a report, make this table the basis for the reports and evaluations to follow so everything can join together.

OUTPUT TABLES:
#temp_season_positions

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_season_positions_all exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions_all') IS NOT NULL
	DROP TABLE #temp_season_positions_all

	CREATE TABLE #temp_season_positions_all (
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


	INSERT INTO #temp_season_positions_all
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


	INSERT INTO #temp_season_positions_all
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


	-- Check if #temp_season_positions exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_season_positions') IS NOT NULL
	DROP TABLE #temp_season_positions

	SELECT *
	INTO #temp_season_positions
	FROM #temp_season_positions_all
	WHERE bane_player_id = 7037
		AND season = 2019
		AND season_type_adjusted = 'REGPOST'


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
		,explanation NVARCHAR(MAX)
	)


	INSERT INTO #temp_analytics_evaluations 	
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,ma.skill_id
		,gr.id AS grade_id
		,CONCAT(ex.explanation_start
			,' '
			,CAST(ROUND(statistic_value*multiply_by,1) AS NVARCHAR(10))
			,CASE WHEN LEFT(explanation_end,1) = '%' THEN '' ELSE ' ' END
			,explanation_end
			,' ('
			,CONCAT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(statistic_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile).')
		) AS explanation
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
		,CONCAT(projected_reps
			,' reps before fatigue sets in ('
			,CONCAT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(endurance_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile).')
		) AS explanation
	FROM #temp_season_positions rp
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
		,CONCAT(reps_to_start
			,' reps to reach full strength ('
			,CONCAT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),CASE WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (1) THEN 'st' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (2) THEN 'nd' WHEN RIGHT(CAST(ROUND(work_rate_position_percentile*100,0) AS NVARCHAR(3)),1) IN (3) THEN 'rd' ELSE 'th' END,' percentile work rate).')
		) AS explanation
	FROM #temp_season_positions rp
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
		,CONCAT(LEFT(CAST(ROUND(projected_forty,2) AS VARCHAR(255)),4),' projected 40 based on NGS.') AS explanation
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
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.25 THEN 5
				WHEN (CAST(fo.projected_forty_rank AS FLOAT) - 1) / NULLIF(fc.position_count,0) >= 0.10 THEN 4
				ELSE 3 
			END) = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(d)

Insert final summary rows into the evaluations table.

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	INSERT INTO #temp_analytics_evaluations
	SELECT bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,1379 AS skill_id
		,NULL AS grade_id
		,'' AS explanation
	FROM #temp_season_positions rp


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(e)

Manually add the final summaries text by updating the final summary rows.

Also manually insert final summary updates or revised final summarries here. You don't automatically add those in because not all reports have them.

As of 06/14/2020 skill ids:
1379 - final summary
1380 - final summary update
1454 - revised final summary
1381 - workout/misc. notes

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

UPDATE #temp_analytics_evaluations
SET explanation = 'Vinny is a potential low cost signing with some pass rush upside.  in 2019, he was a 6 pass rusher by both stats and NGS and was a 6 tackler to go along with it.  He isn''t a consistently good tackler - he was only a 4 in 2018.'
WHERE skill_id = 1379
	AND season = 2019
	AND season_type_adjusted = 'REGPOST'
	AND bane_player_id = 7037

/*

INSERT INTO #temp_analytics_evaluations VALUES
([bane_player_id],[season],[season_type_adjusted],[skill_id],[grade_id],[explanation])

*/


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(3)


Create the overall grades table.  This will ultimately just be a pull from an updated model grades table, but for now (06/14/2020)

OUTPUT TABLES:
#temp_analytics_grades

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_grades exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_grades') IS NOT NULL
	DROP TABLE #temp_analytics_grades

	SELECT bane_player_id
		,season
		,season_type_adjusted
		,NULL AS grade_id
	INTO #temp_analytics_grades
	FROM #temp_season_positions

	UPDATE #temp_analytics_grades
	SET grade_id = 47
	WHERE season = 2019
		AND season_type_adjusted = 'REGPOST'
		AND bane_player_id = 7037


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(4)


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
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = 299999
	WHERE table_name = 'test_reports'

-- Find the next unique report id 
	DECLARE @next_report_id INT
	EXEC Analytics.dbo.sp_get_next_surrogate_key 'test_reports', @next_report_id OUTPUT


	-- Check if #temp_analytics_reports_with_seasons exists, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_reports_with_seasons') IS NOT NULL
	DROP TABLE #temp_analytics_reports_with_seasons

	SELECT @next_report_id  + ROW_NUMBER() OVER (ORDER BY rp.bane_player_id, rp.season, rp.season_type_adjusted) AS id
		,70 AS author_id
		,gr.grade_id
		,po.id AS position_id
		,'analytics-pro' AS [type]
		,0 AS submitted
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,rp.bane_player_id AS player_id
		,SUBSTRING(CONCAT(display_nt,display_dt3t,display_de5t,display_de43,display_rush,display_sam,display_ob34,display_mike,display_will,display_ib,display_cb,display_nb,display_ds,display_qb,display_rb,display_fb,display_wr,display_te,display_slot,display_lot,display_log,display_oc,display_rog,display_rot),3,255) AS alignment
		,0 AS [imported_with_errors]
		,0 AS [is_deleted]
		,'' AS [exposure]
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


	--INSERT INTO Analytics.dbo.analytics_reports
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
	WHERE table_name = 'test_reports'


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
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = 299999
	WHERE table_name = 'test_evals'

-- Find the next unique report id 
	DECLARE @next_eval_id INT
	EXEC Analytics.dbo.sp_get_next_surrogate_key 'test_evals', @next_eval_id OUTPUT


	--INSERT INTO Analytics.dbo.analytics_evaluations
	SELECT @next_eval_id  + ROW_NUMBER() OVER (ORDER BY ev.bane_player_id, ev.season, ev.season_type_adjusted, ev.skill_id) AS id
		,ev.skill_id
		,ev.grade_id
		,re.id AS report_id
		,ev.explanation
		,GETDATE() AS created_at
		,GETDATE() AS updated_at
		,0 AS is_deleted
		,NULL AS interview_id
		,NULL AS advance_id
	FROM #temp_analytics_reports_with_seasons re
	INNER JOIN #temp_analytics_evaluations ev
		ON re.player_id = ev.bane_player_id
		AND re.season = ev.season
		AND re.season_type_adjusted = ev.season_type_adjusted


-- Update the next id table with all the ones you just wrote in
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = (SELECT MAX(id) FROM Analytics.dbo.analytics_evaluations)
	WHERE table_name = 'test_evals'
