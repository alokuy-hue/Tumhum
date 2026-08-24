# TUM HUM Basket — Supabase Setup (400 Products)

Your store now supports **Supabase** as live database + local fallback.

## 1) Create Supabase Project

1. Go to https://supabase.com → New Project
2. Name: `tum-hum-basket`
3. **Region:** `ap-south-1` (Mumbai) — fastest for Ludhiana
4. Set DB password, create project (wait ~1 min)
5. Go to **Project Settings → API** → copy:
   - `Project URL` → e.g. `https://abcd1234.supabase.co`
   - `anon public` key → long JWT starting with `eyJ...`

## 2) Create Tables

Go to **SQL Editor** → New Query → paste entire content of `supabase-setup.sql` → Run.

This creates:
- `products` table (id, name, display_name, cat, emoji, unit, price, mrp, image, created_at, updated_at)
- RLS enabled with public read + anon write (for demo)
- `orders` table (optional future logging)

**Check:** Table Editor → `products` should exist, empty.

## 3) Configure Your Sites

### Option A: Via Admin Panel (easiest, no code)

1. Open `admin.html` (password `admin123`)
2. Top green config card → paste **Supabase URL** and **Anon Key** → Save
3. Click **Test** → should say "✓ Connected • 0 products in Supabase"
4. Click **⬆ Push 400 local → Supabase** → waits, upserts 400 in batches → "✓ Pushed 400"
5. Your store `index.html` will auto-detect config (same localStorage) and show "● Live from Supabase • 400"

### Option B: Via Code (permanent deploy)

Edit `index.html` and `admin.html` top:

```js
const THBSUPABASE = {
  url: 'https://YOUR_PROJECT_ID.supabase.co',
  key: 'YOUR_ANON_KEY',
  table: 'products'
};
```

Replace `YOUR_` placeholders. Also update `supabase-config.js`.

## 4) How It Works

**Dual Mode (default)**
- `index.html` tries to fetch from Supabase first: `select * from products order by created_at limit 500`
- If succeeds and has rows → use Supabase catalog
- If fails/offline/empty → fallback to local 400 products embedded in file + localStorage edits
- Shows status pill: "● Live from Supabase" or "○ Local mode"

**Admin Panel**
- If Supabase configured: Add/Edit/Delete → writes to Supabase (`upsert`/`delete`) + localStorage cache
- Buttons:
  - `Push` = upload local 400 to Supabase (use after first setup)
  - `Pull` = replace local with Supabase data
  - `Clear` = delete all rows in Supabase table
  - Export JSON / Import JSON still works locally

## 5) Security – Production Hardening

Current SQL allows anon write for demo. For production:

1. In Supabase Dashboard → Authentication → enable Email auth
2. Create admin user
3. Change RLS policies:

```sql
drop policy "Allow anon write" on products;
create policy "Allow authenticated write" on products
for all to authenticated using (true) with check (true);
```

Then in admin.html, sign in with `supabase.auth.signInWithPassword()` before writes. Or keep anon write but add secret header.

## 6) Optional: Seed via SQL (alternative to Push button)

If you want to seed via Dashboard import:

1. Export JSON from admin panel → convert to CSV if needed
2. Or use this JS snippet in browser console on admin page after configuring:

```js
// already implemented as Push button
```

## 7) Files

- `index.html` – store, Supabase fetch + fallback
- `admin.html` – admin with Supabase CRUD + config UI
- `supabase-setup.sql` – schema + policies
- `supabase-config.js` – config helper
- `README_SUPABASE.md` – this file

## 8) Deploy

After pushing to Supabase, upload `index.html` + `admin.html` to any static host (Vercel, Netlify, Cloudflare Pages). No backend needed.

Your 400 products will be live from Supabase, editable from `admin.html` from anywhere.

## 9) Troubleshooting

- **"Not configured"** → check URL contains `.supabase.co` and key length > 20, Save again
- **CORS / fetch failed** → In Supabase → API → check anon key copied fully, no newline
- **Table empty after push** → check SQL ran, table exists in `public` schema, RLS policies exist
- **Store still local** → clear cache: localStorage.removeItem('thb_products_cache'), reload. Check browser console logs.

Enjoy! 🛒
