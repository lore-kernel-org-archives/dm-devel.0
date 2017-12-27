From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to use NVMe's error handler
Date: Tue, 26 Dec 2017 22:22:52 -0500
Message-ID: <20171227032257.8182-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com
Cc: emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This v2 follows Keith's suggestion to only add a 'failover_rq_fn' to
the request_queue (rather than both the bio and request structs).

Jens or Christoph, provided review is favorable, I'd very much
appreciate it you'd pick up patches 1 - 3 for 4.16.

These patches enable DM multipath to work well on NVMe over Fabrics
devices.  Currently that implies CONFIG_NVME_MULTIPATH is _not_ set.

But follow-on work will be to make it so that native NVMe multipath
and DM multipath can be made to co-exist (e.g. blacklisting certain
NVMe devices from being consumed by native NVMe multipath?)

Patch 1 updates block core to formalize a recent construct that
Christoph embeedded into NVMe core (and native NVMe multipath):
callback into a bio-based driver from the blk-mq driver's .complete
hook to blk_steal_bios() a request's bios.

Patch 2 switches NVMe over to using the request_queue's
'failover_rq_fn' established by Patch 1.

Patch 3 moves the nvme_req_needs_failover() from NVMe multipath to
core.  Which allows stacked devices (like DM multipath) to make use of
NVMe's enhanced error handling.

Patch 4 updates DM multipath to also make use of the request_queue's
'failover_rq_fn' established by Patch 1.

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
(James Smart has since sent a fix for commit a0b69cc8)

Thanks,
Mike

Mike Snitzer (5):
  block: establish request failover callback
  nvme: use request_queue's failover_rq_fn callback for multipath failover
  nvme: move nvme_req_needs_failover() from multipath to core
  dm mpath: use NVMe error handling to know when an error is retryable
  dm mpath: skip calls to end_io_bio if using NVMe bio-based and round-robin

 drivers/md/dm-mpath.c         | 87 +++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm-rq.c            |  8 ++--
 drivers/md/dm-table.c         |  2 +
 drivers/md/dm.c               |  7 ++--
 drivers/nvme/host/core.c      | 51 ++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c | 48 ------------------------
 drivers/nvme/host/nvme.h      | 10 -----
 include/linux/blkdev.h        |  6 +++
 include/linux/device-mapper.h |  9 +++++
 9 files changed, 158 insertions(+), 70 deletions(-)

-- 
2.15.0
