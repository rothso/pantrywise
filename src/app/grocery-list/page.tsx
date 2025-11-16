import GroceryList from '@/components/grocery-list';
import Container from '@/components/layout/container';
import { getGroceryListByHousehold } from '@/repositories/groceryList';
import { getHouseholdIdForUser } from '@/repositories/users';
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
    redirect('/login'); // TODO: Next.js protected route?
  }

  const householdId = await getHouseholdIdForUser(user.id); // TODO: Context?
  const groceryList = await getGroceryListByHousehold(householdId);

  // TODO: Map units to their respective labels before sending to UI component
  const groceryListByStore = Map.groupBy(groceryList, (item) => item.store);

  console.log(util.inspect(groceryListByStore, { depth: null, colors: true }));

  return (
    // TODO: Standardize container width
    <Container className="w-[768px]">
      <GroceryList groceryListByStore={groceryListByStore} />
    </Container>
  );
}
