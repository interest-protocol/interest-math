module interest_math::u64;

use interest_math::uint_macro as macro;

// === Constants ===

// @dev The maximum u64 number.
const MAX_U64: u256 = 0xFFFFFFFFFFFFFFFF;

// === Try Functions do not throw ===

/*
 * @notice It tries to perform `x` + `y`.
 *
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` + `y`. If it fails, it will be 0.
 */
public fun try_add(x: u64, y: u64): (bool, u64) {
    macro::try_add!(x, y, MAX_U64)
}

/*
 * @notice It tries to perform `x` - `y`.
 *
 * @dev Checks for underflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` - `y`. If it fails, it will be 0.
 */
public fun try_sub(x: u64, y: u64): (bool, u64) {
    macro::try_sub!(x, y)
}

/*
 * @notice It tries to perform `x` * `y`.
 *
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` * `y`. If it fails, it will be 0.
 */
public fun try_mul(x: u64, y: u64): (bool, u64) {
    let (pred, r) = macro::try_mul!(x, y);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

/*
 * @notice It tries to perform `x` / `y` rounding down.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u64. The result of x / y. If it fails, it will be 0.
 */
public fun try_div_down(x: u64, y: u64): (bool, u64) {
    macro::try_div_down!(x, y)
}

/*
 * @notice It tries to perform `x` / `y` rounding up.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` / `y`. If it fails, it will be 0.
 */
public fun try_div_up(x: u64, y: u64): (bool, u64) {
    macro::try_div_up!(x, y)
}

/*
 * @notice It tries to perform `x` * `y` / `z` rounding down.
 *
 * @dev Checks for zero division.
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` * `y` / `z`. If it fails, it will be 0.
 */
public fun try_mul_div_down(x: u64, y: u64, z: u64): (bool, u64) {
    let (pred, r) = macro::try_mul_div_down!(x, y, z);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

/*
 * @notice It tries to perform `x` * `y` / `z` rounding up.
 *
 * @dev Checks for zero division.
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return bool. If the operation was successful.
 * @return u64. The result of `x` * `y` / `z`. If it fails, it will be 0.
 */
public fun try_mul_div_up(x: u64, y: u64, z: u64): (bool, u64) {
    let (pred, r) = macro::try_mul_div_up!(x, y, z);
    if (!pred || r > MAX_U64) (false, 0) else (true, (r as u64))
}

/*
 * @notice It tries to perform `x` % `y`.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u128. The result of `x` % `y`. If it fails, it will be 0.
 */
public fun try_mod(x: u64, y: u64): (bool, u64) {
    macro::try_mod!(x, y)
}

// === These functions will throw on overflow/underflow/zero division ===

/*
 * @notice It performs `x` + `y`.
 *
 * @dev It will throw on overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The result of `x` + `y`.
 */
public fun add(x: u64, y: u64): u64 {
    macro::add!(x, y)
}

/*
 * @notice It performs `x` - `y`.
 *
 * @dev It will throw on underflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The result of `x` - `y`.
 */
public fun sub(x: u64, y: u64): u64 {
    macro::sub!(x, y)
}

/*
 * @notice It performs `x` * `y`.
 *
 * @dev It will throw on overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The result of `x` * `y`.
 */
public fun mul(x: u64, y: u64): u64 {
    macro::mul!(x, y)
}

/*
 * @notice It performs `x` / `y` rounding down.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The result of `x` / `y`.
 */
public fun div_down(x: u64, y: u64): u64 {
    macro::div_down!(x, y)
}

/*
 * @notice It performs `x` / `y` rounding up.
 *
 * @dev It will throw on zero division.
 * @dev It does not overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The result of `x` / `y`.
 */
public fun div_up(a: u64, b: u64): u64 {
    macro::div_up!(a, b)
}

/*
 * @notice It performs `x` * `y` / `z` rounding down.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return u64. The result of `x` * `y` / `z`.
 */
public fun mul_div_down(x: u64, y: u64, z: u64): u64 {
    macro::mul_div_down!(x, y, z)
}

/*
 * @notice It performs `x` * `y` / `z` rounding up.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return u64. The result of `x` * `y` / `z`.
 */
public fun mul_div_up(x: u64, y: u64, z: u64): u64 {
    macro::mul_div_up!(x, y, z)
}

/*
 * @notice It returns the lowest number.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The lowest number.
 */
public fun min(x: u64, y: u64): u64 {
    macro::min!(x, y)
}

/*
 * @notice It returns the largest number.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The largest number.
 */
public fun max(x: u64, y: u64): u64 {
    macro::max!(x, y)
}

/*
 * @notice Clamps `x` between the range of [lower, upper].
 *
 * @param x The operand.
 * @param lower The lower bound of the range.
 * @param upper The upper bound of the range.
 * @return u64. The clamped x.
 */
public fun clamp(x: u64, lower: u64, upper: u64): u64 {
    macro::clamp!(x, lower, upper)
}

/*
 * @notice Performs |x - y|.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. The difference.
 */
public fun diff(x: u64, y: u64): u64 {
    macro::diff!(x, y)
}

/*
 * @notice Performs n^e.
 *
 * @param n The base.
 * @param e The exponent.
 * @return u64. The result of n^e.
 */
public fun pow(x: u64, n: u64): u64 {
    macro::pow!(x, n)
}

/*
 * @notice Adds all x in `nums` in a vector.
 *
 * @param nums A vector of numbers.
 * @return u256. The sum.
 */
public fun sum(nums: vector<u64>): u64 {
    macro::sum!(nums)
}

/*
 * @notice It returns the average between two numbers (`x` + `y`) / 2.
 *
 * @dev It does not overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return u64. (`x` + `y`) / 2.
 */
public fun average(x: u64, y: u64): u64 {
    macro::average!(x, y)
}

/*
 * @notice Calculates the average of the vector of numbers sum of vector/length of vector.
 *
 * @param nums A vector of numbers.
 * @return u64. The average.
 */
public fun average_vector(nums: vector<u64>): u64 {
    macro::average_vector!(nums)
}

/*
 * @notice Returns the square root of `x` number. If the number is not a perfect square, the x is rounded down.
 *
 * @dev Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
 *
 * @param x The operand.
 * @return u64. The square root of x rounding down.
 */
public fun sqrt_down(x: u64): u64 {
    macro::sqrt_down!(x)
}

/*
 * @notice Returns the square root of `x` number. If the number is not a perfect square, the `x` is rounded up.
 *
 * @dev Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
 *
 * @param x The operand.
 * @return u64. The square root of x rounding up.
 */
public fun sqrt_up(a: u64): u64 {
    macro::sqrt_up!(a)
}

/*
 * @notice Returns the log2(x) rounding down.
 *
 * @param x The operand.
 * @return u64. Log2(x).
 */
public fun log2_down(value: u64): u8 {
    macro::log2_down!(value)
}

/*
 * @notice Returns the log2(x) rounding up.
 *
 * @param x The operand.
 * @return u64. Log2(x).
 */
public fun log2_up(value: u64): u16 {
    macro::log2_up!(value)
}

/*
 * @notice Returns the log10(x) rounding down.
 *
 * @param x The operand.
 * @return u64. Log10(x).
 */
public fun log10_down(value: u64): u8 {
    macro::log10_down!(value)
}

/*
 * @notice Returns the log10(x) rounding up.
 *
 * @param x The operand.
 * @return u64. Log10(x).
 */
public fun log10_up(value: u64): u8 {
    macro::log10_up!(value)
}

/*
 * @notice Returns the log256(x) rounding down.
 *
 * @param x The operand.
 * @return u64. Log256(x).
 */
public fun log256_down(x: u64): u8 {
    macro::log256_down!(x)
}

/*
 * @notice Returns the log256(x) rounding up.
 *
 * @param x The operand.
 * @return u64. Log256(x).
 */
public fun log256_up(x: u64): u8 {
    macro::log256_up!(x)
}

/*
 * @notice Returns the maximum value of u64.
 *
 * @return u64. The maximum value.
 */
public fun max_value(): u64 {
    (MAX_U64 as u64)
}
