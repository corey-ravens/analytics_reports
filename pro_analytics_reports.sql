


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

v1 is just a work file with lots of info, you can dump it
v2 is when you start adding structure to the tables
v3 is when you start adding in report_id and evaluation_id dynamically
v4 is the almost finalized version where dunamic ids are done at the end, and added into Analytics tables
v5 is just a slight tweak on v4, where you are manually inserting grades and summaries because those auto tables aren't ready yet. Can loook back at v4 once those are done.
v6 adds burst.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(1)


Create the season position table. You need the overall position along with all the percentages (for the alignment field).

Defense and offense positions are kept in different tables, so do defense then append offense to it.

Since you need a position to do a report, make this table the basis for the reports and evaluations to follow so everything can join together.

OUTPUT TABLES:
#temp_season_positions

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
		,CASE WHEN CAST(snap_count_nt AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', NT (',CAST(ROUND(CAST(snap_count_nt AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_nt
		,CASE WHEN CAST(snap_count_dt3t AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', DT3T (',CAST(ROUND(CAST(snap_count_dt3t AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_dt3t
		,CASE WHEN CAST(snap_count_de5t AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', DE5T (',CAST(ROUND(CAST(snap_count_de5t AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_de5t
		,CASE WHEN CAST(snap_count_de43 AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', DE43 (',CAST(ROUND(CAST(snap_count_de43 AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_de43
		,CASE WHEN CAST(snap_count_rush AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', RUSH (',CAST(ROUND(CAST(snap_count_rush AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rush
		,CASE WHEN CAST(snap_count_sam AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', SAM (',CAST(ROUND(CAST(snap_count_sam AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_sam
		,CASE WHEN CAST(snap_count_ob34 AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', OB34 (',CAST(ROUND(CAST(snap_count_ob34 AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ob34
		,CASE WHEN CAST(snap_count_mike AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', MIKE (',CAST(ROUND(CAST(snap_count_mike AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_mike
		,CASE WHEN CAST(snap_count_will AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', WILL (',CAST(ROUND(CAST(snap_count_will AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_will
		,CASE WHEN CAST(snap_count_ib AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', IB (',CAST(ROUND(CAST(snap_count_ib AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ib
		,CASE WHEN CAST(snap_count_cb AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', CB (',CAST(ROUND(CAST(snap_count_cb AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_cb
		,CASE WHEN CAST(snap_count_nb AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', NB (',CAST(ROUND(CAST(snap_count_nb AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_nb
		,CASE WHEN CAST(snap_count_ds AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', DS (',CAST(ROUND(CAST(snap_count_ds AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_ds
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
		,CASE WHEN CAST(snap_count_qb AS FLOAT)  / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', QB (',CAST(ROUND(CAST(snap_count_qb AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_qb
		,CASE WHEN CAST(snap_count_rb AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', RB (',CAST(ROUND(CAST(snap_count_rb AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rb
		,CASE WHEN CAST(snap_count_fb AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', FB (',CAST(ROUND(CAST(snap_count_fb AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_fb
		,CASE WHEN CAST(snap_count_wr AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', WR (',CAST(ROUND(CAST(snap_count_wr AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_wr
		,CASE WHEN CAST(snap_count_te AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', TE (',CAST(ROUND(CAST(snap_count_te AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_te
		,CASE WHEN CAST(snap_count_slot AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', SLOT (',CAST(ROUND(CAST(snap_count_slot AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_slot
		,CASE WHEN CAST(snap_count_lot AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', LT (',CAST(ROUND(CAST(snap_count_lot AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_lot
		,CASE WHEN CAST(snap_count_log AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', LG (',CAST(ROUND(CAST(snap_count_log AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_log
		,CASE WHEN CAST(snap_count_oc AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', OC (',CAST(ROUND(CAST(snap_count_oc AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_oc
		,CASE WHEN CAST(snap_count_rog AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', RG (',CAST(ROUND(CAST(snap_count_rog AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rog
		,CASE WHEN CAST(snap_count_rot AS FLOAT) / NULLIF(snap_count_all,0) >= 0.05 THEN CONCAT(', RT (',CAST(ROUND(CAST(snap_count_rot AS FLOAT) / NULLIF(snap_count_all,0) * 100,0) AS NVARCHAR(3)),'%)') ELSE '' END AS display_rot
	FROM Analytics.dbo.analysis_players_season_position_offense de
	INNER JOIN BaneProductionAnalytics.dbo.players pl
		ON de.nfl_player_id = pl.nfl_id
		AND pl.is_deleted = 0
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON pl.position_id = po.id
	WHERE po.[team] = 'offense'
		AND snap_count_all >= 0


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
			,CASE WHEN LEFT(RIGHT(CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)),2),1) <> '.' THEN CONCAT(CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)),'.0') ELSE CAST(ROUND(ABS(statistic_value)*multiply_by,1) AS NVARCHAR(10)) END
			,CASE WHEN LEFT(explanation_end,1) = '%' THEN '' ELSE ' ' END
			,CASE WHEN statistic_value < 0 THEN REPLACE(explanation_end,'more','less') ELSE explanation_end END --hard to change this in the map table because sometimes '%' goes before 'more', sometimes it doesn't
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
		,RANK() OVER (PARTITION BY po.season, position_group_blt ORDER BY p40.[value] DESC) AS projected_forty_rank
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

Insert close on the ball/range (based on burst) into the evaluations table.

The burst table doesn't have grades or percentiles, so you have to turn the values into grades first.

Skill IDs of 06/13/2020:
9029 - close on the ball/range

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	-- Check if #temp_ranked_bursts, if it does drop it
	IF OBJECT_ID('tempdb..#temp_ranked_bursts') IS NOT NULL
	DROP TABLE #temp_ranked_bursts

	SELECT po.bane_player_id
		,po.season
		,po.season_type_adjusted
		,CASE WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS') THEN 'DS'
		END AS position_group_blt
		,AVG(bu.burst_speed) AS burst_average
		,RANK() OVER (PARTITION BY po.season, po.season_type_adjusted, CASE WHEN position_blt IN ('CB','NB') THEN 'CB' WHEN position_blt IN ('FS','SS','DS') THEN 'DS' END ORDER BY AVG(bu.burst_speed)) AS burst_average_rank
	INTO #temp_ranked_bursts
	FROM #temp_season_positions po
	INNER JOIN (SELECT pl.id AS bane_player_id, 2019 AS season, 'REGPOST' AS season_type_adjusted, bu2.*, RANK() OVER (PARTITION BY gsis_player_id ORDER BY burst_speed DESC) AS burst_rank FROM AnalyticsWork.dbo.sarah_safety_bursts_20200614 bu2 INNER JOIN BaneProductionAnalytics.dbo.players pl ON bu2.gsis_player_id = pl.nfl_id AND pl.is_deleted = 0) AS bu
		ON po.bane_player_id = bu.bane_player_id
		AND po.season = bu.season
		AND po.season_type_adjusted = bu.season_type_adjusted
		AND bu.burst_rank BETWEEN 3 AND 7
	WHERE po.season_type_adjusted = 'REGPOST'
		AND position_blt IN ('FS','SS','DS')
	GROUP BY po.bane_player_id
		,po.season
		,po.season_type_adjusted
		,CASE WHEN position_blt IN ('CB','NB') THEN 'CB'
			WHEN position_blt IN ('FS','SS','DS') THEN 'DS'
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


	INSERT INTO #temp_analytics_evaluations 	
	SELECT rp.bane_player_id
		,rp.season
		,rp.season_type_adjusted
		,9029 AS skill_id
		,gr.id AS grade_id
		,CONCAT(LEFT(CAST(ROUND(burst_average,2) AS VARCHAR(255)),4),' yards covered in first second of burst.') AS explanation
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
				WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.25 THEN 5
				WHEN (CAST(bu.burst_average_rank AS FLOAT) - 1) / NULLIF(bc.position_count,0) >= 0.10 THEN 4
				ELSE 3 
			END) = gr.[value]
		AND gr.scale_id = 5
		AND gr.active = 1


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(2)(e)

Manually insert the final summaries into the evaluations table.

As of 06/14/2020 skill ids:
1379 - final summary
1380 - final summary update
1454 - revised final summary
1381 - workout/misc. notes

OUTPUT TABLES:
#temp_analytics_evaluations

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	INSERT INTO #temp_analytics_evaluations VALUES
	--([bane_player_id],[season],[season_type_adjusted],[skill_id],[grade_id],[explanation])
	(7037,2019,'REGPOST',1379,NULL,'Vinny is a potential low cost signing with some pass rush upside.  In 2019, he was a very good pass rusher by both stats and NGS and was a very good tackler to go along with it.  He is typically inconsistent in both tackling and run defense, sometimes showing very good performance but not holding it through year to year.')
	,(61386,2019,'REGPOST',1379,NULL,'Joey is the top DE in the league.  He is consistently at the top of the league in pressure rate, and in 3 of the last 4 years was also one of the most active DEs in the league in terms of making extra tackles.  While not a consistent top tier run defender, he has never been worst than inconsistent, and was oustanding in 2019.')
	,(3957,2019,'REGPOST',1379,NULL,'Byron is a solid starter who seems to be improving his coverage skills.  After three years of inconsistent coverage, he was very good in 2018 and oustanding in 2019.  Byron is inconsistent at both playing the ball and tackling. He is one of the fastest DBs in the league. While the improving coverage skills are promising, he does not look to be worth a top tier contract.')
	,(64417,2019,'REGPOST',1379,NULL,'Maliek is a potential low cost signing with interior pass rush upside.  He was a very good pass rusher in 2019, but had been inconsistent or worse in his previous seasons.  He is a poor tackler and a poor run defender.')
	,(203146,2019,'REGPOST',1379,NULL,'Matt is a solid starter who flashes playmaking ability.  He has been a very good or outstanding pass rusher the last two seasons, but it is important to note he leads the NFL in unblocked pressures the last two seasons.  This could indicate schemed up pressure moreso than personally generated pressure.  Matt is an inconsistent tackler and run defender.  He is an outstanding playmaker.')
	,(2698,2019,'REGPOST',1379,NULL,'Ha Ha is a capable safety who should provide good value for a low cost.  He has a history of outstanding or very good coverage.  He has been an inconsistent tackler most of his career, but has shown ability to be better a few seasons.  In 2019 he showed inconsistent ball skills, but had historically been very good in that area.')
	,(58798,2019,'REGPOST',1379,NULL,'Derrick is a capabale starting running back.  Our statistics do not like Derrick as much as traditional measures do.  He was inconsistent at avoiding tackles and poor as both as pass catcher and pass protector.  It looks like a lot of his raw rushing totals came as a result of a good offensive line.  He does have very good endurance.')
	,(35702,2019,'REGPOST',1379,NULL,'Keenan a high impact player.  He has had very good or outstanding receivng production and outstanding hands his entire career.  He is inconsistent after the catch and as a run blocker.  He is slow, so his production likely comes from route skills rather than speed.')
	,(4376,2019,'REGPOST',1379,NULL,'Nick is a solid starter. He is an outstanding run blocker year in and year out.  He is inconsistent as a receiver and after the catch.')
	,(2606,2019,'REGPOST',1379,NULL,'Todd is a hgh impact player. He has always been a very good or outstanding tackler and was outstanding in coverage last year. He was also very good at making plays, but was an inconsistent run defender.')
	,(197847,2019,'REGPOST',1379,NULL,'Dak is a high impact, potential Pro Bowl QB.  He has been very good at completing more passes than we''d expect for his entire career.  He was oustanding at making plays in 2019.')
	,(71767,2019,'REGPOST',1379,NULL,'Brad is a solid starter. He was a very good run blocker and an inconsistent pass blocker in 2019 - both were large improvements over 2018.  He looks like a hard worker.')
	
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

(3)


Create the overall grades table.  This will ultimately just be a pull from an updated model grades table, but for now (06/14/2020)

OUTPUT TABLES:
#temp_analytics_grades

----------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

	-- Check if #temp_analytics_grades, if it does drop it
	IF OBJECT_ID('tempdb..#temp_analytics_grades') IS NOT NULL
	DROP TABLE #temp_analytics_grades

	CREATE TABLE #temp_analytics_grades (
		bane_player_id INT
		,season INT
		,season_type_adjusted NVARCHAR(7)
		,author_id INT
		,grade_id INT
	)


	INSERT INTO #temp_analytics_grades VALUES
	--([bane_player_id],[season],[season_type_adjusted],[author_id],[grade_id])
	(7037,2019,'REGPOST',70,48)
	,(61386,2019,'REGPOST',70,40)
	,(3957,2019,'REGPOST',70,46)
	,(64417,2019,'REGPOST',70,48)
	,(203146,2019,'REGPOST',70,45)
	,(2698,2019,'REGPOST',70,46)
	,(58798,2019,'REGPOST',70,46)
	,(35702,2019,'REGPOST',70,43)
	,(4376,2019,'REGPOST',70,45)
	,(2606,2019,'REGPOST',70,43)
	,(197847,2019,'REGPOST',70,42)
	,(71767,2019,'REGPOST',70,45)
	
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
	WHERE table_name = 'analytics_reports'

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
	UPDATE [Analytics].[dbo].surrogate_key
	SET next_key = 299999
	WHERE table_name = 'analytics_evaluations'

-- Find the next unique report id 
	DECLARE @next_eval_id INT
	EXEC Analytics.dbo.sp_get_next_surrogate_key 'analytics_evaluations', @next_eval_id OUTPUT


	INSERT INTO Analytics.dbo.analytics_evaluations
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
	WHERE table_name = 'analytics_evaluations'
