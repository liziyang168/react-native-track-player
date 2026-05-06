import type { MediaItem } from '@rntp/player';

const localTrack = require('../assets/CallTheSpirit.mp3');

export type AlbumTrack = MediaItem & { isLocal?: boolean };

export const LOCAL_MEDIA_IDS = new Set<string>(['call-the-spirit']);

export interface Album {
  title: string;
  artist: string;
  artwork: string;
  year: number;
  tracks: AlbumTrack[];
}

export const album: Album = {
  title: 'Synthetic Dreams',
  artist: 'Various Artists',
  artwork:
    'https://cdn2.suno.ai/image_479d721a-7fac-4f99-8f20-6e767b857784.jpeg',
  year: 2025,
  tracks: [
    {
      mediaId: 'call-the-spirit',
      title: 'Call the Spirit',
      artist: 'dcvz',
      albumTitle: 'Synthetic Dreams',
      url: localTrack,
      duration: undefined,
      isLocal: true,
    },
    {
      mediaId: 'lunar-serenade',
      title: 'Lunar Serenade',
      artist: 'dcvz',
      albumTitle: 'Synthetic Dreams',
      artworkUrl:
        'https://cdn2.suno.ai/image_479d721a-7fac-4f99-8f20-6e767b857784.jpeg',
      url: 'https://cdn1.suno.ai/479d721a-7fac-4f99-8f20-6e767b857784.mp3',
      duration: 212,
    },
    {
      mediaId: 'beware-french-men',
      title: 'Beware of the French Men',
      artist: 'KenSarMusic',
      albumTitle: 'Synthetic Dreams',
      artworkUrl:
        'https://cdn2.suno.ai/image_a73f6912-2c39-4c1d-a134-87af32fb5e9f.jpeg',
      url: 'https://cdn1.suno.ai/9cd7f8cc-d9e5-4d10-b1a0-3b5fad2418c5.mp3',
      duration: 186,
    },
    {
      mediaId: 'fairy-spring',
      title: 'Fairy Spring',
      artist: 'dcvz',
      albumTitle: 'LoZ',
      artworkUrl:
        'https://cdn2.suno.ai/image_3b11f85d-6efd-4667-b138-bdcf659331a7.jpeg',
      url: 'https://cdn1.suno.ai/3b11f85d-6efd-4667-b138-bdcf659331a7.mp3',
      duration: 198,
    },
    {
      mediaId: 'rain-storms',
      title: 'Rain Storms',
      artist: 'dcvz',
      albumTitle: 'LoZ',
      artworkUrl:
        'https://cdn2.suno.ai/image_8c4e4561-a919-4b4c-9a60-402ec7117dc7.jpeg',
      url: 'https://cdn1.suno.ai/8c4e4561-a919-4b4c-9a60-402ec7117dc7.m4a',
      duration: 224,
    },
    {
      mediaId: 'lullaby',
      title: 'Lullaby',
      artist: 'dcvz',
      albumTitle: 'LoZ',
      artworkUrl:
        'https://cdn2.suno.ai/image_2f6a521d-5f91-4da5-8785-06228904da79.jpeg',
      url: 'https://cdn1.suno.ai/2f6a521d-5f91-4da5-8785-06228904da79.mp3',
      duration: 195,
    },
  ],
};
