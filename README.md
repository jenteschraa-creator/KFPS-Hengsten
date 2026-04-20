# KFPS Hengsten Platform

Fokkerijplatform voor Friese paarden — merrie-beheer, hengsten-overzicht, score-invoer en matchmaking.

## Projectstructuur

```
index.html              Login / landingspagina
dashboard.html          Gebruikersdashboard
merries.html            Overzicht eigen merries
merrie-toevoegen.html   Merrie toevoegen / bewerken
merrie-detail.html      Merrie detailpagina
hengsten.html           KFPS-goedgekeurde hengsten
hengst-detail.html      Hengst detailpagina + match
js/
  mare-config.js        Gedeelde predicaten & score-categorieën
supabase/
  migrations/           SQL-migraties (schema + RLS)
  seed.sql              Testdata (10 hengsten + scores)
types/
  database.ts           TypeScript types (gegenereerd vanuit schema)
```

## Lokale ontwikkeling

### 1. Vereisten

- Node.js (voor de lokale dev-server en screenshots)
- Een Supabase project (gratis tier volstaat)

### 2. Omgevingsvariabelen instellen

Kopieer `.env.example` naar `.env.local` en vul je eigen Supabase-gegevens in:

```bash
cp .env.example .env.local
```

> **Let op:** `.env.local` staat in `.gitignore` en wordt nooit gecommit.

### 3. Dev-server starten

```bash
node serve.mjs
# Opent op http://localhost:3000
```

### 4. Supabase migraties uitvoeren

Voer de migraties uit in je Supabase project via de SQL Editor of Supabase CLI:

```bash
# Via Supabase CLI (als geïnstalleerd):
supabase db push

# Of handmatig in Supabase Dashboard > SQL Editor, in volgorde:
# 1. supabase/migrations/20240120000000_initial_schema.sql
# 2. supabase/migrations/20240121000000_fix_rls_admin_recursion.sql
```

Zie [supabase/README.md](supabase/README.md) voor details over de schema-opzet en RLS-beleid.

### 5. Seed data laden (optioneel)

Laad testdata met 10 hengsten:

```bash
# Via Supabase Dashboard > SQL Editor:
# Plak de inhoud van supabase/seed.sql en voer uit
```

---

## Security

### Welke variabelen zijn nodig?

| Variabele | Waar te vinden | Veilig in frontend? |
|---|---|---|
| `SUPABASE_URL` | Dashboard → Project Settings → API | ✅ Ja |
| `SUPABASE_ANON_KEY` | Dashboard → Project Settings → API | ✅ Ja (via RLS) |
| `SUPABASE_SERVICE_ROLE_KEY` | Dashboard → Project Settings → API | 🚨 **Nooit in frontend** |

### Hardcoded sleutels in HTML-bestanden

Dit project gebruikt de **Supabase anon/publishable key** rechtstreeks in de HTML-bestanden. Dit is het **bedoelde gebruik** voor een pure frontend-app:

- De anon key geeft alleen toegang tot wat de RLS-policies toestaan
- Alle gevoelige data is beveiligd via Row Level Security
- Gebruikers zien alleen hun eigen merries (`user_id = auth.uid()`)
- Hengsten zijn publiek leesbaar (bewust beleid)

> ⚠️ **De `SUPABASE_SERVICE_ROLE_KEY` mag NOOIT in frontend-code of een gecommit bestand.**
> Deze sleutel omzeilt alle RLS-policies en geeft volledige database-toegang.
> Gebruik hem alleen in server-side scripts of Supabase Edge Functions.

### RLS-beleid (Row Level Security)

Alle tabellen hebben RLS ingeschakeld:

| Tabel | Lezen | Schrijven |
|---|---|---|
| `profiles` | eigen rij | eigen rij |
| `mares` | eigen rijen | eigen rijen |
| `mare_scores` | eigen rijen | eigen rijen |
| `stallions` | iedereen (publiek) | alleen admin |
| `stallion_scores` | iedereen (publiek) | alleen admin |

### Wat moet je NOOIT committen?

- `.env`, `.env.local`, `.env.production` — Supabase keys/wachtwoorden
- `SUPABASE_SERVICE_ROLE_KEY` — omzeilt RLS
- Database wachtwoorden (pooler connection strings)
- JWT secrets

Al deze bestanden staan in `.gitignore`.
