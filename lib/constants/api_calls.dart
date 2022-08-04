final Map<String, dynamic> apiCalls= {
  "info": {
    "_postman_id": "85b51e21-abc3-434e-aa53-088fb2745401",
    "name": "Candidate task",
    "schema":
        "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Simple get popular",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.themoviedb.org/3/movie/popular?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=1",
          "protocol": "https",
          "host": ["api", "themoviedb", "org"],
          "path": ["3", "movie", "popular"],
          "query": [
            {"key": "api_key", "value": "b8d7f76947904a011286dc732c55234e"},
            {"key": "language", "value": "en_US"},
            {"key": "page", "value": "1"}
          ]
        }
      },
      "response": []
    },
    {
      "name": "Get movie details",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.themoviedb.org/3/movie/508947?api_key=b8d7f76947904a011286dc732c55234e&language=en_US&page=1",
          "protocol": "https",
          "host": ["api", "themoviedb", "org"],
          "path": ["3", "movie", "508947"],
          "query": [
            {"key": "api_key", "value": "b8d7f76947904a011286dc732c55234e"},
            {"key": "language", "value": "en_US"},
            {"key": "page", "value": "1"}
          ]
        }
      },
      "response": []
    },
    {
      "name": "Advanced get popular",
      "request": {
        "auth": {
          "type": "bearer",
          "bearer": [
            {
              "key": "token",
              "value": "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGQ3Zjc2OTQ3OTA0YTAxMTI4NmRjNzMyYzU1MjM0ZSIsInN1YiI6IjYwMzM3ODBiMTEzODZjMDAzZjk0ZmM2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XYuIrLxvowrkevwKx-KhOiOGZ2Tn-R8tEksXq842kX4",
              "type": "string"
            }
          ]
        },
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.themoviedb.org/3/movie/popular?language=en_US&page=1",
          "protocol": "https",
          "host": ["api", "themoviedb", "org"],
          "path": ["3", "movie", "popular"],
          "query": [
            {"key": "language", "value": "en_US"},
            {"key": "page", "value": "1"}
          ]
        }
      },
      "response": []
    },
    {
      "name": "Get genres",
      "request": {
        "auth": {
          "type": "bearer",
          "bearer": [
            {
              "key": "token",
              "value": "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGQ3Zjc2OTQ3OTA0YTAxMTI4NmRjNzMyYzU1MjM0ZSIsInN1YiI6IjYwMzM3ODBiMTEzODZjMDAzZjk0ZmM2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XYuIrLxvowrkevwKx-KhOiOGZ2Tn-R8tEksXq842kX4",
              "type": "string"
            }
          ]
        },
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.themoviedb.org/3/genre/movie/list",
          "protocol": "https",
          "host": ["api", "themoviedb", "org"],
          "path": ["3", "genre", "movie", "list"]
        }
      },
      "response": []
    },
    {
      "name": "Get poster image",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://image.tmdb.org/t/p/w500/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg",
          "protocol": "https",
          "host": ["image", "tmdb", "org"],
          "path": ["t", "p", "w500", "qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg"]
        }
      },
      "response": []
    }
  ]
};
