@isTest
public class OAuthCalloutMocks {
    public class HeaderMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Location', 'https://login.salesforce.com/redirectedUrl');
            res.setStatusCode(302); 
            res.setBody('Redirecting');
            return res;
        }
    }
    public class ErrorMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);  
            res.setBody('Bad Request');
            return res;
        }
    }
    
    public class SuccessMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res= new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{' +
            '"access_token": "mockAccessToken",' +
            '"refresh_token": "mockRefreshToken",' +
            '"instance_url": "https://mockinstance.salesforce.com"' +
        '}');
            return res;
        }
    }
    public class FailureMock implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res= new HttpResponse();
            res.setStatusCode(400);
            res.setBody('Methods defined as TestMethod do not support Web service callouts');
            return res;
        }
    }
}