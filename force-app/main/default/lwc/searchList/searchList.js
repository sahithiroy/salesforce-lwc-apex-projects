import { LightningElement,track } from 'lwc';

export default class SearchList extends LightningElement {
    @track searchKey;
    @track searchResults=[];
    handleSearch(){
        this.searchKey=event.target.value;
        if (this.searchKey.length()>2){
            
        }
    }

}