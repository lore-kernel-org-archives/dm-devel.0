From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH] dm dust: change ret to r in dust_map_write
Date: Thu,  5 Dec 2019 17:08:37 -0500
Message-ID: <1575583717-12502-1-git-send-email-bgurney@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

In the dust_map_write() function, change the return code variable
"ret" to "r", to match the convention of the other device-mapper
targets.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/md/dm-dust.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index eb37584427a4..ff03b90072c5 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -207,16 +207,16 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 			  bool fail_read_on_bb)
 {
 	unsigned long flags;
-	int ret = DM_MAPIO_REMAPPED;
+	int r = DM_MAPIO_REMAPPED;
 
 	if (fail_read_on_bb) {
 		thisblock >>= dd->sect_per_block_shift;
 		spin_lock_irqsave(&dd->dust_lock, flags);
-		ret = __dust_map_write(dd, thisblock);
+		r = __dust_map_write(dd, thisblock);
 		spin_unlock_irqrestore(&dd->dust_lock, flags);
 	}
 
-	return ret;
+	return r;
 }
 
 static int dust_map(struct dm_target *ti, struct bio *bio)
-- 
2.21.0
