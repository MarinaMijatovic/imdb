const String simpleGetPopularUrl =  "https://api.themoviedb.org/3/movie/popular?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=1";
const String getMovieDetailsUrl =  "https://api.themoviedb.org/3/movie/508947?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=1";
const String genresUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=b8d7f76947904a011286dc732c55234e&language=en-US";
const String imageFormatUrl = "https://image.tmdb.org/t/p/w780";

const List<String> kImageFailedExceptions = [
  "SocketException: Network is unreachable (OS Error: Network is unreachable, errno = 101), address = image.tmdb.org, port = 58638",
  "SocketException: Failed host lookup: 'image.tmdb.org' (OS Error: No address associated with hostname, errno = 7)",
];
