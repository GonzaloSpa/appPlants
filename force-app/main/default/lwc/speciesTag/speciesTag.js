import { LightningElement, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class SpeciesTag extends NavigationMixin (LightningElement) {
    @api specie;

    //specie.Locotion__c = "indoors"
    //specie.Locotion__c = "outdoors"
    //specie.Locotion__c = "indoors, outdoors"
    
    get isOutdoors(){
        return this.specie.Loca__c.includes("Outdoors");
    }
    get isIndoors(){
        return this.specie.Loca__c.includes("Indoors");
    }

    navigateToRecordViewPage() {
        //view a custom object record
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.specie.Id,
                objectApiName: 'Species__c', // objectApiName is optional
                actionName: 'view'
            }
        });
    }
    

}
