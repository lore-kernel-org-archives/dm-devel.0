From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] md/bitmap.c:bitmap_mask_state(): fix
	inconsequent NULL checking
Date: Fri, 10 Mar 2006 19:06:16 +0100
Message-ID: <20060310180616.GR21864@stusta.de>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

We dereference bitmap both one line above and one line below this check 
rendering this check quite useless.

Spotted by the Coverity checker.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc5-mm3-full/drivers/md/bitmap.c.old	2006-03-10 19:02:38.000000000 +0100
+++ linux-2.6.16-rc5-mm3-full/drivers/md/bitmap.c	2006-03-10 19:02:54.000000000 +0100
@@ -546,7 +546,7 @@ static void bitmap_mask_state(struct bit
 	unsigned long flags;
 
 	spin_lock_irqsave(&bitmap->lock, flags);
-	if (!bitmap || !bitmap->sb_page) { /* can't set the state */
+	if (!bitmap->sb_page) { /* can't set the state */
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		return;
 	}
