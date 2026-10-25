<script lang="ts">
  import type { GroceryList } from '$lib/gen/pantrywise/grocery/v1/grocery_pb';
  import GroceryItem from './GroceryItem.svelte';

  interface Props {
    groceryLists: GroceryList[];
  }

  const { groceryLists }: Props = $props();
</script>

<div class="flex w-full flex-col gap-4 p-4">
  {#each groceryLists as groceryList (groceryList.listId)}
    <section class="w-full">
      <div class="mb-4 flex items-center gap-2">
        <h2 class="text-2xl font-semibold">{groceryList.name}</h2>
        <span class="rounded-md bg-gray-800 px-2 py-1 text-sm text-gray-400">
          {groceryList.items.length} items
        </span>
      </div>
      <div class="mb-4 flex flex-col gap-2">
        {#each groceryList.items as item (item.itemId)}
          <GroceryItem {item} />
        {/each}
        {#if groceryList.items.length === 0}
          <p class="text-gray-500">No items yet.</p>
        {/if}
      </div>
    </section>
  {/each}
  {#if groceryLists.length === 0}
    <p class="text-gray-500">No grocery lists yet.</p>
  {/if}
</div>
