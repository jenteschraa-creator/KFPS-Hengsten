-- =============================================================================
-- Fix: Infinite recursion in admin RLS policies
-- =============================================================================
-- The original admin policies used EXISTS (SELECT 1 FROM profiles WHERE ...)
-- which caused infinite recursion when the anon role queried any table,
-- because checking profiles triggered the profiles admin policy again.
--
-- Solution: security definer function that bypasses RLS when checking admin role.
-- =============================================================================

-- Security definer function: check admin without triggering RLS recursion
create or replace function public.is_admin()
returns boolean language sql security definer stable as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;


-- ── profiles ──────────────────────────────────────────────────────────────
-- Allow users to create their own profile (needed for users pre-dating the trigger)
create policy "profiles: eigen profiel aanmaken"
  on public.profiles for insert
  with check (auth.uid() = id);

drop policy if exists "profiles: admin alles" on public.profiles;
create policy "profiles: admin alles"
  on public.profiles for all
  using (public.is_admin());


-- ── mares ─────────────────────────────────────────────────────────────────
drop policy if exists "mares: admin alles" on public.mares;
create policy "mares: admin alles"
  on public.mares for all
  using (public.is_admin());


-- ── mare_scores ────────────────────────────────────────────────────────────
drop policy if exists "mare_scores: admin alles" on public.mare_scores;
create policy "mare_scores: admin alles"
  on public.mare_scores for all
  using (public.is_admin());


-- ── stallions ──────────────────────────────────────────────────────────────
-- Also open stallion reads to anon (public KFPS data, no auth needed)
drop policy if exists "stallions: iedereen mag lezen" on public.stallions;
create policy "stallions: iedereen mag lezen"
  on public.stallions for select
  using (true);

drop policy if exists "stallions: admin alles" on public.stallions;
create policy "stallions: admin alles"
  on public.stallions for all
  using (public.is_admin());


-- ── stallion_scores ────────────────────────────────────────────────────────
drop policy if exists "stallion_scores: iedereen mag lezen" on public.stallion_scores;
create policy "stallion_scores: iedereen mag lezen"
  on public.stallion_scores for select
  using (true);

drop policy if exists "stallion_scores: admin alles" on public.stallion_scores;
create policy "stallion_scores: admin alles"
  on public.stallion_scores for all
  using (public.is_admin());
