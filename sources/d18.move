/*
* @title D18
*
* @notice A set of functions to operate over u256 numbers with 1e18 precision.
*
* @dev It emulates the decimal precision of ERC20 to port some of their advanced math operations such as {exp} and {ln}.
*/
module interest_math::d18;

use interest_math::{i256::{Self, I256}, uint_macro as macro};

// === Constants ===

// @dev One Wad represents the Ether's decimal scalar - 1e18
const D18_SCALAR: u256 = 1_000_000_000_000_000_000;
// 1e18

// === Errors ===

// @dev It is thrown in values that would overflow in the {exp} function.
const EOverflow: u64 = 0;
// @dev when the natural log function receives a negative value
const EUndefined: u64 = 1;

// === Constant Function ===

/*
* @notice It returns 1 WAD.
* @return u256. 1e18.
*/
public fun scalar(): u256 {
    D18_SCALAR
}

// === Structs ===

public struct D18 has copy, drop, store { value: u256 }

// === Public Convert Functions ===

/*
* @notice It converts a `D18` to a `u256`.
*
* @param self The `D18` struct.
* @return The inner value.
*/
public fun raw_value(self: D18): u256 {
    self.value
}

public fun from_u256(value: u256): D18 {
    D18 { value: (value * D18_SCALAR) }
}

public fun from_u128(value: u128): D18 {
    D18 { value: ((value as u256) * D18_SCALAR) }
}

public fun from_u64(value: u64): D18 {
    D18 { value: ((value as u256) * D18_SCALAR) }
}

public fun from_raw_u256(value: u256): D18 {
    D18 { value }
}

public fun from_raw_u128(value: u128): D18 {
    D18 { value: (value as u256) }
}

public fun from_raw_u64(value: u64): D18 {
    D18 { value: (value as u256) }
}

public fun to_u256(x: D18, decimals: u8): u256 {
    let value = macro::mul_div_down!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value
}

public fun to_u128(x: D18, decimals: u8): u128 {
    let value = macro::mul_div_down!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value as u128
}

public fun to_u64(x: D18, decimals: u8): u64 {
    let value = macro::mul_div_down!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value as u64
}

public fun to_u256_up(x: D18, decimals: u8): u256 {
    let value = macro::mul_div_up!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value
}

public fun to_u128_up(x: D18, decimals: u8): u128 {
    let value = macro::mul_div_up!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value as u128
}

public fun to_u64_up(x: D18, decimals: u8): u64 {
    let value = macro::mul_div_up!<u256>(x.value, macro::pow!<u256>(10, decimals), D18_SCALAR);
    value as u64
}

