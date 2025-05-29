public class MyfirstApex {
    public String name;
    public MyfirstApex(String newname){
        System.debug('I am in constructor');
        this.name=newname;
    }
    public void SayHello(){
        System.debug('Hello' +name+ '!');
    }
    public void SpecificObject() {
        Account obj1 = new Account(); 
        obj1.Name = 'sahithi';
        obj1.Phone = '7998097986';
        System.debug('Account: ' + obj1);
    }
    public void GenericObject(){
        sObject obj=new Account(Name='Test');
        Account acc=(Account)obj;
        System.debug('Acc'+acc);
    }
    public void  listMethod(){
        Boolean res;
        List<String> strList=new List<String>();
        List<String> strlist2=new List<String>();
        Set<String> strSet=new Set<String>();
        strList.add('India');
        strList.add('USA');
        strList.add(1,'UK');
        strlist2.add('Australia');
        strlist2.add('Canada');
        strList.addAll(strlist2);
        strSet.add('Japan');
        strList2.addall(strSet);
        System.debug('strList=>'+strList);
        System.debug('strList2=>'+strList2);
        strList2.clear();
        System.debug('strList2=>'+strList2);
        strList2=strList.clone();
        System.debug('strList2=>'+strList2);
        res=strList.contains('India');
        System.debug('Result'+res);
        sObject sobj=[SELECT Id,Name from Account Limit 1];
        System.debug('object type'+sobj.getSobjectType());
    }

}