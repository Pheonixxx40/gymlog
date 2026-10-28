-- GymLog Supabase schema
-- Run this entire file in Supabase Dashboard -> SQL Editor -> New query.
-- Row Level Security ensures each signed-in user can access only their own sessions.

create extension if not exists pgcrypto;

create table if not exists public.workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_date date not null default current_date,
  day_key text not null check (day_key in ('mon','tue','wed','thu','sat')),
  workout_name text not null,
  bodyweight_kg numeric(5,2),
  sleep_hours numeric(4,2),
  energy smallint check (energy between 1 and 5),
  cardio_minutes integer check (cardio_minutes >= 0),
  avg_hr integer check (avg_hr between 30 and 250),
  max_hr integer check (max_hr between 30 and 250),
  session_rpe smallint check (session_rpe between 1 and 10),
  abs_done boolean not null default false,
  notes text not null default '',
  exercises jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists workout_sessions_user_date_idx
  on public.workout_sessions (user_id, session_date desc);

alter table public.workout_sessions enable row level security;

drop policy if exists "Users can read their own workout sessions" on public.workout_sessions;
create policy "Users can read their own workout sessions"
  on public.workout_sessions for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert their own workout sessions" on public.workout_sessions;
create policy "Users can insert their own workout sessions"
  on public.workout_sessions for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own workout sessions" on public.workout_sessions;
create policy "Users can update their own workout sessions"
  on public.workout_sessions for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own workout sessions" on public.workout_sessions;
create policy "Users can delete their own workout sessions"
  on public.workout_sessions for delete to authenticated
  using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.workout_sessions to authenticated;
