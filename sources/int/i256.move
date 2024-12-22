module interest_math::i256;

use interest_math::{int_macro as macro, uint_macro};

// === Constants ===

const MAX_U256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

const MAX_POSITIVE: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

const MIN_NEGATIVE: u256 = 0x8000000000000000000000000000000000000000000000000000000000000000;

// === Errors ===

const EOverflow: u64 = 0;

const EUnderflow: u64 = 1;

const EDivByZero: u64 = 2;

const EInvalidBitShift: u64 = 3;

// === Structs ===

public enum Compare has copy, drop, store {
    Less,
    Equal,
    Greater,
}

public struct I256 has copy, drop, store {
    value: u256,
}

// === Package Functions ===

public fun value(self: I256): u256 {
    macro::value!(self)
}

public fun zero(): I256 {
    I256 { value: 0 }
}

public fun max(): I256 {
    I256 { value: MAX_POSITIVE }
}

public fun min(): I256 {
    I256 { value: MIN_NEGATIVE }
}

public fun from_u8(value: u8): I256 {
    I256 { value: value as u256 }
}

public fun from_u256(value: u256): I256 {
    I256 { value: check_overflow_and_return(value) }
}

public fun from(value: u64): I256 {
    I256 { value: value as u256 }
}

public fun from_u128(value: u128): I256 {
    I256 { value: value as u256 }
}

public fun negative_from_u256(value: u256): I256 {
    if (value == 0) return zero();

    I256 {
        value: not_u256(check_underflow_and_return(value)) + 1 | MIN_NEGATIVE,
    }
}

public fun negative_from(value: u64): I256 {
    negative_from_u256(value as u256)
}

public fun negative_from_u128(value: u128): I256 {
    negative_from_u256(value as u256)
}

public fun to_u8(self: I256): u8 {
    (self.value as u8)
}

public fun to_u256(self: I256): u256 {
    self.check_is_positive_and_return_value()
}

public fun truncate_to_u8(self: I256): u8 {
    ((self.value & 0xFF) as u8)
}

public fun truncate_to_u16(self: I256): u16 {
    ((self.value & 0xFFFF) as u16)
}

public fun truncate_to_u32(self: I256): u32 {
    ((self.value & 0xFFFFFFFF) as u32)
}

public fun truncate_to_u64(self: I256): u64 {
    ((self.value & 0xFFFFFFFFFFFFFFFF) as u64)
}

public fun truncate_to_u128(self: I256): u128 {
    ((self.value & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) as u128)
}

public fun is_negative(self: I256): bool {
    macro::is_negative!(self, MIN_NEGATIVE)
}

public fun is_positive(self: I256): bool {
    macro::is_positive!(self, MIN_NEGATIVE)
}

public fun is_zero(self: I256): bool {
    self.value == 0
}

public fun abs(self: I256): I256 {
    if (self.is_negative()) {
        assert!(self.value > MIN_NEGATIVE, EUnderflow);
        I256 { value: not_u256(self.value - 1) }
    } else {
        self
    }
}

public fun eq(self: I256, other: I256): bool {
    self.compare(other) == Compare::Equal
}

public fun lt(self: I256, other: I256): bool {
    self.compare(other) == Compare::Less
}

public fun gt(self: I256, other: I256): bool {
    self.compare(other) == Compare::Greater
}

public fun lte(self: I256, other: I256): bool {
    let pred = self.compare(other);
    pred == Compare::Less || pred == Compare::Equal
}

public fun gte(self: I256, other: I256): bool {
    let pred = self.compare(other);
    pred == Compare::Greater || pred == Compare::Equal
}

public fun add(self: I256, other: I256): I256 {
    let sum = self.wrapping_add(other);

    let sign_a = self.sign();
    let sign_b = other.sign();
    let sign_sum = sum.sign();

    assert!(!(sign_a == sign_b && sign_a != sign_sum), EOverflow);

    sum
}

public fun sub(self: I256, other: I256): I256 {
    self.add(I256 { value: not_u256(other.value) }.wrapping_add(from(1)))
}

public fun mul(self: I256, other: I256): I256 {
    if (self.value == 0 || other.value == 0) return zero();
    if (self.is_positive() != other.is_positive()) {
        negative_from_u256(self.abs_unchecked_u256() * other.abs_unchecked_u256())
    } else {
        from_u256(self.abs_unchecked_u256() * other.abs_unchecked_u256())
    }
}

