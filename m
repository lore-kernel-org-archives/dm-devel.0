From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] fix nvme test
Date: Mon, 26 Feb 2018 14:42:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802261437140.5096@file01.intranet.prod.int.rdu2.redhat.com>
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
To: msnizer@redhat.com
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

The strncmp function should compare 4 bytes.

But I'm wondering what's the purpose of this test at all? bio-based 
interface doesn't support partial completions for any device - so why do 
we need special code path just for nvme and why can't we use it for other 
block devices?

Mikulas


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2018-02-24 03:40:18.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2018-02-26 19:36:29.728499000 +0100
@@ -1755,7 +1755,7 @@ static int device_no_partial_completion(
 	char b[BDEVNAME_SIZE];
 
 	/* For now, NVMe devices are the only devices of this class */
-	return (strncmp(bdevname(dev->bdev, b), "nvme", 3) == 0);
+	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) == 0);
 }
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
