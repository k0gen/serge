<script lang="ts">
  import { invalidate, invalidateAll } from "$app/navigation";

  let isProcessing = false;
  
  const handleRefresh = (e) => {
    isProcessing = true;
    new Promise((resolve, reject) => {
      fetch("/api/model/refresh", {
        method: "POST",
        body: new FormData(e.target instanceof HTMLFormElement ? e.target : {}),
      })
      .then(r => {
        if (r.ok) {
          return invalidate("/api/model/all");
        } else {
          throw new Error("Error refreshing models");
        }
      })
      .catch(error => {
        console.error(error);
      })
      .finally(() => {
        isProcessing = false;
      });
    });
  };
<dialog bind:this={dialogTag} class="modal">
  <form method="dialog" class="modal-box">
    <button class="btn-ghost btn-sm btn-circle btn absolute right-2 top-2"
      >✕</button
    >
    <form on:submit|preventDefault={handleRefresh}>
      <h3 class="text-lg font-bold">Model refresh</h3>
      <p class="py-4">
        Enter the URL of the JSON file containing the models below
      </p>
      <input
        type="text"
        name="url"
        class="input-bordered input-primary input mb-4 w-full"
        bind:value={link}
      />
      <div class="modal-action">
        <!-- if there is a button in form, it will close the modal -->
        <button type="submit" class="btn" disabled={isProcessing}>
          {#if isProcessing}
            <span class="loading loading-spinner" />
          {/if}
          Refresh
        </button>
      </div>
    </form>
  </form>
</dialog>
