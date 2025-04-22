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
        }
    }

    var
        myInt: Integer;
}