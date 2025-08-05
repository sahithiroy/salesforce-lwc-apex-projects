import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import storeTokens from '@salesforce/apex/OAuthController.storeTokens';

export default class AuthRedirectHandler extends LightningElement {
    authCode;
    state;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('CurrentPageReference:', currentPageReference);

            this.authCode = currentPageReference.state?.c__authCode;
            this.state = currentPageReference.state?.c__recordId;

            console.log('OAuth Code:', this.authCode);
            console.log('OAuth State:', this.state);

            if (this.authCode) {
                // Call Apex
                storeTokens({ authCode: this.authCode ,incomingId:this.state})
            }
        }
    }
}





/*import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class AuthRedirectHandler extends LightningElement {
     
     /*@wire(CurrentPageReference)
     currentPageReference;

    connectedCallback(){
        console.log('currentpagereference',this.currentPageReference);
        console.log(`c__myParam = ${this.currentPageReference.state.c__myParam}`);
    }
    @wire(CurrentPageReference)
    getCurrentRef;
    authCode;
    recordId;
    error;
   
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            
            const params = currentPageReference.state;
            console.log('URL State Parameters:', params);

            this.authCode = params.code;
            this.recordId = params.recordId;

            if (this.authCode) {
                console.log('Auth Code:', this.authCode);
                console.log('Record Id:', this.recordId);

                storeTokens({
                    authCode: this.authCode, recordId:this.recordId
                })
                    .then(() => {
                        console.log('Tokens stored successfully');
                    })
                    .catch(error => {
                        console.error('Error storing tokens:', error);
                        this.error = 'Failed to store tokens.';
                    });
            } else {
                this.error = 'Authorization code not found in URL.';
                console.error(this.error);
            }
        }
    }/*
   connectedCallback() {
    console.log('connectedCallback');
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get('code');
    const state = urlParams.get('state');
 
    console.log('OAuth Code:', code);
    console.log('OAuth State:', state);
    console.log('current url is ', window.location.search);
    console.log('current url params ',urlParams);
     
  }
        
    
}*/