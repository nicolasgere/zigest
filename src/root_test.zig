const std = @import("std");
const testing = std.testing;
const root = @import("root.zig");
const err = @import("error.zig");

const Org = struct {
    login: []const u8,
    id: u64,
    node_id: []const u8,
    url: []const u8,
    repos_url: []const u8,
    events_url: []const u8,
    hooks_url: []const u8,
    issues_url: []const u8,
    members_url: []const u8,
    public_members_url: []const u8,
    avatar_url: []const u8,
    description: ?[]const u8,
};

// test "basic get" {
//     const allocator = std.testing.allocator;
//     var client = try root.HttpClient.init(allocator);
//     defer client.deinit();

//     var response = try client.get("https://api.github.com/users/hadley/orgs", .{});
//     defer response.deinit();
//     try std.testing.expectEqual(std.http.Status.ok, response.status);

//     const orgs = try response.json([]Org);
//     defer orgs.deinit();
//     try std.testing.expectEqual(@as(usize, 10), orgs.value.len);
// }
test "basic get with headers" {
    const allocator = std.testing.allocator;
    var client = try root.HttpClient.init(allocator);
    defer client.deinit();
    const headers = allocator.alloc(std.http.Header, 1) catch unreachable;
    defer allocator.free(headers);
    headers[0] = std.http.Header{ .name = "Accept", .value = "application/vnd.github.v3+json" };

    var response = try client.get("https://api.github.com/users/hadley/orgs", .{ .headers = headers });
    defer response.deinit();
    try std.testing.expectEqual(std.http.Status.ok, response.status);
    const orgs = try response.json([]Org);
    defer orgs.deinit();
    try std.testing.expectEqual(@as(usize, 10), orgs.value.len);
}
