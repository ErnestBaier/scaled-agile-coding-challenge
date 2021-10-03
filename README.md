# Scaled Agile Coding Challenge
 A repository created for the coding challenge provided by Scaled Agile

# The challenge
Instructions
Develop the solution using your choice of a scratch org or developer edition org.

### Task 1 - Meetup App
Create an app to manage Meetups.
This app will be used by Salesforce users to create and manage Meetups.
Use OOTB Salesforce features to build the UI (Apps, Tabs, Page layouts)
Use the model below instead of standard Salesforce objects like Lead and Campaign

### Meetup__c

| Field Name | Field Type | Description |
| :---: | :---: | :---: |
| Name | Text | The standard name field. |
| Owner | Lookup (User) | The standard owner field. |
| Status__c | Picklist | The status of the Meetup. The registration page should only allow new registrations when the status = Open Values: ● Open - default ● Closed |
| RegistrationCode__c | Text - 8 chars | The registration code that will be used to find this meetup on the registration page. When the Meetup is created, a registration code should be auto-generated. The registration code should be 8 characters long. Use only Alphanumeric characters. It should be random. |
| RegistrationLimit__c | Number | Required - The max # of registrations allowed for this Meetup |

### MeetupRegistration__c 

| Field Name | Field Type | Description |
| :---: | :---: | :---: |
| Registration Number | Text | The standard name field. Populate with an auto-number |
| Meetup__c | Master/Detail (Meetup__c) | Creates a M/D relationship with Meetup__c as the parent. |
| Email__c | email | Required |
| FirstName__c | Text - 40 chars | Required |
| LastName__c | Text - 80 char | Required |

### Task 2 - Registration Page
Create a page using LWCs that allows a user to register for the Meetup. Create a standard lightning page and add it to your Meetups app. Use LWCs for all UI and Apex for all data operations.

**Requirements:**
* The page should look for the Registration Code in the query string. I.e.
RegistrationPage?code=12345
The user can only register if the Meetup status is Open.
* The user cannot register when the total # of registrations exceed the registration limit for
this Meetup.
* Provide inputs for first name, last name and email. These fields are required.
* Each email must be unique per Meetup.
When creating the registration page, keep the following in mind:
* How can we make the registration process friendly for the user?
* All business rules must be reinforced in apex for security reasons.
* Unit tests are highly encouraged for all apex

# Setup

This repository contains SFDX project files that contain the metadata for custom objects, configuration and code used to provide a solution to meet the requirements and for discussion with the development team at Scaled Agile

# Additional Questions/ Assumptions

1. Should the Meetups and Meetup Registrations be searchable or will they be required to have a registation code?

2. Meetups/Calendar invites typically include a date - are these left out intentionally for business purpose?