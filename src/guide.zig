const std = @import("std");

const print = std.debug.print;
const expect = @import("std").testing.expect;


pub fn main() !void{
    // (const | var) identifier[: type] = value
    const constant: i32 = 5;
    var variable: u32 = 5000;

    variable = 40;

    const inferred_constant = @as(i32,5);
    const inferred_variable = @as(u32, 500);

    // if no value can be assigned you can assign "undefined"
    const a: i32 = undefined;
    var b: u32 = undefined;
    
    b = 40;

    // !! if possible youse const over var !

   print("{d}\n", .{constant});
   print("{d}\n", .{variable});

   print("{d}\n", .{inferred_constant});
   print("{d}\n", .{inferred_variable});
    
   print("{d}\n", .{a});
   print("{d}\n", .{b});

    // Arrays
    // [N]T, N = number and T = type
    // if you don't know the amount of items in the array use _ as number

    const c = [5]u8{'h','e', 'l', 'l', 'o'};
    const d = [_]u8{'w', 'o','r', 'l', 'd'};
    
    const array = [_]u8{'w', 'o','r', 'l', 'd'};
    const length = array.len;

    print("{d}\n", .{length});
    print("{c}\n", .{c});
    print("{c}\n", .{d});

    var five: u32 = 5;
    five = addFive(five);
    print("{d}\n", .{five});

    var fibo: u16 = 10;
    fibo = fibonacci(fibo);
    print("{d}\n", .{fibo});
    

}

// errors
const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};

test "coerce from sub to superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}

// (var name: type) return type {}
fn addFive(x: u32) u32 {
    return x + 5;
}

fn fibonacci(n: u16) u16 {
    if(n == 0 or n == 1){
        return 1;
    } else {
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

// defer is like using in c# and is used to cleanup things after the code block is 
// executed

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5);
}

// for loop
test "for"{
    const string = [_]u8{'a', 'b', 'c'};
    for (string, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for(string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}


// while loops

test "if statement" {
        const e = true;
        var x: u16 = 0;
        if(e){
            x += 1;
        } else {
            x += 2;
        }
        try expect( x == 1);
}

test "if as expression" { 
    const f = true;
    var x: u16 = 0;
    x += if(f) 1 else 2;
    try expect(x==1);
}

test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    try expect (i == 128);
}

test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while(i <= 10) : (i += 1) {
        sum += i;
    }
    try expect(sum == 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if(i == 2) continue;
        sum += i;
    }
    try expect(sum == 4);
}

test "while break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if(i == 2) break;
        sum += i;
    }
    try expect(sum == 1);
}





