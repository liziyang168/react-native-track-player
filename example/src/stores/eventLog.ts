import { create } from 'zustand';

export interface LogEntry {
  id: number;
  timestamp: Date;
  event: string;
  payload: string;
}

let nextId = 0;

interface EventLogState {
  logs: LogEntry[];
  addLog: (event: string, payload?: Record<string, unknown>) => void;
  clearLogs: () => void;
}

export const useEventLogStore = create<EventLogState>(set => ({
  logs: [],
  addLog: (event, payload) => {
    if (!event) return;
    set(state => ({
      logs: [
        {
          id: nextId++,
          timestamp: new Date(),
          event,
          payload: payload ? JSON.stringify(payload) : '',
        },
        ...state.logs,
      ].slice(0, 200),
    }));
  },
  clearLogs: () => set({ logs: [] }),
}));
