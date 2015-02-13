From: heinzm@redhat.com
Subject: [PATCH 3/3] md bitmap: export bitmap_destroy() to
	support dm-raid down takover to raid0
Date: Fri, 13 Feb 2015 19:48:08 +0100
Message-ID: <1423853288-6278-4-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch exports symbol bitmap_destroy to allow dm-raid to remove
bitmaps when performing a down takeover to md raid0.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3a57679..b484d15 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1631,6 +1631,7 @@ void bitmap_destroy(struct mddev *mddev)
 
 	bitmap_free(bitmap);
 }
+EXPORT_SYMBOL_GPL(bitmap_destroy);
 
 /*
  * initialize the bitmap structure
-- 
2.1.0
