import { createClient } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';
import { API_URL } from '$app/env/private';
import { GroceryService } from '$lib/gen/pantrywise/grocery/v1/grocery_pb';

const transport = createConnectTransport({ baseUrl: API_URL });
const groceryClient = createClient(GroceryService, transport);

export const getGroceries = async () => {
  const response = await groceryClient.listGroceryLists({});
  return response.groceryLists;
};
