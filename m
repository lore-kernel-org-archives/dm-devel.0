From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] dm: fix freeze_bdev() return value check
Date: Mon, 24 Sep 2007 19:56:36 +0900
Message-ID: <20070924105636.GA30406@APFDCB5C>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

freeze_bdev() does not return errno as pointer on failure.
This patch fixes the return value check.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/md/dm.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: 2.6-git/drivers/md/dm.c
===================================================================
--- 2.6-git.orig/drivers/md/dm.c
+++ 2.6-git/drivers/md/dm.c
@@ -1290,16 +1290,11 @@ out:
  */
 static int lock_fs(struct mapped_device *md)
 {
-	int r;
-
 	WARN_ON(md->frozen_sb);
 
 	md->frozen_sb = freeze_bdev(md->suspended_bdev);
-	if (IS_ERR(md->frozen_sb)) {
-		r = PTR_ERR(md->frozen_sb);
-		md->frozen_sb = NULL;
-		return r;
-	}
+	if (!md->frozen_sb)
+		return -ENODEV;
 
 	set_bit(DMF_FROZEN, &md->flags);
 
