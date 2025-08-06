public class Example {
    
    public static void changeValue(Integer num) {
        System.debug('befor num'+num);
        num = 100;
        System.debug('after num'+num);
    }

    public static void run() {
        Integer x = 10;
        changeValue(x);
        System.debug(x); 
    }
    public static void method1(){
        List<Integer>marklist=new List<Integer>();
        System.debug('before marklist'+marklist.size());
        method2(marklist);
        System.debug('after marklist'+marklist.size());
        System.debug('after marklist'+marklist.size());
    }
    public static void method2(List<integer>mklist){
        mklist.add(20);
        mklist.add(2);
        mklist.add(20);
        System.debug('mklist'+mklist.size());
        System.debug('Succesfully completed  marklist');
    }
}