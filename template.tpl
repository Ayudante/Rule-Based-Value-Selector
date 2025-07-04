___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "displayName": "Rule-Based Value Selector",
  "description": "Evaluate multiple matching rules with AND/OR logic and return the first matching value",
  "id": "cvt_CASE_WHEN",
  "type": "MACRO",
  "version": 1,
  "containerContexts": [
    "WEB"
  ],
  "categories": ["UTILITY"],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "displayName": "Documentation: Define matching rules to return different values based on multiple criteria",
    "name": "documentation",
    "type": "LABEL"
  },
  {
    "displayName": "Matching Rules",
    "name": "rules",
    "type": "PARAM_TABLE",
    "paramTableColumns": [
      {
        "param": {
          "displayName": "Rule Name (Optional)",
          "simpleValueType": true,
          "name": "ruleName",
          "type": "TEXT"
        },
        "isUnique": false
      },
      {
        "param": {
          "selectItems": [
            {
              "displayValue": "All rules match (AND)",
              "value": "AND"
            },
            {
              "displayValue": "Any rule matches (OR)",
              "value": "OR"
            }
          ],
          "defaultValue": "AND",
          "displayName": "Logical Operator",
          "name": "logicalOperator",
          "type": "SELECT",
          "help": "Evaluate all matching rules in this group with AND or OR logic"
        },
        "isUnique": false
      },
      {
        "param": {
          "displayName": "Matching Rules",
          "name": "conditions",
          "type": "SIMPLE_TABLE",
          "help": "Define rules to match against variables. Example: {{Page Path}} contains /products/",
          "displayMessageWhenNotSet": "Add matching rules (variable + operator + value combinations)",
          "simpleTableColumns": [
            {
              "valueValidators": [
                {
                  "type": "NON_EMPTY"
                }
              ],
              "defaultValue": "",
              "displayName": "Variable",
              "name": "variable",
              "type": "TEXT"
            },
            {
              "selectItems": [
                {
                  "displayValue": "Equals",
                  "value": "equals"
                },
                {
                  "displayValue": "Contains",
                  "value": "contains"
                },
                {
                  "displayValue": "Starts with",
                  "value": "startsWith"
                },
                {
                  "displayValue": "Ends with",
                  "value": "endsWith"
                },
                {
                  "displayValue": "Matches RegEx",
                  "value": "matchesRegEx"
                },
                {
                  "displayValue": "Matches RegEx (ignore case)",
                  "value": "matchesRegExIgnoreCase"
                },
                {
                  "displayValue": "Does not equal",
                  "value": "doesNotEqual"
                },
                {
                  "displayValue": "Does not contain",
                  "value": "doesNotContain"
                },
                {
                  "displayValue": "Does not start with",
                  "value": "doesNotStartWith"
                },
                {
                  "displayValue": "Does not end with",
                  "value": "doesNotEndWith"
                },
                {
                  "displayValue": "Does not match RegEx",
                  "value": "doesNotMatchRegEx"
                },
                {
                  "displayValue": "Does not match RegEx (ignore case)",
                  "value": "doesNotMatchRegExIgnoreCase"
                },
                {
                  "displayValue": "Less than",
                  "value": "lessThan"
                },
                {
                  "displayValue": "Less than or equal to",
                  "value": "lessThanOrEqualTo"
                },
                {
                  "displayValue": "Greater than",
                  "value": "greaterThan"
                },
                {
                  "displayValue": "Greater than or equal to",
                  "value": "greaterThanOrEqualTo"
                }
              ],
              "defaultValue": "equals",
              "displayName": "Operator",
              "name": "operator",
              "type": "SELECT"
            },
            {
              "valueValidators": [
                {
                  "type": "NON_EMPTY"
                }
              ],
              "defaultValue": "",
              "displayName": "Value",
              "name": "value",
              "type": "TEXT"
            }
          ],
          "newRowButtonText": "Add Rule"
        },
        "isUnique": false
      },
      {
        "param": {
          "valueValidators": [
            {
              "type": "NON_EMPTY"
            }
          ],
          "displayName": "Return Value",
          "simpleValueType": true,
          "name": "returnValue",
          "type": "TEXT"
        },
        "isUnique": false
      }
    ],
    "newRowTitle": "Add New Rule",
    "editRowTitle": "Edit Rule",
    "newRowButtonText": "Add Rule"
  },
  {
    "displayName": "Default Value (when no rules match)",
    "simpleValueType": true,
    "name": "default_value",
    "type": "TEXT",
    "help": "Value to return when no rules match. Returns undefined if empty."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const defaultValue = data.default_value;

// Operator definitions
const OPERATORS = {
  equals: (variable, value) => {
    return variable == value;
  },
  contains: (variable, value) => {
    return variable.indexOf(value) > -1;
  },
  startsWith: (variable, value) => {
    return variable.indexOf(value) === 0;
  },
  endsWith: (variable, value) => {
    const endIndex = variable.length - value.length;
    return endIndex >= 0 && variable.indexOf(value) === endIndex;
  },
  matchesRegEx: (variable, value) => {
    return variable.match(value) !== null;
  },
  matchesRegExIgnoreCase: (variable, value) => {
    return variable.toLowerCase().match(value.toLowerCase()) !== null;
  },
  doesNotEqual: (variable, value) => {
    return variable != value;
  },
  doesNotContain: (variable, value) => {
    return variable.indexOf(value) === -1;
  },
  doesNotStartWith: (variable, value) => {
    return variable.indexOf(value) !== 0;
  },
  doesNotEndWith: (variable, value) => {
    const endIndex = variable.length - value.length;
    return endIndex < 0 || variable.indexOf(value) !== endIndex;
  },
  doesNotMatchRegEx: (variable, value) => {
    return variable.match(value) === null;
  },
  doesNotMatchRegExIgnoreCase: (variable, value) => {
    return variable.toLowerCase().match(value.toLowerCase()) === null;
  },
  lessThan: (variable, value) => {
    return variable < value;
  },
  lessThanOrEqualTo: (variable, value) => {
    return variable <= value;
  },
  greaterThan: (variable, value) => {
    return variable > value;
  },
  greaterThanOrEqualTo: (variable, value) => {
    return variable >= value;
  }
};

// Value resolution (type conversion)
function resolve(x) {
  switch (typeof x) {
    case 'undefined': 
      x = 'undefined'; 
      break;
    case 'boolean': 
      x = x ? 'true' : 'false'; 
      break;
  }
  // Convert to string and trim
  return (x + '').trim();
}

// Single rule condition evaluation
function evaluateRuleCondition(ruleCondition) {
  if (!ruleCondition || !ruleCondition.variable || !ruleCondition.operator || !ruleCondition.value) {
    return false;
  }
  
  const variable = resolve(ruleCondition.variable);
  const value = resolve(ruleCondition.value);
  
  const operator = OPERATORS[ruleCondition.operator];
  
  if (!operator) {
    return false;
  }
  
  const result = operator(variable, value);
  return result;
}

// Rule group evaluation (uniform AND/OR evaluation)
function evaluateRuleGroup(ruleGroup) {
  if (!ruleGroup) {
    return false;
  }
  
  if (!ruleGroup.conditions || ruleGroup.conditions.length === 0) {
    return false;
  }
  
  const logicalOperator = ruleGroup.logicalOperator || 'AND';
  
  // Single rule condition case
  if (ruleGroup.conditions.length === 1) {
    return evaluateRuleCondition(ruleGroup.conditions[0]);
  }
  
  // Multiple rule conditions case
  if (logicalOperator === 'OR') {
    // OR evaluation: true if any rule condition is true
    for (let i = 0; i < ruleGroup.conditions.length; i++) {
      const ruleConditionResult = evaluateRuleCondition(ruleGroup.conditions[i]);
      if (ruleConditionResult) {
        return true;
      }
    }
    return false;
  } else {
    // AND evaluation: true only when all rule conditions are true
    for (let i = 0; i < ruleGroup.conditions.length; i++) {
      const ruleConditionResult = evaluateRuleCondition(ruleGroup.conditions[i]);
      if (!ruleConditionResult) {
        return false;
      }
    }
    return true;
  }
}

// Main processing
const ruleGroups = data.rules;

if (ruleGroups && ruleGroups.length > 0) {
  // Evaluate each rule group in order
  for (let i = 0; i < ruleGroups.length; i++) {
    const ruleGroup = ruleGroups[i];
    
    if (evaluateRuleGroup(ruleGroup)) {
      // Return the value of the first matching rule group
      return ruleGroup.returnValue;
    }
  }
}

// Return default value when no rule groups match
return defaultValue;

 