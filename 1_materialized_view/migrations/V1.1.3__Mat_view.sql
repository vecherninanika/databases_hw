create materialized view tasks_view as
with task_with_topic as (
        select
        t.id,
        t.task,
        t.difficulty,
        t.answer,
        coalesce(
            json_agg(
                json_build_object('topic', tp.topic, 'studentsbook', tp.studentsbook)
            ) filter (where tp.studentsbook is not null),
            '[]') as topics
        from task t left join topic tp on t.topic_id = tp.id
        group by t.id, t.task, t.difficulty, t.answer
        ),
    task_with_person as (
        select task_id,
        coalesce(
            json_agg(
                json_build_object('name', p.name, 'phone', p.phone)
            ),
        '[]') as persons
        from person_to_task pt join person p on p.id = pt.person_id
        group by task_id
        )

select id, task, difficulty, answer, topics, coalesce(persons, '[]')
from task_with_topic twt join task_with_person twp
on twt.id = twp.task_id;


create unique index on tasks_view(id);

create function tasks_view_refresh()
    returns trigger as
$$
begin
    refresh materialized view concurrently tasks_view;
    return new;
end;
$$
        language 'plpgsql';

create trigger task_table_update
    after insert or update or delete
    on task
    for each row
    execute function tasks_view_refresh();
