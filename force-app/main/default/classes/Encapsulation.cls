public class Encapsulation {
    Decimal length;
    Decimal breadth;
    public Encapsulation(Decimal l, Decimal b){
        length=l;
        breadth=b;
    }
    public void area(){
        Decimal res=length*breadth;
        System.debug('area'+res);
    }
    public void Perimeter(){
        Decimal res=2*(length+breadth);
        System.debug('perimeter'+res);
    }

}