-- TEMPORARY: Allow anon to write for seeding 440 products
-- Run this, then Push from admin, then run supabase-setup-secure.sql again to lock down

drop policy if exists "Authenticated can write" on public.products;
drop policy if exists "Allow anon write" on public.products;

create policy "Allow anon write" on public.products for all using (true) with check (true);

-- Verify
-- After seeding, run supabase-setup-secure.sql to make it secure again
