<script lang="ts">
  import type { GroceryStore } from '$lib/types/api';
  import GroceryItem from './GroceryItem.svelte';

  interface GroceryListProps {
    groceryListByStore: GroceryStore[];
  }

  const { groceryListByStore }: GroceryListProps = $props();
</script>

<div class="flex h-screen w-full flex-col items-center justify-center gap-4 p-4">
  {#each groceryListByStore as { storeId, storeName, categories } (storeId)}
    <div class="w-full">
      <h2 class="mb-4 text-2xl font-semibold">{storeName}</h2>
      {#each categories as { categoryId, categoryName, items } (categoryId)}
        <div>
          <h3 class="mb-4 text-xl">{categoryName}</h3>
          {#each items as item (item.itemId)}
            <GroceryItem {item} />
          {/each}
        </div>
      {/each}
    </div>
  {/each}
</div>
