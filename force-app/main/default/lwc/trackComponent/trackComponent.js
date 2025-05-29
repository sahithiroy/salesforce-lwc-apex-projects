import { LightningElement,track } from 'lwc';

export default class TrackComponent extends LightningElement {
     @track fruits=['Apple','Orange','Banana'];
     
     handleAdd(){
         this.fruits.push('Mango');
         this.fruits=[...this.fruits];
     }
}