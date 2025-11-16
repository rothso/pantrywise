import { Checkbox } from './ui/checkbox';

const groceryListByStore = [
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

// TODO: Use the real grocery list
export default function GroceryList({ groceryListByStore: unused }) {
  return (
    // TODO: Support light mode
    <div className="flex flex-col items-center justify-center h-screen gap-4 p-4 w-full">
      {groceryListByStore.map(({ storeId, storeName, categories }) => (
        <div className="w-full" key={storeId}>
          <h2 className="text-2xl font-semibold mb-4">{storeName}</h2>
          {categories.map(({ categoryId, categoryName, items }) => (
            <div key={categoryId}>
              <h3 className="text-xl mb-4">{categoryName}</h3>
              <div className="p-6 bg-gray-800 rounded-md shadow-md">
                {items.map(
                  ({
                    itemId,
                    itemName,
                    quantity,
                    units,
                    recipes,
                    totalPrice,
                    storePricePerUnit,
                    storeUnit,
                  }) => (
                    <div key={itemId} className="flex gap-4">
                      <Checkbox className="mt-1" />
                      <div className="flex flex-col flex-grow">
                        <div className="flex justify-between text-lg">
                          <span>
                            {itemName}{' '}
                            {quantity && units && (
                              <span className="text-gray-500">
                                {quantity} {units}
                              </span>
                            )}
                          </span>
                          <span>${totalPrice}</span>
                        </div>
                        <div className="flex justify-between text-gray-400">
                          <span className="italic">
                            {recipes?.map((r) => r.recipeName).join(', ')}
                          </span>
                          <span>
                            ${storePricePerUnit}/{storeUnit}
                          </span>
                        </div>
                      </div>
                    </div> // TODO: qty, price, etc.
                  ),
                )}
              </div>
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}
