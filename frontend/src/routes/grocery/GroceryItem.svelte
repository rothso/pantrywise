<script lang="ts">
  import Checkbox from '$lib/components/ui/checkbox/Checkbox.svelte';
  import type { GroceryItem } from '$lib/types/api';

  interface Props {
    item: GroceryItem;
  }

  const { item }: Props = $props();

  let checked = $state(false);
</script>

<div class="rounded-md bg-gray-800 p-5 shadow-md {checked && 'line-through opacity-70'}">
  <div class="flex gap-4">
    <Checkbox class="mt-1" bind:checked />
    <div class="flex grow flex-col">
      <div class="flex justify-between">
        <span>
          {item.itemName}{' '}

          {#if item.quantity && item.units}
            <span class="text-gray-500">
              {item.quantity}
              {item.units}
            </span>
          {/if}
        </span>

        {#if item.totalPrice}
          <span>${item.totalPrice}</span>
        {/if}
      </div>
      <div class="flex justify-between text-sm text-gray-400">
        <span class="italic">
          {item.recipes?.map((r) => r.recipeName).join(', ')}
        </span>
        {#if item.storePricePerUnit && item.storeUnit}
          <span>
            ${item.storePricePerUnit}/{item.storeUnit}
          </span>
        {/if}
      </div>
    </div>
  </div>
</div>
