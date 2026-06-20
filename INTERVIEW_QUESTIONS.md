# CoinPilot — Tough Interviewer Question Set
> Level: Advanced → Micro | Feature-wise | Frontend + Backend | Page by Page

---

## SECTION 1 — PROJECT ARCHITECTURE

**ADV-1.** This project uses both Next.js and Flutter Web. Explain exactly why two separate frontends were chosen. What does each one own? What would break if you merged them into one?

**ADV-2.** The dev proxy (`dev-proxy.js`) runs on port 8080 and routes to three different servers. Why not just use Next.js rewrites for everything? What specific problem does the proxy solve that Next.js rewrites cannot?

**ADV-3.** In production, traffic flows through Nginx. Draw the full request path from a user typing `coinastra.site/dashboard` to Flutter rendering a chart. Include every hop.

**MID-4.** What is the difference between `NEXT_PUBLIC_FLUTTER_DASHBOARD_URL` and `FLUTTER_APP_URL` in `.env.development`? Why do both exist?

**MID-5.** The Flutter build is committed into the Next.js `public/app/` folder. What is the `--base-href /app/` flag doing? What breaks if you build Flutter with `--base-href /`?

**MICRO-6.** What does `next.config.mjs` rewrite rule `{ source: "/app/:path*", destination: "/app/index.html" }` do? Why is it needed for a Flutter SPA?

**MICRO-7.** Full form: SPA, SPA, OHLCV, CORS, JWT, OTP, RSI, MACD, EMA, ATH, ATL, RR (in trading context).

---

## SECTION 2 — AUTH FLOW (Next.js)

### Pages: `/auth/login`, `/auth/signup`, `/auth/forgot-password`, `/auth/verify-otp`, `/auth/reset-password`

**ADV-8.** Walk through the complete forgot-password flow end to end. Name every API endpoint hit, in order, and what each one returns. What does `otpVerified = true` mean on the backend?

**ADV-9.** The `verify-otp` Next.js route strips `type` before forwarding to the backend. Why? What would happen if `type` was forwarded? What does the backend do with unknown fields?

**ADV-10.** Tokens are stored using `setTokens()` in `lib/auth`. Where exactly are they stored? Why not use `httpOnly` cookies? What XSS risk does the current approach carry?

**MID-11.** After OTP verification for `email_verification`, the app redirects differently than for `password_reset`. Explain the exact redirect logic and why OTP is NOT passed in the URL for password reset.

**MID-12.** The resend-OTP endpoint currently only sends `{ email }`. The backend spec required `{ email, purpose }`. Why was `purpose` removed? What risk does this carry if the backend has multiple OTP types?

**MID-13.** The `verify-otp` page shows "Sent successfully — check your spam if you don't see it" even before the user actually resends. When does this message appear and is that correct UX?

**MICRO-14.** In `reset-password/page.tsx`, the body was changed from `{ email, otp, newPassword }` to `{ email, password }`. What was wrong with the old body? What field name does the backend actually expect?

**MICRO-15.** What does `NEXTAUTH_SECRET` do in this project? Is NextAuth actually being used for auth here or is it a custom auth system?

---

## SECTION 3 — CHARTS SCREEN (Flutter)

### File: `features/charts/charts_screen.dart` + `providers/charts_provider.dart`

**ADV-16.** Explain the dual-stream architecture in `ChartsNotifier`. There is a kline stream AND a ticker stream fallback. Why both? When does the ticker stream kick in? What problem does it solve?

**ADV-17.** `_fetchPattern()` fires after `loadCandles()` completes. What happens if the user switches coin quickly three times? Could you get race conditions with stale pattern results? How would you fix it?

**ADV-18.** The AI overlay requires minimum 4H timeframe. Explain the exact enforcement logic in `toggleAiOverlayActive()`. What happens if the user is on 1H and enables it?

**MID-19.** The candlestick widget throws an assertion error if `candles.length == 1`. Why does this edge case happen in practice? Where in the data flow could exactly 1 candle appear?

**MID-20.** `_onKlineTick()` checks `tick.openTime == dateMs` vs `tick.openTime > dateMs`. Explain what each branch does and why a third case (older tick) is silently ignored.

**MID-21.** After switching chart type to Line, the AI overlay auto-disables. Where is this logic and why is the AI overlay incompatible with Line chart?

**MID-22.** `PatternResult.fromJson` uses `??` fallbacks for every field. What does the backend return if the Groq model fails to detect a pattern? Does the app handle a null `data` field in the response?

