public class JenkinsPMDFutureCallout {
    
    private static final String JENKINS_URL = 'https://your-jenkins-server';
    private static final String JOB_NAME    = 'Run-PMD';
    private static final String USERNAME    = 'your-jenkins-user';
    private static final String API_TOKEN   = 'your-api-token';
    
    // Step 1: Trigger Jenkins PMD Job
    @future(callout=true)
    public static void runPMD(String repoUrl, String branch) {
        try {
            String endpoint = JENKINS_URL + '/job/' + JOB_NAME + '/buildWithParameters';
            endpoint += '?REPO_URL=' + EncodingUtil.urlEncode(repoUrl, 'UTF-8');
            endpoint += '&BRANCH=' + EncodingUtil.urlEncode(branch, 'UTF-8');

            String auth = USERNAME + ':' + API_TOKEN;
            String encodedAuth = EncodingUtil.base64Encode(Blob.valueOf(auth));

            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Authorization', 'Basic ' + encodedAuth);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 201) {
                System.debug(' Jenkins PMD job triggered successfully.');
            } else {
                System.debug('Jenkins PMD job trigger failed: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(' Error triggering PMD job: ' + e.getMessage());
        }
    }

    // Step 2: Fetch PMD Report
    @future(callout=true)
    public static void fetchPMDReport() {
        try {
            // This assumes the latest build has completed
            String endpoint = JENKINS_URL + '/job/' + JOB_NAME + '/lastBuild/artifact/pmdReport.html';

            String auth = USERNAME + ':' + API_TOKEN;
            String encodedAuth = EncodingUtil.base64Encode(Blob.valueOf(auth));

            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Basic ' + encodedAuth);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                String reportHtml = res.getBody();
                System.debug('✅ PMD Report retrieved, length: ' + reportHtml.length());

                // Example: Store in Attachment
                Attachment att = new Attachment();
                att.Name = 'PMD_Report.html';
                att.Body = Blob.valueOf(reportHtml);
                att.ContentType = 'text/html';
                att.ParentId = UserInfo.getUserId(); // Or any related record ID
                insert att;

            } else {
                System.debug(' Failed to fetch PMD report: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(' Error fetching PMD report: ' + e.getMessage());
        }
    }
}
