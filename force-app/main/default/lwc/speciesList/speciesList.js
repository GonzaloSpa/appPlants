import { LightningElement, wire } from 'lwc';
import getFilteredSpecies from "@salesforce/apex/SpeciesService.getFilteredSpecies";

export default class SpeciesList extends LightningElement {
    // PROPERTIES, GETTERS & SETTERS
    searchText = ""; 

    // LIFECYCLE HOOKS

    //WIRE
    @wire(getFilteredSpecies, { searchText : '$searchText'})
    species;

    //METHODS
    handleInputChange(event) {
        const searchTextAux = event.target.value;
        if (searchTextAux.length >= 3 || searchTextAux === ""){
            this.searchText = searchTextAux;
        }
        

    }
}