**MICRO-23.** The `_mapTimeframe` function converts `1H` → `1h`. Why doesn't the Flutter app just use lowercase timeframes everywhere? Where is this uppercase format coming from?

**MICRO-24.** `_fetchPattern()` sends candles as a `List<Map>`. Each map has 6 keys. Name them and their types. What is the `timestamp` field measured in?

**MICRO-25.** Full form: OHLCV. What does each letter represent in a candlestick data point?

---

## SECTION 4 — PATTERN DETECTION API

### Endpoint: `POST /api/v1/charts/detect-pattern`

**ADV-26.** The backend uses Groq (llama-3.3-70b-versatile) for pattern detection. What are the limitations of using an LLM for real-time financial pattern detection vs a rule-based algorithm? Name 3 specific failure modes.

**ADV-27.** The app sends up to 100 candles in the POST body. At 1H timeframe, that's ~4 days of data. Is that enough context for pattern detection? What patterns require more history?

**MID-28.** The `timeframe` field validation on the backend only accepts lowercase values like `1h`, `4h`. Why was the Flutter app sending `1H` (uppercase) originally? What layer should have caught this mismatch earlier?

**MID-29.** The response includes `riskRewardRatio`, `keyLevels.support`, `keyLevels.resistance`, `volumeConfirmation`, `confidence`. Which of these does the Flutter overlay currently display? Which are ignored?

**MICRO-30.** The response includes a `usage` object with `prompt_tokens`, `completion_tokens`, `total_tokens`. What is this for? Who pays for these tokens and how?

**MICRO-31.** `patternType` can be `"continuation"` or `"reversal"`. The Flutter overlay doesn't currently show this. What visual change would make sense to communicate this distinction to users?

---

## SECTION 5 — DASHBOARD (Flutter)

### File: `features/dashboard/` + `providers/dashboard_provider.dart`

**ADV-32.** The dashboard uses a ticker stream via WebSocket. Explain the full Socket.IO connection lifecycle: connect → subscribe → receive ticks → reconnect on drop. Where is each step handled in code?

**ADV-33.** `DashboardSocket.instance` is a singleton. What are the risks of a singleton WebSocket in a Flutter web app? What happens when the user navigates away and back?

**MID-34.** The `tickerProvider` is watched in `ChartsScreen` to show live price. Explain how a price update in the socket flows all the way to updating the price badge in the chart header.

**MID-35.** Fear & Greed index is fetched from `/api/v1/dashboard/fear-greed`. What does this number represent? What range is it? What are the classifications?

**MICRO-36.** What does `ticker24hr` endpoint return that `klines` doesn't? Why would you use one vs the other for displaying a live price?

---

## SECTION 6 — TRADE NOW / AI ANALYSIS (Flutter)

### Endpoint chain: signal → sentiment → open-interest → long-short → liquidations

**ADV-37.** The Trade Now screen fires multiple API calls in sequence or parallel. Which calls are independent and could be parallelized? What is the current strategy and what would change with `Future.wait`?

**ADV-38.** `analysisSignal` returns an AI trading signal. What inputs does the backend likely use to generate this? What makes it different from the pattern detection endpoint?

**MID-39.** Open Interest and Long/Short ratio are both market structure metrics. Explain the difference. When would high OI + high long ratio be bearish rather than bullish?

**MID-40.** The liquidations endpoint returns historical liquidation data. How does this data inform a trade signal? What is a "liquidation cascade"?

**MICRO-41.** Full form: OI (Open Interest). What does it measure and on which type of market (spot or futures)?

---

## SECTION 7 — MARKET MEMORY (Flutter)

### Endpoint: `GET /api/v1/memory/patterns?symbol=BTC&lookback=30`

**ADV-42.** The memory patterns feature retrieves historical patterns from MongoDB. Explain the difference between this and the chart's real-time pattern detection. When would you use one vs the other?

**ADV-43.** The `lookback` parameter defaults to 365 days, max 1000. What are the performance implications on the backend of a 1000-day lookback? How should the backend handle this?

**MID-44.** A pattern has a `similarity` score (e.g., 85.0) and an `outcome`. How is similarity calculated? What algorithm would you use on the backend to compare historical candlestick patterns?

**MID-45.** The response includes `outcome: "Bullish (Target reached: +4.20% change)"`. How does the backend know the outcome was reached? Is this evaluated at request time or pre-computed?

