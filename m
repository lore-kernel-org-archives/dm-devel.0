From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: fix potential NULL pointer in
	dm_table_set_integrity
Date: Thu,  4 Aug 2011 17:34:45 -0400
Message-ID: <1312493685-8052-1-git-send-email-snitzer@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Commit a63a5cf (dm: improve block integrity support) introduced a
two-phase initialization of a DM device's integrity profile.  The
dm_table_set_integrity() call to blk_integrity_register() may deference
a NULL 'template_disk' due to an integrity profile mismatch.

An integrity profile mismatch can occur if the integrity profile for
devices in a DM table are changed between the call to
dm_table_prealloc_integrity() and dm_table_set_integrity() (possible
via table loads for stacked DM devices with integrity profiles).

Reported-by: Zdenek Kabelac <zkabelac@redhat.com> (coverity run)
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@kernel.org # >= 2.6.39.y
---
 drivers/md/dm-table.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5e8e2f3..6cd8d95 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1260,14 +1260,15 @@ static void dm_table_set_integrity(struct dm_table *t)
 		return;
 
 	template_disk = dm_table_get_integrity_disk(t, true);
-	if (!template_disk &&
-	    blk_integrity_is_initialized(dm_disk(t->md))) {
+	if (template_disk)
+		blk_integrity_register(dm_disk(t->md),
+				       blk_get_integrity(template_disk));
+	else if (blk_integrity_is_initialized(dm_disk(t->md)))
 		DMWARN("%s: device no longer has a valid integrity profile",
 		       dm_device_name(t->md));
-		return;
-	}
-	blk_integrity_register(dm_disk(t->md),
-			       blk_get_integrity(template_disk));
+	else
+		DMWARN("%s: unable to establish an integrity profile",
+		       dm_device_name(t->md));
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
-- 
1.7.4.4
