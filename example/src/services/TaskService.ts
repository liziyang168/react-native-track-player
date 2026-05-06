import { useEventLogStore } from '../stores/eventLog';

// On Android, HeadlessJS delivers { event: string, payload: Record<string, unknown> }
export async function TaskService(data: {
  event: string;
  payload?: Record<string, unknown>;
}) {
  useEventLogStore.getState().addLog(data.event, data.payload);
}
