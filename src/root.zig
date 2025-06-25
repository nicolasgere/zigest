const std = @import("std");
const err = @import("error.zig");

pub const RequestOptions = struct {
    headers: ?[]std.http.Header = null,
};

pub const HttpClient = struct {
    allocator: std.mem.Allocator,
    client: std.http.Client,

    pub fn init(allocator: std.mem.Allocator) !HttpClient {
        return HttpClient{ .allocator = allocator, .client = std.http.Client{ .allocator = allocator } };
    }

    pub fn deinit(self: *HttpClient) void {
        self.client.deinit();
    }

    pub fn get(self: *HttpClient, url: []const u8, options: ?RequestOptions) !HttpResponse {
        var buf: [4096]u8 = undefined;

        // Parse the URL properly
        const uri = try std.Uri.parse(url);

        // Start the HTTP request
        var req = try self.client.open(.GET, uri, .{ .server_header_buffer = &buf });
        if (options != null) {
            if (options.?.headers != null) {
                req.extra_headers = options.?.headers.?;
            }
        }

        errdefer req.deinit();

        // Send the request
        try req.send();
        // Wait for the headers
        try req.wait();
        return HttpResponse{
            .allocator = self.allocator,
            .req = req,
            .complete = false,
            .status = req.response.status,
            .status_class = req.response.status.class(),
        };
    }
};

pub const HttpResponse = struct {
    allocator: std.mem.Allocator,
    req: std.http.Client.Request,
    complete: bool,
    status: std.http.Status,
    status_class: std.http.Status.Class,

    pub fn deinit(self: *HttpResponse) void {
        if (self.complete == false) {
            self.req.deinit();
            self.complete = true;
        }
    }

    pub fn ok(self: *HttpResponse) !void {
        if (self.status.class() != std.http.Status.Class.success) {
            const err1 = err.statusCodeToError(@intFromEnum(self.status));
            std.debug.print("HTTP error: {}\n", .{err1});
            return err1;
        }
        return;
    }
    pub fn do(self: *HttpResponse) !std.ArrayList(u8) {
        defer {
            self.complete = true;
            self.req.deinit();
        }

        // Read the response body
        var content = std.ArrayList(u8).init(self.allocator);
        var reader = self.req.reader();
        try reader.readAllArrayList(&content, std.math.maxInt(usize));
        return content;
    }
    pub fn json(self: *HttpResponse, comptime T: type) !std.json.Parsed(T) {
        const content = try self.do();
        defer content.deinit();

        // Parse the JSON
        const parsed = try std.json.parseFromSlice(T, self.allocator, content.items, .{});

        return parsed;
    }
};
