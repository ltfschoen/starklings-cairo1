// move_semantics3.cairo
// Make me compile without adding new lines-- just changing existing lines!
// (no lines with multiple semicolons necessary!)
// Execute `starklings hint move_semantics3` or use the `hint` watch subcommand for a hint.

use array::ArrayTrait;
use array::ArrayTCloneImpl;
use array::SpanTrait;
use clone::Clone;
use debug::PrintTrait;

fn main() {
    let mut arr0 = ArrayTrait::new();

    fill_arr(ref arr0);

    arr0.clone().print();

    arr0.append(88);

    arr0.clone().print();
}

fn fill_arr(ref arr: Array<felt252>) {
    // error: ref argument must be a mutable variable.
    arr.append(22);
    arr.append(44);
    arr.append(66);
}
