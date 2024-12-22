#[test_only]
module interest_math::d18_tests;

use interest_math::{
    d18::{
        Self,
        ln,
        exp,
        div_up,
        mul_up,
        div_down,
        mul_down,
        try_mul_up,
        try_div_up,
        try_mul_down,
        try_div_down,
        scalar,
    },
    i256,
    u256::pow
};
use sui::test_utils::assert_eq;

const D18_SCALAR: u256 = 1_000_000_000_000_000_000;
// 1e18
const MAX_U256: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

use fun d18::from_raw_u256 as u256.from_raw;
use fun d18::from_u256 as u256.from;

#[test]
fun test_scalar() {
    assert_eq(scalar(), D18_SCALAR);
}

#[test]
fun test_convert_functions() {
    assert_eq(d18::from_raw_u256(3).raw_value(), 3);
    assert_eq(d18::from_u256(3).raw_value(), 3 * D18_SCALAR);

    assert_eq(d18::from_raw_u128(3).raw_value(), 3);
    assert_eq(d18::from_u128(3).raw_value(), 3 * D18_SCALAR);

    assert_eq(d18::from_raw_u64(3).raw_value(), 3);
    assert_eq(d18::from_u64(3).raw_value(), 3 * D18_SCALAR);

    assert_eq(d18::u64_to_d18(3 * 1000000000, 9).raw_value(), 3 * D18_SCALAR); 
    assert_eq(d18::u64_to_d18(3 * 1000000000, 9).to_u64(9), 3 * 1000000000); 

    assert_eq(d18::u128_to_d18(3 * 1000000000000000000, 18).raw_value(), 3 * D18_SCALAR);   
    assert_eq(d18::u128_to_d18(3 * 1000000000000000000, 18).to_u128(18), 3 * 1000000000000000000);    

    assert_eq(d18::u256_to_d18(3 * 100000000000000000000000000000000000000000000000000, 50).raw_value(), 3 * D18_SCALAR);   
    assert_eq(d18::u256_to_d18(3 * 100000000000000000000000000000000000000000000000000, 50).to_u256(50), 3 * 100000000000000000000000000000000000000000000000000);    
}

#[test]
fun test_try_mul_down() {
    let (pred, r) = try_mul_down(3u256.from(), 5u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 15 * D18_SCALAR);

    let (pred, r) = try_mul_down(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 45 * D18_SCALAR / 10);

    let (pred, r) = try_mul_down(3333333333u256.from_raw(), 23234567832u256.from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 77);

    // not enough precision
    let (pred, r) = try_mul_down(333333u256.from_raw(), 21234u256.from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 0);
    // rounds down

    let (pred, r) = try_mul_down(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_mul_down(MAX_U256.from_raw(), MAX_U256.from_raw());
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);
}

#[test]
fun test_try_mul_up() {
    let (pred, r) = try_mul_up(3u256.from(), 5u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 15 * D18_SCALAR);

    let (pred, r) = try_mul_up(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 45 * D18_SCALAR / 10);

    let (pred, r) = try_mul_down(3333333333u256.from_raw(), 23234567832u256.from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 77);

    let (pred, r) = try_mul_up(333333u256.from_raw(), 21234u256.from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 1);
    // rounds up

    let (pred, r) = try_mul_up(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_mul_up(MAX_U256.from_raw(), MAX_U256.from_raw());
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);
}

#[test]
fun test_try_div_down() {
    let (pred, r) = try_div_down(3u256.from(), 5u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 6 * D18_SCALAR / 10);

    let (pred, r) = try_div_down(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 2 * D18_SCALAR);
    //

    let (pred, r) = try_div_down(7u256.from(), 2u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 35 * D18_SCALAR / 10);

    let (pred, r) = try_div_down(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_div_down(333333333u256.from(), 222222221u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 1500000006750000037);
    // rounds down
    let (pred, r) = try_div_down(1u256.from(), 0u256.from());
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_div_down(MAX_U256.from_raw(), MAX_U256.from_raw());
    // overflow
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);
}

