import { LightningElement ,wire } from 'lwc';
import Acccount_Phone from '@salesforce/schema/Account.Phone';
import Acccount_Website from '@salesforce/schema/Account.Website';
import Acccount_Shipping_Address from '@salesforce/schema/Account.ShippingAddress';
import Acccount_Type from '@salesforce/schema/Account.Type';
import {getRecord} from 'lightning/uiRecordApi';
import Account_Object from '@salesforce/schema/Account';
import {createRecord} from 'lightning/uiRecordApi';
import { deleteRecord } from 'lightning/uiRecordApi';
export default class Example extends LightningElement {
    fields = [Acccount_Phone,Acccount_Website,Acccount_Shipping_Address,Acccount_Type];
    name;
    
    handleChange(event){
        this.name=event.target.value;
    }
    submit(){
        console.log('Submitted Name:', this.name);
        alert('Name submitted: ' + this.name);
    }
    //wire property 
    recordId='001dL00000xfUD8QAM';
    @wire(getRecord,{recordId:'$recordId',fields:[Acccount_Type]})
    record;
    //wired function
    @wire(getRecord,{recordId:'$recordId',fields:[Acccount_Type]})
    wiredRecords({data,error}){
        if(data){
            this.accounttype=data.fields.Type.value;
            console.log(data);
        }
        else if (error){
            console.log(error);
        }
    }
    
    createAcc(){
        const fields='';
        fields[Acccount_Phone.fieldApiName]='34567890';
        const recordInput={apiName:Account_Object.objectApiName,fields};
        createRecord(recordInput)
        .then((account)=>{
            console.log('Account record'+account.id);
        })
        .catch((error)=>{
            console.log(error);
        })
    }
    
            
}