public class FetchParent {
    public static Id FetchUltimateParent(Id input_id){
        Account currentRecord=[SELECT id,ParentId from Account where id= :input_id limit 1];
        while (currentRecord.ParentId!=null){
            currentRecord=[SELECT id,ParentId from Account where id =: currentRecord.ParentId limit 1];
        }
        System.debug('Ultimate Record'+currentRecord.Id);
        return currentRecord.Id;
    }

}