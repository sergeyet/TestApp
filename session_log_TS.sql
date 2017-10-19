with ts123
as
(
--select to_date('01.02.2011','dd.mm.yyyy') dt from dual
select trunc(CURRENT_DATE) - 0 dt from dual
)

select * from (
select t.date_start, to_char(t.date_start, 'hh24:mi:ss') time_start, /* t.date_finish,*/
trunc((t.date_finish - t.date_start) * 24 * 60, 2) time_sec,
ft.event_type_desc,
t.who_started || '-->' || t.event_comment t,
t.event_id,
1E28 err_id,
'event' sel_type
from tsdb2.frs_event t, tsdb2.frs_event_type ft, ts
where ft.event_type_code = t.event_type_code --and t.event_id >= (select max(event_id) from frs_event where event_type_code = 7000)
and trunc(t.date_start) >= ts.dt
union
select t.date_start, to_char(fr.err_date, 'hh24:mi:ss') time_start, /*null,*/
null,
null,
to_char(fr.err_level) || fr.err_text t,
t.event_id,
fr.err_id,
'error' sel_type
from tsdb2.frs_event t, tsdb2.frs_err fr, ts
where fr.event_id = t.event_id --and fr.err_code = fr.err_code --and t.event_id >= (select max(event_id) from frs_event where event_type_code = 7000)
and trunc(t.date_start) >= ts.dt
)
--where date_start <= to_date('16102008','ddmmyyyy')
--where t like '%bid_init_pair%'
order by event_id desc, err_id desc, sel_type desc

