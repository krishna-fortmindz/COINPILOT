class EndPoints {
  EndPoints._();

  // ─────────────────────────────────────────────────────────────
  // Backend Base URLs
  // ─────────────────────────────────────────────────────────────

  static const String baseUrl = 'http://10.24.227.45:5000';
  // static const String baseUrl = 'https://crypto-backend-4557.onrender.com';

  static const String apiBaseUrl = '$baseUrl/api/v1';
  static const String dashboardBaseUrl = '$apiBaseUrl/dashboard';
  static const String aiBaseUrl = '$baseUrl/api/ai';

  // Socket.IO
  static const String socketUrl = baseUrl;
  static const String socketPath = '/socket.io';

  // ─────────────────────────────────────────────────────────────
  // Auth / Token
  // ─────────────────────────────────────────────────────────────

  static const String generateNewToken = '$apiBaseUrl/token/generate';

  // ─────────────────────────────────────────────────────────────
  // Dashboard REST APIs
  // ─────────────────────────────────────────────────────────────

  static const String dashboardSummary = '$dashboardBaseUrl/summary';

  static const String marketCoins = '$dashboardBaseUrl/markets';

  static const String trendingCoins = '$dashboardBaseUrl/trending';

  static const String globalMarket = '$dashboardBaseUrl/global';

  static const String fearGreedIndex = '$dashboardBaseUrl/fear-greed';

  static const String klines = '$dashboardBaseUrl/klines';

  static const String orderBook = '$dashboardBaseUrl/order-book';

  static const String ticker24hr = '$dashboardBaseUrl/ticker-24hr';

  static const String exchangeInfo = '$dashboardBaseUrl/exchange-info';

  static const String fundingRates = '$dashboardBaseUrl/funding-rates';
  static const String marketAiAnalysis = '$apiBaseUrl/analysis/market';

  // ─────────────────────────────────────────────────────────────
  // Trade Now — AI Analysis APIs
  // ─────────────────────────────────────────────────────────────

  // Trade Now
  static const String analysisSignal = '$apiBaseUrl/analysis/signal';
  static const String analysisSentiment = '$apiBaseUrl/analysis/sentiment';
  static const String analysisOpenInterest =
      '$apiBaseUrl/analysis/open-interest';
  static const String analysisLongShort = '$apiBaseUrl/analysis/long-short';
  static const String analysisLiquidations =
      '$apiBaseUrl/analysis/liquidations';
  static const String analysisHistory = '$apiBaseUrl/analysis/history';

  // Order Book
  static const String analysisLevels = '$apiBaseUrl/analysis/levels';

  // Charts — indicators & pattern overlay (NEW — backend to build)
  static const String analysisIndicators = '$apiBaseUrl/analysis/indicators';
  static const String analysisPatterns = '$apiBaseUrl/analysis/patterns';

  // ─────────────────────────────────────────────────────────────
  // New Listings (NEW — backend to build)
  // GET ?page=1&limit=20
  // ─────────────────────────────────────────────────────────────
  static const String newListings = '$dashboardBaseUrl/new-listings';

  // GET ?coinId=bitcoin
  static const String newListingsAiScore = '$aiBaseUrl/listings/score';

  // ─────────────────────────────────────────────────────────────
  // On-chain / Sentiment (NEW — backend to build)
  // ─────────────────────────────────────────────────────────────
  static const String sentimentNews = '$baseUrl/api/sentiment/news';
  static const String sentimentSocial = '$baseUrl/api/sentiment/social';
  static String sentimentCoin(String coinId) =>
      '$baseUrl/api/sentiment/coins/$coinId';
  static const String sentimentOnChain = '$baseUrl/api/sentiment/on-chain';
  static const String onchainIndicators = '$apiBaseUrl/onchain/indicators';

  // ─────────────────────────────────────────────────────────────
  // Portfolio (NEW — backend to build)
  // ─────────────────────────────────────────────────────────────
  static const String portfolio = '$apiBaseUrl/portfolio';
  static const String portfolioHoldings = '$apiBaseUrl/portfolio/holdings';
  static const String portfolioPerformance =
      '$apiBaseUrl/portfolio/performance';

  // ─────────────────────────────────────────────────────────────
  // Alerts (NEW — backend to build)
  // ─────────────────────────────────────────────────────────────
  static const String alerts = '$apiBaseUrl/alerts';
  static const String alertsHistory = '$apiBaseUrl/alerts/history';

  // ─────────────────────────────────────────────────────────────
  // Trade Journal (NEW — backend to build)
  // ─────────────────────────────────────────────────────────────
  static const String journal = '$baseUrl/api/journal';
  static const String journalStats = '$baseUrl/api/journal/stats';

  // ─────────────────────────────────────────────────────────────
  // AI Chat (NEW — backend to build)
  // ─────────────────────────────────────────────────────────────
  static const String aiChat = '$apiBaseUrl/ai/chat';
  static const String aiChatHistory = '$apiBaseUrl/ai/chat/history';

  // ─────────────────────────────────────────────────────────────
  // Predictions
  // ─────────────────────────────────────────────────────────────
  static const String predictionsLeaderboard =
      '$apiBaseUrl/predictions/leaderboard';
  static const String predictionsUser = '$apiBaseUrl/predictions/user';
  static const String predictionsUserMine = '$apiBaseUrl/predictions/user/mine';
  static const String predictionsUserVsAi =
      '$apiBaseUrl/predictions/user/vs-ai';

  static String predictionAccuracy(String coinId) =>
      '$apiBaseUrl/predictions/$coinId/accuracy';

  static String predictionHistory(String coinId) =>
      '$apiBaseUrl/predictions/$coinId/history';

  static String predictionPostMortems(String coinId) =>
      '$apiBaseUrl/predictions/$coinId/post-mortems';

  // ─────────────────────────────────────────────────────────────
  // Dynamic Dashboard APIs
  // ─────────────────────────────────────────────────────────────

  static String coinDetails(String coinId) {
    return '$dashboardBaseUrl/coins/$coinId';
  }

  static String coinAiAnalysis(String coinId) {
    return '$aiBaseUrl/analysis/$coinId';
  }

  static String coinOhlc(String coinId) {
    return '$dashboardBaseUrl/coins/$coinId/ohlc';
  }

  // ─────────────────────────────────────────────────────────────
  // Query Helpers
  // ─────────────────────────────────────────────────────────────

  static String dashboardSummaryWithParams({
    String coinIds = 'bitcoin,ethereum,solana,binancecoin',
    String symbols = 'BTCUSDT,ETHUSDT,SOLUSDT,BNBUSDT',
  }) {
    return '$dashboardSummary?coinIds=$coinIds&symbols=$symbols';
  }

  static String marketCoinsWithParams({
    String? ids,
    String vsCurrency = 'usd',
    int perPage = 20,
    int page = 1,
    bool sparkline = true,
  }) {
    final query = <String, String>{
      if (ids != null && ids.isNotEmpty) 'ids': ids,
      'vsCurrency': vsCurrency,
      'perPage': perPage.toString(),
      'page': page.toString(),
      'sparkline': sparkline.toString(),
    };

    return Uri.parse(marketCoins).replace(queryParameters: query).toString();
  }

  static String marketCoinsSearch({
    String searchQuery = '',
    int perPage = 10,
    int page = 1,
  }) {
    final params = <String, String>{
      'perPage': perPage.toString(),
      'page': page.toString(),
      if (searchQuery.isNotEmpty) 'query': searchQuery,
    };
    return Uri.parse(marketCoins).replace(queryParameters: params).toString();
  }

  static String klinesWithParams({
    required String symbol,
    String interval = '1h',
    int limit = 100,
  }) {
    return Uri.parse(klines).replace(
      queryParameters: {
        'symbol': symbol,
        'interval': interval,
        'limit': limit.toString(),
      },
    ).toString();
  }

  static String orderBookWithParams({
    required String symbol,
    int limit = 50,
  }) {
    return Uri.parse(orderBook).replace(
      queryParameters: {
        'symbol': symbol,
        'limit': limit.toString(),
      },
    ).toString();
  }

  static String ticker24hrWithParams({
    String? symbol,
  }) {
    return Uri.parse(ticker24hr).replace(
      queryParameters: {
        if (symbol != null && symbol.isNotEmpty) 'symbol': symbol,
      },
    ).toString();
  }

  static String exchangeInfoWithParams({
    String? symbol,
  }) {
    return Uri.parse(exchangeInfo).replace(
      queryParameters: {
        if (symbol != null && symbol.isNotEmpty) 'symbol': symbol,
      },
    ).toString();
  }

  static String fundingRatesWithSymbol({
    required String symbol,
    int limit = 10,
  }) {
    return Uri.parse(fundingRates).replace(
      queryParameters: {
        'symbol': symbol,
        'limit': limit.toString(),
      },
    ).toString();
  }

  static String fundingRatesWithSymbols({
    required List<String> symbols,
  }) {
    return Uri.parse(fundingRates).replace(
      queryParameters: {
        'symbols': symbols.join(','),
      },
    ).toString();
  }

  static String fearGreedWithParams({
    int limit = 30,
  }) {
    return Uri.parse(fearGreedIndex).replace(
      queryParameters: {
        'limit': limit.toString(),
      },
    ).toString();
  }

  static String coinOhlcWithParams({
    required String coinId,
    String vsCurrency = 'usd',
    int days = 1,
  }) {
    return Uri.parse(coinOhlc(coinId)).replace(
      queryParameters: {
        'vsCurrency': vsCurrency,
        'days': days.toString(),
      },
    ).toString();
  }

  static String newListingsWithParams({int page = 1, int limit = 20}) {
    return Uri.parse(newListings).replace(
      queryParameters: {'page': '$page', 'limit': '$limit'},
    ).toString();
  }

  static String analysisIndicatorsWithParams({
    required String symbol,
    required String type,
    String interval = '1h',
  }) {
    return Uri.parse(analysisIndicators).replace(
      queryParameters: {'symbol': symbol, 'type': type, 'interval': interval},
    ).toString();
  }

  static String journalEntry(String id) => '$journal/$id';

  static String alertEntry(String id) => '$alerts/$id';

  static String portfolioHolding(String id) => '$portfolioHoldings/$id';

  // ─────────────────────────────────────────────────────────────
  // Risk Management
  // ─────────────────────────────────────────────────────────────
  static const String riskPositionSize = '$baseUrl/api/risk/position-size';
  static const String riskRrCalculator = '$baseUrl/api/risk/rr-calculator';
  static String riskMaxDrawdown({
    String symbol = 'BTCUSDT',
    String period = '30d',
    String interval = '1d',
  }) =>
      '$baseUrl/api/risk/max-drawdown?symbol=$symbol&period=$period&interval=$interval';
}
