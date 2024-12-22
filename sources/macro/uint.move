module interest_math::uint_macro;

// === Try Functions do not throw ===

/*
 * @notice It tries to perform `x` + `y`.
 *
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return The result of `x` + `y`. If it fails, it will be 0.
 */
public(package) macro fun try_add<$T>($x: _, $y: _, $max: u256): (bool, $T) {
    let r = ($x as u256) + ($y as u256);
    if (r > $max) (false, 0) else (true, (r as $T))
}

/*
 * @notice It tries to perform `x` - `y`.
 *
 * @dev Checks for underflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return The result of `x` - `y`. If it fails, it will be 0.
 */
public(package) macro fun try_sub($x: _, $y: _): (bool, _) {
    if ($y > $x) (false, 0) else (true, $x - $y)
}

/*
 * @notice It tries to perform `x` * `y`.
 *
 * @dev Checks for overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u256. The result of `x` * `y`. If it fails, it will be 0.
 */
public(package) macro fun try_mul($x: _, $y: _): (bool, u256) {
    let x = $x as u256;
    let y = $y as u256;

    if (y == 0) return (true, 0);
    if (
        x > 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff / y
    ) (false, 0) else (true, x * y)
}

/*
 * @notice It tries to perform `x` / `y rounding down.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return u256. The result of x / y. If it fails, it will be 0.
 */
public(package) macro fun try_div_down($x: _, $y: _): (bool, _) {
    if ($y == 0) (false, 0) else (true, div_down!($x, $y))
}

/*
 * @notice It tries to perform `x` / `y` rounding up.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return The result of `x` / `y`. If it fails, it will be 0.
 */
