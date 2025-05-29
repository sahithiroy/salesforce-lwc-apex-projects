public class ListTask {
    public Integer sum=0;
    public void addIntegers(){
        for (Integer i=0;i<=10;i++){
            sum=sum+i;
        }
        System.debug('sum'+sum);
    }
    public void ReverseIntegers(){
        List<Integer> lis =new List<Integer>{1, 2, 3, 4, 5};
        System.debug('list=>'+lis);
        List<Integer> revlis =new List<Integer>();
        for (Integer i=lis.size();i>0;i--){
            revlis.add(i);
        }
        System.debug('revlist=>'+revlis);
    }
    public void FindDuplicateValues(){
        List<Integer> lis =new List<Integer>{1, 2, 3, 4, 5,5};
        System.debug('list=>'+lis);
        Set<Integer> set1=new Set<Integer>();
        set1.addall(lis);
        System.debug('set=>'+set1);
         Set<Integer> uniquevalues=new Set<Integer>();
         Set<Integer> duplicatevalues=new Set<Integer>();
        for (Integer num: lis){
            if(!uniquevalues.add(num)){
                duplicatevalues.add(num);
            }
        }
        System.debug('duplicatevalues'+duplicatevalues);
        
    }
    public void CountWordFrequency(){
        List<String> lis =new List<String>{'apple', 'banana', 'apple', 'orange', 'banana', 'apple'};
        System.debug('list=>'+lis);
        Map<String,Integer> mapword=new Map<String,Integer>();
        for (String num:lis){
            if (mapword.containskey(num)){
                mapword.put(num,mapword.get(num)+1);
            }else{
                mapword.put(num,1);
            }
        }
        System.debug('map'+mapword);
    }
    public void sobjectMethod(){
        List<Account> lisAcc=new List<Account>();
        Set<Id> accIds=new Set<Id>();
        lisAcc=[SELECT Id,Name From Account Limit 2];
        System.debug('lisacc=>'+lisAcc);
        for (Account acc:lisAcc){
            accIds.add(acc.id);
        }
        System.debug('accids'+accIds);
    }
}