**MICRO-46.** What does `memorySimilarEvents`, `memoryMarketCycles`, `memoryMacroContext` each return? How are they different from `memoryPatterns`?

---

## SECTION 8 — SENTIMENT (Flutter)

### Endpoints: `/api/sentiment/news`, `/api/sentiment/social`, `/api/sentiment/coins/:coinId`, `/api/sentiment/onchain`

**ADV-47.** Social sentiment uses Binance Futures long/short account percent. Explain what `longAccountPercent` actually measures. Why is it a contrarian indicator at extremes?

**ADV-48.** On-chain sentiment is fetched from `/api/sentiment/onchain`. What on-chain metrics would you include in this endpoint? Name 5 and explain their significance.

**MID-49.** The `sentimentCoin(coinId)` endpoint takes a CoinGecko coin ID. What's the difference between a coin ID (`bitcoin`) and a trading symbol (`BTCUSDT`)? Where does the conversion happen?

**MICRO-50.** What is the Fear & Greed Index and who publishes it? What inputs does Alternative.me use to calculate it?

---

## SECTION 9 — ORDER BOOK (Flutter)

### Endpoint: `GET /api/v1/dashboard/order-book?symbol=BTCUSDT&limit=50`

**ADV-51.** The order book shows bids and asks. Explain how to detect a "liquidity wall" from order book data. How would you visually represent it in Flutter?

**MID-52.** Order book data is inherently real-time. The current implementation uses REST polling. What are the trade-offs vs WebSocket streaming for the order book? What latency difference does it create?

**MICRO-53.** What is the `limit` parameter in the order book endpoint? What does increasing it from 50 to 500 affect in terms of performance and data quality?

---

## SECTION 10 — RISK MANAGER (Flutter)

### Endpoints: `/api/risk/position-size`, `/api/risk/rr-calculator`, `/api/risk/max-drawdown`

**ADV-54.** Explain the Kelly Criterion. Would it be appropriate to use for position sizing in crypto? What are its failure modes in high-volatility markets?

**MID-55.** The RR (Risk/Reward) calculator endpoint takes entry, stop-loss, and target. Write out the formula for RR ratio. What is considered a minimum acceptable RR ratio?

**MID-56.** Max drawdown is computed over a given period and interval. What is max drawdown? Explain the formula. Why does interval choice (`1d` vs `1h`) change the result?

**MICRO-57.** Full form: RR, MDD, ATR. What does each measure and which one is volatility-based?

---

## SECTION 11 — TRADE JOURNAL (Flutter)

### Endpoint base: `/api/journal`

**ADV-58.** A trade journal stores trade entries. Design the MongoDB schema for a journal entry. What fields are mandatory? How would you calculate win rate and profit factor from journal data?

**MID-59.** The journal has CRUD operations. For the DELETE operation, should entries be hard-deleted or soft-deleted? What is the difference and which is better for a trading journal?

**MICRO-60.** What is `profit factor`? Formula: sum of winning trades / sum of losing trades. What value means the strategy breaks even?

---

## SECTION 12 — AI CHAT (Flutter)

### Endpoint: `POST /api/v1/ai/chat`

**ADV-61.** The AI chat likely uses streaming responses. How would you implement streaming in Flutter Web from a streaming API? What is the difference between `text/event-stream` and regular JSON response?

**ADV-62.** Chat history is stored and retrieved. What are the privacy implications of storing user chat messages? How should conversation context be managed to avoid token limit issues on the LLM?

**MID-63.** The chat endpoint uses the backend AI (Groq). The Next.js API routes use Anthropic. Why different AI providers for different features? What trade-offs does Groq offer over Anthropic Claude?

**MICRO-64.** What is a "system prompt" in LLM context? What would a good system prompt look like for a crypto trading AI assistant?

---

## SECTION 13 — PREDICTIONS / AI ACCURACY (Flutter)

### Endpoints: `/api/v1/predictions/:coinId/accuracy`, `/api/v1/predictions/user/vs-ai`

**ADV-65.** The predictions leaderboard compares user predictions vs AI predictions. How would you design the scoring system? What metrics beyond win rate matter for prediction quality?

**MID-66.** A prediction has an outcome that is evaluated after a time window. Explain the full lifecycle: user submits prediction → time passes → outcome is evaluated → score updated. Where does each step happen?

**MICRO-67.** What is a "post-mortem" in trading? What does the `predictionPostMortems` endpoint return?

