const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    // user
    const user = User{
        .power = 9001,
        .name = "Goku",
    };
    std.debug.print("{s}'s power is {d}\n", .{ user.name, user.power });

    // math
    const sum = add(8999, 2);
    std.debug.print("8999 + 2 = {d}\n", .{sum});

    // user methods
    user.diagnose();
    User.diagnose(user);

    print("\n", .{});

    const a = [_]i32{ 1, 2, 3, 4, 5 };
    var end: usize = 4;
    end += 1;
    const b = a[1..end];
    print("{any}", .{@TypeOf(b)});

    print("\n", .{});

    const method = "";

    if (std.mem.eql(u8, method, "GET") or std.mem.eql(u8, method, "HEAD")) {
        print("Get \n", .{});
    } else if (std.mem.eql(u8, method, "POST")) {
        print("Post \n", .{});
    } else {
        print("else \n", .{});
    }

    const power = user.power;
    const super = if (power < 9000) true else false;
    print("{any}\n", .{super});

    const result = anniversaryName(4);
    print("{s}\n", .{result});

    const arrive = arrivalTimeDesc(4, false);
    print("{s}\n", .{arrive});

    // fro loop range uses .. dots as it does not include the upper and lower number
    for (0..10) |i| {
        print("{d}\n", .{i});
    }

    const src = "this is a \\sting \\with some escape \\chars in it";

    var escape_count: usize = 0;
    {
        var i: usize = 0;
        while (i < src.len) {
            if (src[i] == '\\') {
                i += 2;
                escape_count += 1;
            } else {
                i += 1;
            }
        }
        print("{any}\n", .{escape_count});
    }

    print("{}\n", .{Status.ok});

    const stage1 = Stage.confirmed;
    const stage2 = Stage.validate;

    print("{}\n", .{stage1.isComplete()});
    print("{}\n", .{stage2.isComplete()});

    const n = Number{ .int = 32 };
    print("{d}\n", .{n.int});

    const ts = Timestamp{ .unix = 1693278411 };
    print("{d}\n", .{ts.seconds()});

    var pseido_uuid: [16]u8 = undefined;
    std.crypto.random.bytes(&pseido_uuid);

    print("{s}\n", .{pseido_uuid});

    // errors

    const save = (try Save.loadLast()) orelse Save.blank();
    print("{any}\n", .{save});

    var user2 = User2{
        .id = 1,
        .power = 100,
        .name = "Goku",
    };
    user2.power += 0;

    // pass the address of user2
    levelUp(&user2);

    // adress of operator is '&'
    print("{*}\n{*}\n{*}\n", .{ &user2, &user2.id, &user2.power });

    const user_p = &user2;
    print("{any}\n", .{@TypeOf(user_p)});

    print("User {d} has the power of {d}\n and the name {s}\n", .{ user2.id, user2.power, user2.name });

    var user3 = User2{
        .id = 2,
        .power = 200,
        .name = "Son",
    };

    user3.levelUp();

    print("User {d} has the power of {d}\n and the name {s}\n", .{ user3.id, user3.power, user3.name });

    //
    const arr = std.ArrayList(i32).init();
    arr[0] = 1233;
    arr[1] = 245;
    print("{any}\n", .{arr});
}

// accept pointer so the main object gets modified and not the copy
fn levelUp(user: *User2) void {
    print("{*}\n{*}\n", .{ &user, user });
    var u = user;
    u.power += 1;
}

pub const User2 = struct {
    id: i64,
    power: i32,
    name: []const u8,

    fn levelUp(user: *User2) void {
        user.power += 1;
    }
};

pub const Save = struct {
    lives: u8,
    level: u16,

    pub fn loadLast() !?Save {
        //todo
        return null;
    }

    pub fn blank() Save {
        return .{
            .lives = 3,
            .level = 1,
        };
    }
};

const OpenError = error{
    AccessDenied,
    NotFound,
};

const Status = enum {
    ok,
    bad,
    unknown,
};

const Stage = enum {
    validate,
    await_confirmation,
    confirmed,
    err,

    fn isComplete(self: Stage) bool {
        return self == .confirmed or self == .err;
    }
};

const TimestampType = enum {
    unix,
    datetime,
};

const Timestamp = union(TimestampType) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                const seconds_since_midnight: i32 = @rem(ts, 86400);
                return @intCast(@rem(seconds_since_midnight, 60));
            },
        }
    }
};

// a union defines a set of types a value can have
// number can have the type int, float, or nan (not a number)
const Number = union {
    int: i64,
    float: f64,
    nan: void,
};

fn anniversaryName(years_Married: u16) []const u8 {
    switch (years_Married) {
        1 => return "paper",
        2 => return "cotton",
        3 => return "leather",
        4 => return "flower",
        5 => return "wood",
        6 => return "sugar",
        else => return "no more gifts for you",
    }
}

// switch statement range user ... dots as it includes upper and lower
fn arrivalTimeDesc(minutes: u16, is_late: bool) []const u8 {
    switch (minutes) {
        0 => return "arrived",
        1, 2 => return "soon",
        3...5 => return "no more than 5 minutes",
        else => {
            if (!is_late) {
                return "sorry, it'll be a while";
            }
            return "never";
        },
    }
}

fn contains(haystack: []const u32, needle: u32) bool {
    for (haystack) |value| {
        if (needle == value) {
            return true;
        }
    }
    return false;
}

// the params a and b are constant
pub fn add(a: i64, b: i64) i64 {
    return a + b;
}

pub const User = struct {
    power: u64 = 0,
    name: []const u8,

    pub const SUPER_POWER = 9000;

    // this intiates the struct
    pub fn init(name: []const u8, power: u64) User {
        return User{
            .name = name,
            .power = power,
        };
    }

    pub fn diagnose(user: User) void {
        if (user.power >= SUPER_POWER) {
            std.debug.print("it's over {d}!!!", .{SUPER_POWER});
        }
    }

    //  --!!  Array and Slices !!--
    const a = [5]i32{ 1, 2, 3, 4, 5 };
    const b: [5]i32 = .{ 1, 2, 3, 4, 5 };

    // _ the compiler sets the lenght of the array at comp time
    const c = [_]i32{ 1, 2, 3, 4, 5 };
};
