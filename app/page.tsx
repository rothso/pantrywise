import { getHouseholdIdForUser } from '@/repositories/users';
import { getRecipesByHousehold } from '@/repositories/recipes';
import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';
import util from 'util';

export default async function Page() {
  const supabase = await createClient();

  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();
  if (error || !user) {
    redirect('/login');
  }

  const householdId = await getHouseholdIdForUser(user.id);
  const recipes = await getRecipesByHousehold(householdId);

  console.log(util.inspect(recipes, { depth: null, colors: true }));

  return <div>Hello world!</div>;
}
