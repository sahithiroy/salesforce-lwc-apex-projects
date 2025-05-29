public class CallOutExample {
    public void getcall(){
        Http http=new Http();
        HttpRequest request =new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            System.debug('Response Body: ' + response.getBody());
        } else {
            System.debug('Failed with status: ' + response.getStatus());
        }
    }
    public void getPosts() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            System.debug('Response Body: ' + response.getBody());
        } else {
            System.debug('Failed with status: ' + response.getStatus());
        }
    }

}