page 50450 "Exception List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Exception Table";

    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = All;
                }
                field("Multiple Invoices"; Rec."Multiple Invoices")
                {
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Days Late"; Rec."Days Late")
                {
                    ApplicationArea = All;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Run Exception List Report")
            {
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                begin
                    Report.RunModal(Report::"Exception List Report", true, true);
                end;
            }
            action("Show Posted Document")
            {
                ApplicationArea = All;
                Image = Document;
                trigger OnAction()
                var
                    salesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    if Rec."Document No" <> '' then begin
                        salesInvoiceHeader.Get(Rec."Document No");
                        Page.Run(Page::"Posted Sales Invoice", salesInvoiceHeader);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        exceptionTable: Record "Exception Table";
        custLedgerEntry: Record "Cust. Ledger Entry";
        entryNoList: List of [Integer];
        entryNo: Integer;
    begin
        if entryNoList.Count > 0 then
            entryNoList.RemoveRange(1, entryNoList.Count);
        if exceptionTable.FindSet() then
            repeat
                if custLedgerEntry.Get(exceptionTable.Entry_No_CLE) then begin
                    custLedgerEntry.CalcFields("Remaining Amount");
                    if custLedgerEntry."Remaining Amount" = 0 then
                        entryNoList.Add(exceptionTable."Entry No");
                end;
            until exceptionTable.Next() = 0;

        if entryNoList.Count > 0 then begin
            foreach entryNo in entryNoList do begin
                if exceptionTable.Get(entryNo) then begin
                    exceptionTable.Delete();
                end;
            end;
        end;
    end;

    var
        myInt: Integer;
}