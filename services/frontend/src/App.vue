<script setup lang="ts">
import { useHealthStore } from '@/stores/health'
import { Button } from '@/components/ui/button'

const health = useHealthStore()

function checkHealth() {
  health.check()
}
</script>

<template>
  <main>
    <Button @click="checkHealth">Check Health</Button>
    <p v-if="health.loading">Checking backend…</p>
    <p v-else-if="health.status === 'ok'">Backend ✓</p>
    <p v-else-if="health.status === 'error'">Backend unreachable: {{ health.error }}</p>
  </main>
</template>