table 50350 "Exception Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Multiple Invoices"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Days Late"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Entry_No_CLE; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}