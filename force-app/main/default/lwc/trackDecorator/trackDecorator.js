import { LightningElement,track } from 'lwc';

export default class TrackDecorator extends LightningElement {
   @track person={
    'name':'sahithi',
    'age':'21'
   }
   count=0;
   handle(){
    if (this.count%2==0){
        this.person.name='Sugavasi Sahithi';
    }
    else{
        this.person.name='Sahithi';
    }
    
    this.count++;
   }
}