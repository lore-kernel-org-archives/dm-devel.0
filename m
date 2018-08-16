From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: fix a crash when over-reading
	dirty_bitmap
Date: Thu, 16 Aug 2018 12:23:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808161222550.6728@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch fixes a crash in find_next_bit reported in
https://bugzilla.kernel.org/show_bug.cgi?id=200819 . wc->dirty_bitmap_size
is in bytes, so we must multiply it by 8, not by BITS_PER_LONG.


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 4.18+
Fixes: 48debafe4f2f ("dm: add writecache target")

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-08-13 16:52:31.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-08-16 18:06:35.000000000 +0200
@@ -457,7 +457,7 @@ static void ssd_commit_flushed(struct dm
 		COMPLETION_INITIALIZER_ONSTACK(endio.c),
 		ATOMIC_INIT(1),
 	};
-	unsigned bitmap_bits = wc->dirty_bitmap_size * BITS_PER_LONG;
+	unsigned bitmap_bits = wc->dirty_bitmap_size * 8;
 	unsigned i = 0;
 
 	while (1) {
