From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] dm: introduce a new DM_MAPIO_KILL return value
Date: Wed, 26 Apr 2017 09:40:39 +0200
Message-ID: <20170426074039.14602-5-hch@lst.de>
References: <20170426074039.14602-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426074039.14602-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

This untangles the DM_MAPIO_* values returned from ->clone_and_map_rq
from the error codes used by the block layer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-rq.c            | 12 +++++-------
 drivers/md/dm-target.c        |  2 +-
 include/linux/device-mapper.h |  1 +
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 769f04f83ca2..ea4fdf68a0ed 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -504,14 +504,12 @@ static int map_request(struct dm_rq_target_io *tio)
 		/* The target wants to requeue the I/O after a delay */
 		dm_requeue_original_request(tio, true);
 		break;
-	default:
-		if (r > 0) {
-			DMWARN("unimplemented target map return value: %d", r);
-			BUG();
-		}
-
+	case DM_MAPIO_KILL:
 		/* The target wants to complete the I/O */
-		dm_kill_unmapped_request(rq, r);
+		dm_kill_unmapped_request(rq, -EIO);
+	default:
+		DMWARN("unimplemented target map return value: %d", r);
+		BUG();
 	}
 
 	return r;
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 43d3445b121d..6264ff00dcf0 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -135,7 +135,7 @@ static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
 				   union map_info *map_context,
 				   struct request **clone)
 {
-	return -EIO;
+	return DM_MAPIO_KILL;
 }
 
 static void io_err_release_clone_rq(struct request *clone)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5bafe3af27cc..0dc4d9cce128 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -590,6 +590,7 @@ extern struct ratelimit_state dm_ratelimit_state;
 #define DM_MAPIO_REMAPPED	1
 #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
 #define DM_MAPIO_DELAY_REQUEUE	3
+#define DM_MAPIO_KILL		4
 
 #define dm_sector_div64(x, y)( \
 { \
-- 
2.11.0