public fun u64_to_d18(x: u64, decimals: u8): D18 {
    let value = macro::mul_div_up!(x, D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

public fun u128_to_d18(x: u128, decimals: u8): D18 {
    let value = macro::mul_div_up!((x as u256), D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

public fun u256_to_d18(x: u256, decimals: u8): D18 {
    let value = macro::mul_div_up!(x, D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

public fun u64_to_d18_up(x: u64, decimals: u8): D18 {
    let value = macro::mul_div_up!((x as u256), D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

public fun u128_to_d18_up(x: u128, decimals: u8): D18 {
    let value = macro::mul_div_up!((x as u256), D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

public fun u256_to_d18_up(x: u256, decimals: u8): D18 {
    let value = macro::mul_div_up!(x, D18_SCALAR, macro::pow!<u256>(10, decimals));
    D18 { value }
}

// === Try Functions ===

/*
* @notice It tries to `x` * `y` / `WAD` rounding down.
*
* @dev It returns zero instead of throwing an overflow error.
*
* @param x The first operand.
* @param y The second operand.
* @param bool. If the operation was successful or not.
* @return u256. The result of `x` * `y` / `WAD`.
*/
public fun try_mul_down(x: D18, y: D18): (bool, D18) {
    let (pred, value) = macro::try_mul_div_down!(x.value, y.value, D18_SCALAR);
    (pred, D18 { value })
}

/*
* @notice It tries to `x` * `y` / `WAD` rounding up.
*
* @dev It returns zero instead of throwing an overflow error.
*
* @param x The first operand.
* @param y The second operand.
* @param bool. If the operation was successful or not.
* @return u256. The result of `x` * `y` / `WAD`.
*/
public fun try_mul_up(x: D18, y: D18): (bool, D18) {
    let (pred, value) = macro::try_mul_div_up!(x.value, y.value, D18_SCALAR);
    (pred, D18 { value })
}

/*
* @notice It tries to `x` * `WAD` / `y` rounding down.
*
* @dev It will return 0 if `y` is zero.
* @dev It returns zero instead of throwing an overflow error.
*
* @param x The first operand.
* @param y The second operand.
* @param bool. If the operation was successful or not.
* @return u256. The result of `x` * `WAD` / `y`.
*/
public fun try_div_down(x: D18, y: D18): (bool, D18) {
    let (pred, value) = macro::try_mul_div_down!(x.value, D18_SCALAR, y.value);
    (pred, D18 { value })
}

/*
* @notice It tries to `x` * `WAD` / `y` rounding up.
*
* @dev It will return 0 if `y` is zero.
* @dev It returns zero instead of throwing an overflow error.
*
* @param x The first operand.
* @param y The second operand.
* @param bool. If the operation was successful or not.
* @return u256. The result of `x` * `WAD` / `y`.
*/
public fun try_div_up(x: D18, y: D18): (bool, D18) {
    let (pred, value) = macro::try_mul_div_up!(x.value, D18_SCALAR, y.value);
    (pred, D18 { value })
}

/*
* @notice `x` * `y` / `WAD` rounding down.
*
* @param x The first operand.
* @param y The second operand.
* @return u256. The result of `x` * `y` / `WAD`.
*/
public fun mul_down(x: D18, y: D18): D18 {
    let value = macro::mul_div_down!(x.value, y.value, D18_SCALAR);
    D18 { value }
}

/*
* @notice `x` * `y` / `WAD` rounding up.
*
* @param x The first operand.
* @param y The second operand.
* @return u256. The result of `x` * `y` / `WAD`.
*/
public fun mul_up(x: D18, y: D18): D18 {
    let value = macro::mul_div_up!(x.value, y.value, D18_SCALAR);
    D18 { value }
}

/*
* @notice `x` * `WAD` / `y` rounding down.
*
* @param x The first operand.
* @param y The second operand.
* @return u256. The result of `x` * `WAD` / `y`.
*/
public fun div_down(x: D18, y: D18): D18 {
    let value = macro::mul_div_down!(x.value, D18_SCALAR, y.value);
    D18 { value }
}

/*
* @notice `x` * `WAD` / `y` rounding up.
*
* @param x The first operand.
* @param y The second operand.
* @return u256. The result of `x` * `WAD` / `y`.
*/
public fun div_up(x: D18, y: D18): D18 {
    let value = macro::mul_div_up!(x.value, D18_SCALAR, y.value);
    D18 { value }
}

/*
* @notice e^x.
*
* @dev All credits to Remco Bloemen and more information here: https://xn--2-umb.com/22/exp-ln/
* @param x The exponent.
* @return Int. The result of e^x.
*
* aborts-if
*   - `x` is larger than 135305999368893231589.
*/
public fun exp(x: I256): I256 {
    if (x.lte(i256::negative_from_u256(42139678854452767551))) return i256::zero();

    assert!(x.lt(i256::from_u256(135305999368893231589)), EOverflow);

    let mut x = x.shl(78).div(i256::from_u256(macro::pow!(5, 18)));

    let k = x
        .shr(96)
        .div(i256::from_u256(54916777467707473351141471128))
        .add(i256::from_u256(macro::pow!(2, 95)))
        .shr(96);

    x = x.sub(k.mul(i256::from_u256(54916777467707473351141471128)));

    let mut y = x.add(i256::from_u256(1346386616545796478920950773328));
    y =
        y
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(57155421227552351082224309758442),
            );
    let mut p = y.add(x).sub(i256::from_u256(94201549194550492254356042504812));
    p =
        p
            .mul(y)
            .shr(96)
            .add(
                i256::from_u256(28719021644029726153956944680412240),
            );
    p = p.mul(x).add(i256::from_u256(4385272521454847904659076985693276 << 96));

    let mut q = x.sub(i256::from_u256(2855989394907223263936484059900));
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(50020603652535783019961831881945),
            );

    q = q.mul(x).shr(96).sub(i256::from_u256(533845033583426703283633433725380));
    q = q.mul(x).shr(96).sub(i256::from_u256(14423608567350463180887372962807573));
    q = q.mul(x).shr(96).sub(i256::from_u256(14423608567350463180887372962807573));
    q = q.mul(x).shr(96).add(i256::from_u256(26449188498355588339934803723976023));

    let r = p.div(q);

    i256::from_u256(
        (r.to_u256() * 3822833074963236453042738258902158003155416615667) >>
            i256::from(195).sub(k).to_u8(),
    )
}

/*
* @notice ln(x).
*
* @dev All credits to Remco Bloemen and more information here: https://xn--2-umb.com/22/exp-ln/
*
* @param x The operand.
* @return Int. The result of ln(x).
*
* aborts-if
*   - `x` is negative or zero.
*/
public fun ln(mut x: I256): I256 {
    assert!(i256::is_positive(x) && !i256::is_zero(x), EUndefined);

    let k = i256::from_u8(macro::log2_down!(x.to_u256())).sub(i256::from_u256(96));

    x = i256::shl(x, i256::from_u8(159).sub(k).to_u8());
    x = i256::from_u256(i256::value(x) >> 159);

    let mut p = x.add(i256::from_u256(3273285459638523848632254066296));
    p =
        p
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(24828157081833163892658089445524),
            );
    p =
        p
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(43456485725739037958740375743393),
            );
    p =
        p
            .mul(x)
            .shr(96)
            .sub(
                i256::from_u256(11111509109440967052023855526967),
            );
    p =
        p
            .mul(x)
            .shr(96)
            .sub(
                i256::from_u256(45023709667254063763336534515857),
            );
    p =
        p
            .mul(x)
            .shr(96)
            .sub(
                i256::from_u256(14706773417378608786704636184526),
            );
    p = p.mul(x).shr(96).sub(i256::from_u256(795164235651350426258249787498 << 96));

    let mut q = x.add(i256::from_u256(5573035233440673466300451813936));
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(71694874799317883764090561454958),
            );
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(283447036172924575727196451306956),
            );
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(401686690394027663651624208769553),
            );
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(204048457590392012362485061816622),
            );
    q =
        q
            .mul(x)
            .shr(96)
            .add(
                i256::from_u256(31853899698501571402653359427138),
            );
    q = q.mul(x).shr(96).add(i256::from_u256(909429971244387300277376558375));

    let mut r = p.div(q);
    r = r.mul(i256::from_u256(1677202110996718588342820967067443963516166));
    r =
        r.mul(i256::from_u256(
            16597577552685614221487285958193947469193820559219878177908093499208371,
        ).add(
            k,
        ));
    r =
        r.add(
            i256::from_u256(
                600920179829731861736702779321621459595472258049074101567377883020018308,
            ),
        );

    r.shr(174)
}
