public class RestAuth {
@AuraEnabled
public static void methodName(){
    try {
        System.debug('Examplerunning');
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
}