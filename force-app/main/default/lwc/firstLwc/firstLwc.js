import { LightningElement } from 'lwc';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
export default class FirstLwc extends LightningElement {
    name='sahithi';
    company='salesforce';
    designation='Developer';
    salary='8768679';
    ready=false;    
    connectedCallback(){
        setTimeout(() => {
            this.ready = true;
          }, 3000);
    }
}