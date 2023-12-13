-- Задачник: пользователь может решить много задач, каждую задачу может решить много пользователей. Задачи могут быть объединены в группы

drop table if exists person, task, person_to_task, topic;

create table person
(
	id int primary key generated always as identity,
    name  text not null,
    phone text,
    date_of_birth    date,
    grade  int
);

insert into person(name, phone, date_of_birth, grade)
values ('Nika', '1234', '2004-01-01', 11), 
	   ('Anya', '54210', '2010-02-02', 5),
	   ('Katya', '5678', '2006-12-07', 10);


create table topic
(
	id int primary key generated always as identity,
    topic     		text not null,
    studentsbook	text,
    page     		int,
    website	  		text
);

insert into topic(topic, studentsbook, page, website)
values ('Geometry', 'Baranov geometry', 3, 'geometry.ru'),
       ('Arithmetics', 'Ivanov - Easy counting', 31, 'calculator.ru'),
       ('Law of probability', 'Petrov - Law of probability', 45, 'probability-law-tasks.ru'),
       ('Motion', 'Peterson mathematics', 56, 'speed-time-way.ru');

create table task
(
	id           int primary key generated always as identity,
    task         text not null,
    difficulty   text,
    topic_id     int REFERENCES topic(id),
    answer       text
);

insert into task(task, difficulty, topic_id, answer)
values ('Area of circle', 'Easy', 1, '42.35'),
       ('Sum of three numbers', 'Easy', 2, '56'),
       ('Probability of passing the exam', 'Hard', 3, '1%'),
       ('Ways to reach the destination', 'Medium', 4, '567'),
       ('Speed of a motorcicle', 'Easy', 4, '60 km per hour'),
       ('Perimeter of square', 'Easy', 1, '42 sm'),
       ('Division of big numbers', 'Medium', 2, '36, 48, 33, 76'),
       ('Division of big number', 'Medium', 2, '36, 48, 33, 76');


CREATE TABLE person_to_task
(
	id int primary key generated always as identity,
	person_id int REFERENCES person(id),
	task_id int REFERENCES task(id)
);

insert into person_to_task(person_id, task_id)
values (1, 2),
       (2, 2),
       (1, 3),
       (3, 7),
       (3, 6);

