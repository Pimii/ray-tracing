const std = @import("std");

pub const ProgressPrinter = struct {
    progress_step: usize,

    var current_index: u16 = 0;
    var progress = [10]u8{ ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' };

    pub fn init(target_value: u32) ProgressPrinter {
        return ProgressPrinter{
            .progress_step = target_value / progress.len,
        };
    }

    pub fn print(self: ProgressPrinter, current_progress: usize) !void {
        const stdout = std.io.getStdOut().writer();
        if ((current_progress + 1) % self.progress_step == 0 and current_index < progress.len) {
            progress[current_index] = '#';
            current_index += 1;
        }
        try stdout.print("\u{001b}[1AProcessing : [{s}]\n", .{progress});
    }
};