---

## SECTION 14 — STATE MANAGEMENT (Flutter / Riverpod)

**ADV-68.** This app uses `ChangeNotifierProvider` via Riverpod for most state. Compare this to `StateNotifierProvider` and `AsyncNotifierProvider`. Why was `ChangeNotifier` chosen? What refactor would make the code more testable?

**ADV-69.** `chartsProvider` holds candle data, live ticker subscription, and AI pattern state all in one notifier. What are the re-render implications? How would you split this to prevent unnecessary rebuilds?

**MID-70.** `Consumer` is used inside `_NewListingsScreen` (now coming soon) to rebuild only part of the widget tree. Explain why this is better than wrapping the whole `build` method in a `ConsumerWidget`.

**MID-71.** `ref.watch` vs `ref.read` — explain the exact difference. Give an example from this codebase of each used correctly and what would break if you swapped them.

**MICRO-72.** What does `notifyListeners()` do in a `ChangeNotifier`? What happens if you call it without any state change?

---

## SECTION 15 — NAVIGATION (GoRouter)

**ADV-73.** The app uses `ShellRoute` with `AppShell` as the wrapper. What does `ShellRoute` give you that nested `GoRoute` doesn't? How does it maintain the sidebar across navigation?

**MID-74.** The portfolio route had an auth guard. Explain how route guards work in GoRouter. What happens when an unauthenticated user tries to access a guarded route?

**MID-75.** `Router.neglect(context, () => context.go(route))` — why is `Router.neglect` used? What does it prevent that a plain `context.go` would create?

**MICRO-76.** What is the difference between `context.go()` and `context.push()` in GoRouter? When would you use `push` over `go` in this app?

---

## SECTION 16 — API CLIENT & INTERCEPTORS (Flutter)

**ADV-77.** The `_AuthInterceptor` handles 401/403 responses by refreshing the token and retrying the original request. What is the `_TokenRefreshGuard` doing? Why is a `Completer` used? What problem does it solve when multiple requests fail simultaneously?

**ADV-78.** Token is read from SharedPreferences first, then falls back to `localStorage`. Why the fallback? What race condition does this solve? What is the risk of reading from `localStorage` directly in Flutter Web?

**MID-79.** The interceptor adds `ngrok-skip-browser-warning: true` header to every request. What is ngrok? Why is this header needed? Should this be in production?

**MID-80.** `ApiClient.fetchModel` and `fetchList` unwrap the standard `{ success, data }` envelope. What happens if the backend returns `{ success: false, data: null }`? Is that handled?

**MICRO-81.** What is `Dio`? How is it different from Flutter's built-in `http` package? Name 2 specific features Dio provides that `http` doesn't.

**MICRO-82.** What is `BaseOptions.connectTimeout` vs `receiveTimeout`? Both are set to 2 minutes here. Is that appropriate for a real-time trading app?

---

## SECTION 17 — WEBSOCKET & REAL-TIME (Flutter)

**ADV-83.** The Socket.IO client connects through the dev proxy which forwards WebSocket upgrades. Explain the WebSocket upgrade handshake. What HTTP headers are involved in the upgrade?

**ADV-84.** There are two socket streams: `klineStream` and `tickerStream`. The kline stream is the primary and the ticker is a fallback. What event name does the backend emit for each? How are they differentiated client-side?

**MID-85.** `DashboardSocket.instance.subscribeWithInterval(symbol, interval)` — what does this emit to the backend? What does the backend do with this subscription request?

**MICRO-86.** What is `Socket.IO`? How is it different from raw WebSockets? What is long-polling fallback in Socket.IO?

---

## SECTION 18 — NEXT.JS API ROUTES (BFF Layer)

**ADV-87.** All backend calls from the Flutter app go directly to the backend. But Next.js auth calls go through Next.js API routes first. Why? What security benefit does this BFF (Backend for Frontend) pattern provide?

**ADV-88.** The Next.js `/api/ai/patterns` route calls both the backend AND Claude API. It fetches fear/greed, social sentiment, and trending data before calling Claude. Why not just call Claude directly from the frontend? Name 3 reasons.

**MID-89.** The Next.js AI routes use `Anthropic` SDK. The `/api/ai/patterns` route has a `FALLBACK_PATTERNS` array. When is the fallback used? Is returning static fallback data for a financial analysis feature safe?

