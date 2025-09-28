import { getShoppingListByHousehold } from '@/repositories/shoppingList';
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
  const shoppingList = await getShoppingListByHousehold(householdId);

  console.log(util.inspect(shoppingList, { depth: null, colors: true }));

  return (
    <div className="flex flex-col items-center justify-center h-screen gap-4 p-4 w-full">
      <h1 className="text-2xl font-bold">PantryWise</h1>
      <p className="text-lg">Shopping List</p>
      <ul className="list-disc">
        {shoppingList.map((item) => (
          // TODO: Display the expected price (client-side logic)
          <li key={item.itemId} className="flex flex-col gap-2">
            {item.ingredient.name}
            <ul className="list-disc pl-4 ml-4">
              {item.ingredient.name}
              {item.quantity} {item.unit.abbreviation}
              {item.store?.name ?? 'No store'}
              {item.createdAt}
              {item.updatedAt}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
}
