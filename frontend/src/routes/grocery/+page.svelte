<script lang="ts">
  import GroceryList from './GroceryList.svelte';

  const { data } = $props();
</script>

<div class="container mx-auto w-3xl">
  <div class="flex h-screen flex-col items-center justify-center gap-4">
    <h1 class="text-4xl font-bold">Grocery Lists</h1>
    <p class="text-gray-500">Your grocery lists are synced with your pantry.</p>
    <GroceryList groceryLists={data.groceryLists} />
  </div>
</div>
