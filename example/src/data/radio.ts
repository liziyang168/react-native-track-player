import type { MediaItem } from '@rntp/player';

export interface RadioStation {
  mediaItem: MediaItem;
  genre: string;
  description: string;
  color: string;
}

export const radioStations: RadioStation[] = [
  {
    mediaItem: {
      mediaId: 'klubradio-live',
      title: 'Klubrádió',
      artist: 'Klubrádió',
      albumTitle: 'Klubrádió',
      url: 'https://stream.klubradio.hu:8443/',
      isLive: true,
      mimeType: 'audio/mpeg',
    },
    genre: 'News / Talk / Music',
    description:
      'Magyarország független közösségi rádiója. Independent community radio from Budapest.',
    color: '#E30613',
  },
  {
    mediaItem: {
      mediaId: 'dlf-kultur-live',
      title: 'Deutschlandfunk Kultur',
      artist: 'Deutschlandradio',
      albumTitle: 'Deutschlandfunk Kultur',
      url: 'https://st02.sslstream.dlf.de/dlf/02/128/mp3/stream.mp3',
      isLive: true,
      mimeType: 'audio/mpeg',
    },
    genre: 'Culture / Arts / Music',
    description:
      'German public radio for culture, arts and debate. Debatte, Feuilleton, Hörspiel, Konzert.',
    color: '#0A4B78',
  },
];
