From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/9] md/dm-table: Reduce the scope for a variable in
 dm_table_verify_integrity()
Date: Sat, 1 Oct 2016 09:44:40 +0200
Message-ID: <18a48c67-962d-2e61-7d24-dc145ec90935@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 07:10:43 +0200

Move the definition for the variable "template_disk" into an if branch
so that an extra initialisation can be avoided at the beginning
by this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f6b817c..73d38d0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1391,14 +1391,13 @@ int dm_calculate_queue_limits(struct dm_table *table,
  */
 static void dm_table_verify_integrity(struct dm_table *t)
 {
-	struct gendisk *template_disk = NULL;
-
 	if (t->integrity_supported) {
 		/*
 		 * Verify that the original integrity profile
 		 * matches all the devices in this table.
 		 */
-		template_disk = dm_table_get_integrity_disk(t);
+		struct gendisk *template_disk = dm_table_get_integrity_disk(t);
+
 		if (template_disk &&
 		    blk_integrity_compare(dm_disk(t->md), template_disk) >= 0)
 			return;
-- 
2.10.0

