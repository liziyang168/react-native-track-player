{ pkgs, lib, config, inputs, ... }:

{
  env.JAVA_HOME = "${pkgs.jdk17_headless}";

  packages = [
    pkgs.git
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.gradle_8
    pkgs.jdk17_headless
    pkgs.cocoapods
    pkgs.ruby_3_3
  ];

  scripts.validate-js.exec = ''
    set -e
    echo "=== Lint ==="
    cd example && yarn lint
    echo ""
    echo "✅ JS validation complete!"
  '';

  scripts.validate-android.exec = ''
    set -e
    echo "=== Building Android example ==="

    ANDROID_HOME="''${ANDROID_HOME:-$HOME/Library/Android/sdk}"
    if [ ! -d "$ANDROID_HOME" ]; then
      ANDROID_HOME="$HOME/Android/Sdk"
    fi

    NODE_BIN=$(dirname $(which node))
    YARN_BIN=$(dirname $(which yarn))
    JAVA_BIN=$(dirname $(which java))

    cd example/android && env -i \
      HOME="$HOME" \
      PATH="$NODE_BIN:$YARN_BIN:$JAVA_BIN:$ANDROID_HOME/platform-tools:/usr/bin:/bin:/usr/sbin:/sbin" \
      ANDROID_HOME="$ANDROID_HOME" \
      ANDROID_SDK_ROOT="$ANDROID_HOME" \
      JAVA_HOME="$JAVA_HOME" \
      ./gradlew assembleDebug
    echo ""
    echo "✅ Android validation complete!"
  '';

  scripts.validate-ios.exec = ''
    set -e
    echo "=== Building iOS example ==="
    NODE_BIN=$(dirname $(which node))
    cd example && env -i \
      HOME="$HOME" \
      PATH="$NODE_BIN:/usr/bin:/bin:/usr/sbin:/sbin" \
      npx react-native build-ios --mode Debug
    echo ""
    echo "✅ iOS validation complete!"
  '';

  scripts.validate.exec = ''
    set -e
    validate-js
    echo ""
    validate-android
    echo ""
    validate-ios
    echo ""
    echo "✅ All validation complete!"
  '';

  scripts.pod-reset.exec = ''
    cd example/ios && pod deintegrate && pod cache clean --all
  '';

  scripts.pod-install.exec = ''
    NODE_BIN=$(dirname $(which node))
    RUBY_BIN=$(dirname $(which ruby))
    POD_BIN=$(dirname $(which pod))
    cd example/ios && env -i \
      HOME="$HOME" \
      LANG="en_US.UTF-8" \
      PATH="$NODE_BIN:$POD_BIN:$RUBY_BIN:/usr/bin:/bin:/usr/sbin:/sbin" \
      pod install
  '';

  scripts.start.exec = ''
    cd example && yarn start
  '';

  scripts.ios.exec = ''
    set -e
    pod-install
    NODE_BIN=$(dirname $(which node))
    cd example && env -i \
      HOME="$HOME" \
      PATH="$NODE_BIN:/usr/bin:/bin:/usr/sbin:/sbin" \
      npx react-native run-ios --simulator="iPhone 17 Pro"
  '';

  scripts.android.exec = ''
    if [ -z "$ANDROID_HOME" ] || [ ! -d "$ANDROID_HOME" ]; then
      if [ -d "$HOME/Library/Android/sdk" ]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
      elif [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_HOME="$HOME/Android/Sdk"
      else
        echo "❌ ANDROID_HOME not set or SDK not found."
        echo "   Install Android Studio and the SDK will be at ~/Library/Android/sdk"
        exit 1
      fi
    fi

    NODE_BIN=$(dirname $(which node))
    JAVA_BIN=$(dirname $(which java))

    cd example && env -i \
      HOME="$HOME" \
      PATH="$NODE_BIN:$JAVA_BIN:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
      ANDROID_HOME="$ANDROID_HOME" \
      ANDROID_SDK_ROOT="$ANDROID_HOME" \
      JAVA_HOME="$JAVA_HOME" \
      npx react-native run-android
  '';

  scripts.dhu.exec = ''
    if [ -z "$ANDROID_HOME" ] || [ ! -d "$ANDROID_HOME" ]; then
      if [ -d "$HOME/Library/Android/sdk" ]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
      elif [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_HOME="$HOME/Android/Sdk"
      else
        echo "❌ ANDROID_HOME not set or SDK not found."
        exit 1
      fi
    fi

    DHU="$ANDROID_HOME/extras/google/auto/desktop-head-unit"
    if [ ! -x "$DHU" ]; then
      echo "❌ DHU not found at $DHU"
      echo "   Install it via Android Studio SDK Manager → SDK Tools → Android Auto Desktop Head Unit Emulator"
      exit 1
    fi

    ADB="$ANDROID_HOME/platform-tools/adb"
    if [ ! -x "$ADB" ]; then
      echo "❌ adb not found at $ADB"
      exit 1
    fi

    echo "🔌 Forwarding ADB port 5277..."
    "$ADB" forward tcp:5277 tcp:5277

    echo "🚗 Starting Android Auto Desktop Head Unit..."
    echo "   Make sure the head unit server is running on the device"
    echo "   (Android Auto → Settings → ⋮ → Start head unit server)"
    echo ""
    "$DHU" "$@"
  '';

  scripts.logcat.exec = ''
    if [ -z "$ANDROID_HOME" ] || [ ! -d "$ANDROID_HOME" ]; then
      if [ -d "$HOME/Library/Android/sdk" ]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
      elif [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_HOME="$HOME/Android/Sdk"
      else
        echo "❌ ANDROID_HOME not set or SDK not found."
        echo "   Install Android Studio or set ANDROID_HOME"
        exit 1
      fi
    fi

    ADB="$ANDROID_HOME/platform-tools/adb"
    if [ ! -x "$ADB" ]; then
      echo "❌ adb not found at $ADB"
      exit 1
    fi

    echo "📱 Streaming logcat (crashes, errors, and ReactNative)..."
    echo "   Press Ctrl+C to stop"
    echo ""
    "$ADB" logcat '*:E' ReactNative:V ReactNativeJS:V AndroidRuntime:E
  '';

  enterShell = ''
    # Android SDK - check common locations
    if [ -z "$ANDROID_HOME" ]; then
      if [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
      elif [ -d "$HOME/Android/Sdk" ]; then
        export ANDROID_HOME="$HOME/Android/Sdk"
        export ANDROID_SDK_ROOT="$ANDROID_HOME"
      fi
    fi

    if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
      export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    fi

    # Java
    export JAVA_HOME="${pkgs.jdk17_headless}"
    export PATH="$JAVA_HOME/bin:$PATH"

    # Xcode (macOS)
    if [[ "$OSTYPE" == "darwin"* ]] && command -v xcode-select &> /dev/null; then
      XCODE_PATH=$(xcode-select -p 2>/dev/null)
      if [ -n "$XCODE_PATH" ]; then
        XCODE_VERSION=$(xcodebuild -version 2>/dev/null | head -1 || echo "unknown")
        echo "✅ Xcode: $XCODE_VERSION"
      fi
    fi

    if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
      echo "✅ Android SDK: $ANDROID_HOME"
    else
      echo "⚠️  Android SDK not found. Android builds will fail."
      echo "   Install Android Studio or set ANDROID_HOME"
    fi

    echo ""
    echo "Commands:"
    echo "  validate         - Run lint, tests, and Android+iOS builds"
    echo "  validate-js      - Run lint and tests for the example"
    echo "  validate-android - Build Android example"
    echo "  validate-ios     - Build iOS example"
    echo "  pod-install      - Install CocoaPods dependencies"
    echo "  start            - Start Metro bundler"
    echo "  ios              - Build and run iOS example"
    echo "  android          - Build and run Android example"
    echo "  dhu              - Launch Android Auto Desktop Head Unit (via ADB)"
    echo "  logcat           - Stream Android logcat (errors, crashes, RN logs)"
    echo ""
  '';
}
