From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/6] per-cpu in_flight counters for bio-based
	drivers
Date: Fri, 30 Nov 2018 17:22:20 -0500
Message-ID: <20181130222226.77216-1-snitzer@redhat.com>
References: <20181128004211.368810060@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181128004211.368810060@debian.vm>
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

This v2 the product of more thorough review and testing (on my part)
of Mikulas' original patchset.

Not seeing a major performance win in general but no loss either.  DM
devices do see a huge boost in IOPS thanks to being able to eliminate
the inefficient md->pending IO accounting that it was doing, see:
https://www.redhat.com/archives/dm-devel/2018-November/msg00415.html

Happy to iterate on this patchset further as needed, all
review/suggestions are very much appreciated.

Thanks,
Mike

Mike Snitzer (1):
  dm rq: leverage blk_mq_queue_busy() to check for outstanding IO

Mikulas Patocka (5):
  dm: dont rewrite dm_disk(md)->part0.in_flight
  block: delete part_round_stats and switch to less precise counting
  block: switch to per-cpu in-flight counters
  block: return just one value from part_in_flight
  dm: remove the pending IO accounting

 block/bio.c               | 28 ++++++++++++++++----
 block/blk-core.c          | 67 +++++------------------------------------------
 block/blk-merge.c         |  3 +--
 block/blk-mq.c            | 12 ++++-----
 block/blk-mq.h            |  3 +--
 block/genhd.c             | 59 +++++++++++++++++++++++------------------
 block/partition-generic.c | 10 +++----
 drivers/md/dm-core.h      |  2 --
 drivers/md/dm-rq.c        |  9 +++----
 drivers/md/dm.c           | 36 +++++++++++--------------
 include/linux/genhd.h     | 13 +++++----
 11 files changed, 98 insertions(+), 144 deletions(-)

-- 
2.15.0
