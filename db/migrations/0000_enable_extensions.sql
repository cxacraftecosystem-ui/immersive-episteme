CREATE EXTENSION IF NOT EXISTS pg_trgm;--> statement-breakpoint
CREATE EXTENSION IF NOT EXISTS vector;--> statement-breakpoint
CREATE EXTENSION IF NOT EXISTS pgcrypto;
--> statement-breakpoint
DO $$
BEGIN
  IF current_setting('server_version_num')::int < 180000 AND to_regprocedure('uuidv7()') IS NULL THEN
    CREATE FUNCTION public.uuidv7() RETURNS uuid LANGUAGE sql VOLATILE AS
      'SELECT encode(set_bit(set_bit(overlay(uuid_send(gen_random_uuid()) PLACING substring(int8send(floor(extract(epoch FROM clock_timestamp()) * 1000)::bigint) FROM 3) FROM 1 FOR 6), 52, 1), 53, 1), ''hex'')::uuid';
  END IF;
END $$;
