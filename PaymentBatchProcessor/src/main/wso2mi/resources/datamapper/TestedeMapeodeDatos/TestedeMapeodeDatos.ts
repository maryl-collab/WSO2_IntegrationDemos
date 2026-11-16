import * as dmUtils from "./dm-utils";
declare var DM_PROPERTIES: any;

/*
* title : "Payment",
* inputType : "XML",
*/
interface Payment {
    TxId: string
    SenderName: string
    SenderId: string
    SenderBIC: string
    ReceiverName: string
    ReceiverId: string
    ReceiverBIC: string
    Amount: string
    Currency: string
    Reference: string
}

/*
* title : "root",
* outputType : "JSON",
*/
interface Root {
    creditTransfer: {
        paymentId: string
        messageType: string
        debtor: {
            name: string
            account: string
            bic: string
        }
        creditor: {
            name: string
            account: string
            bic: string
        }
        amount: {
            value: number
            currency: string
        }
        remittanceInfo: string
        settlementMethod: string
        chargeBearer: string
    }
}



/**
 * functionName : map_S_Payment_S_root
 * inputVariable : inputPayment
*/
export function mapFunction(input: Payment): Root {
    return {
        creditTransfer: {
            paymentId: input.TxId,
            messageType: "",
            debtor: {
                name: input.SenderName,
                account: input.SenderId,
                bic: input.SenderBIC
            },
            creditor: {
                name: input.ReceiverName,
                account: input.ReceiverId,
                bic: input.ReceiverBIC
            },
            amount: {
                value: parseFloat(input.Amount),
                currency: input.Currency
            },
            remittanceInfo: input.Reference,
            settlementMethod: "",
            chargeBearer: ""
        }
    };
}

