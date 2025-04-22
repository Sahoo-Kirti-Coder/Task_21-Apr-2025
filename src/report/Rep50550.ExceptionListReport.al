report 50550 "Exception List Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './ExceptionListReportRDLC.rdl';

    dataset
    {
        dataitem("Exception Table"; "Exception Table")
        {
            column(Entry_No; "Entry No") { }
            column(Customer_No; "Customer No") { }
            column(Multiple_Invoices; "Multiple Invoices") { }
            column(Document_No; "Document No") { }
            column(Original_Amount; "Original Amount") { }
            column(Remaining_Amount; "Remaining Amount") { }
            column(Days_Late; "Days Late") { }
            column(Invoice_Date; "Invoice Date") { }
            column(Due_Date; "Due Date") { }

            trigger OnPreDataItem()
            var
                customer: Record Customer;
                customerLedgEntry: Record "Cust. Ledger Entry";
                dueDate: Date;
                exceptionTableManagement: Codeunit "Exception Table Management";
                exceptionTable: Record "Exception Table";
                EntryNoToGiven: Integer;
            begin
                EntryNoToGiven := 1;
                if exceptionTable.FindSet() then
                    exceptionTable.DeleteAll();
                if (oldestDate = 0D) and (latestDate = 0D) then begin
                    if customerNo = '' then begin
                        customer.Reset();
                        customer.FindSet();
                        repeat
                            customerLedgEntry.Reset();
                            customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                            customerLedgEntry.SetRange("Customer No.", customer."No.");
                            if customerLedgEntry.FindSet() then
                                exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                        until customer.Next() = 0;
                    end
                    else begin
                        customerLedgEntry.Reset();
                        customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                        customerLedgEntry.SetRange("Customer No.", customerNo);
                        if customerLedgEntry.FindSet() then
                            exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                    end;
                end else begin

                    if oldestDate = 0D then begin
                        if customerNo = '' then begin
                            customer.Reset();
                            customer.FindSet();
                            repeat
                                customerLedgEntry.Reset();
                                customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                                customerLedgEntry.SetRange("Customer No.", customer."No.");
                                customerLedgEntry.SetFilter("Posting Date", '..%1', latestDate);
                                if customerLedgEntry.FindSet() then
                                    exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                            until customer.Next() = 0;
                        end
                        else begin
                            customerLedgEntry.Reset();
                            customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                            customerLedgEntry.SetRange("Customer No.", customerNo);
                            customerLedgEntry.SetFilter("Posting Date", '..%1', latestDate);
                            if customerLedgEntry.FindSet() then
                                exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                        end;
                    end else begin

                        if latestDate = 0D then begin
                            if customerNo = '' then begin
                                customer.Reset();
                                customer.FindSet();
                                repeat
                                    customerLedgEntry.Reset();
                                    customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                                    customerLedgEntry.SetRange("Customer No.", customer."No.");
                                    customerLedgEntry.SetFilter("Posting Date", '%1..', oldestDate);
                                    if customerLedgEntry.FindSet() then
                                        exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                                until customer.Next() = 0;
                            end
                            else begin
                                customerLedgEntry.Reset();
                                customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                                customerLedgEntry.SetRange("Customer No.", customerNo);
                                customerLedgEntry.SetFilter("Posting Date", '%1..', oldestDate);
                                if customerLedgEntry.FindSet() then
                                    exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                            end;
                        end else begin

                            if (oldestDate <> 0D) and (latestDate <> 0D) then begin
                                if customerNo = '' then begin
                                    customer.Reset();
                                    customer.FindSet();
                                    repeat
                                        customerLedgEntry.Reset();
                                        customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                                        customerLedgEntry.SetRange("Customer No.", customer."No.");
                                        customerLedgEntry.SetFilter("Posting Date", '%1..%2', oldestDate, latestDate);
                                        if customerLedgEntry.FindSet() then
                                            exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                                    until customer.Next() = 0;
                                end
                                else begin
                                    customerLedgEntry.Reset();
                                    customerLedgEntry.SetRange("Document Type", customerLedgEntry."Document Type"::Invoice);
                                    customerLedgEntry.SetRange("Customer No.", customerNo);
                                    customerLedgEntry.SetFilter("Posting Date", '%1..%2', oldestDate, latestDate);
                                    if customerLedgEntry.FindSet() then
                                        exceptionTableManagement.insertIntoExceptionTable(customerLedgEntry, EntryNoToGiven);
                                end;
                                exit;
                            end;
                        end;
                    end;
                end;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group("Give Details Please")
                {
                    field("Oldest Posting Date to Use"; oldestDate)
                    {
                        ApplicationArea = All;
                    }
                    field("Latest Posting Date to Use"; latestDate)
                    {
                        ApplicationArea = All;
                    }
                    field(customerNo; customerNo)
                    {
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    var
        oldestDate: Date;
        latestDate: Date;
        customerNo: Code[20];
}