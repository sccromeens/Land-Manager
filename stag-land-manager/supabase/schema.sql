-- SCHEMA: stag_land_manager
-- Creates core tables, role column, and basic RLS. Run this first.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  full_name text,
  role text check (role in ('admin','chief','landman','client')) default 'client',
  created_at timestamp with time zone default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  area text,
  status text default 'active',
  progress int default 0 check (progress between 0 and 100),
  created_by uuid references public.profiles(id),
  created_at timestamp with time zone default now()
);

create table if not exists public.lessors (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  email text,
  phone text,
  created_at timestamp with time zone default now()
);

create table if not exists public.landmen (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete set null,
  notes text,
  created_at timestamp with time zone default now()
);

create table if not exists public.tracts (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  name text not null,
  owner_id uuid references public.lessors(id),
  locked_by_landman uuid references public.landmen(id),
  created_at timestamp with time zone default now()
);

create table if not exists public.assignments (
  id uuid primary key default gen_random_uuid(),
  tract_id uuid references public.tracts(id) on delete cascade,
  landman_id uuid references public.landmen(id) on delete cascade,
  assigned_by uuid references public.profiles(id),
  created_at timestamp with time zone default now(),
  unique (tract_id, landman_id)
);

create table if not exists public.runsheets (
  id uuid primary key default gen_random_uuid(),
  tract_id uuid references public.tracts(id) on delete cascade,
  row_no int not null,
  doc_type text,
  party text,
  recorded_date date,
  notes text,
  created_at timestamp with time zone default now()
);

create table if not exists public.runsheet_audit (
  id bigserial primary key,
  runsheet_id uuid references public.runsheets(id) on delete cascade,
  action text,
  changed_by uuid references public.profiles(id),
  changed_at timestamp with time zone default now(),
  payload jsonb
);

create table if not exists public.files (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id),
  name text,
  url text,
  visibility text check (visibility in ('team','project','private')) default 'project',
  created_by uuid references public.profiles(id),
  created_at timestamp with time zone default now()
);

create table if not exists public.invoices (
  id uuid primary key default gen_random_uuid(),
  created_by uuid references public.profiles(id),
  month int check (month between 1 and 12),
  year int,
  mileage numeric default 0,
  other numeric default 0,
  total numeric generated always as (coalesce(mileage,0)+coalesce(other,0)) stored,
  created_at timestamp with time zone default now()
);

-- Enable RLS
alter table public.profiles enable row level security;
alter table public.projects enable row level security;
alter table public.lessors enable row level security;
alter table public.landmen enable row level security;
alter table public.tracts enable row level security;
alter table public.assignments enable row level security;
alter table public.runsheets enable row level security;
alter table public.runsheet_audit enable row level security;
alter table public.files enable row level security;
alter table public.invoices enable row level security;

-- RLS policies (simple, role-based). Adjust as needed.
-- Profiles: users can view self; admins can view all.
create policy "profiles self view" on public.profiles
for select using ( auth.uid() = id or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin') );

create policy "profiles self update" on public.profiles
for update using ( auth.uid() = id or exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin') );

-- Projects: admins create/update; chiefs & above read all; landmen/clients read if assigned via tracts/invitations (simplified here: everyone can read)
create policy "projects read" on public.projects for select using ( true );
create policy "projects admin write" on public.projects for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin')) );

-- Lessors/Tracts/Assignments: read for all; write for admin/chief
create policy "lessors read" on public.lessors for select using ( true );
create policy "lessors write admin chief" on public.lessors for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','chief')) );

create policy "tracts read" on public.tracts for select using ( true );
create policy "tracts write admin chief" on public.tracts for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','chief')) );

create policy "assignments read" on public.assignments for select using ( true );
create policy "assignments write admin chief" on public.assignments for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','chief')) );

-- Runsheets: read all; insert/update admin/chief/landman
create policy "runsheets read" on public.runsheets for select using ( true );
create policy "runsheets write" on public.runsheets for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','chief','landman')) );

create policy "runsheet audit read" on public.runsheet_audit for select using ( true );
create policy "runsheet audit write admin" on public.runsheet_audit for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin')) );

-- Files: read all; write admin/chief/landman
create policy "files read" on public.files for select using ( true );
create policy "files write" on public.files for all using ( exists (select 1 from public.profiles p where p.id = auth.uid() and p.role in ('admin','chief','landman')) );

-- Invoices: read all; write self or admin
create policy "invoices read" on public.invoices for select using ( true );
create policy "invoices write" on public.invoices for all using (
  exists (select 1 from public.profiles p where p.id = auth.uid() and (p.role = 'admin' or p.id = invoices.created_by))
);

-- Helper function to upsert profile from auth
create or replace function public.handle_new_user() returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name', 'client')
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
