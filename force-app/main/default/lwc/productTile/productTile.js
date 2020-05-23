import { LightningElement,api,track,wire } from 'lwc';
export default class ProductTile extends LightningElement {
    @track isSelected = false;
    @api product;
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('productview', {
            detail: this.product.id
        });
        this.dispatchEvent(selectEvent);
    }
    handleClick() {
        this.isSelected = !this.isSelected;
        //alert(this.product.id);
        const selectEvent = new CustomEvent('checkoutview', {
            detail: {
                id : this.product.id,
                qty : this.product.qty,
                price : this.product.price,
                brand : this.product.brand,
                name : this.product.name,
                code : this.product.code,
                pbid : this.product.pbid
            }
        });
        this.dispatchEvent(selectEvent);
    }
}