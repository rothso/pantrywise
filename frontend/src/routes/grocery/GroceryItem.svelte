<script lang="ts">
  import Checkbox from '$lib/components/ui/checkbox/Checkbox.svelte';
  import type { GroceryListItem } from '$lib/gen/pantrywise/grocery/v1/grocery_pb';

  interface Props {
    item: GroceryListItem;
  }

  const { item }: Props = $props();

  let checked = $state(false);
</script>

<div class="rounded-md bg-gray-800 p-5 shadow-md {checked && 'line-through opacity-70'}">
  <div class="flex gap-4">
    <Checkbox class="mt-1" bind:checked />
    <div class="flex grow flex-col">
      <div class="flex items-center justify-between gap-2">
        <span>{item.foodName}</span>
        <span class="text-sm text-gray-400">{item.quantity} {item.unit}</span>
      </div>
      {#if item.relatedRecipes.length > 0}
        <div class="text-sm text-gray-400">
          {item.relatedRecipes.map((recipe) => recipe.name).join(', ')}
        </div>
      {/if}
    </div>
  </div>
</div>
