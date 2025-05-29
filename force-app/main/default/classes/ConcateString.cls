public class ConcateString {

   public static String ConcatenationOfString(String inputstr) {
       Integer characters=6;
       Integer totalOflength=inputstr.length();
       system.debug('totalOflength --- ' + totalOflength);
       List<String> chunks=new List<String>();
       for (Integer i=0;i<totalOflength;i+=characters){
           Integer endofstr=Math.min(i+characters,totalOflength);
           chunks.add(inputstr.substring(i,endofstr));
       }
       system.debug('chunks --- ' + chunks);
       /*
       String str1=chunks[0];
       String str2=chunks[1];
       String str3=chunks[2];
       System.debug('str1'+str1);
       System.debug('str2'+str2);
       System.debug('str3'+str3);
		*/
       
       String finalstring=String.join(chunks, '');
       System.debug('finalString --- '+finalstring);
       return finalstring;
    }
}