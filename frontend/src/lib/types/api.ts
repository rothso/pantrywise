export type GroceryItem = {
  itemId: number;
  itemName: string;
  quantity?: number;
  units?: string;
  recipes?: {
    recipeName: string;
  }[];
  totalPrice?: number;
  storePricePerUnit?: number;
  storeUnit?: string;
};

export type GroceryCategory = {
  categoryId: number;
  categoryName: string;
  items: GroceryItem[];
};

export type GroceryStore = {
  storeId: number;
  storeName: string;
  categories: GroceryCategory[];
};
