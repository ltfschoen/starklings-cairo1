// move_semantics2.cairo
// Make me compile without changing line 16 or moving line 13!
// Execute `starklings hint move_semantics2` or use the `hint` watch subcommand for a hint.

use array::ArrayTrait;
use array::ArrayTCloneImpl;
use debug::PrintTrait;
use clone::Clone;

fn main() {
    // error: Variable was previously moved. Trait has no implementation in context: core::traits::Copy::<core::array::Array::<core::felt252>>
    let mut arr0 = ArrayTrait::new();

    // Do not move this line
    fill_arr(ref arr0);

    // Do not change the following line!
    arr0.print();
}

fn fill_arr(ref arr: Array<felt252>) {
    let mut arr = arr.clone();

    arr.append(22);
    arr.append(44);
    arr.append(66);
}
