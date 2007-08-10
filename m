From: Jan Blunck <jblunck@suse.de>
Subject: [patch 11/11] dm-snap: Fix snapshot compilation with
	CONFIG_LBD
Date: Fri, 10 Aug 2007 22:02:15 +0200
Message-ID: <37888.8756306425$1186776775@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-CONFIG_LBD-fix.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The snapshot code validates the snapshot chunksize against the device block
size. Since the block size is usually a power of 2 we don't need to use modulo
here which would let the compiler emit a call to __umoddi3(). Therefore this
patch changes to the test to use a bitmask instead.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -397,7 +397,7 @@ static int set_chunk_size(struct dm_snap
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size % (bdev_hardsect_size(s->cow->bdev) >> 9)) {
+	if (chunk_size & ((bdev_hardsect_size(s->cow->bdev) >> 9) - 1)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}

-- 
