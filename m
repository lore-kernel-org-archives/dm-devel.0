From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: remove superfluous test
Date: Sun, 19 Apr 2020 04:34:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004190432230.7214@file01.intranet.prod.int.rdu2.redhat.com>
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

Remove superfluous test if dax_dev is NULL - dax_direct_access already
does this test.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-17 14:06:35.129999000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2020-04-17 16:02:54.339847000 +0200
@@ -234,10 +234,6 @@ static int persistent_memory_claim(struc
 
 	wc->memory_vmapped = false;
 
-	if (!wc->ssd_dev->dax_dev) {
-		r = -EOPNOTSUPP;
-		goto err1;
-	}
 	s = wc->memory_map_size;
 	p = s >> PAGE_SHIFT;
 	if (!p) {
