public with sharing class PmdJenkins {


    @future(callout=true)
    public static void triggerSCA() {
        String username = 'praveen';
        String password = '11a2d14b7670ab29db57f001df9320ea83';
        String jobName = 'SCA_Scan_Job'; // Update this to your Jenkins job name
        String branchName = 'featurebranch';
        String repoUrl = 'https://github.com/sahithiroy/salesforce-lwc-apex-projects';

        // Build Jenkins trigger URL with parameters
        String endpoint = 'http://3.234.208.135:8080/job/Git-Merge-Automation/build/buildWithParameters';
        endpoint += '?BRANCH_NAME=' + EncodingUtil.urlEncode(branchName, 'UTF-8');
        endpoint += '&REPO_URL=' + EncodingUtil.urlEncode(repoUrl, 'UTF-8');

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        // Add basic authentication
        String basicAuth = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
        req.setHeader('Authorization', basicAuth);

        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('✅ Jenkins SCA trigger response: ' + res.getBody());
        } catch (Exception e) {
            System.debug('❌ Jenkins SCA trigger failed: ' + e.getMessage());
        }
    }
}


