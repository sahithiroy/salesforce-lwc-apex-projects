public with sharing class OAuthController {
    //public static Id incomingId;
    
    @AuraEnabled
	public static String geturl(Id recordId) {
    	try {
            
        	String clientId = '3MVG9GCMQoQ6rpzQHnD7aSs3GfF1sS3hUQOUO5ktPnV7508btl2dM.j7s5tdB3HkyOWLwJUilGhps0YV7NcV5';
        	String domain = 'https://login.salesforce.com';
        	String redirectUri = 'https://zyroneenergy-dev-ed.develop.my.salesforce.com/apex/OAuthCallbackPage';

        	// Pass recordId as state
            String authUrl = domain + '/services/oauth2/authorize' +
                             '?response_type=code' +
                             '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                             '&redirect_uri=' + EncodingUtil.urlEncode(redirectUri, 'UTF-8') +
                             '&state=' + EncodingUtil.urlEncode(recordId, 'UTF-8');
            

        	HttpRequest req = new HttpRequest();
        	req.setEndpoint(authUrl);
        	req.setMethod('GET');

        	Http http = new Http();
        	HttpResponse res = http.send(req);
            //string code = res.json()['code'];
            //System.debug('code'+code);

        	System.debug('Response: ' + res);
        	System.debug('Status Code: ' + res.getStatusCode() + ', Body: ' + res.getBody());

        	if (res.getStatusCode() == 302) {
            	String location = res.getHeader('Location');
            	System.debug('Redirect Location: ' + location);
            	return location;
        	} else {
            	return 'Error: ' + res.getStatusCode() + ' - ' + res.getBody();
        	}

    	} catch (Exception e) {
        	return e.getMessage();
    	}
	}
    @AuraEnabled
    public static String storeTokens(String authCode,id incomingId ){
        System.debug('Auth Code: ' + authCode);
        System.debug('incomingId'+incomingId);
        try{
            
            String body='grant_type=authorization_code&client_id=3MVG9GCMQoQ6rpzQHnD7aSs3GfF1sS3hUQOUO5ktPnV7508btl2dM.j7s5tdB3HkyOWLwJUilGhps0YV7NcV5&client_secret=24404AD0EEAF2E642303E1A4CFD046541504FF3E348726A65CB1E292F4705F2A&redirect_uri=https://zyroneenergy-dev-ed.develop.my.salesforce.com/apex/OAuthCallbackPage&code='+authCode;
            Http http=new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody(body);
            HttpResponse res=http.send(req);
            System.debug('res'+res);
            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug('responseMap'+responseMap);
                Authentication__c record=[SELECT Id, Refresh_Token__c,Access_Token__c FROM Authentication__c where Id =:incomingId];
                record.Access_Token__c = (String)responseMap.get('access_token');
                System.debug('acess token '+record.Access_Token__c);
                record.Refresh_Token__c = (String)responseMap.get('refresh_token');
                System.debug('refresh token'+record.Refresh_Token__c);
                record.Domain_Url__c = (String)responseMap.get('instance_url');
                System.debug('domain url'+record.Domain_Url__c);
                update record;
            }
            return res.getBody();
        }catch(Exception ex){
            return ex.getMessage();
        }
        
    }
}