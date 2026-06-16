FROM debian:bullseye-slim AS build
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa wget && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

ENV FLUTTER_SUPPRESS_ANALYTICS=true
RUN git config --global --add safe.directory /flutter

RUN flutter config --enable-web
RUN flutter doctor

WORKDIR /app
COPY . .

RUN mkdir -p lib && \
    if [ ! -f lib/firebase_options.dart ]; then \
      printf "import 'package:firebase_core/firebase_core.dart';\nclass DefaultFirebaseOptions {\n  static FirebaseOptions get currentPlatform => web;\n  static const FirebaseOptions web = FirebaseOptions(\n    apiKey: 'AIzaSyAn_7yMeuqxwfR2HJ-jG93xqU2nxRgfkT4',\n    appId: '1:601110560690:web:25af25de849d2b25282eab',\n    messagingSenderId: '601110560690',\n    projectId: 'homestock-8825d',\n    authDomain: 'homestock-8825d.firebaseapp.com',\n    storageBucket: 'homestock-8825d.firebasestorage.app',\n    measurementId: 'G-6DG39J3314',\n  );\n}" > lib/firebase_options.dart; \
    fi

RUN flutter pub get

RUN flutter create . --platforms web

RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
