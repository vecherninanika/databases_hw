-- JSONB

drop table if exists person_2 cascade;

create table person_2
(
    id              int generated always as identity,
    name            text,
    telegram        jsonb,
    date_of_birth   date,
    grade           int
);

insert into person_2(name, telegram, date_of_birth, grade)
values 
('Nika',
'[
  {
    "phone": "12345",
    "account": "suonica"
  },
  {
    "phone": "67890",
    "account": "nika"
  }
]',
'2004-01-01', 11),
('Anya',
'[
  {
    "phone": "54210",
    "account": "annya"
  },
  {
    "phone": "4352346",
    "account": "anya_5"
  }
]',
'2010-02-02', 5);


-- добавление индекса
create index person_2_telegram on person_2 using gin (telegram);


-- ARRAY

drop table if exists task_2 cascade;
create table task_2
(
    id       int generated always as identity,
    subtasks text[],
    difficulty   text,
    answers  text[]
);

insert into task_2(subtasks, difficulty, answers)
values ('{area of circle, perimeter of square}', 'Easy', '{42.35, 42 sm}'),
       ('{Sum of three numbers, division of big numbers}', 'Easy', '{56, 36}');


-- добавление индекса
create index employee_subtasks on task_2 using gin (subtasks);
create index employee_answers on task_2 using gin (answers);
