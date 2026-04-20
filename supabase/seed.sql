-- =============================================================================
-- KFPS Hengsten Platform — Seed Data
-- Demo-hengsten om de applicatie te testen.
-- =============================================================================
-- Uitvoeren via SQL Editor in Supabase Dashboard, of:
--   supabase db push (voegt seed toe aan migraties)
-- =============================================================================

insert into public.stallions
  (name, stamboeknummer, birth_year, color, height_cm, sire_name, dam_name, damsire_name,
   predicates, stud_fee, owner_name, owner_contact, available, kfps_data)
values
  (
    'Alwin fan de Stjelp', 'KFPS 524', 2016, 'Zwart', 165.0,
    'Tsjalling 502', 'Wendy fan de Stjelp', 'Haitse 436',
    ARRAY['Kroon'], 950.00,
    'Stal de Stjelp', 'info@stalstjelp.nl', true,
    '{"inteelt_coefficient": 0.031, "kfps_goedkeuring": 2019}'
  ),
  (
    'Beart 454', 'KFPS 454', 2012, 'Zwart', 169.0,
    'Nane 354', 'Rosaline fan Groenhout', 'Bartele 292',
    ARRAY['Preferent', 'Model'], 1200.00,
    'Stoeterij Groenhout', 'contact@groenhout.nl', true,
    '{"inteelt_coefficient": 0.048, "kfps_goedkeuring": 2015}'
  ),
  (
    'Doaitsen fan Tinga', 'KFPS 501', 2014, 'Zwart', 162.0,
    'Onne 374', 'Tinga fan Camstra', 'Leffert 468',
    ARRAY['Prestatie'], 750.00,
    'Fam. Tinga', 'doaitsen@tinga.nl', true,
    '{"inteelt_coefficient": 0.025, "kfps_goedkeuring": 2017}'
  ),
  (
    'Fabe 489', 'KFPS 489', 2013, 'Zwart', 171.0,
    'Leffert 468', 'Fabienne van Stal Dijkstra', 'Nanning 471',
    ARRAY['Kroon', 'Preferent'], 1450.00,
    'Stal Dijkstra', 'fabe@staldijkstra.nl', true,
    '{"inteelt_coefficient": 0.039, "kfps_goedkeuring": 2016}'
  ),
  (
    'Gjalt 444', 'KFPS 444', 2011, 'Zwart', 158.0,
    'Piter 490', 'Gjalda fan Wâldhiem', 'Jochem 302',
    ARRAY['Preferent'], 1100.00,
    'Wâldhiem Stoeterij', 'gjalt@waldhiem.nl', true,
    '{"inteelt_coefficient": 0.062, "kfps_goedkeuring": 2014}'
  ),
  (
    'Haitse fan Wâldhiem', 'KFPS 512', 2015, 'Zwart', 163.0,
    'Gjalt 444', 'Haisma fan it Heidezand', 'Rindert 496',
    ARRAY['Kroon'], 875.00,
    'Wâldhiem Stoeterij', 'haitse@waldhiem.nl', true,
    '{"inteelt_coefficient": 0.044, "kfps_goedkeuring": 2018}'
  ),
  (
    'Leffert 468', 'KFPS 468', 2013, 'Zwart', 166.0,
    'Mintse 384', 'Leffina van de Hoeve', 'Tsjalling 502',
    ARRAY['Preferent', 'Prestatie'], 1350.00,
    'Hoeve Leffert', 'info@hoeVeleffert.nl', true,
    '{"inteelt_coefficient": 0.028, "kfps_goedkeuring": 2016}'
  ),
  (
    'Maurus van Stal Dijkstra', 'KFPS 547', 2019, 'Zwart', 164.0,
    'Fabe 489', 'Maurina van Stal Dijkstra', 'Beart 454',
    ARRAY['Kroon'], 950.00,
    'Stal Dijkstra', 'maurus@staldijkstra.nl', true,
    '{"inteelt_coefficient": 0.019, "kfps_goedkeuring": 2022}'
  ),
  (
    'Nanning 471', 'KFPS 471', 2013, 'Zwart', 173.0,
    'Haitse 436', 'Nanninga fan de Slothoeve', 'Doeke 316',
    ARRAY['Preferent', 'Model'], 1600.00,
    'De Slothoeve', 'nanning@slothoeve.nl', true,
    '{"inteelt_coefficient": 0.055, "kfps_goedkeuring": 2016}'
  ),
  (
    'Quirijn van Wolfsberg', 'KFPS 555', 2020, 'Zwart', 162.0,
    'Maurus van Stal Dijkstra', 'Quirina van Wolfsberg', 'Leffert 468',
    ARRAY['Model'], 800.00,
    'Wolfsberg Stoeterij', 'quirijn@wolfsberg.nl', true,
    '{"inteelt_coefficient": 0.014, "kfps_goedkeuring": 2023}'
  );


