



/*
declare @vNewKey int
exec Analytics.dbo.sp_get_next_surrogate_key 'test_table', @vNewKey OUTPUT
select @vNewKey


select *,  ROW_NUMBER () OVER (ORDER BY WorkOutKey) AS RowCounter 
into #tempWorkoutFinal 
from #tempWorkout
select @vRowCount = COUNT(*) from #tempWorkoutFinal 

 

-- Get the next surrogate key blocks
exec [spGetNextSurrogateKeyBlock] 'tStgWorkout', @vRowCount, @vWorkoutKey OUTPUT

 

update #tempWorkoutFinal Set WorkoutKey =  @vWorkoutKey + RowCounter -1 

 

update #tempMeasurable Set WorkOutKey = #tempWorkoutFinal.WorkoutKey 
from #tempWorkoutFinal where #tempMeasurable.APTID = #tempWorkoutFinal.APTID
*/

	select *
	from [BaneProductionAnalytics].[dbo].[reports]
	where id = 51992868


	SELECT 300000 AS [id] --jeremy procedure
		,70 AS [author_id] --67 is sandy, 70 is krawiec, 140 is yam, 139 is mallepalle
		,48 AS [grade_id] --model grade
		,46 --position blt turned into translation
		,'analytics-pro' AS [type]
		,0 AS [submitted]
		,GETDATE() AS [created_at]
		,GETDATE() AS [updated_at]
		,7037 --bane player id
		,'DE43' AS [alignment] --position blt concat everything from positions table.
		,0 AS [imported_with_errors]
		,0 AS [is_deleted]
		,NULL AS [exposure]
		,NULL AS [import_key]
		,NULL AS [revised_overall_grade_id]
		,NULL AS [legacy_grade]
		,NULL AS [stratbridge_season_id]
		,0 AS [incomplete]
		,NULL AS [all_star_game_id]
	FROM [BaneProductionAnalytics].[dbo].[reports]



	SELECT TOP (1000) ev.[id]
		,[skill_id]
		,[grade_id]
		,[report_id]
		,[explanation]
		,NULL AS created_at
		,NULL AS updated_at
		,[is_deleted]
		,[interview_id]
		,[advance_id]
		,sk.*
	FROM [BaneProductionAnalytics].[dbo].[evaluations] ev
	inner join BaneProductionAnalytics.dbo.skills sk
	on ev.skill_id = sk.id and sk.disabled = 0
	WHERE report_id = 51995156




SELECT TOP (1000) [id]
      ,[report_id]
      ,[position_id]
  FROM [BaneProductionAnalytics].[dbo].[positions_reports]
  WHERE REPORT_ID =  51995156

  SELECT [report_id]
      ,count(*)
  FROM [BaneProductionAnalytics].[dbo].[positions_reports]
 group by report_id
 order by count(*) desc


  select *
  from BaneProductionAnalytics.dbo.positions_skills
  where skill_id = 1528



select top 10 * from Analytics.dbo.analysis_players_contracts_NEW where
nfl_contract_id in (224565,227935, 235290)
order by signing_date


select *
from BaneProductionAnalytics.dbo.skills
where name  like '%cover%'

select *
from BaneProductionAnalytics.dbo.positions po
WHERE code = 'de43'


	select sk.*
		,po.*
	from BaneProductionAnalytics.dbo.positions_skills ps
	INNER JOIN BaneProductionAnalytics.dbo.positions po
		ON ps.position_id = po.id
		AND po.deactivated = 0
	INNER JOIN BaneProductionAnalytics.dbo.skills sk
		ON ps.skill_id = sk.id
		and sk.[disabled] = 0
	WHERE po.CODE = 'te'

		and SK.name LIKE '%SUMMARY%'

		select *
		from Analytics.dbo.map_regressed_statistic_position po
		inner join Analytics.dbo.map_regressed_statistic_type ty
			ON po.regressed_statistic_type_id = ty.id



	SELECT nfl_player_id
		,season
		,season_type_adjusted
		,statistic_id
		,ty.code
		,statistic_grade
		,statistic_percentile
	FROM Analytics.dbo.r_output_regressed_statistics rs
	INNER JOIN Analytics.dbo.map_regressed_statistic_type ty
		ON rs.statistic_id = ty.id
	WHERE season_type_adjusted = 'REGPOST'
		AND rolling_game_stats = 0
		AND nfl_player_id = 38589
		AND season = 2019





	SELECT TOP (1000) ev.[id]
		,[skill_id]
		,[grade_id]
		,[report_id]
		,[explanation]
		,NULL AS created_at
		,NULL AS updated_at
		,[is_deleted]
		,[interview_id]
		,[advance_id]
		,sk.*
	FROM [BaneProductionAnalytics].[dbo].[evaluations] ev
	inner join BaneProductionAnalytics.dbo.skills sk
	on ev.skill_id = sk.id and sk.disabled = 0
	WHERE report_id = 51995156
	and sk.name like '%summary%'

