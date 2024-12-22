module interest_math::u64;

use interest_math::uint_macro as macro;

// === Constants ===

const MAX_U64: u256 = 0xFFFFFFFFFFFFFFFF;

// === Try Functions ===

public fun try_add(x: u64, y: u64): (bool, u64) {
    macro::try_add!(x, y, MAX_U64)
}

public fun try_sub(x: u64, y: u64): (bool, u64) {
    macro::try_sub!(x, y)
}

public fun try_mul(x: u64, y: u64): (bool, u64) {
    let (pred, r) = macro::try_mul!(x, y);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

public fun try_div_down(x: u64, y: u64): (bool, u64) {
    macro::try_div_down!(x, y)
}

public fun try_div_up(x: u64, y: u64): (bool, u64) {
    macro::try_div_up!(x, y)
}

public fun try_mul_div_down(x: u64, y: u64, z: u64): (bool, u64) {
    let (pred, r) = macro::try_mul_div_down!(x, y, z);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

public fun try_mul_div_up(x: u64, y: u64, z: u64): (bool, u64) {
    let (pred, r) = macro::try_mul_div_up!(x, y, z);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

public fun try_mod(x: u64, y: u64): (bool, u64) {
    macro::try_mod!(x, y)
}

// === Arithmetic Functions ===

public fun add(x: u64, y: u64): u64 {
    macro::add!(x, y)
}

public fun sub(x: u64, y: u64): u64 {
    macro::sub!(x, y)
}

public fun mul(x: u64, y: u64): u64 {
    macro::mul!(x, y)
}

public fun div_down(x: u64, y: u64): u64 {
    macro::div_down!(x, y)
}

public fun div_up(a: u64, b: u64): u64 {
    macro::div_up!(a, b)
}

public fun mul_div_down(x: u64, y: u64, z: u64): u64 {
    macro::mul_div_down!(x, y, z)
}

public fun mul_div_up(x: u64, y: u64, z: u64): u64 {
    macro::mul_div_up!(x, y, z)
}

// === Comparison Functions ===

public fun min(x: u64, y: u64): u64 {
    macro::min!(x, y)
}

public fun max(x: u64, y: u64): u64 {
    macro::max!(x, y)
}

public fun clamp(x: u64, lower: u64, upper: u64): u64 {
    macro::clamp!(x, lower, upper)
}

public fun diff(x: u64, y: u64): u64 {
    macro::diff!(x, y)
}

public fun pow(x: u64, n: u64): u64 {
    macro::pow!(x, n)
}

// === Vector Functions ===

public fun sum(nums: vector<u64>): u64 {
    macro::sum!(nums)
}

public fun average(x: u64, y: u64): u64 {
    macro::average!(x, y)
}

public fun average_vector(nums: vector<u64>): u64 {
    macro::average_vector!(nums)
}

// === Square Root Functions ===

public fun sqrt_down(x: u64): u64 {
    macro::sqrt_down!(x)
}

public fun sqrt_up(a: u64): u64 {
    macro::sqrt_up!(a)
}

// === Logarithmic Functions ===

public fun log2_down(value: u64): u8 {
    macro::log2_down!(value)
}

public fun log2_up(value: u64): u16 {
    macro::log2_up!(value)
}

public fun log10_down(value: u64): u8 {
    macro::log10_down!(value)
}

public fun log10_up(value: u64): u8 {
    macro::log10_up!(value)
}

public fun log256_down(x: u64): u8 {
    macro::log256_down!(x)
}

public fun log256_up(x: u64): u8 {
    macro::log256_up!(x)
}

// === Utility Functions ===

public fun max_value(): u64 {
    (MAX_U64 as u64)
}
