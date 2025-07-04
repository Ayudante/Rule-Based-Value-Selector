# Rule-Based Value Selector

### Overview

The **Rule-Based Value Selector** is a Google Tag Manager (GTM) custom template variable that allows you to evaluate multiple matching rules with AND/OR logic and return the first matching value. This template provides a powerful way to implement complex conditional logic within GTM without requiring custom JavaScript code.

### Features

- **Multiple Rule Groups**: Define multiple rule groups with different logical operators
- **Flexible Logic**: Support for both AND and OR logic within each rule group
- **Comprehensive Operators**: 16 different comparison operators including:
  - Basic comparisons (equals, contains, starts with, ends with)
  - Regular expression matching (with case sensitivity options)
  - Negative comparisons (does not equal, does not contain, etc.)
  - Numeric comparisons (less than, greater than, etc.)
- **Default Value**: Set a fallback value when no rules match
- **First Match Priority**: Returns the value from the first matching rule group


### Configuration

#### Rule Groups

Each rule group consists of:

- **Rule Name** (Optional): A descriptive name for the rule
- **Logical Operator**: Choose between "All rules match (AND)" or "Any rule matches (OR)"
- **Matching Rules**: Define one or more conditions using:
  - **Variable**: GTM variable (e.g., `{{Page Path}}`, `{{Event}}`)
  - **Operator**: Comparison method
  - **Value**: Value to compare against
- **Return Value**: Value to return when this rule group matches



### Configuration Examples

#### Example 1: VIP Customer Detection
| Rule Name | Logic | Conditions | Return Value |
|-----------|-------|------------|--------------|
| VIP Customer | AND | `{{User Lifetime Value}}` Greater than or equal to `100000`<br/>`{{Login Status}}` Equals `logged_in` | `vip` |

**Default Value**: `standard`　**Use Case**: Display special pricing and exclusive products

#### Example 2: Customer Classification by Purchase History
| Rule Name | Logic | Conditions | Return Value |
|-----------|-------|------------|--------------|
| Loyal Customer | AND | `{{Purchase Count}}` Greater than or equal to `3`<br/>`{{Days Since Last Purchase}}` Less than or equal to `90` | `loyal` |

**Default Value**: `new-customer`　**Use Case**: Distribute repeat customer coupons

#### Example 3: Cart Value-Based Campaign Targeting
| Rule Name | Logic | Conditions | Return Value |
|-----------|-------|------------|--------------|
| High Value Cart | AND | `{{Cart Value}}` Greater than or equal to `10000`<br/>`{{Page Path}}` Contains `/cart/` | `high-value` |

**Default Value**: `standard-cart`　**Use Case**: Offer free shipping and installment payment options

#### Example 4: Device × User Type Detection
| Rule Name | Logic | Conditions | Return Value |
|-----------|-------|------------|--------------|
| New Mobile User | AND | `{{Device Category}}` Equals `mobile`<br/>`{{User Type}}` Equals `new` | `new-mobile` |

**Default Value**: `other-user`　**Use Case**: Promote app downloads

#### Example 5: Page × User Type Detection
| Rule Name | Logic | Conditions | Return Value |
|-----------|-------|------------|--------------|
| Product Browser | AND | `{{User Type}}` Equals `returning`<br/>`{{Page Path}}` Contains `/products/` | `returning-shopper` |

**Default Value**: `visitor`　**Use Case**: Show personalized product recommendations

