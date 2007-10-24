From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: noflush resizing (3/3) Allow table swapping
 with different size
Date: Wed, 24 Oct 2007 17:26:02 -0400
Message-ID: <471FB86A.2060609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch removes the check for whether the loaded table
is going to change the device size and allows resizing of
the dm device suspended with 'noflush'.


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 dm.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.23.work/drivers/md/dm.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm.c
+++ linux-2.6.23.work/drivers/md/dm.c
@@ -1288,11 +1288,6 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
-	/* without bdev, the device size cannot be changed */
-	if (!md->suspended_bdev)
-		if (get_capacity(md->disk) != dm_table_get_size(table))
-			goto out;
-
 	__unbind(md);
 	r = __bind(md, table);
 
