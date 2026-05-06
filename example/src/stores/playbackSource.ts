import { create } from 'zustand';

export type PlaybackSource = 'music' | 'podcast' | 'radio';

interface PlaybackSourceState {
  source: PlaybackSource;
  setSource: (source: PlaybackSource) => void;
}

export const usePlaybackSourceStore = create<PlaybackSourceState>(set => ({
  source: 'music',
  setSource: source => set({ source }),
}));
