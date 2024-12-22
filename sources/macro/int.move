module interest_math::int_macro;

// === Public Package Functions ===

public(package) macro fun value($x: _): _ {
    let x = $x;
    x.value
}

public(package) macro fun is_positive($x: _, $min_negative: _): bool {
    let x = $x;
    let min_negative = $min_negative;
    min_negative > x.value
}

public(package) macro fun is_negative($x: _, $min_negative: _): bool {
    let x = $x;
    let min_negative = $min_negative;
    (x.value & min_negative) != 0
}
