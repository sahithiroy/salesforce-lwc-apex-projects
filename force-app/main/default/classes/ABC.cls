public class ABC {
    public static string zab;
    public string xyz;
    public  ABC(string xyz){
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
      /* public   String xyz='ABC';
       public static  String zab='BCD';
    public ABC( String b){
        xyz=xyz+b;//static elements canot be access in the constructor 
    }
    public static void mtd1(){
        ABC a1= new ABC('sai');
        a1.xyz=a1.xyz+zab; 
        System.debug(a1.xyz);//ABCSAIBCD
    }
    public void mtd2(){
        zab=xyz+zab;
        System.debug(xyz);//ABCSAHITHI
    }
    public void mtd3(){
        zab=xyz+zab;
        System.debug(zab);//ABCSAHITHIABCSAHITHIBCD
    }*/
}
/*
public class ABC{

public string personname;

public string city;

public static string nationality='india';


public void assignvalue(string name,string cit){

personname=name;

city =cit;

}

public static void showvalue(){
    ABC a1=new ABC();
    //a1.assignvalue( 'mahesh','kanpur');
system.debug('personname--->'+a1.personname);

system.debug('city--->'+a1.city);

system.debug('nationality--->'+nationality);

}
    public static void addtwostrings(){

string firstname= 'Kethireddy';

string lastname = 'kusuma' ;

string fullname = firstname +' '+lastname;

system.debug(fullname);

}
    public static double order(integer noBooks, integer noBags){

integer bookCost,bagcost,bookbill,bagBill;

double billAmount,actualbookBill,actualbagBill,finalbillAmount,discount,serviceCharge;

bookCost =1000;

bagcost=2000;

actualbookbill =bookbill-discount;
        System.debug('actualbookbill'+actualbookbill);

actualbagBill =bagBill-discount;
        System.debug('actualbagBill'+actualbagBill);

billAmount=(actualbookbill+actualbagBill);
System.debug('billAmount'+billAmount);
if (bookbill >10000){ discount=bookbill*0.10; }

else{ discount=bookbill*0.05; }

actualbookbill =bookbill-discount;

if (bagBill >50000){

discount=bagBill*0.20; }

else{

discount =bagBill*0.10;

}

bagBill = bagcost*noBags;

serviceCharge=billAmount*0.10;

finalbillAmount =billAmount+serviceCharge;

return billAmount;

}

}*/