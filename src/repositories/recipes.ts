import { createClient } from '@/utils/supabase/server';

export async function getRecipesByHousehold(householdId: number) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('recipes')
    .select(
      `
      recipeId:recipe_id,
      name,
      recipeIngredients:recipe_ingredients (
        amount,
        ingredients (
          name
        )
      )
    `,
    )
    .eq('household_id', householdId);

  if (error) throw error;
  return data ?? [];
}
