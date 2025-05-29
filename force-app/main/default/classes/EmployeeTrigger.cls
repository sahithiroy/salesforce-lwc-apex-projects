public class EmployeeTrigger {
    public static void beforeDelete(List<Employee__c> oldList){
        for (Employee__c emp : oldList){
            if(emp.Active__c==True){
                emp.addError('Employee cannot be removed');
            }
        }
    }
    public static void afterUnDelete(List<Employee__c> newList){
        List<Employee__c> empTobeUpdated=new List<Employee__c>();
        for (Employee__c emp: newList){
            Employee__c e=new Employee__c();
            e.id=emp.id;
            e.Active__c=True;
            empTobeUpdated.add(e);
        }
        if (!empTobeUpdated.isEmpty()){
            update empTobeUpdated;
        }
    }

}