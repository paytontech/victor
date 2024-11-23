use std::ffi::CStr;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rust_hello() -> i32 {
    println!("Hello from Rust !!!");
    42
}

#[no_mangle]
pub extern "C" fn process_data(input: *const c_char) -> i32 {
    let c_str = unsafe { CStr::from_ptr(input) };
    let r_str = c_str.to_str().unwrap_or("Invalid UTF-8");
    println!("Rust received: {}", r_str);
    r_str.len() as i32
}