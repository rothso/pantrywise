import type { GroceryStore } from '$lib/types/api';

const groceryListByStore: GroceryStore[] = [
  {
    storeId: 1,
    storeName: 'Aldi',
    categories: [
      {
        categoryId: 1,
        categoryName: 'Produce',
        items: [
          {
            itemId: 1,
            itemName: 'Banana',
            quantity: 1,
            units: 'lb',
            recipes: [
              {
                recipeName: 'Peanut butter overnight oats',
              },
            ],
            totalPrice: 0.79,
            storePricePerUnit: 0.79,
            storeUnit: 'lb',
          },
        ],
      },
    ],
  },
  {
    storeId: 2,
    storeName: 'Target',
    categories: [
      {
        categoryId: 1,
        categoryName: 'Fruits',
        items: [
          {
            itemId: 1,
            itemName: 'Apple',
          },
        ],
      },
    ],
  },
];

export function load() {
  return {
    groceryListByStore,
  };
}
