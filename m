From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/9] md/dm-table: Delete an unnecessary variable
 initialisation in dm_table_register_integrity()
Date: Sat, 1 Oct 2016 09:45:37 +0200
Message-ID: <984c0dd4-b392-cf4b-c42a-93bc859cc00b@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 07:25:43 +0200

The local variable "template_disk" is reassigned by a statement
at the beginning. Thus omit the explicit initialisation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 73d38d0..67cc635 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1165,7 +1165,7 @@ static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t)
 static int dm_table_register_integrity(struct dm_table *t)
 {
 	struct mapped_device *md = t->md;
-	struct gendisk *template_disk = NULL;
+	struct gendisk *template_disk;
 
 	template_disk = dm_table_get_integrity_disk(t);
 	if (!template_disk)
-- 
2.10.0

