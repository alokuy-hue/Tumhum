-- TUM HUM Basket - Supabase Schema for 400 Products
-- Run this in Supabase Dashboard -> SQL Editor

-- 1. Create products table
create table if not exists public.products (
  id text primary key,
  name text not null,
  display_name text,
  cat text not null check (cat in ('Fruits & Veggies','Dairy & Eggs','Staples','Snacks','Beverages','Personal Care','Home Care')),
  emoji text,
  unit text not null,
  price integer not null check (price > 0),
  mrp integer not null check (mrp > 0),
  image text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. Enable RLS
alter table public.products enable row level security;

-- 3. Policies
-- Allow anyone to read (public store)
drop policy if exists "Allow public read" on public.products;
create policy "Allow public read"
on public.products for select
using (true);

-- Allow anon to write (for demo admin panel). 
-- In production, replace with auth check: using (auth.role() = 'authenticated')
drop policy if exists "Allow anon write" on public.products;
create policy "Allow anon write"
on public.products for all
using (true)
with check (true);

-- 4. Indexes for performance
create index if not exists idx_products_cat on public.products(cat);
create index if not exists idx_products_name on public.products using gin(to_tsvector('english', name));
create index if not exists idx_products_price on public.products(price);

-- 5. Updated_at trigger
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_updated_at on public.products;
create trigger set_updated_at
before update on public.products
for each row execute function public.handle_updated_at();

-- 6. Optional: Orders table for future (WhatsApp orders logging)
create table if not exists public.orders (
  id text primary key,
  items jsonb not null,
  subtotal integer not null,
  delivery_fee integer not null,
  total integer not null,
  customer_location text,
  status text default 'pending' check (status in ('pending','confirmed','out_for_delivery','delivered','cancelled')),
  created_at timestamptz default now()
);

alter table public.orders enable row level security;
drop policy if exists "Allow public orders" on public.orders;
create policy "Allow public orders" on public.orders for all using (true) with check (true);

-- Done! Now seed with 400 products using the admin panel "Push to Supabase" button,
-- or via Supabase Dashboard -> Table Editor -> Import CSV/JSON.
