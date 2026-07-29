<script lang="ts">
  import GroceryList from './GroceryList.svelte';

  const { data } = $props();
</script>

<div class="container mx-auto w-3xl">
  <GroceryList groceryListByStore={data.groceryListByStore} />
</div>
