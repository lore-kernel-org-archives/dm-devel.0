From: Jan Blunck <jblunck@suse.de>
Subject: [patch 06/11] dm-log: remove SECTOR_SHIFT define
Date: Fri, 10 Aug 2007 22:02:10 +0200
Message-ID: <38628.779949113$1186776749@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-log-remove-SECTOR_SHIFT.diff
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

Sector size on Linux is always 512 bytes. Don't even try to give the
impression this is changeable.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-log.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -330,9 +330,9 @@ static int create_log_context(struct dir
 		/*
 		 * Buffer holds both header and bitset.
 		 */
-		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
-				       bitset_size, ti->limits.hardsect_size);
-		lc->header_location.count = buf_size >> SECTOR_SHIFT;
+		buf_size = dm_round_up((LOG_OFFSET << 9) + bitset_size,
+				       ti->limits.hardsect_size);
+		lc->header_location.count = buf_size >> 9;
 		lc->io_req.mem.type = DM_IO_VMA;
 		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
 								   PAGE_SIZE));
@@ -350,8 +350,7 @@ static int create_log_context(struct dir
 			return -ENOMEM;
 		}
 
-		lc->clean_bits = (void *)lc->disk_header +
-				 (LOG_OFFSET << SECTOR_SHIFT);
+		lc->clean_bits = (void *)lc->disk_header + (LOG_OFFSET << 9);
 	}
 
 	memset(lc->clean_bits, -1, bitset_size);

-- 
