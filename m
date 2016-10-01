From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 9/9] md/dm-table: Delete an unwanted space in
 dm_table_get_integrity_disk()
Date: Sat, 1 Oct 2016 09:53:34 +0200
Message-ID: <03f6a9f1-6bd4-fed0-7232-8d537b69753b@users.sourceforge.net>
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
Date: Sat, 1 Oct 2016 09:24:56 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a948ffb..3ad1b1a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1117,7 +1117,7 @@ static bool integrity_profile_exists(struct gendisk *disk)
  * Get a disk whose integrity profile reflects the table's profile.
  * Returns NULL if integrity support was inconsistent or unavailable.
  */
-static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t)
+static struct gendisk *dm_table_get_integrity_disk(struct dm_table *t)
 {
 	struct list_head *devices = dm_table_get_devices(t);
 	struct dm_dev_internal *dd = NULL;
-- 
2.10.0

