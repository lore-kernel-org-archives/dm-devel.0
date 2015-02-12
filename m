From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm space map disk: fix
	sm_disk_count_is_more_than_one()
Date: Thu, 12 Feb 2015 16:51:07 -0500
Message-ID: <1423777867-4435-1-git-send-email-snitzer@redhat.com>
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
Cc: vgoyal@redhat.com
List-Id: dm-devel.ids

dm_tm_shadow_block() is the only caller of
dm_sm_count_is_more_than_one() which only ever operates on a metadata
space-map.  So in practice, sm_disk_count_is_more_than_one() isn't
actually used (which explains why this bug never amounted to anything).

But fix sm_disk_count_is_more_than_one() to properly set *result and
return 0.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-disk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index cfbf961..ebb280a 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -78,7 +78,9 @@ static int sm_disk_count_is_more_than_one(struct dm_space_map *sm, dm_block_t b,
 	if (r)
 		return r;
 
-	return count > 1;
+	*result = count > 1;
+
+	return 0;
 }
 
 static int sm_disk_set_count(struct dm_space_map *sm, dm_block_t b,
-- 
1.9.3 (Apple Git-50)
