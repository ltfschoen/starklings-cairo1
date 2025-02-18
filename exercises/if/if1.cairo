// if1.cairo
// Execute `starklings hint if1` or use the `hint` watch subcommand for a hint.

fn bigger(a: usize, b: usize) -> usize {
    // Complete this function to return the bigger number!
    // Do not use:
    // - another function call
    // - additional variables
    if a > b {
        return a;
    }
    return b;
    // FIXME - how to handle case where a equals b?

    // match a.cmp(&b) {
    //     std::cmp::Ordering::Greater => a,
    //     std::cmp::Ordering::Less => b,
    //     std::cmp::Ordering::Equal => a,
    // }

    // match a {
    //     _ if a > b => a,
    //     _ if b > a => b,
    //     _ => panic!()
    // }
}

// Don't mind this for now :)
#[cfg(test)]
mod tests {
    use super::bigger;

    #[test]
    fn ten_is_bigger_than_eight() {
        assert(10 == bigger(10, 8), '10 bigger than 8');
    }

    #[test]
    fn fortytwo_is_bigger_than_thirtytwo() {
        assert(42 == bigger(32, 42), '42 bigger than 32');
    }
}
