// options1.cairo
// Execute `starklings hint options1` or use the `hint` watch subcommand for a hint.

// https://github.com/starkware-libs/cairo/discussions/1714#discussioncomment-4763880
use option::OptionTrait;
use option::OptionTraitImpl;

// This function returns how much icecream there is left in the fridge.
// If it's before 10PM, there's 5 pieces left. At 10PM, someone eats them
// all, so there'll be no more left :(
fn maybe_icecream(time_of_day: usize) -> Option<usize> {
    // We use the 24-hour system here, so 10PM is a value of 22 and 12AM is a value of 0
    // The Option output should gracefully handle cases where time_of_day > 23.
    // TODO: Complete the function body - remember to return an Option!
    // https://book.cairo-lang.org/ch05-02-the-match-control-flow-construct.html#matching-with-options

    // attempt1
    // note: this works if i don't run the `maybe_icecream(25).is_none()` test
    if time_of_day < 22 {
        return Option::Some(5);
    } else if time_of_day <= 24 {
        return Option::Some(0);
    } else {
        return Option::None(());
    }

    // FIXME - can't get below to work

    // // attempt2
    // // note: this gives weird errors, and even more weird errors when i add brackets
    // match time_of_day {
    //     t if time_of_day < 22 => return Option::Some(5),
    //     t if time_of_day <= 24 => return Option::Some(0),
    //     t if time_of_day > 24 => return Option::None(()),
    //     _ => return Option::None(()),
    // }

    // attempt3 - simple but not answer
    // match time_of_day {
    //     something_else if time_of_day > 0 => Option::Some(0_usize),
    //     _ => Option::None(()),
    // }
}


#[test]
fn check_icecream() {
    assert(maybe_icecream(9).unwrap() == 5, 'err_1');
    assert(maybe_icecream(10).unwrap() == 5, 'err_2');
    assert(maybe_icecream(23).unwrap() == 0, 'err_3');
    assert(maybe_icecream(22).unwrap() == 0, 'err_4');
    assert(maybe_icecream(25).is_none(), 'err_5');
}

#[test]
fn raw_value() {
    // TODO: Fix this test. How do you get at the value contained in the Option?
    let icecreams = maybe_icecream(12).unwrap();
    assert(icecreams == 5, 'err_6');
}