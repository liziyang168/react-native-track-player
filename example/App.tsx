import { StatusBar, StyleSheet, Text, useColorScheme } from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import TrackPlayer from '@rntp/player';

function App() {
  const isDarkMode = useColorScheme() === 'dark';

  return (
    <SafeAreaProvider>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <SafeAreaView style={styles.container}>
        <Text style={styles.title}>Audio Ex Example</Text>
        <Text style={styles.subtitle}>React Native 0.83</Text>
        <Text style={styles.info}>
          Library loaded: {TrackPlayer ? 'Yes' : 'No'}
        </Text>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginBottom: 16,
  },
  info: {
    fontSize: 14,
    color: '#888',
  },
});

export default App;