**MID-90.** `export const dynamic = "force-dynamic"` is set on AI routes. What does this do in Next.js 14? What is the alternative and why would it be wrong for a live data endpoint?

**MICRO-91.** The Next.js `BACKEND_URL` defaults to `http://10.255.251.45:5000`. What happens in production if this env variable is not set? Should there be a fallback to prod URL or should it throw?

---

## SECTION 19 — SECURITY

**ADV-92.** JWT access tokens are stored in `localStorage` via `coinastra_access` key. Name 3 specific XSS attack vectors that could steal this token in a Next.js app. How would `httpOnly` cookies mitigate this?

**ADV-93.** The auth interceptor retries any 401/403 with a refreshed token. What happens if the refresh token is also expired or revoked? Is there an infinite retry loop risk? Where should the loop be broken?

**MID-94.** The Next.js headers config sets `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, `Strict-Transport-Security`. Explain what each one protects against.

**MID-95.** The reset-password endpoint takes `{ email, password }` with no OTP in the body. The backend trusts that OTP was verified via `otpVerified` flag. What happens if someone calls this endpoint directly without going through the OTP flow? What backend protection prevents this?

**MICRO-96.** Full form: XSS, CSRF, HSTS, CSP, MFA. Which of these does the current app implement?

---

## SECTION 20 — DEPLOYMENT & DEVOPS

**ADV-97.** The Flutter build is committed to the git repo inside `nextjs-app/public/app/`. The folder is gitignored via `.gitignore` but added with `git add -f`. Why is this pattern used? What are the risks of committing build artifacts?

**ADV-98.** The Dockerfile for Flutter uses a multi-stage build: `ghcr.io/cirruslabs/flutter:stable` as builder, then `nginx:alpine` as runner. Why multi-stage? What would the image size difference be with a single stage?

**MID-99.** The `docker-compose.yml` has a `profiles: [production]` on the nginx service. What does this mean? How do you start nginx with docker-compose?

**MID-100.** The root `package.json` uses `concurrently` to run Next.js, Flutter, and the dev proxy in parallel. What happens if the Flutter build fails mid-stream? Does `concurrently` kill the other processes?

**MICRO-101.** What port does each service run on in dev? Next.js: \_\_\_, Flutter: \_\_\_, Proxy: \_\_\_, Backend: \_\_\_.

---

## SECTION 21 — PERFORMANCE

**ADV-102.** The `main.dart.js` file in a Flutter web build can be 5–15MB. What strategies does the Flutter build system use to reduce this? What is tree-shaking and how did it reduce `MaterialIcons-Regular.otf` from 1.6MB to 19KB?

**ADV-103.** The Next.js app has long-lived cache headers on `/app/canvaskit/` and `/app/assets/`. Explain the cache strategy. What is `immutable` in `Cache-Control`? What happens when assets change?

**MID-104.** `SingleChildScrollView` with `NeverScrollableScrollPhysics` inside a `GridView` — explain why this pattern is needed in the More sheet. What would happen without it?

**MICRO-105.** What is `canvaskit` in Flutter Web? What is the alternative renderer and what are the trade-offs?

---

## SECTION 22 — COMING SOON FEATURES

**ADV-106.** New Listings was disabled by commenting out the original `ConsumerStatefulWidget` and replacing with a `StatelessWidget`. Explain why this is better than a feature flag approach. What is the risk of the commented-out code drifting out of sync with provider changes?

**MID-107.** Token Unlocks tracked vesting schedules. Explain what token vesting is in crypto. Why is a token unlock event often bearish for price? What data source would you use for unlock schedules?

**MICRO-108.** Portfolio was removed from the navigation. The route still exists in the router. What happens if a user navigates directly to `/portfolio` via URL? Is the route protected?

---

## BONUS — SYSTEM DESIGN

**ADV-109.** Design a real-time alert system for this app. A user sets: "Alert me when BTC drops 5% in 1 hour." Describe the full architecture: how alerts are stored, how the backend monitors prices, how the Flutter app receives alerts in real time.

**ADV-110.** This app currently has no offline support. Design an offline-first architecture for the dashboard page. What data would you cache? What storage mechanism would you use in Flutter Web? What changes when the connection is restored?

**ADV-111.** The AI pattern detection sends 100 candles (≈ 6KB of JSON) per request. At 1000 concurrent users all enabling AI overlay simultaneously, estimate the backend load. How would you add caching to `detect-pattern` without serving stale results?

---

*End of question set — 111 questions across 22 sections.*