public(package) macro fun try_div_up($x: _, $y: _): (bool, _) {
    if ($y == 0) (false, 0) else (true, div_up!($x, $y))
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
 * @return The result of `x` * `y` / `z`. If it fails, it will be 0.
 */
public(package) macro fun try_mul_div_down($x: _, $y: _, $z: _): (bool, u256) {
    let x = $x as u256;
    let y = $y as u256;
    let z = $z as u256;

    if (z == 0) return (false, 0);
    let (pred, _) = try_mul!(x, y);
    if (!pred) return (false, 0);

    (true, mul_div_down!<u256>(x, y, z))
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
 * @return The result of `x` * `y` / `z`. If it fails, it will be 0.
 */
public(package) macro fun try_mul_div_up($x: _, $y: _, $z: _): (bool, u256) {
    let x = $x as u256;
    let y = $y as u256;
    let z = $z as u256;

    if (z == 0) return (false, 0);
    let (pred, _) = try_mul!(x, y);
    if (!pred) return (false, 0);

    (true, mul_div_up!<u256>(x, y, z))
}

/*
 * @notice It tries to perform `x` % `y`.
 *
 * @dev Checks for zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return bool. If the operation was successful.
 * @return The result of `x` % `y`. If it fails, it will be 0.
 */
public(package) macro fun try_mod($x: _, $y: _): (bool, _) {
    if ($y == 0) (false, 0) else (true, $x % $y)
}

/*
 * @notice It performs `x` + `y`.
 *
 * @dev It will throw on overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The result of `x` + `y`.
 */
public(package) macro fun add($x: _, $y: _): _ {
    $x + $y
}

/*
 * @notice It performs `x` - `y`.
 *
 * @dev It will throw on underflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The result of `x` - `y`.
 */
public(package) macro fun sub($x: _, $y: _): _ {
    $x - $y
}

/*
 * @notice It performs `x` * `y`.
 *
 * @dev It will throw on overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The result of `x` * `y`.
 */
public(package) macro fun mul($x: _, $y: _): _ {
    $x * $y
}

/*
 * @notice It performs `x` / `y` rounding down.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The result of `x` / `y`.
 */
public(package) macro fun div_down($x: _, $y: _): _ {
    $x / $y
}

/*
 * @notice It performs `x` / `y` rounding up.
 *
 * @dev It will throw on zero division.
 * @dev It does not overflow.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The result of `x` / `y`.
 */
public(package) macro fun div_up($x: _, $y: _): _ {
    if ($x == 0) 0 else 1 + ($x - 1) / $y
}

/*
 * @notice It performs `x` * `y` / `z` rounding down.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return The result of `x` * `y` / `z`.
 */
public(package) macro fun mul_div_down<$T>($x: _, $y: _, $z: _): $T {
    let x = $x as u256;
    let y = $y as u256;
    let z = $z as u256;

    let r = x * y / z;

    r as $T
}

/*
 * @notice It performs `x` * `y` / `z` rounding up.
 *
 * @dev It will throw on zero division.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @param z The divisor.
 * @return The result of `x` * `y` / `z`.
 */
public(package) macro fun mul_div_up<$T>($x: _, $y: _, $z: _): $T {
    let x = $x as u256;
    let y = $y as u256;
    let z = $z as u256;

    let r = mul_div_down!<u256>(x, y, z) + if ((x * y) % z > 0) 1 else 0;

    r as $T
}

/*
 * @notice It returns the lowest number.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The lowest number.
 */
public(package) macro fun min($x: _, $y: _): _ {
    if ($x < $y) $x else $y
}

/*
 * @notice It returns the largest number.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The largest number.
 */
public(package) macro fun max($x: _, $y: _): _ {
    if ($x >= $y) $x else $y
}

/*
 * @notice Clamps `x` between the range of [lower, upper].
 *
 * @param x The operand.
 * @param lower The lower bound of the range.
 * @param upper The upper bound of the range.
 * @return The clamped x.
 */
public(package) macro fun clamp($x: _, $lower: _, $upper: _): _ {
    min!($upper, max!($lower, $x))
}

/*
 * @notice Performs |x - y|.
 *
 * @param x The first operand.
 * @param y The second operand.
 * @return The difference.
 */
public(package) macro fun diff($x: _, $y: _): _ {
    if ($x > $y) {
        $x - $y
    } else {
        $y - $x
    }
}

/*
 * @notice Performs n^e.
 *
 * @param n The base.
 * @param e The exponent.
 * @return The result of n^e.
 */
public(package) macro fun pow<$T>($n: _, $e: _): $T {
    let mut n = $n as u256;
    let mut e = $e as u256;

    if (e == 0) {
        1 as $T
    } else {
        let mut p = 1;
        while (e > 1) {
            if (e % 2 == 1) {
                p = p * n;
            };
            e = e / 2;
            n = n * n;
        };
        (p * n) as $T
    }
}

/*
 * @notice Adds all xs in a vector.
 *
 * @param nums A vector of numbers.
 * @return The sum.
 */
public(package) macro fun sum<$T>($nums: _): $T {
    let nums = $nums;

    let len = nums.length();
    let mut i = 0;
    let mut sum = 0;

    while (i < len) {
        sum = (sum as $T) + (nums[i] as $T);
        i = i + 1;
    };

    sum
}

/*
 * @notice It returns the average between two numbers (`x` + `y`) / 2.
 *
 * @dev It does not overflow.
 * @param x The first operand.
 * @param y The second operand.
 * @return The average.
 */
public(package) macro fun average($x: _, $y: _): _ {
    ($x & $y) + ($x ^ $y) / 2
}

/*
 * @notice Calculates the average of the vector of numbers sum of vector/length of vector.
 *
 * @param nums A vector of numbers.
 * @return The average.
 */
public(package) macro fun average_vector<$T>($nums: _): $T {
    let nums = $nums;

    let len = nums.length();

    if (len == 0) return 0;

    let sum = sum!<u256>(nums);

    (sum / (len as u256)) as $T
}

/*
 * @notice Returns the square root of a number. If the number is not a perfect square, the x is rounded down.
 *
 * @dev Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
 *
 * @param x The operand.
 * @return The square root of x rounding down.
 */
public(package) macro fun sqrt_down<$T>($x: _): $T {
    let x = $x as u256;

    if (x == 0) return 0 as $T;

    let mut result = 1 << ((log2_down!(x) >> 1) as u8);

    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;
    result = (result + x / result) >> 1;

    min!(result, x / result) as $T
}

/*
 * @notice Returns the square root of `x` number. If the number is not a perfect square, the `x` is rounded up.
 *
 * @dev Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
 *
 * @param x The operand.
 * @return The square root of x rounding up.
 */
public(package) macro fun sqrt_up<$T>($x: _): $T {
    let r = sqrt_down!($x);
    r + if (r * r < $x) 1 else 0
}

/*
 * @notice Returns the log2(x) rounding down.
 *
 * @param x The operand.
 * @return The log2(x).
 */
public(package) macro fun log2_down<$T>($x: _): $T {
    let mut x = $x as u256;
    let mut result = 0;
    if (x >> 128 > 0) {
        x = x >> 128;
        result = result + 128;
    };

    if (x >> 64 > 0) {
        x = x >> 64;
        result = result + 64;
    };

    if (x >> 32 > 0) {
        x = x >> 32;
        result = result + 32;
    };

    if (x >> 16 > 0) {
        x = x >> 16;
        result = result + 16;
    };

    if (x >> 8 > 0) {
        x = x >> 8;
        result = result + 8;
    };

    if (x >> 4 > 0) {
        x = x >> 4;
        result = result + 4;
    };

    if (x >> 2 > 0) {
        x = x >> 2;
        result = result + 2;
    };

    if (x >> 1 > 0) result = result + 1;

    result
}

/*
 * @notice Returns the log2(x) rounding up.
 *
 * @param x The operand.
 * @return u256. Log2(x).
 */
public(package) macro fun log2_up($x: _): u16 {
    let x = $x as u256;

    let r = log2_down!(x);
    (r as u16) + if (1 << (r as u8) < x) 1 else 0
}

/*
 * @notice Returns the log10(x) rounding down.
 *
 * @param x The operand.
 * @return The log10(x).
 */
public(package) macro fun log10_down($x: _): u8 {
    let mut x = $x as u256;

    let mut result = 0;

    if (x >= 10000000000000000000000000000000000000000000000000000000000000000) {
        x = x / 10000000000000000000000000000000000000000000000000000000000000000;
        result = result + 64;
    };

    if (x >= 100000000000000000000000000000000) {
        x = x / 100000000000000000000000000000000;
        result = result + 32;
    };

    if (x >= 10000000000000000) {
        x = x / 10000000000000000;
        result = result + 16;
    };

    if (x >= 100000000) {
        x = x / 100000000;
        result = result + 8;
    };

    if (x >= 10000) {
        x = x / 10000;
        result = result + 4;
    };

    if (x >= 100) {
        x = x / 100;
        result = result + 2;
    };

    if (x >= 10) result = result + 1;

    result
}

/*
 * @notice Returns the log10(x) rounding up.
 *
 * @param x The operand.
 * @return u256. Log10(x).
 */
public(package) macro fun log10_up($x: _): u8 {
    let r = log10_down!($x);
    r + if (pow!(10, (r as u256)) < $x) 1 else 0
}

/*
 * @notice Returns the log256(x) rounding down.
 *
 * @param x The operand.
 * @return The log256(x).
 */
public(package) macro fun log256_down($x: _): u8 {
    let mut x = $x as u256;
    let mut result = 0;

    if (x >> 128 > 0) {
        x = x >> 128;
        result = result + 16;
    };

    if (x >> 64 > 0) {
        x = x >> 64;
        result = result + 8;
    };

    if (x >> 32 > 0) {
        x = x >> 32;
        result = result + 4;
    };

    if (x >> 16 > 0) {
        x = x >> 16;
        result = result + 2;
    };

    if (x >> 8 > 0) result = result + 1;

    result
}

/*
 * @notice Returns the log256(x) rounding up.
 *
 * @param x The operand.
 * @return The log256(x).
 */
public(package) macro fun log256_up($x: _): u8 {
    let r = log256_down!($x);
    r + if (1 << ((r << 3)) < $x) 1 else 0
}
