import searchProducts from '@salesforce/apex/PricebookEntryController.searchProducts';
import insertOrderItems from '@salesforce/apex/OrderItemController.insertOrderItems';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from 'lightning/platformResourceLoader';
import ursusResources from '@salesforce/resourceUrl/ursus_park';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, wire, track, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import ORDER_OBJECT from '@salesforce/schema/Order';
import ACCOUNTID_FIELD from '@salesforce/schema/Order.AccountId';
import CONTRACTID_FIELD from '@salesforce/schema/Order.ContractId';
import STATUS_FIELD from '@salesforce/schema/Order.Status';
import EFFECTIVEDATE_FIELD from '@salesforce/schema/Order.EffectiveDate';
import SHIPPINGADDRESS_FIELD from '@salesforce/schema/Order.ShippingAddress';

export default class ProdListNav extends NavigationMixin(LightningElement) {
	@track columns = [
        // { label: 'ind', fieldName: 'ind', type: 'text'},
        { label: 'Name', fieldName: 'Name'},
        { label: 'Product Code', fieldName: 'ProductCode'},
        { label: 'Brand', fieldName: 'Brand'},
		{ label: 'Unit Price', fieldName: 'UnitPrice', type:'currency'},
		{ label: 'In Stock', fieldName: 'StockQuantity', type:'number'},
        { label: 'Quantity', fieldName:'Quantity', type: 'number', editable: true},
    ];
	@api recordId;
	@track orderId;
	@track draftValues;
	orderObject = ORDER_OBJECT;
	myfields = [ACCOUNTID_FIELD,EFFECTIVEDATE_FIELD,CONTRACTID_FIELD,STATUS_FIELD,SHIPPINGADDRESS_FIELD];
	searchTerm = '';
	@track showup = false;
	@track showplist = true;
	@wire(searchProducts, {searchTerm: '$searchTerm'})
	products;
	connectedCallback() {
		loadStyle(this, ursusResources + '/style.css');
	}
	@track selectedProds = [];
	handleSearchTermChange(event) {
		// Debouncing this method: do not update the reactive property as
		// long as this function is being called within a delay of 300 ms.
		// This is to avoid a very large number of Apex method calls.
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
		console.log(this.products);
	}
	get hasResults() {
		return (this.products.data.length > 0);
	}
	handleProductView(event) {
		// Get bear record id from bearview event
		const productId = event.detail;
		// Navigate to bear record page
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: productId,
				objectApiName: 'Product2',
				actionName: 'view',
			},
		});
	}
	handleCheckoutView(event){
		const prod = {'Id':event.detail.id,
					'Name':event.detail.name,
					'Brand':event.detail.brand,
					'ProductCode':event.detail.code,
					'UnitPrice':event.detail.price,
					'StockQuantity':event.detail.qty,
					'PricebookId':event.detail.pbid};
		console.log(prod);
		const idx = this.selectedProds.map(function(e) { return e.Id; }).indexOf(prod.Id);
		console.log(idx);
		if(idx!=-1){
			this.selectedProds.splice(idx,1);
			this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Product removed!',
                    message: 'Product removed from cart : '+prod.Brand+' '+prod.Name,
                    variant: 'info'
                })
            );
		}
		else{
			this.selectedProds.push(prod);
			this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Product added!',
                    message: 'Product added to cart : '+prod.Brand+' '+prod.Name,
                    variant: 'success'
                })
            );
		}
		console.log(this.selectedProds.length);
	}
	handleOpenCart(event){
		if(this.selectedProds.length!=0)
			this.showup = true;
		else{
			this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!',
                    message: 'Cart Empty : Add products to proceed',
                    variant: 'error'
                })
            );
		}

	}
	closeModal(){
		this.showup = false;
	}
	handleOrderCreated(event){
		this.orderId = event.detail.id;
		this.dispatchEvent(
			new ShowToastEvent({
				title: 'Order created!',
				message: 'Order '+event.detail.id+' created',
				variant: 'success'
			})
		);
		this.showplist=false;
	}
	handleClear(){
        this.searchTerm='';
	}
	handleSave(event){
		var i = 0;
		const dataToInsert = [];
		for(var e in event.detail.draftValues){
			const ind = this.selectedProds.map(function(e) { return e.Id; }).indexOf(event.detail.draftValues[i].Id);
			const item = {'sobjectType': 'OrderItem'};
			item.OrderId = this.orderId;
			item.Product2Id = this.selectedProds[ind].Id;
			item.Quantity = event.detail.draftValues[i].Quantity;
			item.UnitPrice = this.selectedProds[ind].UnitPrice;
			item.PricebookEntryId = this.selectedProds[ind].PricebookId;
			dataToInsert.push(item);
			i++;
		}
		insertOrderItems({
            li:dataToInsert
        })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: event.detail.draftValues.length+' Records inserted',
                    variant: 'success'
                })
            );
            // Clear all draft values
            this.draftValues = [];
			
            // Display fresh data in the datatable
			this.searchKey='';
			this.showup=false;
			return refreshApex(this.products);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error inserting records',
                    message: 'Recheck quantities entered for each product',
                    variant: 'error'
                })
            );
		});
	}
}