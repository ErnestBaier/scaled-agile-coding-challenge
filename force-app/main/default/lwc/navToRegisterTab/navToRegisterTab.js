import { api, LightningElement, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import REGISTRATION_CODE from '@salesforce/schema/Meetup__c.Registration_Code__c';


export default class NavToRegisterTab extends NavigationMixin(LightningElement) {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: REGISTRATION_CODE })
    meetup;

    get registrationCode() {
        return getFieldValue(this.meetup.data, REGISTRATION_CODE);
    }

    navigateToRegisterTab() {
        console.log(this.registrationCode);
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Register'
            },
            state:{c__code : this.registrationCode }
        });
    }
}