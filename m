From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: fix queue limits stacking when data
 device has compulsory merge_bvec_fn
Date: Wed, 23 Jan 2013 17:16:53 -0500
Message-ID: <20130123221653.GA1545@redhat.com>
References: <201301180219.10467.db@kavod.com>
	<20130121184954.GA18892@redhat.com> <50FE739C.5090200@redhat.com>
	<20130122135132.GA24851@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130122135132.GA24851@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: sandeen@redhat.com, Daniel Browning <db@kavod.com>, ejt@redhat.com, Jeff Moyer <jmoyer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

When a thin-pool uses an MD device for the data device a thin device
from the thin-pool must respect MD's constraints about disallowing a bio
to span multiple chunks.  Otherwise we can see problems.  If the raid0
chunksize is 1152K and thin-pool chunksize is 256K I see the following
md/radi0 error (with extra debug tracing added to thin_endio) when
mkfs.xfs is executed against the thin device:

md/raid0:md99: make_request bug: can't convert block across chunks or bigger than 1152k 6688 127
device-mapper: thin: bio sector=2080 err=-5 bi_size=130560 bi_rw=17 bi_vcnt=32 bi_idx=0

This extra DM debugging shows that the failing bio is spanning across
the first and second logical 1152K chunk (sector 2080 + 255 takes the
bio beyond the first chunk's boundary of sector 2304).  So the bio
splitting that DM is doing clearly isn't respecting the MD limits.

max_hw_sectors_kb is 127 for both the thin-pool and thin device
(queue_max_hw_sectors returns 255 so we'll excuse sysfs's lack of
precision).  So this explains why bi_size is 130560.

But the thin device's max_hw_sectors_kb should be 4 (PAGE_SIZE) given
that it doesn't have a .merge function (for bio_add_page to consult
indirectly via dm_merge_bvec) yet the thin-pool does sit above an MD
device that has a compulsory merge_bvec_fn.  This scenario is exactly
why DM must resort to sending single PAGE_SIZE bios to the underlying
layer -- some additional context for this is available in the header for
commit 8cbeb67a.

Look story short, the reason a thin device doesn't properly get
configured to have a max_hw_sectors_kb of 4 (PAGE_SIZE) is that
thin_io_hints() is blindly copying the queue limits from the thin-pool
device directly to the thin device's queue limits.

Fix this by eliminating thin_io_hints.  Doing so is safe because the
block layer's queue limits stacking already enables the upper level thin
device to inherit the thin-pool device's discard and minimum_io_size and
optimal_io_size limits that get set in pool_io_hints.  But avoiding the
queue limits copy allows the thin and thin-pool limits to be different
where it is important, namely max_hw_sectors_kb.

Reported-by: Daniel Browning <db@kavod.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 074e570..9bd59ae 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2819,16 +2819,6 @@ static int thin_iterate_devices(struct dm_target *ti,
 	return 0;
 }
 
-/*
- * A thin device always inherits its queue limits from its pool.
- */
-static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
-{
-	struct thin_c *tc = ti->private;
-
-	*limits = bdev_get_queue(tc->pool_dev->bdev)->limits;
-}
-
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 6, 0},
@@ -2840,7 +2830,6 @@ static struct target_type thin_target = {
 	.postsuspend = thin_postsuspend,
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
-	.io_hints = thin_io_hints,
 };
 
 /*----------------------------------------------------------------*/
