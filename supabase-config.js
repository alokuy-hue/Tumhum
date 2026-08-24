// TUM HUM Basket - Supabase Config
// 1. Create a project at https://supabase.com (choose Region: ap-south-1 Mumbai for Ludhiana)
// 2. Go to Project Settings -> API -> Copy Project URL and anon public key
// 3. Paste below OR set via Admin Panel (stored in localStorage)

const SUPABASE_CONFIG = {
  // Replace with your project credentials
  url: localStorage.getItem('thb_supabase_url') || 'https://ysugaslkvsllfddjyffg.supabase.co',
  anonKey: localStorage.getItem('thb_supabase_key') || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzdWdhc2xrdnNsbGZkZGp5ZmZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc0NDI2ODQsImV4cCI6MjEwMzAxODY4NH0.9JR4urDo02in8zEGwgjcB0tde6tp9HZ_llgjjXouw6Q',
  
  // Set to true to force Supabase only (no fallback to local 400 products)
  // Leave false for dual mode (try Supabase, fallback to local if offline/error)
  supabaseOnly: false,
  
  // Table name
  table: 'products'
};

// Helper to check if configured
function isSupabaseConfigured() {
  return SUPABASE_CONFIG.url.includes('.supabase.co') && 
         !SUPABASE_CONFIG.url.includes('YOUR_PROJECT_ID') &&
         SUPABASE_CONFIG.anonKey.length > 20;
}

// For ES module usage if needed
// export { SUPABASE_CONFIG, isSupabaseConfigured };
