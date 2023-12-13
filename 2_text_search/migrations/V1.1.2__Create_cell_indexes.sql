create index topic_topic on topic using btree(topic);
create index topic_studentsbook on topic using btree(studentsbook, topic);
create index topic_page on topic using hash(page);