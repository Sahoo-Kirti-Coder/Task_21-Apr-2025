codeunit 50650 "Exception Table Management"
{
    procedure insertIntoExceptionTable(var custLedgerEntry: Record "Cust. Ledger Entry"; var EntryNoToGiven: Integer)
    var
        totalInterval: Integer;
        currentWorkDate: Date;
        exceptionTable: Record "Exception Table";
        entryNoHolder: List of [Integer];
        entryNo: Integer;
        isCustomerExistsBefore: Boolean;
        customerNo: Code[20];

    begin
        currentWorkDate := WorkDate;

        repeat
            totalInterval := currentWorkDate - custLedgerEntry."Due Date";
            if totalInterval > 5 then begin
                if not checkIfDataAlreadyExistsByCustNoAndDocNo(custLedgerEntry."Customer No.", custLedgerEntry."Document No.") then begin
                    custLedgerEntry.CalcFields("Original Amt. (LCY)");
                    custLedgerEntry.CalcFields("Remaining Amount");
                    if custLedgerEntry."Remaining Amount" <> 0 then begin
                        exceptionTable.Init();
                        exceptionTable."Entry No" := EntryNoToGiven;
                        exceptionTable."Customer No" := custLedgerEntry."Customer No.";
                        exceptionTable."Document No" := custLedgerEntry."Document No.";
                        exceptionTable."Original Amount" := custLedgerEntry."Original Amt. (LCY)";
                        exceptionTable."Remaining Amount" := custLedgerEntry."Remaining Amount";
                        exceptionTable."Days Late" := totalInterval;
                        exceptionTable."Invoice Date" := custLedgerEntry."Posting Date";
                        exceptionTable."Due Date" := custLedgerEntry."Due Date";
                        exceptionTable.Insert();
                        entryNoHolder.Add(EntryNoToGiven);
                        EntryNoToGiven += 1;
                    end;
                end;
            end;
        until custLedgerEntry.Next() = 0;

        if entryNoHolder.Count > 1 then begin
            foreach entryNo in entryNoHolder do begin
                if exceptionTable.Get(entryNo) then begin
                    exceptionTable."Multiple Invoices" := true;
                    exceptionTable.Modify();
                end;
            end;
            exceptionTable.Get(entryNoHolder.Get(1));
            customerNo := exceptionTable."Customer No";
            makePreviousMultipleInvoiceTrue(customerNo);
        end
        else
            if entryNoHolder.Count > 0 then begin
                exceptionTable.Get(entryNoHolder.Get(1));
                customerNo := exceptionTable."Customer No";
                isCustomerExistsBefore := checkIfDataAlreadyExistsByOnlyCustNo(customerNo);

                if isCustomerExistsBefore then begin
                    if exceptionTable.Get(entryNoHolder.Get(1)) then begin
                        exceptionTable."Multiple Invoices" := true;
                        exceptionTable.Modify();
                        makePreviousMultipleInvoiceTrue(customerNo);
                    end;
                end;
            end;

        if entryNoHolder.Count > 0 then
            entryNoHolder.RemoveRange(1, entryNoHolder.Count);
    end;

    procedure checkIfDataAlreadyExistsByOnlyCustNo(custNo: Code[20]): Boolean
    var
        exceptionTable: Record "Exception Table";
    begin
        exceptionTable.Reset();
        exceptionTable.SetCurrentKey("Customer No");
        exceptionTable.SetRange("Customer No", custNo);
        if exceptionTable.Count > 1 then begin
            exit(true);
        end
        else
            exit(false);
    end;

    procedure checkIfDataAlreadyExistsByCustNoAndDocNo(custNo: Code[20]; docNo: Code[20]): Boolean
    var
        exceptionTable: Record "Exception Table";
    begin
        exceptionTable.Reset();
        exceptionTable.SetCurrentKey("Customer No");
        exceptionTable.SetRange("Customer No", custNo);
        exceptionTable.SetCurrentKey("Document No");
        exceptionTable.SetRange("Document No", docNo);
        if exceptionTable.Count > 0 then
            exit(true)
        else
            exit(false);
    end;

    procedure makePreviousMultipleInvoiceTrue(custNo: Code[20])
    var
        exceptionTable: Record "Exception Table";
    begin
        exceptionTable.Reset();
        exceptionTable.SetCurrentKey("Customer No");
        exceptionTable.SetRange("Customer No", custNo);
        exceptionTable.SetCurrentKey("Multiple Invoices");
        exceptionTable.SetRange("Multiple Invoices", false);
        if exceptionTable.FindSet() then
            repeat
                exceptionTable."Multiple Invoices" := true;
                exceptionTable.Modify();
            until exceptionTable.Next() = 0;
    end;
}