table 58537 "Condition_FF_TSL"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    Caption = 'Condition';
    LookupPageId = Conditions_FF_TSL;
    Access = Internal;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Function; Code[10])
        {
            Caption = 'Function';
            DataClassification = CustomerContent;
            TableRelation = Function_FF_TSL;
            NotBlank = true;
        }
        field(3; Argument; Text[2048])
        {
            Caption = 'Argument';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Function);
            end;

            trigger OnLookup()
            var
                FeatureFlagMgt: Codeunit FeatureFlagMgt_FF_TSL;
            begin
                TestField(Function);
                FeatureFlagMgt.LookupConditionArgument(Function, Argument)
            end;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        DeleteQst: Label 'Condition is in use. Proceed with removal?';

    trigger OnDelete()
    var
        FeatureFlagCondition: Record FeatureFlagCondition_FF_TSL;
    begin
        FeatureFlagCondition.SetRange(ConditionCode, Code);
        if not FeatureFlagCondition.IsEmpty() then
            if Confirm(DeleteQst) then
                FeatureFlagCondition.DeleteAll();
    end;
}