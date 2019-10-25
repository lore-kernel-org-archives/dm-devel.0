From: Alessio Balsini <balsini@android.com>
Subject: dm-snapshot for system updates in Android
Date: Fri, 25 Oct 2019 11:16:24 +0100
Message-ID: <20191025101624.GA61225@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: elsk@google.com, dvander@google.com, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com
List-Id: dm-devel.ids

Hello everyone!

I hope you will appreciate knowing that we are currently evaluating the use of
dm-snapshot to implement a mechanism to obtain revertible, space-efficient
system upgrades in Android.  More specifically, we are using
dm-snapshot-persistent to test the updated device after reboot, then issue a
merge in case of success, otherwise, destroy the snapshot.
This new update mechanism is still under evaluation, but its development is
openly done in AOSP.

At the current stage, we have a prototype we are happy with, both in terms of
space consumption overhead (for the COW device) and benchmarking results for
read-write and merge operations.

I would be glad if you could provide some feedback on a few points that I don't
have completely clear.


-- Interface stability

To obtain an initial, empty COW device as quick as possible, we force to 0 only
its first 32 bit (magic field). This solution looks clear from the kernel code,
but can we rely on that for all the kernels with SNAPSHOT_DISK_VERSION == 1?
Would you appreciate it if a similar statement is added as part of
/Documentation, making this solution more stable? Or maybe I can think of
adding an initialization flag to the dm-snapshot table to explicitly request
the COW initialization within the kernel?

Another issue we are facing is to be able to know in advance what the minimum
COW device size would be for a given update to be able to allocate the right
size for the COW device in advance.  To do so, we rely on the current COW
structure that seems to have kept the same stable shape in the last decade, and
compute the total COW size by knowing the number of modified chunks. The
formula would be something like that:

  table_line_bytes      = 64 * 2 / 8;
  exceptions_per_chunk  = chunk_size_bytes / table_line_bytes;
  total_cow_size_chunks = 1 + 1 + modified_chunks
                        + modified_chunks / exceptions_per_chunk;

This formula seems to be valid for all the recent kernels we checked. Again,
can we assume it to be valid for all the kernels for which
SNAPSHOT_DISK_VERSION == 1?


-- Alignment

Our approach follows the solution proposed by Mikulas [1].
Being the block alignment of file extents automatically managed by the
filesystem, using FIEMAP should have no alignment-related performance issue.
But in our implementation we hit a misalignment [2] branch which leads to
dmwarning messages [3, 4].

I have a limited experience with the block layer and dm, so I'm still
struggling in finding the root cause for this, either in user space or kernel
space.
But our benchmarks seems to be good, so we were thinking as last option to
rate-limit or directly remove that warning from our kernels as a temporary
solution, but we prefer to avoid diverging from mainline. Rate-limiting is a
solution that would make sense also to be proposed in the list, but completely
removing the warning doesn't seem the right thing to do. Maybe we are
benchmarking something else? What do you think?

Many thanks for taking the time to read this, feedbacks would be highly
appreciated.

Regards.
Alessio

[1] https://www.redhat.com/archives/dm-devel/2018-October/msg00363.html
[2] https://elixir.bootlin.com/linux/v5.3/source/block/blk-settings.c#L540
[3] https://elixir.bootlin.com/linux/v5.3/source/drivers/md/dm-table.c#L484
[4] https://elixir.bootlin.com/linux/v5.3/source/drivers/md/dm-table.c#L1558
