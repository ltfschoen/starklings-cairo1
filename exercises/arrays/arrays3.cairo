// arrays3.cairo
// Make me compile and pass the test!
// Execute `starklings hint arrays3` or use the `hint` watch subcommand for a hint.

// Note:
// * Cairo Starknet docs under Arrays and Spans, they use `unbox()` after obtaining the element
// of an array or a span https://book.starknet.io/chapter_2/arrays.html#accessing_array_elements
// * in this Rust post they show `unbox()` being used to dereference a `Box` value  https://stackoverflow.com/a/42264074/3208553,
// where `Box` is a type that may be used to stored data on the heap (rather than the stack) with
// just a pointer to that data being on the stack.
// * array is stored on the heap, so when you get a value it returns a Box<T>
// * may use trait `use box::BoxTrait`
// https://book.cairo-lang.org/ch02-99-01-arrays.html
// * `.at()` doesnt return `Box` because it is already unboxed
// see Cairo's source code here: https://github.com/starkware-libs/cairo/blob/main/corelib/src/array.cairo#L51
// * .get() returns a Box while .at() is `array_at(self, index).unbox()`

use array::ArrayTrait;
use option::OptionTrait;

fn create_array() -> Array<felt252> {
    let mut a = ArrayTrait::new(); // something to change here...
    a.append(0);
    a.append(1);
    a.append(2);
    a.pop_front().unwrap();
    a
}

#[test]
fn test_arrays3() {
    let mut a = create_array();
    //TODO modify the method called below to make the test pass.
    // You should not change the index accessed.
    // a.at(2);
    if a.get(2_usize).is_some() {
        // a.at(2);
        a.get(2_usize).unwrap();
        // why doesn't this work https://book.starknet.io/chapter_2/arrays.html#accessing_array_elements
        // a.get(2_usize).unwrap().unbox();
    }
    
}
