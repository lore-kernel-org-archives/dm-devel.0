From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/7] per-cpu in_flight counters for bio-based
	drivers
Date: Wed,  5 Dec 2018 15:24:26 -0500
Message-ID: <20181205202433.95823-1-snitzer@redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi,

This v3 adds "block: stop passing 'cpu' to all percpu stats methods"
before switching over to percpu counters.

Thanks,
Mike

Mike Snitzer (2):
  dm rq: leverage blk_mq_queue_busy() to check for outstanding IO
  block: stop passing 'cpu' to all percpu stats methods

Mikulas Patocka (5):
  dm: dont rewrite dm_disk(md)->part0.in_flight
  block: delete part_round_stats and switch to less precise counting
  block: switch to per-cpu in-flight counters
  block: return just one value from part_in_flight
  dm: remove the pending IO accounting

 block/bio.c               | 36 ++++++++++++++----
 block/blk-core.c          | 80 ++++++---------------------------------
 block/blk-merge.c         |  4 +-
 block/blk-mq.c            | 12 +++---
 block/blk-mq.h            |  3 +-
 block/genhd.c             | 61 ++++++++++++++++++-----------
 block/partition-generic.c | 10 ++---
 drivers/md/dm-core.h      |  2 -
 drivers/md/dm-rq.c        |  9 ++---
 drivers/md/dm.c           | 36 ++++++++----------
 drivers/md/md.c           |  7 ++--
 include/linux/genhd.h     | 33 ++++++++--------
 12 files changed, 125 insertions(+), 168 deletions(-)

-- 
2.18.0
