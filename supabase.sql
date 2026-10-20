-- Выполните целиком в Supabase: SQL Editor -> New query -> Run

create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) > 0),
  vk_url text,
  created_at timestamptz not null default now()
);

create table if not exists combo_status (
  combo_key text primary key,        -- ID участников, отсортированные и склеенные через запятую
  done boolean not null default false,
  updated_at timestamptz not null default now()
);

alter table players enable row level security;
alter table combo_status enable row level security;

-- Доступ без авторизации для всех, у кого есть ссылка на сайт (командный инструмент)
create policy "players_all" on players for all using (true) with check (true);
create policy "combo_status_all" on combo_status for all using (true) with check (true);

-- Обновления в реальном времени
alter publication supabase_realtime add table players;
alter publication supabase_realtime add table combo_status;
