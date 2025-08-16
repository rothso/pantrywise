import { createClient } from '@/utils/supabase/server';

export async function getHouseholdIdForUser(userId: string) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('users')
    .select('household_id')
    .eq('user_id', userId)
    .single();

  if (error || !data) throw error;
  return data.household_id;
}
