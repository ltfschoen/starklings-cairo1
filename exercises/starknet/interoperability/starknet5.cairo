// starknet5.cairo
// Address all the TODOs to make the tests pass!
// Execute `starklings hint starknet5` or use the `hint` watch subcommand for a hint.
// https://book.cairo-lang.org/ch99-02-00-abis-and-cross-contract-interactions.html

use core::traits::Into;
use core::result::ResultTrait;
use starknet::syscalls::deploy_syscall;
use array::ArrayTrait;
use traits::TryInto;
use option::OptionTrait;
use starknet::class_hash::Felt252TryIntoClassHash;

// Call ContractB from inside ContractA using the following Dispatcher object 
// that is automatically generated upon compilation, but just shown below for reference.
// It is of the type of the called contract ContractB, where the Dispatcher
// has associated methods available under the `DispatcherTrait`, that
// correspond to the external functions of the ContractB contract that you want to call.
// See https://book.cairo-lang.org/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html#contract-dispatcher
// trait IContractBDispatcherTrait<TContractState> {
//     // https://book.cairo-lang.org/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html#using-low-level-syscalls
//     fn is_enabled(
//         ref self: TContractState,
//         address: starknet::ContractAddress,
//         selector: felt252,
//         calldata: Array<felt252>,
//     ) -> bool;
//     // ...
// }

// #[derive(Copy, Drop, storage_access::StorageAccess, Serde)]
// struct IContractBDispatcher {
//     contract_address: starknet::ContractAddress,
// }

// impl IContractBDispatcherImpl of IContractBDispatcherTrait<IContractBDispatcher> {
//     fn is_enabled(
//         ref self: IContractBDispatcher,
//         address: starknet::ContractAddress,
//         selector: felt252,
//         calldata: Array<felt252>,
//     ) -> bool { // starknet::call_contract_syscall is called in here
//         // `call_contract_syscall` https://github.com/starkware-libs/cairo/blob/main/corelib/src/starknet/syscalls.cairo#L10
//         let mut res = starknet::call_contract_syscall(address, selector, calldata.span())
//             .unwrap_syscall();
//         Serde::<bool>::deserialize(ref res).unwrap()
//     }
//     // ...
// }

// Note: in older cairo versions it would be annotated with 
// `#[starknet::interface]` instead of `#[abi]`
#[abi]
trait IContractA {
    fn set_value(_value: u128) -> bool;
    fn get_value() -> u128;
}

#[contract]
mod ContractA {
    use traits::Into;
    use starknet::info::get_contract_address;
    use starknet::ContractAddress;
    use super::IContractBDispatcher;
    use super::IContractBDispatcherTrait;
    use result::ResultTrait;
    use debug::PrintTrait;

    struct Storage {
        contract_b: ContractAddress,
        value: u128,
    }

    #[constructor]
    fn constructor(_contract_b: ContractAddress) {
        contract_b::write(_contract_b)
    }

    #[external]
    fn set_value(
        _value: u128
    ) -> bool { //TODO: check if contract_b is enabled. If it is, set the value and return true. Otherwise, return false.
        let address_b: ContractAddress = contract_b::read();
        let is_enabled = IContractBDispatcher { contract_address: address_b }.is_enabled();
        'ContractB is_enabled: '.print();
        (is_enabled).print();
        if is_enabled == true {
            value::write(_value);
            return true;
        } else {
            return false;
        }
    }

    #[view]
    fn get_value() -> u128 {
        value::read()
    }
}

#[abi]
trait IContractB {
    fn enable();
    fn disable();
    fn is_enabled() -> bool;
}

#[contract]
mod ContractB {
    struct Storage {
        enabled: bool
    }

    #[constructor]
    fn constructor() {}

    #[external]
    fn enable() {
        enabled::write(true);
    }

    #[external]
    fn disable() {
        enabled::write(false);
    }

    #[view]
    fn is_enabled() -> bool {
        enabled::read()
    }
}

#[cfg(test)]
mod test {
    use option::OptionTrait;
    use starknet::syscalls::deploy_syscall;
    use traits::Into;
    use traits::TryInto;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use array::ArrayTrait;
    use result::ResultTrait;
    use starknet::ContractAddress;
    use debug::PrintTrait;

    use super::ContractA;
    use super::IContractADispatcher;
    use super::IContractADispatcherTrait;
    use super::ContractB;
    use super::IContractBDispatcher;
    use super::IContractBDispatcherTrait;

    #[test]
    #[available_gas(30000000)]
    fn test_interoperability() {
        // Deploy ContractB
        let (address_b, _) = deploy_syscall(
            ContractB::TEST_CLASS_HASH.try_into().unwrap(), 0, ArrayTrait::new().span(), false
        ).unwrap();

        // Deploy ContractA
        let mut calldata = ArrayTrait::new();
        calldata.append(address_b.into());
        let (address_a, _) = deploy_syscall(
            ContractA::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        ).unwrap();

        // contract_a is of type IContractADispatcher. Its methods are defined in IContractADispatcherTrait.
        let contract_a = IContractADispatcher { contract_address: address_a };
        let contract_b = IContractBDispatcher { contract_address: address_b };

        //TODO interact with contract_b to make the test pass.

        // call the enable() function of ContractA to be able to store a value in the `value`
        // key of storage with `set_value` function, otherwise there will not be a value there to
        // be retrieved by calling `get_value` function and below assertion will fail
        contract_b.enable();
        

        assert(contract_a.set_value(300) == true, 'Could not set value');
        assert(contract_a.get_value() == 300, 'Value was not set');
        assert(contract_b.is_enabled() == true, 'Contract b is not enabled');
    }
}
