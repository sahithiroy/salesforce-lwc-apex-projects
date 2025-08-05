@isTest
public class OAuthControllerTest {
    /*@isTest
    static void test_successurl(){
        Test.setMock(HttpCalloutMock.class, new OAuthCalloutMocks.HeaderMock());
        Test.startTest();
        String result=OAuthController.geturl();
        Test.stopTest();
        System.debug('result'+result);
        System.assertEquals(result, 'https://login.salesforce.com/redirectedUrl');
    }
    @isTest
    static void testGetUrlError() {
        Test.setMock(HttpCalloutMock.class, new OAuthCalloutMocks.ErrorMock());
        Test.startTest();
        String result = OAuthController.geturl();
        Test.stopTest();
        System.debug('Test Error Result: ' + result);
        System.assert(result.startsWith('Error:'), 'Expected an error response');
    }
    @isTest 
    static void testGetUrlException(){
        //Test.setMock(HttpCalloutMock.class, new OAuthCalloutMocks.FailureMock());
        Test.startTest();
        String result=OAuthController.geturl();
        Test.stopTest();
        System.debug('result'+result);
        System.assert(result.contains('Methods defined as TestMethod do not support Web service callouts'), 'Expected exception message when callout fails');
    }
    @isTest
    static void testGetSucessTokens(){
        Test.setMock(HttpCalloutMock.class,new OAuthCalloutMocks.SuccessMock());
        Authentication__c auth = new Authentication__c(Name='sahithi');
        insert auth;
        Test.startTest();
        string result=OAuthController.storeTokens('zxdrt67yujm098765re12wedfvgbnzdrt6789009uytrd',auth.id);
        Test.stopTest();
        System.debug('Test Sucess result : '+result);
        System.assert(result.contains('access_token'), 'Expected token in response');
        //System.assertEquals(result.getStatuscode(),200);
        
    }
    @isTest
    static void  testfailure(){
        Authentication__c auth = new Authentication__c(Name='sahithi');
        insert auth;
        Test.startTest();
        string result=OAuthController.storeTokens('zxdrt67yujm098765re12wedfvgbnzdrt6789009uytrd',auth.id);
        Test.stopTest();
        System.debug('Test failure result : '+result);
        System.assert(result.contains('Methods defined as TestMethod do not support Web service callouts'), 'Expected exception message when callout fails');
    }*/
}