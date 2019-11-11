From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 8/9] scsi: sd_zbc: Cleanup
 sd_zbc_alloc_report_buffer()
Date: Mon, 11 Nov 2019 11:39:29 +0900
Message-ID: <20191111023930.638129-9-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

There is no need to arbitrarily limit the size of a report zone to the
number of zones defined by SD_ZBC_REPORT_MAX_ZONES. Rather, simply
calculate the report buffer size needed for the requested number of
zones without exceeding the device total number of zones. This buffer
size limitation to the hardware maximum transfer size and page mapping
capabilities is kept unchanged. Starting with this initial buffer size,
the allocation is optimized by iterating over decreasing buffer size
until the allocation succeeds (each iteration is allowed to fail fast
using the __GFP_NORETRY flag). This ensures forward progress for zone
reports and avoids failures of zones revalidation under memory pressure.

While at it, also replace the hard coded 512 B sector size with the
SECTOR_SIZE macro.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7c4690f26698..663608d1003b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -104,11 +104,6 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
-/*
- * Maximum number of zones to get with one report zones command.
- */
-#define SD_ZBC_REPORT_MAX_ZONES		8192U
-
 /**
  * Allocate a buffer for report zones reply.
  * @sdkp: The target disk
@@ -138,17 +133,24 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
 	 */
-	nr_zones = min(nr_zones, SD_ZBC_REPORT_MAX_ZONES);
-	bufsize = roundup((nr_zones + 1) * 64, 512);
+	nr_zones = min(nr_zones, sdkp->nr_zones);
+	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
 
-	buf = vzalloc(bufsize);
-	if (buf)
-		*buflen = bufsize;
+	while (bufsize >= SECTOR_SIZE) {
+		buf = __vmalloc(bufsize,
+				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY,
+				PAGE_KERNEL);
+		if (buf) {
+			*buflen = bufsize;
+			return buf;
+		}
+		bufsize >>= 1;
+	}
 
-	return buf;
+	return NULL;
 }
 
 /**
-- 
2.23.0
