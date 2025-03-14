module interest_math::signed_fixed18;

use interest_math::fixed18::{Self, Fixed18};

/// SignedFixed18 represents a signed fixed-point number with 18 decimal places.
/// The struct contains a value (magnitude) and a sign flag (true for negative).
public struct SignedFixed18 has copy, drop, store {
    value: Fixed18,
    is_negative: bool,
}

// === Constructors ===

/// Create a signed fixed-point number from a Fixed18 value with a sign flag
public fun from_fixed18(value: Fixed18, is_negative: bool): SignedFixed18 {
    // If value is zero, always set is_negative to false
    SignedFixed18 {
        value,
        is_negative: if (value.is_zero()) false else is_negative,
    }
}

/// Create a positive signed fixed-point number from a Fixed18 value
public fun from_fixed18_positive(value: Fixed18): SignedFixed18 {
    SignedFixed18 {
        value,
        is_negative: false,
    }
}

/// Create a negative signed fixed-point number from a Fixed18 value
public fun from_fixed18_negative(value: Fixed18): SignedFixed18 {
    from_fixed18(value, true)
}

/// Create a signed fixed-point number from a raw u256 value and a sign flag
public fun from_raw_u256(value: u256, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_raw_u256(value), is_negative)
}

/// Create a zero signed fixed-point number
public fun zero(): SignedFixed18 {
    SignedFixed18 {
        value: fixed18::zero(),
        is_negative: false,
    }
}

/// Create a one signed fixed-point number
public fun one(): SignedFixed18 {
    SignedFixed18 {
        value: fixed18::one(),
        is_negative: false,
    }
}

/// Create a negative one signed fixed-point number
public fun negative_one(): SignedFixed18 {
    SignedFixed18 {
        value: fixed18::one(),
        is_negative: true,
    }
}

/// Create a signed fixed-point number from a u256 value
public fun from_u256(value: u256, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_u256(value), is_negative)
}

/// Create a signed fixed-point number from a u128 value
public fun from_u128(value: u128, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_u128(value), is_negative)
}

/// Create a signed fixed-point number from a u64 value
public fun from_u64(value: u64, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_u64(value), is_negative)
}

/// Create a signed fixed-point number from a raw u128 value
public fun from_raw_u128(value: u128, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_raw_u128(value), is_negative)
}

/// Create a signed fixed-point number from a raw u64 value
public fun from_raw_u64(value: u64, is_negative: bool): SignedFixed18 {
    from_fixed18(fixed18::from_raw_u64(value), is_negative)
}

// === Getters ===

/// Get the magnitude (absolute value) of a signed fixed-point number
public fun value(self: SignedFixed18): Fixed18 {
    self.value
}

/// Check if a signed fixed-point number is negative
public fun is_negative(self: SignedFixed18): bool {
    self.is_negative
}

/// Check if a signed fixed-point number is positive or zero
public fun is_positive_or_zero(self: SignedFixed18): bool {
    !self.is_negative
}

/// Check if a signed fixed-point number is zero
public fun is_zero(self: SignedFixed18): bool {
    self.value.is_zero()
}

/// Get the raw u256 value of the magnitude
public fun raw_value(self: SignedFixed18): u256 {
    self.value.raw_value()
}

/// Get the base value (10^18)
public fun base(): u256 {
    fixed18::base()
}

// === Conversion Functions ===

/// Convert SignedFixed18 to u256 with given decimals
/// Aborts if the value is negative
public fun to_u256(x: SignedFixed18, decimals: u8): u256 {
    assert!(!x.is_negative, 0);
    fixed18::to_u256(x.value, decimals)
}

/// Convert SignedFixed18 to u128 with given decimals
/// Aborts if the value is negative
public fun to_u128(x: SignedFixed18, decimals: u8): u128 {
    assert!(!x.is_negative, 0);
    fixed18::to_u128(x.value, decimals)
}

/// Convert SignedFixed18 to u64 with given decimals
/// Aborts if the value is negative
public fun to_u64(x: SignedFixed18, decimals: u8): u64 {
    assert!(!x.is_negative, 0);
    fixed18::to_u64(x.value, decimals)
}

/// Convert SignedFixed18 to u256 with given decimals, rounding up
/// Aborts if the value is negative
public fun to_u256_up(x: SignedFixed18, decimals: u8): u256 {
    assert!(!x.is_negative, 0);
    fixed18::to_u256_up(x.value, decimals)
}

/// Convert SignedFixed18 to u128 with given decimals, rounding up
/// Aborts if the value is negative
public fun to_u128_up(x: SignedFixed18, decimals: u8): u128 {
    assert!(!x.is_negative, 0);
    fixed18::to_u128_up(x.value, decimals)
}

/// Convert SignedFixed18 to u64 with given decimals, rounding up
/// Aborts if the value is negative
public fun to_u64_up(x: SignedFixed18, decimals: u8): u64 {
    assert!(!x.is_negative, 0);
    fixed18::to_u64_up(x.value, decimals)
}

