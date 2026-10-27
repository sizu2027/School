-- ============================================================
-- স্কুল + অফিস ম্যানেজমেন্ট ওয়েবসাইট — Supabase টেবিল ও RLS
-- চালান: Supabase Dashboard → SQL Editor → New query → Run
-- স্ক্রিপ্টটি একাধিকবার চালানো নিরাপদ (if not exists / drop policy)।
-- ============================================================

create table if not exists public.students (
  id text primary key,
  name text not null default '',
  cls text default '',
  roll integer,
  section text default '',
  guardian text default '',
  phone text default '',
  payable numeric not null default 0,
  paid numeric not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists public.teachers (
  id text primary key,
  name text not null default '',
  subject text default '',
  phone text default '',
  qualification text default '',
  photo text default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.notices (
  id text primary key,
  title text not null default '',
  body text default '',
  date text default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.fees (
  id text primary key,
  student_id text not null,
  payable numeric not null default 0,
  paid numeric not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists public.attendance (
  id text primary key,
  att_date text not null,
  cls text default '',
  student_id text not null,
  status text not null default 'P',
  updated_at timestamptz not null default now()
);

alter table public.students enable row level security;
alter table public.teachers enable row level security;
alter table public.notices enable row level security;
alter table public.fees enable row level security;
alter table public.attendance enable row level security;

-- নীতি: publishable (anon) key ও লগইন-করা ব্যবহারকারী — দুজনেই পড়তে/লিখতে পারবে।
-- সতর্কতা: সহজ এই নীতি নিজের স্কুলের ব্যবহারের জন্য; চাইলে পরে শুধু
-- authenticated ভূমিকার জন্য সীমিত করুন। service_role key কখনো শেয়ার করবেন না।
drop policy if exists "school_all_access" on public.students;
create policy "school_all_access" on public.students for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.teachers;
create policy "school_all_access" on public.teachers for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.notices;
create policy "school_all_access" on public.notices for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.fees;
create policy "school_all_access" on public.fees for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.attendance;
create policy "school_all_access" on public.attendance for all to anon, authenticated using (true) with check (true);

-- ============================================================
-- অফিস ম্যানেজমেন্ট — টেবিল ও RLS
-- ============================================================

create table if not exists public.employees (
  id text primary key,
  name text not null default '',
  dept text default '',
  designation text default '',
  phone text default '',
  email text default '',
  salary numeric not null default 0,
  join_date text default '',
  status text default 'সক্রিয়',
  updated_at timestamptz not null default now()
);

create table if not exists public.departments (
  id text primary key,
  name text not null default '',
  head text default '',
  note text default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.office_attendance (
  id text primary key,
  att_date text not null,
  emp_id text not null,
  status text not null default 'P',
  updated_at timestamptz not null default now()
);

create table if not exists public.leaves (
  id text primary key,
  emp_id text not null,
  type text default '',
  from_date text default '',
  to_date text default '',
  reason text default '',
  status text not null default 'pending',
  updated_at timestamptz not null default now()
);

create table if not exists public.payroll (
  id text primary key,
  emp_id text not null,
  month text default '',
  basic numeric not null default 0,
  allowance numeric not null default 0,
  deduction numeric not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id text primary key,
  title text not null default '',
  emp_id text default '',
  due text default '',
  priority text default 'মাঝারি',
  status text not null default 'চলমান',
  updated_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id text primary key,
  title text not null default '',
  category text default '',
  amount numeric not null default 0,
  exp_date text default '',
  note text default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.office_docs (
  id text primary key,
  title text not null default '',
  category text default '',
  doc_date text default '',
  note text default '',
  updated_at timestamptz not null default now()
);

alter table public.employees enable row level security;
alter table public.departments enable row level security;
alter table public.office_attendance enable row level security;
alter table public.leaves enable row level security;
alter table public.payroll enable row level security;
alter table public.tasks enable row level security;
alter table public.expenses enable row level security;
alter table public.office_docs enable row level security;

drop policy if exists "school_all_access" on public.employees;
create policy "school_all_access" on public.employees for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.departments;
create policy "school_all_access" on public.departments for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.office_attendance;
create policy "school_all_access" on public.office_attendance for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.leaves;
create policy "school_all_access" on public.leaves for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.payroll;
create policy "school_all_access" on public.payroll for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.tasks;
create policy "school_all_access" on public.tasks for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.expenses;
create policy "school_all_access" on public.expenses for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.office_docs;
create policy "school_all_access" on public.office_docs for all to anon, authenticated using (true) with check (true);

-- ============================================================
-- শিক্ষার্থীর বার্ষিক খরচ — টেবিল ও RLS
-- ============================================================

create table if not exists public.cost_types (
  id text primary key,
  name text not null default '',
  amount numeric not null default 0,
  is_custom boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.student_costs (
  id text primary key,
  student_id text not null,
  cost_type_id text default '',
  name text not null default '',
  amount numeric not null default 0,
  paid numeric not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.cost_types enable row level security;
alter table public.student_costs enable row level security;

drop policy if exists "school_all_access" on public.cost_types;
create policy "school_all_access" on public.cost_types for all to anon, authenticated using (true) with check (true);
drop policy if exists "school_all_access" on public.student_costs;
create policy "school_all_access" on public.student_costs for all to anon, authenticated using (true) with check (true);
