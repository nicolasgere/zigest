const std = @import("std");
const err = @import("error.zig");

pub const RequestOptions = struct {
    headers: ?[]std.http.Header = null,
};

const InternalRequestOptions = struct {
    options: ?RequestOptions,
    url: []const u8,
    method: std.http.Method,
    body: ?[]const u8,
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

    fn doRequest(self: *HttpClient, options: InternalRequestOptions) !HttpResponse {
        var buf: [4096]u8 = undefined;

        // Parse the URL properly
        const uri = try std.Uri.parse(options.url);

        // Start the HTTP request
        var req = try self.client.open(options.method, uri, .{ .server_header_buffer = &buf });

        if (options.options.?.headers.?.len > 0) {
            req.extra_headers = options.options.?.headers.?;
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
    pub fn post(self: *HttpClient, url: []const u8, comptime body: type, options: ?RequestOptions) !HttpResponse {
        var string = std.ArrayList(u8).init(self.allocator);
        defer string.deinit();
        try std.json.stringify(body, .{}, string.writer());

        const body_string = try string.toOwnedSlice();
        const internalOptions = InternalRequestOptions{ .options = options, .url = url, .method = .GET, .body = body_string };

        return self.doRequest(internalOptions);
    }

    pub fn get(self: *HttpClient, url: []const u8, options: ?RequestOptions) !HttpResponse {
        const internalOptions = InternalRequestOptions{
            .options = options.?,
            .url = url,
            .method = .GET,
            .body = null,
        };

        return self.doRequest(internalOptions);
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
