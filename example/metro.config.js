const path = require('path');
const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const { withNativeWind } = require('nativewind/metro');

const root = path.resolve(__dirname, '..');
const escape = str => str.replace(/[/\\]/g, '[\\\\/]');

const config = {
  watchFolders: [root],
  resolver: {
    blockList: [
      new RegExp(`${escape(root)}${escape('/node_modules/react/')}.*`),
      new RegExp(`${escape(root)}${escape('/node_modules/react-native/')}.*`),
    ],
    extraNodeModules: {
      '@rntp/player': root,
      react: path.resolve(__dirname, 'node_modules/react'),
      'react-native': path.resolve(__dirname, 'node_modules/react-native'),
      'react-native-css-interop': path.resolve(
        __dirname,
        'node_modules/react-native-css-interop',
      ),
    },
  },
};

module.exports = withNativeWind(
  mergeConfig(getDefaultConfig(__dirname), config),
  { input: './src/global.css', inlineRem: 16 },
);
