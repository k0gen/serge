<script>
  import { onMount } from 'svelte';
  import { ChatService } from '../../services/chat.service';

  let chatId = null;
  let chat = null;

  onMount(async () => {
    chat = await ChatService.getChat(chatId);
  });
</script>

<style>
  /* Define your styles here */
</style>

<main>
  {#if chat}
    <h1>{chat.title}</h1>
    <!-- Render the chat messages here -->
  {/if}
</main>
