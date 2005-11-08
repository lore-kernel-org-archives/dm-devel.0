From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/md/kcopyd.c: remove kcopyd_cancel()
Date: Tue, 8 Nov 2005 14:44:19 +0100
Message-ID: <20051108134419.GR3847@stusta.de>
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
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

A function that is
- not used
- empty
- without a prototype in any header file
should be removed.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 5 Nov 2005

 drivers/md/kcopyd.c |   11 -----------
 1 file changed, 11 deletions(-)

--- linux-2.6.14-rc5-mm1-full/drivers/md/kcopyd.c.old	2005-11-05 16:36:11.000000000 +0100
+++ linux-2.6.14-rc5-mm1-full/drivers/md/kcopyd.c	2005-11-05 17:04:45.000000000 +0100
@@ -558,16 +558,6 @@
 	return 0;
 }
 
-/*
- * Cancels a kcopyd job, eg. someone might be deactivating a
- * mirror.
- */
-int kcopyd_cancel(struct kcopyd_job *job, int block)
-{
-	/* FIXME: finish */
-	return -1;
-}
-
 /*-----------------------------------------------------------------
  * Unit setup
  *---------------------------------------------------------------*/
@@ -685,4 +675,3 @@
 EXPORT_SYMBOL(kcopyd_client_create);
 EXPORT_SYMBOL(kcopyd_client_destroy);
 EXPORT_SYMBOL(kcopyd_copy);
-EXPORT_SYMBOL(kcopyd_cancel);
