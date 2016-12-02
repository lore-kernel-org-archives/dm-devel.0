From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] dm space map metadata: skip useless memcpy in
	metadata_ll_init_index()
Date: Fri,  2 Dec 2016 15:14:17 -0600
Message-ID: <1480713257-26301-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

When metadata_ll_init_index() is called by sm_ll_new_metadata(),
ll->mi_le hasn't been initialized yet. So, when
metadata_ll_init_index() copies the contents of ll->mi_le into the
newly allocated bitmap_root, it is just copying garbage. ll->mi_le
will be allocated later in sm_ll_extend() and copied into the
bitmap_root, in sm_ll_commit().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 306d2e4..10978ba 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -547,7 +547,6 @@ static int metadata_ll_init_index(struct ll_disk *ll)
 	if (r < 0)
 		return r;
 
-	memcpy(dm_block_data(b), &ll->mi_le, sizeof(ll->mi_le));
 	ll->bitmap_root = dm_block_location(b);
 
 	dm_tm_unlock(ll->tm, b);
-- 
2.1.0
