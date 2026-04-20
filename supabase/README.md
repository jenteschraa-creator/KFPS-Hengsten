# Supabase — Database Setup

## Verbindingsgegevens

| Parameter      | Waarde                                      |
|----------------|---------------------------------------------|
| Project URL    | `https://uiqnlivjhqcxvgjzugcn.supabase.co` |
| Pooler host    | `aws-0-eu-west-1.pooler.supabase.com`       |
| Pooler port    | `5432` (session mode, ondersteunt DDL)      |
| Database user  | `postgres.uiqnlivjhqcxvgjzugcn`             |
| Database       | `postgres`                                  |

> Sla het database wachtwoord op in een `.env` bestand (nooit committen naar git).

---

## Benodigdheden

- [Supabase CLI](https://supabase.com/docs/guides/cli) geïnstalleerd (`npm install -g supabase`)
- Je bent ingelogd: `supabase login`
- Project is gelinkt: `supabase link --project-ref <jouw-project-ref>`

De project-ref vind je in Supabase Dashboard → Project Settings → General.

---

## Migraties uitvoeren

### Optie A — Via Supabase CLI (aanbevolen)

```bash
# Eenmalig linken aan je remote project
supabase link --project-ref <project-ref>

# Migratie pushen naar remote database
supabase db push
```

### Optie B — Handmatig in SQL Editor

1. Ga naar [supabase.com/dashboard](https://supabase.com/dashboard) → jouw project
2. Klik op **SQL Editor** → **New query**
3. Plak de inhoud van `migrations/20240120000000_initial_schema.sql`
4. Klik **Run**

---

## TypeScript types regenereren

Na elke schema-wijziging (nieuwe migratie) kun je de types automatisch laten genereren:

```bash
supabase gen types typescript --linked > types/database.ts
```

> De huidige `types/database.ts` is handmatig geschreven op basis van het schema.
> Na het uitvoeren van bovenstaand commando wordt hij overschreven met de automatische versie.

---

## Nieuwe migratie aanmaken

```bash
supabase migration new <naam_van_de_migratie>
# Voorbeeld:
supabase migration new add_matching_scores
```

Dit maakt een nieuw bestand aan in `supabase/migrations/` met een automatische timestamp.

---

## Admin-rol toekennen

Een gebruiker admin maken doe je direct in de database:

```sql
update public.profiles
set role = 'admin'
where id = '<uuid-van-de-gebruiker>';
```

De UUID vind je in Supabase Dashboard → Authentication → Users.

---

## Schema-overzicht

| Tabel             | Beschrijving                                      | RLS             |
|-------------------|---------------------------------------------------|-----------------|
| `profiles`        | Uitbreiding op auth.users (naam, stal, etc.)       | Eigen rij only  |
| `mares`           | Fokmerries per gebruiker                          | Eigen rijen only|
| `mare_scores`     | Exterieur/sport/lineair scores per merrie          | Via mare-eigenaar|
| `stallions`       | KFPS dekhengsten (gedeeld, admin beheert)          | Read voor iedereen|
| `stallion_scores` | Scores per hengst                                 | Read voor iedereen|

---

## Vervolgstappen

1. **Seed data** — Voeg de demo-hengsten uit `hengsten.html` toe aan de `stallions` tabel zodat de app echte data toont. Zie `migrations/` voor een toekomstig `seed.sql` bestand.

2. **Storage bucket** — Maak een `photos` bucket aan in Supabase Storage voor paard-foto's (`photo_url` velden). Stel RLS in zodat gebruikers alleen naar hun eigen map kunnen uploaden (`users/{user_id}/`).

3. **Supabase client helpers** — Maak `lib/supabase.ts` aan met een getypte client:
   ```typescript
   import { createClient } from '@supabase/supabase-js'
   import type { Database } from '../types/database'

   export const supabase = createClient<Database>(
     process.env.SUPABASE_URL!,
     process.env.SUPABASE_ANON_KEY!
   )
   ```

4. **Matching algoritme** — Voeg later een `match_scores` tabel toe (merrie_id, stallion_id, score, berekend_op) voor opgeslagen matchresultaten.

5. **kfps_data invullen** — Zodra KFPS een data-export levert, kunnen inteeltcoëfficiënten, volledige pedigrees en keuringsdata via de `kfps_data` JSONB kolom worden ingeladen zonder schema-wijziging.
