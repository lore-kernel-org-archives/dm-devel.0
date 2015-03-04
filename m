From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/8] dm: optimize request-based queue processing
Date: Tue,  3 Mar 2015 19:47:03 -0500
Message-ID: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

This patchset is the result of working through the report that
request-based DM (via dm-multipath) performance suffers on very fast
storage.

The last patch is this set introduces a new per-device sysfs parameter
(rq_based_queue_deadline) that can be set to throttle how aggressively
a request is allowed to remain on the queue to promote merging.
Netapp found that for their filer with an SSD backend and 4 paths they
needed to set this to 10us -- performance jumped nearly 100% (from 280
to 503 MB/s) for their multi-threaded sequential IO workload.

This new parameter is clearly beneficial but yet unfortunate because:
it requires users with really fast multipath storage configs to
test/set this parameter based on running their sequential IO workload
on their specific hardware config.

While I'd love it if we could autodetect the proper value for _any_
storage I really don't think that autotuning belongs in the kernel.
Not to mention: getting that algorithm 1) correct 2) efficient across
all storage is difficult.  But I'm open to any suggestions for how to
autotune this parameter in-kernel without impacting slower setups that
have no need to be bothered with this parameter.

Mike Snitzer (8):
  dm: remove unnecessary wrapper around blk_lld_busy
  dm: remove request-based DM queue's lld_busy_fn hook
  dm: remove request-based logic from make_request_fn wrapper
  dm: only run the queue on completion if congested or no requests pending
  dm: don't schedule delayed run of the queue if nothing to do
  dm: don't start current request if it would've merged with the previous
  dm sysfs: introduce ability to add writable attributes
  dm: impose configurable deadline for dm_request_fn's merge heuristic

 block/blk-core.c              |   5 +-
 drivers/md/dm-mpath.c         |   2 +-
 drivers/md/dm-sysfs.c         |  34 +++++++++--
 drivers/md/dm-table.c         |  14 -----
 drivers/md/dm.c               | 128 +++++++++++++++++++++++++++---------------
 drivers/md/dm.h               |   5 +-
 include/linux/blkdev.h        |   2 -
 include/linux/device-mapper.h |   5 --
 8 files changed, 121 insertions(+), 74 deletions(-)

-- 
1.9.3 (Apple Git-50)
