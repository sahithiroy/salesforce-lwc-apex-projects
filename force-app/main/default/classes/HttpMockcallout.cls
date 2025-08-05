global class HttpMockcallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"userId":1,"id":1,"title":"Sample Title","body":"Sample Body"}]');
        res.setStatusCode(200);
        return res;
    }
}