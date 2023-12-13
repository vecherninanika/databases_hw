create extension if not exists pg_trgm;
create index ngram_text_search on task using gin(task gin_trgm_ops);

create extension if not exists fuzzystrmatch;
