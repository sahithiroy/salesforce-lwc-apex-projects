import { LightningElement,wire } from 'lwc';
import NAME_FILED from '@salesforce/schema/Account.Name';
import { getRecord } from 'lightning/uiRecordApi';
export default class DataService extends LightningElement {
      recordId;
      @wire(getRecord,{recordId:'001dL00000udqL5QAI',fields:[NAME_FILED]})
      account;
      getName(){
        return  this.account.data.fields.Name.value ;
      }
}