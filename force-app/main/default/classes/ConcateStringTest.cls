@isTest
public class ConcateStringTest {
    @isTest
    public static void testConcatenationOfString() {
        String input = 'SalesForce is a CRM platform that helps business manage customer interactions, automate process and analyaze data.';
        system.debug('input-->'+input.length());
        String result = ConcateString.ConcatenationOfString(input);
        system.debug('result-->'+result.length());
        System.assertEquals(input, result);
    }
    @isTest
    public static void testWithShortString() {
        String input = 'Short string example for test.';
        system.debug('input-->'+input.length());
        String result = ConcateString.ConcatenationOfString(input);
        system.debug('result-->'+result.length());
        System.assertEquals(input, result);
    }
    @isTest
    public static void testWithEmptyString() {
        String input = '';
        system.debug('input-->'+input.length());
        String result = ConcateString.ConcatenationOfString(input);
        system.debug('result-->'+result.length());
        System.assertEquals('', result);
    }
}