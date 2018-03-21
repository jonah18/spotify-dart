library spotify_api;

import 'dart:async';
import 'package:rpc/rpc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

import 'credentials.dart' as creds;

@ApiClass(name: 'spotify_dart', version: 'v1')
class SpotifyDartService {

  String accessToken = '';
  String spotifyApiUrl = "https://api.spotify.com/v1";

  @ApiMethod(method: 'GET', path: 'authenticate')
  SpotifyResponse authenticate() {

    // Format response body and headers
    String tokenUrl = "https://accounts.spotify.com/api/token";
    String auth = creds.clientId + ":" + creds.clientSecret;
    var bytes = UTF8.encode(auth);
    var encoded = BASE64.encode(bytes);
    var body = {"grant_type": "client_credentials"};
    var headers = {"Authorization": "Basic " + encoded};

    // Connect to HTTP Client and make token request of Spotify API
    var client = new http.Client();
    client.post(tokenUrl, body: body, headers: headers)
      .then((response) {
        if (response.statusCode == 200) {
          print("Successfully Authenticated");

          // Parse and retrieve access token
          Map parsedRes = JSON.decode(response.body);
          accessToken = parsedRes['access_token'];
        } else {
          print("Error authenticating");
        }
      });

    return new SpotifyResponse("auth", "Authenticating");
  }

  @ApiMethod(method: 'GET', path: 'artist/search/{artistName}')
  SpotifyResponse searchArtist(String artistName) {

    String searchUrl =
      Uri.encodeFull(spotifyApiUrl + "/search?type=artist&limit=1&q=" + artistName);
    var headers = {"Authorization": "Bearer " + accessToken};

    // Connect to HTTP Client and make search request
    var client = new http.Client();
    client.get(searchUrl, headers: headers)
      .then((response) {
        print("=====RESPONSE BODY: \n${response.body}");
      });

    return new SpotifyResponse("search", "Searched " + artistName);
  }
}

class SpotifyResponse {
  String method, message;
  SpotifyResponse(this.method, this.message);
}