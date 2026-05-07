FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release --base-href /

FROM nginx:alpine AS runner
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx-flutter.conf /etc/nginx/conf.d/default.conf
EXPOSE 5000
CMD ["nginx", "-g", "daemon off;"]
