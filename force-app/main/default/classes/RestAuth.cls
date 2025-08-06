public class RestAuth {
     public static string zab;
    public string xyz;
    public  RestAuth(string xyz){
        xyz=xyz;
    }
    public void mtd3(){
        system.debug('mtd3-->xyz'+xyz);
    }
    public static void mtd1(string res){
        zab=res;
        System.debug('zab--->mtd1'+zab);
    }
    public static void mtd2(){
        System.debug('zab--->mtd2'+zab);
    }
@AuraEnabled
public static void methodName(){
    try {
        System.debug('Examplerunning');
         System.debug('Examplerunning');
         
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
}