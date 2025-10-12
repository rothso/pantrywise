import { getHouseholdIdForUser } from '@/repositories/users';
import { getRecipesByHousehold } from '@/repositories/recipes';
import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';

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

  return (
    <div className="flex flex-col items-center justify-center h-screen gap-4 p-4 w-full">
      <h1 className="text-2xl font-bold">PantryWise</h1>
      <p className="text-lg">Recipes</p>
      <ul className="list-disc">
        {recipes.map((recipe) => (
          <li key={recipe.recipeId} className="flex flex-col gap-2">
            {recipe.name}
            <ul className="list-disc pl-4 ml-4">
              {recipe.recipeIngredients.map((ingredient) => (
                <li key={ingredient.ingredients.name}>
                  {ingredient.amount} {ingredient.ingredients.name}
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
}
