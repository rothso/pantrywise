import { createClient } from '@/utils/supabase/server';

export async function getGroceryListByHousehold(householdId: number) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('grocery_list')
    .select(
      `
      itemId:item_id,
      ingredient:ingredient_id (
        name,
        category:category_id (
          name
        ),
        prices:ingredient_prices (
          storeId:store_id,
          price,
          quantity,
          unitId:unit_id
        ),
        recipes (
          name
        )
      ),
      quantity,
      unitId:unit_id,
      purchased,
      store:store_id (
        id:store_id,
        name,
        location
      ),
      createdAt:created_at,
      updatedAt:updated_at
    `,
    )
    .eq('household_id', householdId)
    .eq('ingredient.recipes.planned', true)
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data ?? [];
}
