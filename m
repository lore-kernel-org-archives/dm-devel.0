From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] dm space map: always set ev if sm_ll_mutate()
	succeeds
Date: Sun,  4 Dec 2016 23:26:38 -0600
Message-ID: <1480915598-10169-1-git-send-email-bmarzins@redhat.com>
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

If no block was allocated or freed, sm_ll_mutate() wasn't setting
*ev, leaving the variable unitialized. sm_ll_insert(),
sm_disk_inc_block(), and sm_disk_new_block() all check ev to see
if there was an allocation event in sm_ll_mutate(), possibly
reading unitialized data.

If no allocation event occured, sm_ll_mutate() should set *ev
to SM_NONE.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 10978ba..4c28608 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -464,7 +464,8 @@ static int sm_ll_mutate(struct ll_disk *ll, dm_block_t b,
 		ll->nr_allocated--;
 		le32_add_cpu(&ie_disk.nr_free, 1);
 		ie_disk.none_free_before = cpu_to_le32(min(le32_to_cpu(ie_disk.none_free_before), bit));
-	}
+	} else
+		*ev = SM_NONE;
 
 	return ll->save_ie(ll, index, &ie_disk);
 }
-- 
2.1.0
