import { defineStore } from 'pinia'
import { ref } from 'vue'
import { api } from '@/services/api'

type HealthStatus = 'unknown' | 'ok' | 'error'

interface HealthResponse {
  status: string
}

export const useHealthStore = defineStore('health', () => {
  const status = ref<HealthStatus>('unknown')
  const error = ref<string | null>(null)
  const loading = ref(false)

  async function check() {
    loading.value = true
    error.value = null

    try {
      const data = await api.get<HealthResponse>('/api/health')
      status.value = data.status === 'ok' ? 'ok' : 'error'
    } catch (e) {
      status.value = 'error'
      error.value = e instanceof Error ? e.message : 'Unknown error'
    } finally {
      loading.value = false
    }
  }

  return { status, error, loading, check }
})