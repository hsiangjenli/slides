<template>
  <footer
    v-if="$slidev.themeConfigs.github"
    class="absolute bottom-4 right-4"
  >
    <a 
      :href="$slidev.themeConfigs.github" 
      target="_blank"
      rel="noopener"
      :class="isCover ? 'text-white' : 'text-black'"
      class="hover:opacity-75 transition text-2xl"
    >
      <div class="i-carbon:logo-github" />
    </a>
  </footer>
</template>

<script setup>
import { computed } from 'vue'

const isCover = computed(() => $slidev.nav.currentLayout === 'cover')
</script>