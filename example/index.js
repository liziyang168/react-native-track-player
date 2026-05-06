import { AppRegistry } from 'react-native';
import TrackPlayer from '@rntp/player';
import App from './src/App';
import { TaskService } from './src/services/TaskService';
import { name as appName } from './app.json';

TrackPlayer.registerBackgroundEventHandler(() => TaskService);
AppRegistry.registerComponent(appName, () => App);
