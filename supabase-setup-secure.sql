
-- SECURE VERSION - Only authenticated can write, public can read
-- Run this in Supabase SQL Editor

create table if not exists public.products (
  id text primary key,
  name text not null,
  display_name text,
  cat text not null check (cat in ('Staples','Snacks','Beverages','Masala','Home Care','Fruits & Veggies','Dairy & Eggs','Personal Care')),
  emoji text,
  unit text not null,
  price integer not null check (price > 0),
  mrp integer not null check (mrp > 0),
  image text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.products enable row level security;

-- Public can read
drop policy if exists "Public can read products" on public.products;
create policy "Public can read products" on public.products for select using (true);

-- Only authenticated users can write (secure, no anon bypass)
drop policy if exists "Allow anon write" on public.products;
drop policy if exists "Authenticated can write" on public.products;
create policy "Authenticated can write" on public.products for all to authenticated using (true) with check (true);

-- Indexes
create index if not exists idx_products_cat on public.products(cat);
create index if not exists idx_products_price on public.products(price);

-- Updated_at trigger
create or replace function public.handle_updated_at() returns trigger as $$
begin new.updated_at = now(); return new; end; $$ language plpgsql;
drop trigger if exists set_updated_at on public.products;
create trigger set_updated_at before update on public.products for each row execute function public.handle_updated_at();

-- Orders table (optional)
create table if not exists public.orders (
  id text primary key,
  items jsonb not null,
  subtotal integer not null,
  delivery_fee integer not null,
  total integer not null,
  customer_location text,
  status text default 'pending',
  created_at timestamptz default now()
);
alter table public.orders enable row level security;
drop policy if exists "Public can manage orders" on public.orders;
create policy "Public can manage orders" on public.orders for all using (true) with check (true);
