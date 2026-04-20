-- =============================================================================
-- KFPS Hengsten Platform — Initial Schema
-- =============================================================================
-- Run via: supabase db push
-- Or paste directly in Supabase SQL editor (Dashboard → SQL Editor)
-- =============================================================================


-- =============================================================================
-- EXTENSIONS
-- =============================================================================
create extension if not exists "uuid-ossp";


-- =============================================================================
-- UTILITY: updated_at trigger function
-- =============================================================================
create or replace function handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;


-- =============================================================================
-- TABLE: profiles
-- Extension of auth.users — one row per registered user.
-- =============================================================================
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  full_name     text,
  stable_name   text,                    -- Stalsnaam / bedrijfsnaam
  location      text,                    -- Gemeente / regio
  phone         text,
  role          text not null default 'user'
                  check (role in ('user', 'admin')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function handle_updated_at();

comment on table  public.profiles           is 'Extended user profile, linked 1:1 to auth.users.';
comment on column public.profiles.role      is 'user = normal fokker, admin = KFPS beheerder.';
comment on column public.profiles.stable_name is 'Naam van de stoeterij of het bedrijf.';


-- =============================================================================
-- TABLE: mares
-- Fokmerries die toebehoren aan een gebruiker.
-- =============================================================================
create table if not exists public.mares (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles(id) on delete cascade,

  -- Identificatie
  name            text not null,
  stamboeknummer  text,                  -- KFPS stamboek nr (per user uniek)

  -- Basisgegevens
  birth_year      smallint check (birth_year between 1970 and 2100),
  color           text,
  height_cm       numeric(5,1) check (height_cm between 100 and 220),

  -- Afstamming (tekstvelden — later uitbreidbaar via kfps_data)
  sire_name       text,                  -- Vader
  dam_name        text,                  -- Moeder
  damsire_name    text,                  -- Moedervader

  -- Predicaten & kwalificaties
  predicates      text[] not null default '{}',   -- ['ster','kroon',...]

  -- Media & notities
  photo_url       text,
  notes           text,

  -- Ruimte voor toekomstige KFPS raw data (inteeltcoeff, pedigree JSON, etc.)
  kfps_data       jsonb not null default '{}',

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  -- Stamboeknummer is uniek per gebruiker (niet globaal)
  unique (user_id, stamboeknummer)
);

create trigger set_mares_updated_at
  before update on public.mares
  for each row execute function handle_updated_at();

create index idx_mares_user_id       on public.mares(user_id);
create index idx_mares_stamboeknummer on public.mares(stamboeknummer);
create index idx_mares_kfps_data     on public.mares using gin(kfps_data);

comment on table  public.mares                  is 'Fokmerries per gebruiker.';
comment on column public.mares.predicates        is 'Array van predicaten: ster, kroon, model, preferent, elite, etc.';
comment on column public.mares.kfps_data         is 'Vrij JSONB veld voor raw KFPS data (inteelt, volledige pedigree, etc).';
comment on column public.mares.stamboeknummer    is 'Uniek per gebruiker, niet globaal (fokker kan nr zelf invoeren).';


-- =============================================================================
-- TABLE: mare_scores
-- Lineaire, exterieur- en sportscores per merrie.
-- =============================================================================
create table if not exists public.mare_scores (
  id          uuid primary key default gen_random_uuid(),
  mare_id     uuid not null references public.mares(id) on delete cascade,

  -- Scoregroepering
  score_type  text not null
                check (score_type in ('exterieur', 'sport', 'gebruiksaanleg', 'lineair')),
  category    text not null,             -- bijv. 'hoofd', 'hals', 'bovenlijn', 'draf', 'stap'

  -- Waarde
  value       numeric(5,2) not null check (value >= 0 and value <= 100),

  -- Herkomst
  source      text not null default 'kfps'
                check (source in ('kfps', 'eigen_meting', 'keuring')),
  measured_at date,

  created_at  timestamptz not null default now()
);

create index idx_mare_scores_mare_id on public.mare_scores(mare_id);
create index idx_mare_scores_type    on public.mare_scores(score_type);

comment on table  public.mare_scores            is 'Score-metingen per merrie (exterieur, sport, lineair).';
comment on column public.mare_scores.value       is 'Score 0–100. Voor lineaire scores (1–9) optioneel normaliseren in app.';
comment on column public.mare_scores.source      is 'kfps = officieel, eigen_meting = fokker zelf, keuring = keuringsdag.';


-- =============================================================================
-- TABLE: stallions
-- KFPS-goedgekeurde dekhengsten — gedeeld voor alle gebruikers.
-- Beheerd door admins (of via toekomstige KFPS data-import).
-- =============================================================================
create table if not exists public.stallions (
  id              uuid primary key default gen_random_uuid(),

  -- Identificatie
  name            text not null,
  stamboeknummer  text unique,           -- Globaal uniek voor hengsten

  -- Basisgegevens
  birth_year      smallint check (birth_year between 1950 and 2100),
  color           text,
  height_cm       numeric(5,1) check (height_cm between 100 and 220),

  -- Afstamming
  sire_name       text,
  dam_name        text,
  damsire_name    text,

  -- Predicaten
  predicates      text[] not null default '{}',

  -- Media
  photo_url       text,

  -- Dekgeld & eigenaar
  stud_fee        numeric(10,2) check (stud_fee >= 0),
  owner_name      text,
  owner_contact   text,

  -- Beschikbaarheid
  available       boolean not null default true,

  -- Raw KFPS data (inteelt, volledige pedigree, goedkeuringsdata, etc.)
  kfps_data       jsonb not null default '{}',

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger set_stallions_updated_at
  before update on public.stallions
  for each row execute function handle_updated_at();

create index idx_stallions_stamboeknummer on public.stallions(stamboeknummer);
create index idx_stallions_available      on public.stallions(available);
create index idx_stallions_kfps_data      on public.stallions using gin(kfps_data);

comment on table  public.stallions               is 'KFPS-goedgekeurde dekhengsten. Read-only voor normale gebruikers.';
comment on column public.stallions.kfps_data      is 'Vrij JSONB veld: inteeltcoëff, nakomelingendata, goedkeuringsdossier, etc.';
comment on column public.stallions.stud_fee       is 'Dekgeld in euro per dekking.';


-- =============================================================================
-- TABLE: stallion_scores
-- Scores per hengst — zelfde structuur als mare_scores.
-- =============================================================================
create table if not exists public.stallion_scores (
  id          uuid primary key default gen_random_uuid(),
  stallion_id uuid not null references public.stallions(id) on delete cascade,

  score_type  text not null
                check (score_type in ('exterieur', 'sport', 'gebruiksaanleg', 'lineair')),
  category    text not null,

  value       numeric(5,2) not null check (value >= 0 and value <= 100),

  source      text not null default 'kfps'
                check (source in ('kfps', 'eigen_meting', 'keuring')),
  measured_at date,

  created_at  timestamptz not null default now()
);

create index idx_stallion_scores_stallion_id on public.stallion_scores(stallion_id);
create index idx_stallion_scores_type        on public.stallion_scores(score_type);

comment on table public.stallion_scores is 'Score-metingen per hengst (exterieur, sport, lineair).';


-- =============================================================================
-- TRIGGER: auto-create profile on new user registration
-- =============================================================================
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', null)
  );
  return new;
end;
$$ language plpgsql security definer;

-- Drop first in case of re-run
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

comment on function handle_new_user() is 'Maakt automatisch een profiel aan voor elke nieuwe auth-gebruiker.';


-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

alter table public.profiles        enable row level security;
alter table public.mares           enable row level security;
alter table public.mare_scores     enable row level security;
alter table public.stallions       enable row level security;
alter table public.stallion_scores enable row level security;


-- ── profiles ──────────────────────────────────────────────────────────────
-- Gebruiker ziet/bewerkt alleen zijn eigen profiel.
create policy "profiles: eigen profiel lezen"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles: eigen profiel bijwerken"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Admin: volledige toegang (rol wordt later uitgebreid)
create policy "profiles: admin alles"
  on public.profiles for all
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- ── mares ─────────────────────────────────────────────────────────────────
create policy "mares: eigen merries lezen"
  on public.mares for select
  using (auth.uid() = user_id);

create policy "mares: eigen merries toevoegen"
  on public.mares for insert
  with check (auth.uid() = user_id);

create policy "mares: eigen merries bijwerken"
  on public.mares for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "mares: eigen merries verwijderen"
  on public.mares for delete
  using (auth.uid() = user_id);

create policy "mares: admin alles"
  on public.mares for all
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- ── mare_scores ────────────────────────────────────────────────────────────
-- Via join op mares.user_id controleren.
create policy "mare_scores: scores van eigen merries lezen"
  on public.mare_scores for select
  using (
    exists (
      select 1 from public.mares m
      where m.id = mare_scores.mare_id and m.user_id = auth.uid()
    )
  );

create policy "mare_scores: scores eigen merries toevoegen"
  on public.mare_scores for insert
  with check (
    exists (
      select 1 from public.mares m
      where m.id = mare_scores.mare_id and m.user_id = auth.uid()
    )
  );

create policy "mare_scores: scores eigen merries bijwerken"
  on public.mare_scores for update
  using (
    exists (
      select 1 from public.mares m
      where m.id = mare_scores.mare_id and m.user_id = auth.uid()
    )
  );

create policy "mare_scores: scores eigen merries verwijderen"
  on public.mare_scores for delete
  using (
    exists (
      select 1 from public.mares m
      where m.id = mare_scores.mare_id and m.user_id = auth.uid()
    )
  );

create policy "mare_scores: admin alles"
  on public.mare_scores for all
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- ── stallions ──────────────────────────────────────────────────────────────
-- Alle ingelogde gebruikers mogen hengsten lezen.
-- Schrijven is alleen voor admins (beheer via Supabase dashboard of toekomstige import).
create policy "stallions: iedereen mag lezen"
  on public.stallions for select
  using (auth.role() = 'authenticated');

create policy "stallions: admin alles"
  on public.stallions for all
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- ── stallion_scores ────────────────────────────────────────────────────────
create policy "stallion_scores: iedereen mag lezen"
  on public.stallion_scores for select
  using (auth.role() = 'authenticated');

create policy "stallion_scores: admin alles"
  on public.stallion_scores for all
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role = 'admin'
    )
  );


-- =============================================================================
-- DONE
-- =============================================================================
