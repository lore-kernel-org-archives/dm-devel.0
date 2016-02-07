From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 00/15] dm: improve request-based DM and
	multipath
Date: Sun,  7 Feb 2016 10:53:22 -0500
Message-ID: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com, Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

These changes have been staged in linux-dm.git's 'for-next', see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

The first patch is a stable@ candidate to go into 4.5-rc4+, the
remainder are targetting the 4.6 merge window.

Any review would be appreciated.

Mike Snitzer (15):
  dm: fix excessive dm-mq context switching
  dm: remove unused dm_get_rq_mapinfo()
  dm: cleanup dm_any_congested()
  dm: set DM_TARGET_WILDCARD feature on "error" target
  dm: optimize dm_mq_queue_rq()
  dm: optimize dm_request_fn()
  dm: add 'blk_mq_nr_hw_queues' and 'blk_mq_queue_depth' module params
  dm: allocate blk_mq_tag_set rather than embed in mapped_device
  dm: rename target's per_bio_data_size to per_io_data_size
  dm: allow immutable request-based targets to use blk-mq pdu
  dm mpath: use blk-mq pdu for per-request 'struct dm_mpath_io'
  dm mpath: cleanup 'struct dm_mpath_io' management code
  dm mpath: use blk_mq_alloc_request() and blk_mq_free_request() directly
  dm mpath: reduce granularity of locking in __multipath_map
  dm mpath: remove unnecessary casts in front of ti->private

 block/blk-core.c              |   2 +-
 drivers/md/dm-cache-target.c  |   2 +-
 drivers/md/dm-crypt.c         |   2 +-
 drivers/md/dm-delay.c         |   2 +-
 drivers/md/dm-flakey.c        |   2 +-
 drivers/md/dm-ioctl.c         |   5 +-
 drivers/md/dm-log-writes.c    |   2 +-
 drivers/md/dm-mpath.c         | 101 ++++++++++++------
 drivers/md/dm-raid1.c         |   2 +-
 drivers/md/dm-snap.c          |   2 +-
 drivers/md/dm-table.c         |  30 +++++-
 drivers/md/dm-target.c        |   3 +-
 drivers/md/dm-thin.c          |   2 +-
 drivers/md/dm-verity-fec.c    |   2 +-
 drivers/md/dm-verity-target.c |  12 +--
 drivers/md/dm.c               | 239 ++++++++++++++++++++++++------------------
 drivers/md/dm.h               |   4 +-
 include/linux/device-mapper.h |  13 ++-
 18 files changed, 263 insertions(+), 164 deletions(-)

-- 
2.5.4 (Apple Git-61)
