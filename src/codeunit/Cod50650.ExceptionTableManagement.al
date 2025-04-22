codeunit 50650 "Exception Table Management"
{
    procedure insertIntoExceptionTable(var custLedgerEntry: Record "Cust. Ledger Entry"; var EntryNoToGiven: Integer)
    var
        totalInterval: Integer;
        currentWorkDate: Date;
        exceptionTable: Record "Exception Table";
        entryNoHolder: List of [Integer];
        entryNo: Integer;

    begin
        currentWorkDate := WorkDate;

        repeat
            totalInterval := currentWorkDate - custLedgerEntry."Due Date";
            if totalInterval > 5 then begin
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
                EntryNoToGiven += 1;
                entryNoHolder.Add(exceptionTable."Entry No");
            end;
        until custLedgerEntry.Next() = 0;

        if entryNoHolder.Count > 1 then begin
            foreach entryNo in entryNoHolder do begin
                if exceptionTable.Get(entryNo) then begin
                    exceptionTable."Multiple Invoices" := true;
                    exceptionTable.Modify();
                end;
            end;
        end;
        if entryNoHolder.Count > 0 then
            entryNoHolder.RemoveRange(1, entryNoHolder.Count);
    end;
}