From: heinzm@redhat.com
Subject: [PATCH 08/10] dm raid: remove unused "struct raid_set"
	member
Date: Fri,  1 Dec 2017 01:02:26 +0100
Message-ID: <20171201000228.32677-9-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1c06417944d7..8e63888fe670 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -227,7 +227,6 @@ struct rs_layout {
 struct raid_set {
 	struct dm_target *ti;
 
-	uint32_t bitmap_loaded;
 	uint32_t stripe_cache_entries;
 	unsigned long ctr_flags;
 	unsigned long runtime_flags;
-- 
2.13.6
