import { createClient } from '@/utils/supabase/server';

export async function getShoppingListByHousehold(householdId: number) {
  const supabase = await createClient();

  // TODO: Join with ingredient_prices to get the price
  // TODO: Join with recipes to get the upcoming recipes (potentially)
  const { data, error } = await supabase
    .from('shopping_list')
    .select(
      `
      itemId:item_id,
      ingredient:ingredient_id (
        name,
        category:category_id (
          name
        )
      ),
      quantity,
      unit:unit_id (
        abbreviation
      ),
      purchased,
      store:store_id (
        name,
        location
      ),
      createdAt:created_at,
      updatedAt:updated_at
    `,
    )
    .eq('household_id', householdId)
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data ?? [];
}
