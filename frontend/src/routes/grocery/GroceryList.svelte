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
      <h2 class="mb-4 text-2xl font-semibold">{groceryList.name}</h2>
      {#each groceryList.items as item (item.itemId)}
        <GroceryItem {item} />
      {/each}
      {#if groceryList.items.length === 0}
        <p class="text-gray-500">No items yet.</p>
      {/if}
    </section>
  {/each}
  {#if groceryLists.length === 0}
    <p class="text-gray-500">No grocery lists yet.</p>
  {/if}
</div>
