import { LightningElement,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

import FIRST_NAME_FIELD from '@salesforce/schema/Meetup_Registration__c.First_Name__c';
import LAST_NAME_FIELD from '@salesforce/schema/Meetup_Registration__c.Last_Name__c';
import EMAIL_FIELD from '@salesforce/schema/Meetup_Registration__c.Email__c';
import MEETUP_FIELD from '@salesforce/schema/Meetup_Registration__c.Meetup__c';
import getSingleMeetup from '@salesforce/apex/MeetupController.getSingleMeetup';
import createMeetupRegistration from '@salesforce/apex/MeetupRegistrationController.createMeetupRegistration';


export default class MeetupRegistration extends NavigationMixin(LightningElement) {
    //Modeled after recipe in lwc-recipes repo - https://github.com/trailheadapps/lwc-recipes/blob/main/force-app/main/default/lwc/apexImperativeMethodWithParams/apexImperativeMethodWithParams.js
    isLoading = false;
    showModal = false;
    currentPageReference;
    meetup;
    registrationCode;

    //Modeled after https://salesforceprofs.com/how-to-get-url-params-in-lwc/
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if(currentPageReference) {
            console.log(currentPageReference);
            this.currentPageReference = currentPageReference;
            //?code=12345
            this.registrationCode = this.currentPageReference.state.c__code;
        }
    }

    hanldeCodeChange(event) {
        this.registrationCode = event.target.value;
    }

    handleSearch() {
        //Activate spinner
        this.isLoading = true;
        console.log(this.registrationCode);
        //Perform query of meetup records with code
        //If found - show modal/ else toast error with no meetup found
        getSingleMeetup({ registrationCode: this.registrationCode })
            .then((result) => {
                console.log(result);
                this.meetup = result;
                this.showModal = true;
            })
            .catch((error) => {
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error finding meetup record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                this.showModal = false;
            });
        this.isLoading = false;
    }

    //Using imperative Apex method for Meetup_Registration__c creation rather than Create Record Form to satisfy 2 requirements
    // 1. ● Each email must be unique per Meetup.
    // 2. ● All business rules must be reinforced in apex for security reasons.
    handleRegistration() {
        //Activate spinner
        this.isLoading = true;
        let registrationRecord = {};
        let inputs = this.template.querySelectorAll("lightning-input");
        //Build object for insert from input values
        inputs.forEach(function(element){
            if(element.name == FIRST_NAME_FIELD.fieldApiName) {
                registrationRecord[FIRST_NAME_FIELD.fieldApiName] = element.value;
            }
            else if(element.name == LAST_NAME_FIELD.fieldApiName) {
                registrationRecord[LAST_NAME_FIELD.fieldApiName] = element.value;
            }
            else if(element.name == EMAIL_FIELD.fieldApiName) {
                registrationRecord[EMAIL_FIELD.fieldApiName] = element.value;
            }
        });
        registrationRecord[MEETUP_FIELD.fieldApiName] = this.meetup.Id;
        
        console.log(registrationRecord);
        createMeetupRegistration({meetupRegistrationObject : registrationRecord})
            .then((registration) => {
                console.log(registration);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Registration created',
                        variant: 'success'
                    })
                );
                this.showModal = false;
                this.navToRegistration(registration);
            })
            .catch((error) => {
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        this.isLoading = false;
    }

    navToRegistration(registration) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: registration.Id,
                objectApiName: 'Meetup_Registration__c',
                actionName: 'view'
            }
        });
    }

    handleCancel() {
        this.showModal = !this.showModal;
    }
}