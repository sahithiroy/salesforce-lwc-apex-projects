public class GitHubPMDCallout {

    @future(callout=true)
    public static void fetchPMDArtifactZip() {
        try {
            String gitHubToken = '';
            String repoOwner = 'sahithiroy';
            String repoName = 'salesforce-lwc-apex-projects';
            String runId = '16777099801';

            // GitHub API to list artifacts
            String artifactsUrl = 'https://api.github.com/repos/' + repoOwner + '/' + repoName + '/actions/runs/' + runId + '/artifacts';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(artifactsUrl);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + gitHubToken);
            req.setHeader('User-Agent', 'SalesforceApex');
            req.setHeader('Accept', 'application/vnd.github+json');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> artifacts = (List<Object>) jsonResponse.get('artifacts');

                for (Object obj : artifacts) {
                    Map<String, Object> artifact = (Map<String, Object>) obj;
                    String name = (String) artifact.get('name');

                    if (name == 'pmd-report') {//report name of the zip file
                        String downloadUrl = (String) artifact.get('archive_download_url');
                        System.debug(' PMD Artifact Download URL: ' + downloadUrl);

                        // Follow redirect to download the ZIP
                        HttpRequest downloadReq = new HttpRequest();
                        downloadReq.setEndpoint(downloadUrl);
                        downloadReq.setMethod('GET');
                        downloadReq.setHeader('Authorization', 'Bearer ' + gitHubToken);
                        downloadReq.setHeader('User-Agent', 'SalesforceApex');
                        downloadReq.setHeader('Accept', 'application/vnd.github+json');
                       
                        HttpResponse redirectRes = http.send(downloadReq);
                        if (redirectRes.getStatusCode() == 302) {
                            String redirectedUrl = redirectRes.getHeader('Location');
                            System.debug(' Redirected to: ' + redirectedUrl);

                            //  Actual download
                            HttpRequest zipReq = new HttpRequest();
                            zipReq.setEndpoint(redirectedUrl);
                            zipReq.setMethod('GET');
                            zipReq.setHeader('User-Agent', 'SalesforceApex');

                            HttpResponse zipRes = http.send(zipReq);
                            if (zipRes.getStatusCode() == 200) {
                                Blob zipBlob = zipRes.getBodyAsBlob();
                                System.debug('Succefully completed forthe retriving  zip file without unzip the content');
                                Compression.ZipReader reader = new Compression.ZipReader(zipBlob);
                                List<Compression.ZipEntry> entries = reader.getEntries();
                                for (Compression.ZipEntry entry : entries) {
                                    System.debug('Entry Path and Name: ' + entry.getName());
                                    System.debug('Entry Content: ' + entry.getContent());
                                    System.debug('Entry Compressed Size: ' + entry.getCompressedSize());
                                    System.debug('Entry Uncompressed Size: ' + entry.getUncompressedSize());
                                    Blob fileData = reader.extract(entry);
                                    System.debug('fileData'+fileData);
                                     if (entry.getName().endsWith('.json')) {
                                        String jsonContent = fileData.toString();
                                        System.debug(' JSON File Content: ' + jsonContent);
                                       JSONParser parser = JSON.createParser(jsonContent);Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonContent);
                                        System.debug(' Parsed JSON Map: ' + jsonMap);
                                     }
                                }
                                
                                
                            } else {
                                System.debug(' Failed to download ZIP: ' + zipRes.getStatusCode());
                            }

                        } else {
                            System.debug('Redirect not received, status: ' + redirectRes.getStatusCode());
                        }

                        break;
                    }
                }

            } else {
                System.debug(' Failed to get artifact list: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug(' Error in fetchPMDArtifactZip: ' + e.getMessage());
        }
    }
}
