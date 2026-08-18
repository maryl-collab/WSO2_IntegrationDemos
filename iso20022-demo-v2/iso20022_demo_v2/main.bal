import ballerina/http;

type PaymentRequest record {
    string messageId;
    string debtorName;
    string debtorIBAN;
    string debtorBIC;
    string creditorName;
    string creditorIBAN;
    string creditorBIC;
    decimal amount;
    string currency;
    string reference;
};

service /iso20022 on new http:Listener(8290) {

    resource function get health() returns json {
        return {
            "status": "UP",
            "service": "WSO2 Integrator - ISO 20022 Demo",
            "standard": "ISO 20022",
            "capabilities": [
                "Generate pain.001 - Payment Initiation",
                "Generate pacs.008 - Interbank Credit Transfer"
            ]
        };
    }

    resource function post pain001(
            @http:Payload PaymentRequest req)
            returns http:Response {

        string xmlBody = string `<?xml version="1.0" encoding="UTF-8"?>
<Envelope>
  <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.12">
    <CstmrCdtTrfInitn>
      <GrpHdr>
        <MsgId>${req.messageId}</MsgId>
        <CreDtTm>2025-08-13T10:00:00</CreDtTm>
        <NbOfTxs>1</NbOfTxs>
        <CtrlSum>${req.amount}</CtrlSum>
        <InitgPty>
          <Nm>${req.debtorName}</Nm>
        </InitgPty>
      </GrpHdr>
      <PmtInf>
        <PmtInfId>${req.messageId}</PmtInfId>
        <PmtMtd>TRF</PmtMtd>
        <ReqdExctnDt>
          <Dt>2025-08-14</Dt>
        </ReqdExctnDt>
        <Dbtr>
          <Nm>${req.debtorName}</Nm>
        </Dbtr>
        <DbtrAcct>
          <Id>
            <IBAN>${req.debtorIBAN}</IBAN>
          </Id>
        </DbtrAcct>
        <DbtrAgt>
          <FinInstnId>
            <BICFI>${req.debtorBIC}</BICFI>
          </FinInstnId>
        </DbtrAgt>
        <CdtTrfTxInf>
          <PmtId>
            <EndToEndId>${req.reference}</EndToEndId>
          </PmtId>
          <Amt>
            <InstdAmt Ccy="${req.currency}">${req.amount}</InstdAmt>
          </Amt>
          <CdtrAgt>
            <FinInstnId>
              <BICFI>${req.creditorBIC}</BICFI>
            </FinInstnId>
          </CdtrAgt>
          <Cdtr>
            <Nm>${req.creditorName}</Nm>
          </Cdtr>
          <CdtrAcct>
            <Id>
              <IBAN>${req.creditorIBAN}</IBAN>
            </Id>
          </CdtrAcct>
          <RmtInf>
            <Ustrd>${req.reference}</Ustrd>
          </RmtInf>
        </CdtTrfTxInf>
      </PmtInf>
    </CstmrCdtTrfInitn>
  </Document>
</Envelope>`;

        http:Response response = new;
        response.setPayload(xmlBody);
        error? contentTypeResult = response.setContentType("application/xml");
        if contentTypeResult is error {
            return new http:Response();
        }
        return response;
    }

    resource function post pacs008(
            @http:Payload PaymentRequest req)
            returns http:Response {

        string xmlBody = string `<?xml version="1.0" encoding="UTF-8"?>
<Envelope>
  <AppHdr xmlns="urn:iso:std:iso:20022:tech:xsd:head.001.001.04">
    <Fr>
      <FIId>
        <FinInstnId>
          <BICFI>${req.debtorBIC}</BICFI>
        </FinInstnId>
      </FIId>
    </Fr>
    <To>
      <FIId>
        <FinInstnId>
          <BICFI>${req.creditorBIC}</BICFI>
        </FinInstnId>
      </FIId>
    </To>
    <BizMsgIdr>${req.messageId}</BizMsgIdr>
    <MsgDefIdr>pacs.008.001.12</MsgDefIdr>
    <CreDt>2025-08-13T10:00:00</CreDt>
  </AppHdr>
  <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pacs.008.001.12">
    <FIToFICstmrCdtTrf>
      <GrpHdr>
        <MsgId>${req.messageId}</MsgId>
        <CreDtTm>2025-08-13T10:00:00</CreDtTm>
        <NbOfTxs>1</NbOfTxs>
        <SttlmInf>
          <SttlmMtd>CLRG</SttlmMtd>
        </SttlmInf>
      </GrpHdr>
      <CdtTrfTxInf>
        <PmtId>
          <InstrId>${req.messageId}</InstrId>
          <EndToEndId>${req.reference}</EndToEndId>
          <UETR>a1b2c3d4-e5f6-7890-abcd-ef1234567890</UETR>
        </PmtId>
        <IntrBkSttlmAmt Ccy="${req.currency}">${req.amount}</IntrBkSttlmAmt>
        <ChrgBr>SHAR</ChrgBr>
        <InstgAgt>
          <FinInstnId>
            <BICFI>${req.debtorBIC}</BICFI>
          </FinInstnId>
        </InstgAgt>
        <InstdAgt>
          <FinInstnId>
            <BICFI>${req.creditorBIC}</BICFI>
          </FinInstnId>
        </InstdAgt>
        <Dbtr>
          <Nm>${req.debtorName}</Nm>
        </Dbtr>
        <DbtrAcct>
          <Id>
            <IBAN>${req.debtorIBAN}</IBAN>
          </Id>
        </DbtrAcct>
        <DbtrAgt>
          <FinInstnId>
            <BICFI>${req.debtorBIC}</BICFI>
          </FinInstnId>
        </DbtrAgt>
        <CdtrAgt>
          <FinInstnId>
            <BICFI>${req.creditorBIC}</BICFI>
          </FinInstnId>
        </CdtrAgt>
        <Cdtr>
          <Nm>${req.creditorName}</Nm>
        </Cdtr>
        <CdtrAcct>
          <Id>
            <IBAN>${req.creditorIBAN}</IBAN>
          </Id>
        </CdtrAcct>
        <RmtInf>
          <Ustrd>${req.reference}</Ustrd>
        </RmtInf>
      </CdtTrfTxInf>
    </FIToFICstmrCdtTrf>
  </Document>
</Envelope>`;

        http:Response response = new;
        response.setPayload(xmlBody);
        error? contentTypeResult = response.setContentType("application/xml");
        if contentTypeResult is error {
            return new http:Response();
        }
        return response;
    }
}
