FROM debian:bullseye-slim AS build
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa wget && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Allow flutter to run as root
ENV FLUTTER_SUPPRESS_ANALYTICS=true
RUN git config --global --add safe.directory /flutter

RUN flutter config --enable-web
RUN flutter doctor

WORKDIR /app
COPY . .

RUN mkdir -p lib && \
    if [ ! -f lib/firebase_options.dart ]; then \
      printf "import 'package:firebase_core/firebase_core.dart';\nclass DefaultFirebaseOptions {\n  static FirebaseOptions get currentPlatform => const FirebaseOptions(\n    apiKey: 'stub', appId: 'stub',\n    messagingSenderId: 'stub', projectId: 'stub');\n}" > lib/firebase_options.dart; \
    fi

RUN flutter pub get

# Configure project for web
RUN flutter create . --platforms web

RUN flutter build web --release --no-pub

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
