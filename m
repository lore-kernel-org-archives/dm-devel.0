From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 0/5] block, nvme, dm: allow DM multipath to use NVMe's error handler
Date: Tue, 19 Dec 2017 16:05:41 -0500
Message-ID: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

These patches enable DM multipath to work well on NVMe over Fabrics
devices.  Currently that implies CONFIG_NVME_MULTIPATH is _not_ set.

But follow-on work will be to make it so that native NVMe multipath
and DM multipath can be made to co-exist (e.g. blacklisting certain
NVMe devices from being consumed by native NVMe multipath?)

Patch 1 updates block core to formalize a recent construct that
Christoph embeedded into NVMe core (and native NVMe multipath):
callback into a bio-based driver from the blk-mq driver's .complete
hook to blk_steal_bios() a request's bios.

Patch 2 switches NVMe over to using the block infrastructure
established by Patch 1.

Patch 3 moves the nvme_req_needs_failover() from NVMe multipath to
core.  Which allow sstacked devices (like DM multipath) to make use of
NVMe's enhanced error handling.

Patch 4 updates DM multipath to also make use of the block
infrastructure established by Patch 1.

Patch 5 can be largely ignored.. but it illustrates that Patch 1 - 4
enable DM multipath to avoid extra DM endio callbacks.

These patches have been developed ontop of numerous DM changes I've
staged for 4.16, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16
(which happens to include these 5 patches at the end, purely for
interim linux-next coverage purposes as these changes land in the
appropriate maintainer tree).

I've updated the "mptest" DM multipath testsuite to provide NVMe test
coverage (using NVMe fcloop), see: https://github.com/snitm/mptest

The tree I've been testing includes all of 'dm-4.16' and all but one
of the commits from 'nvme-4.16', see:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-4.16_nvme-4.16
(I've let James Smart know that commit a0b69cc8 causes "nvme connect"
to not work on my fcloop testbed).

Jens, provided review is favorable, I'd very much appreciate it you'd
pick up patches 1 - 3 for 4.16.

Thanks,
Mike

Mike Snitzer (5):
  block: establish request failover callback infrastructure
  nvme: use request's failover callback for multipath failover
  nvme: move nvme_req_needs_failover() from multipath to core
  dm mpath: use NVMe error handling to know when an error is retryable
  dm mpath: skip calls to end_io_bio if using NVMe bio-based and round-robin

 block/blk-core.c              |  2 ++
 block/blk-mq.c                |  1 +
 drivers/md/dm-mpath.c         | 68 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-rq.c            |  8 ++---
 drivers/md/dm.c               |  7 +++--
 drivers/nvme/host/core.c      | 50 +++++++++++++++++++++++++++++--
 drivers/nvme/host/multipath.c | 52 ++-------------------------------
 drivers/nvme/host/nvme.h      | 14 ---------
 include/linux/blk_types.h     |  4 +++
 include/linux/blkdev.h        |  6 ++++
 include/linux/device-mapper.h |  6 ++++
 11 files changed, 145 insertions(+), 73 deletions(-)

-- 
2.15.0