#[test]
fun test_try_div_up() {
    let (pred, r) = try_div_up(3u256.from(), 5u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 6 * D18_SCALAR / 10);

    let (pred, r) = try_div_up(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 2 * D18_SCALAR);
    //

    let (pred, r) = try_div_up(7u256.from(), 2u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 35 * D18_SCALAR / 10);

    let (pred, r) = try_div_up(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_div_up(333333333u256.from(), 222222221u256.from());
    assert_eq(pred, true);
    assert_eq(r.raw_value(), 1500000006750000038);
    // rounds up
    let (pred, r) = try_div_up(1u256.from(), 0u256.from());
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);

    let (pred, r) = try_div_up(MAX_U256.from_raw(), MAX_U256.from_raw());
    // overflow
    assert_eq(pred, false);
    assert_eq(r.raw_value(), 0);
}

#[test]
fun test_mul_down() {
    assert_eq(mul_down(3u256.from(), 5u256.from()).raw_value(), 15 * D18_SCALAR);

    assert_eq(mul_down(333333333u256.from_raw(), 222222221u256.from_raw()).raw_value(), 0u256);

    assert_eq(mul_down(333333u256.from_raw(), 21234u256.from_raw()).raw_value(), 0u256);
    // rounds down

    assert_eq(mul_down(0u256.from_raw(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 0u256);
}

#[test]
fun test_mul_up() {
    assert_eq(mul_up(3u256.from(), 5u256.from()).raw_value(), 15 * D18_SCALAR);

    assert_eq(mul_up(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 45 * D18_SCALAR / 10);

    assert_eq(mul_up(333333u256.from_raw(), 21234u256.from_raw()).raw_value(), 1);
    // rounds up

    assert_eq(mul_up(0u256.from_raw(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 0);
}

#[test]
fun test_div_down() {
    assert_eq(div_down(3u256.from(), 5u256.from()).raw_value(), 6 * D18_SCALAR / 10);

    assert_eq(div_down(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 2 * D18_SCALAR);
    //

    assert_eq(div_down(7u256.from(), 2u256.from()).raw_value(), 35 * D18_SCALAR / 10);

    assert_eq(div_down(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 0);

    assert_eq(div_down(333333333u256.from(), 222222221u256.from()).raw_value(), 1500000006750000037);
    // rounds down
}

#[test]
fun test_div_up() {
    assert_eq(div_up(3u256.from(), 5u256.from()).raw_value(), 6 * D18_SCALAR / 10);

    assert_eq(div_up(3u256.from(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 2 * D18_SCALAR);
    //

    assert_eq(div_up(7u256.from(), 2u256.from()).raw_value(), 35 * D18_SCALAR / 10);

    assert_eq(div_up(0u256.from(), ((D18_SCALAR / 10) * 15).from_raw()).raw_value(), 0);

    assert_eq(div_up(333333333u256.from(), 222222221u256.from()).raw_value(), 1500000006750000038);
    // rounds up
}

#[test]
fun test_to_d18() {
    assert_eq(d18::u256_to_d18(D18_SCALAR, 18).raw_value(), D18_SCALAR);
    assert_eq(d18::u256_to_d18(2, 1).raw_value(), 2 * D18_SCALAR / 10);
    assert_eq(d18::u256_to_d18(20 * D18_SCALAR, 18).raw_value(), 20 * D18_SCALAR);
}

// #[test]
// fun test_exp() {
//     assert_eq(exp(int::neg_from_u256(42139678854452767551)).value(), 0);

//     assert_eq(exp(int::neg_from_u256(3000000000000000000)).value(), 49787068367863942);
//     assert_eq(exp(int::neg_from_u256(2 * D18_SCALAR)).value(), 135335283236612691);
//     assert_eq(exp(int::neg_from_u256(D18_SCALAR)).value(), 367879441171442321);

//     assert_eq(exp(int::neg_from_u256(5 * D18_SCALAR / 10)).value(), 606530659712633423);
//     assert_eq(exp(int::neg_from_u256(3 * D18_SCALAR / 10)).value(), 740818220681717866);

//     assert_eq(exp(int::from_u256(0)).value(), D18_SCALAR);

//     assert_eq(exp(int::from_u256(3 * D18_SCALAR / 10)).value(), 1349858807576003103);
//     assert_eq(exp(int::from_u256(5 * D18_SCALAR / 10)).value(), 1648721270700128146);

//     assert_eq(exp(int::from_u256(1 * D18_SCALAR)).value(), 2718281828459045235);
//     assert_eq(exp(int::from_u256(2 * D18_SCALAR)).value(), 7389056098930650227);
//     assert_eq(exp(int::from_u256(3 * D18_SCALAR)).value(), 20085536923187667741);

//     assert_eq(exp(int::from_u256(10 * D18_SCALAR)).value(), 220264657948067165169_80);

//     assert_eq(exp(int::from_u256(50 * D18_SCALAR)).value(), 5184705528587072464_148529318587763226117);

//     assert_eq(
//         exp(int::from_u256(100 * D18_SCALAR)).value(),
//         268811714181613544841_34666106240937146178367581647816351662017,
//     );

//     assert_eq(
//         exp(int::from_u256(135305999368893231588)).value(),
//         578960446186580976_50144101621524338577433870140581303254786265309376407432913,
//     );
// }

#[test]
fun test_ln() {
    assert_eq(ln(i256::from_u256(D18_SCALAR)).value(), 0);
    assert_eq(ln(i256::from_u256(2718281828459045235)).value(), 999999999999999999);
    assert_eq(ln(i256::from_u256(11723640096265400935)).value(), 2461607324344817918);

    assert_eq(ln(i256::from_u256(1)), i256::negative_from_u256(41446531673892822313));
    assert_eq(ln(i256::from_u256(42)), i256::negative_from_u256(37708862055609454007));
    assert_eq(ln(i256::from_u256(10000)), i256::negative_from_u256(32236191301916639577));
    assert_eq(ln(i256::from_u256(1000000000)), i256::negative_from_u256(20723265836946411157));

    assert_eq(ln(i256::from_u256(pow(2, 255) - 1)).value(), 135305999368893231589);
    assert_eq(ln(i256::from_u256(pow(2, 170))).value(), 76388489021297880288);
    assert_eq(ln(i256::from_u256(pow(2, 128))).value(), 47276307437780177293);
}

#[test]
#[expected_failure]
fun test_div_down_overflow() {
    div_down(MAX_U256.from_raw(), MAX_U256.from_raw());
}

#[test]
#[expected_failure]
fun test_div_down_zero_division() {
    div_down(1u256.from_raw(), 0u256.from_raw());
}

#[test]
#[expected_failure]
fun test_div_up_zero_division() {
    div_up(1u256.from_raw(), 0u256.from_raw());
}

#[test]
#[expected_failure]
fun test_mul_up_overflow() {
    mul_up(MAX_U256.from_raw(), MAX_U256.from_raw());
}

#[test]
#[expected_failure]
fun test_mul_down_overflow() {
    mul_down(MAX_U256.from_raw(), MAX_U256.from_raw());
}

// #[test]
// #[expected_failure(abort_code = d18::EUndefined)]
// fun test_negative_ln() {
//     ln(int::neg_from_u256(1));
// }

// #[test]
// #[expected_failure(abort_code = d18::EUndefined)]
// fun test_zero_ln() {
//     ln(int::from_u256(0));
// }

// #[test]
// #[expected_failure(abort_code = d18::EOverflow)]
// fun test_exp_overflow() {
//     exp(int::from_u256(135305999368893231589));
// }
