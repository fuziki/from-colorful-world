<script setup lang="ts">
import TheWelcome from '@/components/TheWelcome.vue'
</script>

<template>
  <main>
    <nav>
      <RouterLink to="/">Home</RouterLink>
      <RouterLink to="/csv">CSV Creator</RouterLink>
    </nav>
    <TheWelcome />
  </main>
</template>