/// Convert a u64 with given decimals to SignedFixed18
public fun u64_to_signed_fixed18(
    x: u64,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u64_to_fixed18(x, decimals);
    from_fixed18(value, is_negative)
}

/// Convert a u128 with given decimals to SignedFixed18
public fun u128_to_signed_fixed18(
    x: u128,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u128_to_fixed18(x, decimals);
    from_fixed18(value, is_negative)
}

/// Convert a u256 with given decimals to SignedFixed18
public fun u256_to_signed_fixed18(
    x: u256,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u256_to_fixed18(x, decimals);
    from_fixed18(value, is_negative)
}

/// Convert a u64 with given decimals to SignedFixed18, rounding up
public fun u64_to_signed_fixed18_up(
    x: u64,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u64_to_fixed18_up(x, decimals);
    from_fixed18(value, is_negative)
}

/// Convert a u128 with given decimals to SignedFixed18, rounding up
public fun u128_to_signed_fixed18_up(
    x: u128,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u128_to_fixed18_up(x, decimals);
    from_fixed18(value, is_negative)
}

/// Convert a u256 with given decimals to SignedFixed18, rounding up
public fun u256_to_signed_fixed18_up(
    x: u256,
    decimals: u8,
    is_negative: bool,
): SignedFixed18 {
    let value = fixed18::u256_to_fixed18_up(x, decimals);
    from_fixed18(value, is_negative)
}

// === Try Functions ===

/// Try to add two signed fixed-point numbers
public fun try_add(a: SignedFixed18, b: SignedFixed18): (bool, SignedFixed18) {
    if (a.is_zero()) return (true, b);
    if (b.is_zero()) return (true, a);

    if (a.is_negative == b.is_negative) {
        // Same sign: try to add values and keep the sign
        let (success, result_value) = fixed18::try_add(a.value, b.value);
        if (!success) {
            return (false, a)
        };

        (
            true,
            SignedFixed18 {
                value: result_value,
                is_negative: a.is_negative,
            },
        )
    } else {
        // Different signs: subtract smaller from larger and determine sign
        let (larger, smaller, result_negative) = if (a.value.gt(b.value)) {
            (a.value, b.value, a.is_negative)
        } else if (b.value.gt(a.value)) {
            (b.value, a.value, b.is_negative)
        } else {
            // Equal magnitudes with different signs = zero result
            return (true, zero())
        };

        let (_, result_value) = fixed18::try_sub(larger, smaller);

        (
            true,
            SignedFixed18 {
                value: result_value,
                is_negative: result_negative,
            },
        )
    }
}

/// Try to subtract b from a
public fun try_sub(a: SignedFixed18, b: SignedFixed18): (bool, SignedFixed18) {
    try_add(a, negate(b))
}

/// Try to multiply two signed fixed-point numbers, rounding down
public fun try_mul_down(
    a: SignedFixed18,
    b: SignedFixed18,
): (bool, SignedFixed18) {
    if (a.is_zero() || b.is_zero()) {
        return (true, zero())
    };

    // Product value is the product of magnitudes
    let (success, product_value) = fixed18::try_mul_down(a.value, b.value);
    if (!success) {
        return (false, a)
    };

    // Product sign is negative if exactly one of the inputs is negative
    let product_negative = a.is_negative != b.is_negative;

    (
        true,
        SignedFixed18 {
            value: product_value,
            is_negative: product_negative,
        },
    )
}

/// Try to multiply two signed fixed-point numbers, rounding up
public fun try_mul_up(
    a: SignedFixed18,
    b: SignedFixed18,
): (bool, SignedFixed18) {
    if (a.is_zero() || b.is_zero()) {
        return (true, zero())
    };

    // Product value is the product of magnitudes
    let (success, product_value) = fixed18::try_mul_up(a.value, b.value);
    if (!success) {
        return (false, a)
    };

    // Product sign is negative if exactly one of the inputs is negative
    let product_negative = a.is_negative != b.is_negative;

    (
        true,
        SignedFixed18 {
            value: product_value,
            is_negative: product_negative,
        },
    )
}

/// Try to divide a by b, rounding down
public fun try_div_down(
    a: SignedFixed18,
    b: SignedFixed18,
): (bool, SignedFixed18) {
    if (a.is_zero()) {
        return (true, zero())
    };

    // Quotient value is the quotient of magnitudes
    let (success, quotient_value) = fixed18::try_div_down(a.value, b.value);
    if (!success) {
        return (false, a)
    };

    // Quotient sign is negative if exactly one of the inputs is negative
    let quotient_negative = a.is_negative != b.is_negative;

    (
        true,
        SignedFixed18 {
            value: quotient_value,
            is_negative: quotient_negative,
        },
    )
}

/// Try to divide a by b, rounding up
public fun try_div_up(
    a: SignedFixed18,
    b: SignedFixed18,
): (bool, SignedFixed18) {
    if (a.is_zero()) {
        return (true, zero())
    };

    // Quotient value is the quotient of magnitudes
    let (success, quotient_value) = fixed18::try_div_up(a.value, b.value);
    if (!success) {
        return (false, a)
    };

    // Quotient sign is negative if exactly one of the inputs is negative
    let quotient_negative = a.is_negative != b.is_negative;

    (
        true,
        SignedFixed18 {
            value: quotient_value,
            is_negative: quotient_negative,
        },
    )
}

