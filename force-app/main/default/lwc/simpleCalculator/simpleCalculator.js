import { LightningElement, track } from 'lwc';

export default class SimpleCalculator extends LightningElement {
    @track a ;
    @track b ;
    @track result;

    handleChange(event) {
        const field = event.target.label;
        if (field === 'a') {
            this.a = parseFloat(event.target.value);
        } else if (field === 'b') {
            this.b = parseFloat(event.target.value);
        }
    }

    add() {
        this.result = this.a + this.b;
    }

    subtract() {
        this.result = this.a - this.b;
    }

    mul() {
        this.result = this.a * this.b;
    }

    div() {
        this.result = this.b !== 0 ? this.a / this.b : 'Cannot divide by zero';
    }
}