-- =============================================================================
-- Stallion scores (exterieur + sport per hengst)
-- =============================================================================

-- Alwin fan de Stjelp
insert into public.stallion_scores (stallion_id, score_type, category, value, source, measured_at)
select id, 'exterieur', 'Hoofd & hals',   85, 'kfps', '2023-04-15'::date from public.stallions where stamboeknummer = 'KFPS 524'
union all
select id, 'exterieur', 'Bovenlijn',       88, 'kfps', '2023-04-15'::date from public.stallions where stamboeknummer = 'KFPS 524'
union all
select id, 'exterieur', 'Beenwerk',        82, 'kfps', '2023-04-15'::date from public.stallions where stamboeknummer = 'KFPS 524'
union all
select id, 'sport',     'Draf',            90, 'kfps', '2023-04-15'::date from public.stallions where stamboeknummer = 'KFPS 524'
union all
select id, 'sport',     'Stap',            87, 'kfps', '2023-04-15'::date from public.stallions where stamboeknummer = 'KFPS 524';

-- Beart 454
insert into public.stallion_scores (stallion_id, score_type, category, value, source, measured_at)
select id, 'exterieur', 'Hoofd & hals',   90, 'kfps', '2023-05-10'::date from public.stallions where stamboeknummer = 'KFPS 454'
union all
select id, 'exterieur', 'Bovenlijn',       93, 'kfps', '2023-05-10'::date from public.stallions where stamboeknummer = 'KFPS 454'
union all
select id, 'exterieur', 'Beenwerk',        91, 'kfps', '2023-05-10'::date from public.stallions where stamboeknummer = 'KFPS 454'
union all
select id, 'sport',     'Draf',            95, 'kfps', '2023-05-10'::date from public.stallions where stamboeknummer = 'KFPS 454'
union all
select id, 'sport',     'Stap',            89, 'kfps', '2023-05-10'::date from public.stallions where stamboeknummer = 'KFPS 454';

-- Fabe 489
insert into public.stallion_scores (stallion_id, score_type, category, value, source, measured_at)
select id, 'exterieur', 'Hoofd & hals',   94, 'kfps', '2023-03-22'::date from public.stallions where stamboeknummer = 'KFPS 489'
union all
select id, 'exterieur', 'Bovenlijn',       96, 'kfps', '2023-03-22'::date from public.stallions where stamboeknummer = 'KFPS 489'
union all
select id, 'exterieur', 'Beenwerk',        95, 'kfps', '2023-03-22'::date from public.stallions where stamboeknummer = 'KFPS 489'
union all
select id, 'sport',     'Draf',            97, 'kfps', '2023-03-22'::date from public.stallions where stamboeknummer = 'KFPS 489'
union all
select id, 'sport',     'Stap',            93, 'kfps', '2023-03-22'::date from public.stallions where stamboeknummer = 'KFPS 489';

-- Nanning 471
insert into public.stallion_scores (stallion_id, score_type, category, value, source, measured_at)
select id, 'exterieur', 'Hoofd & hals',   93, 'kfps', '2022-11-05'::date from public.stallions where stamboeknummer = 'KFPS 471'
union all
select id, 'exterieur', 'Bovenlijn',       92, 'kfps', '2022-11-05'::date from public.stallions where stamboeknummer = 'KFPS 471'
union all
select id, 'exterieur', 'Beenwerk',        94, 'kfps', '2022-11-05'::date from public.stallions where stamboeknummer = 'KFPS 471'
union all
select id, 'sport',     'Draf',            96, 'kfps', '2022-11-05'::date from public.stallions where stamboeknummer = 'KFPS 471'
union all
select id, 'sport',     'Stap',            91, 'kfps', '2022-11-05'::date from public.stallions where stamboeknummer = 'KFPS 471';

-- Leffert 468
insert into public.stallion_scores (stallion_id, score_type, category, value, source, measured_at)
select id, 'exterieur', 'Hoofd & hals',   88, 'kfps', '2023-06-18'::date from public.stallions where stamboeknummer = 'KFPS 468'
union all
select id, 'exterieur', 'Bovenlijn',       91, 'kfps', '2023-06-18'::date from public.stallions where stamboeknummer = 'KFPS 468'
union all
select id, 'exterieur', 'Beenwerk',        89, 'kfps', '2023-06-18'::date from public.stallions where stamboeknummer = 'KFPS 468'
union all
select id, 'sport',     'Draf',            93, 'kfps', '2023-06-18'::date from public.stallions where stamboeknummer = 'KFPS 468'
union all
select id, 'sport',     'Stap',            90, 'kfps', '2023-06-18'::date from public.stallions where stamboeknummer = 'KFPS 468';
