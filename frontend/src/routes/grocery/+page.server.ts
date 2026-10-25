import { getGroceries } from '$lib/api/grocery';

export const load = async () => {
  return {
    groceryLists: await getGroceries(),
  };
};