public fun div(self: I256, other: I256): I256 {
    assert!(other.value != 0, EDivByZero);

    if (self.is_positive() != other.is_positive()) {
        negative_from_u256(self.abs_unchecked_u256() / other.abs_unchecked_u256())
    } else {
        from_u256(self.abs_unchecked_u256() / other.abs_unchecked_u256())
    }
}

public fun div_up(self: I256, other: I256): I256 {
    assert!(other.value != 0, EDivByZero);

    if (self.is_positive() != other.is_positive()) {
        negative_from_u256(
            uint_macro::div_up!(
                self.abs_unchecked_u256(),
                other.abs_unchecked_u256(),
            ),
        )
    } else {
        from_u256(
            uint_macro::div_up!(
                self.abs_unchecked_u256(),
                other.abs_unchecked_u256(),
            ),
        )
    }
}

public fun mod(self: I256, other: I256): I256 {
    assert!(other.value != 0, EDivByZero);

    let other_abs = other.abs_unchecked_u256();

    if (self.is_negative()) {
        negative_from_u256(self.abs_unchecked_u256() % other_abs)
    } else {
        from_u256(self.value % other_abs)
    }
}

public fun pow(self: I256, exponent: u256): I256 {
    let result = uint_macro::pow!<u256>(self.abs().value, exponent);

    if (self.is_negative() && exponent % 2 != 0) negative_from_u256(result)
    else from_u256(result)
}

public fun wrapping_add(self: I256, other: I256): I256 {
    I256 {
        value: if (self.value > (MAX_U256 - other.value)) {
            self.value - (MAX_U256 - other.value) - 1
        } else {
            self.value + other.value
        },
    }
}

public fun wrapping_sub(self: I256, other: I256): I256 {
    self.wrapping_add(I256 { value: not_u256(other.value) }.wrapping_add(from(1)))
}

public fun and(self: I256, other: I256): I256 {
    I256 { value: self.value & other.value }
}

public fun or(self: I256, other: I256): I256 {
    I256 { value: self.value | other.value }
}

public fun xor(self: I256, other: I256): I256 {
    I256 { value: self.value ^ other.value }
}

public fun not(self: I256): I256 {
    I256 { value: not_u256(self.value) }
}

public fun shr(self: I256, rhs: u8): I256 {
    assert!((rhs as u16) < (256 as u16), EInvalidBitShift);

    if (rhs == 0) return self;

    if (self.is_positive()) {
        I256 { value: self.value >> rhs }
    } else {
        I256 { value: self.value >> rhs | MAX_U256 << ((256 - (rhs as u16) as u8)) }
    }
}

public fun shl(self: I256, lhs: u8): I256 {
    assert!((lhs as u16) < (256 as u16), EInvalidBitShift);

    I256 { value: self.value << lhs }
}

// === Private Functions ===

fun abs_unchecked_u256(self: I256): u256 {
    if (self.is_positive()) {
        self.value
    } else {
        not_u256(self.value - 1)
    }
}

fun compare(self: I256, other: I256): Compare {
    if (self.value == other.value) return Compare::Equal;

    if (self.is_positive()) {
        if (other.is_positive()) {
            return if (self.value > other.value) Compare::Greater
            else Compare::Less
        } else {
            return Compare::Greater
        }
    } else {
        if (other.is_positive()) {
            return Compare::Less
        } else {
            return if (self.abs().value > other.abs().value) Compare::Less
            else Compare::Greater
        }
    }
}

fun sign(self: I256): u8 {
    (self.value >> 255) as u8
}

fun not_u256(value: u256): u256 {
    value ^ MAX_U256
}

fun check_is_positive_and_return_value(self: I256): u256 {
    assert!(self.is_positive(), EUnderflow);
    self.value
}

fun check_overflow(value: u256) {
    assert!(MAX_POSITIVE >= value, EOverflow);
}

fun check_underflow(value: u256) {
    assert!(MIN_NEGATIVE >= value, EUnderflow);
}

fun check_overflow_and_return(value: u256): u256 {
    check_overflow(value);
    value
}

fun check_underflow_and_return(value: u256): u256 {
    check_underflow(value);
    value
}