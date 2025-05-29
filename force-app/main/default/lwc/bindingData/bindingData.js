import { LightningElement } from 'lwc';

export default class BindingData extends LightningElement {
    greeting='Hello sahithi !';
    name='';
    eventHandle(event){
        this.name=event.target.value;
    }
}