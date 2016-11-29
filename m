From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix discard support regression
Date: Tue, 29 Nov 2016 22:37:30 +0100
Message-ID: <1480455450-17352-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

With upstream commit ecbfb9f118bc raid level takeover support got added.

In dm core, restrictions including discard properties are applied when
swapping in a new table.  Any discard settings provided in the context
of pre_resume, which gets called afterwards are lost.

Solve by moving configure_discard_support() back into the constructor.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9d5c6bb..b49b122 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2999,6 +2999,9 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		}
 	}
 
+	/* Disable/enable discard support on raid set. */
+	configure_discard_support(rs);
+
 	mddev_unlock(&rs->md);
 	return 0;
 
@@ -3585,12 +3588,6 @@ static int raid_preresume(struct dm_target *ti)
 	if (test_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags))
 		rs_update_sbs(rs);
 
-	/*
-	 * Disable/enable discard support on raid set after any
-	 * conversion, because devices can have been added
-	 */
-	configure_discard_support(rs);
-
 	/* Load the bitmap from disk unless raid0 */
 	r = __load_dirty_region_bitmap(rs);
 	if (r)
-- 
2.7.4
