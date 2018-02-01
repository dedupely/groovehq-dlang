module groovehq;

import std.net.curl;
import std.json;
import std.stdio;
import std.uri;
import etc.c.curl : CurlOption;

ushort createGrooveTicket(string apiKey, JSONValue ticket) {
  HTTP http = HTTP("https://api.groovehq.com/v1/tickets?access_token=" ~ apiKey);
  ushort code;
  string rawBody;

  http.handle.set(CurlOption.ssl_verifypeer, 0);
  http.handle.set(CurlOption.ssl_verifyhost, 0);

  http.method = HTTP.Method.post;

  http.onReceiveStatusLine = (http.StatusLine statusLine) {
    code = statusLine.code;
  };

  http.onReceive = (ubyte[] data) {
    rawBody ~= cast(string)data;

    return data.length;
  };

  string ticketStr = ticket.toJSON();
  
  http.contentLength = ticketStr.length;
  http.setPostData(ticketStr, "application/json");

  http.perform();

  return code;
}