// === Arithmetic Operations ===

/// Negate a signed fixed-point number
public fun negate(self: SignedFixed18): SignedFixed18 {
    if (self.is_zero()) {
        return self
    };

    SignedFixed18 {
        value: self.value,
        is_negative: !self.is_negative,
    }
}

/// Add two signed fixed-point numbers
public fun add(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    if (a.is_zero()) return b;
    if (b.is_zero()) return a;

    if (a.is_negative == b.is_negative) {
        // Same sign: add values and keep the sign
        SignedFixed18 {
            value: a.value.add(b.value),
            is_negative: a.is_negative,
        }
    } else {
        // Different signs: subtract smaller from larger and determine sign
        let (larger, smaller, result_negative) = if (a.value.gt(b.value)) {
            (a.value, b.value, a.is_negative)
        } else if (b.value.gt(a.value)) {
            (b.value, a.value, b.is_negative)
        } else {
            // Equal magnitudes with different signs = zero result
            return zero()
        };

        SignedFixed18 {
            value: larger.sub(smaller),
            is_negative: result_negative,
        }
    }
}

/// Subtract b from a
public fun sub(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    add(a, negate(b))
}

/// Multiply two signed fixed-point numbers with rounding down
public fun mul_down(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    if (a.is_zero() || b.is_zero()) {
        return zero()
    };

    // Product value is the product of magnitudes
    let product_value = fixed18::mul_down(a.value, b.value);

    // Product sign is negative if exactly one of the inputs is negative
    let product_negative = a.is_negative != b.is_negative;

    SignedFixed18 {
        value: product_value,
        is_negative: product_negative,
    }
}

/// Multiply two signed fixed-point numbers with rounding up
public fun mul_up(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    if (a.is_zero() || b.is_zero()) {
        return zero()
    };

    // Product value is the product of magnitudes
    let product_value = fixed18::mul_up(a.value, b.value);

    // Product sign is negative if exactly one of the inputs is negative
    let product_negative = a.is_negative != b.is_negative;

    SignedFixed18 {
        value: product_value,
        is_negative: product_negative,
    }
}

/// Multiply two signed fixed-point numbers (alias for mul_down for
/// compatibility)
public fun mul(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    mul_down(a, b)
}

/// Divide a by b with rounding down
public fun div_down(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    if (a.is_zero()) {
        return zero()
    };

    // Quotient value is the quotient of magnitudes
    let quotient_value = fixed18::div_down(a.value, b.value);

    // Quotient sign is negative if exactly one of the inputs is negative
    let quotient_negative = a.is_negative != b.is_negative;

    SignedFixed18 {
        value: quotient_value,
        is_negative: quotient_negative,
    }
}

/// Divide a by b with rounding up
public fun div_up(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    if (a.is_zero()) {
        return zero()
    };

    // Quotient value is the quotient of magnitudes
    let quotient_value = fixed18::div_up(a.value, b.value);

    // Quotient sign is negative if exactly one of the inputs is negative
    let quotient_negative = a.is_negative != b.is_negative;

    SignedFixed18 {
        value: quotient_value,
        is_negative: quotient_negative,
    }
}

/// Divide a by b (alias for div_down for compatibility)
public fun div(a: SignedFixed18, b: SignedFixed18): SignedFixed18 {
    div_down(a, b)
}

/// Compare two signed fixed-point numbers for equality
public fun eq(a: SignedFixed18, b: SignedFixed18): bool {
    a.is_negative == b.is_negative && 
        // Check if both values are equal using raw values
        a.value.raw_value() == b.value.raw_value()
}

/// Check if a is greater than b
public fun gt(a: SignedFixed18, b: SignedFixed18): bool {
    if (a.is_negative && !b.is_negative) {
        false
    } else if (!a.is_negative && b.is_negative) {
        !a.is_zero() || !b.is_zero()
    } else if (!a.is_negative && !b.is_negative) {
        a.value.gt(b.value)
    } else {
        a.value.lt(b.value)
    }
}

/// Check if a is less than b
public fun lt(a: SignedFixed18, b: SignedFixed18): bool {
    gt(b, a)
}

/// Check if a is greater than or equal to b
public fun gte(a: SignedFixed18, b: SignedFixed18): bool {
    gt(a, b) || eq(a, b)
}

/// Check if a is less than or equal to b
public fun lte(a: SignedFixed18, b: SignedFixed18): bool {
    lt(a, b) || eq(a, b)
}

/// Convert to Fixed18 if positive, abort if negative
public fun to_fixed18(self: SignedFixed18): Fixed18 {
    assert!(!self.is_negative, 0);
    self.value
}

/// Get the absolute value of a signed fixed-point number
public fun abs(self: SignedFixed18): SignedFixed18 {
    SignedFixed18 {
        value: self.value,
        is_negative: false,
    }
}
