From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: handle partitions on persistent
 memory correctly
Date: Mon, 24 Aug 2020 11:09:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2008241106190.26379@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch fixes handling partitions in the dm-writecache target. The
function dax_direct_access doesn't take partitions into account, it always
maps pages from the beginning of the device. Therefore, we must get the
partition offset using the function get_start_sect and add it to the page
offsets passed to dax_direct_access.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 4.18+
Fixes: 48debafe4f2f ("dm: add writecache target")

---
 drivers/md/dm-writecache.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-08-19 15:04:21.499999000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2020-08-24 17:07:54.169999000 +0200
@@ -231,6 +231,7 @@ static int persistent_memory_claim(struc
 	pfn_t pfn;
 	int id;
 	struct page **pages;
+	sector_t offset;
 
 	wc->memory_vmapped = false;
 
@@ -245,9 +246,16 @@ static int persistent_memory_claim(struc
 		goto err1;
 	}
 
+	offset = get_start_sect(wc->ssd_dev->bdev);
+	if (offset & (PAGE_SIZE / 512 - 1)) {
+		r = -EINVAL;
+		goto err1;
+	}
+	offset >>= PAGE_SHIFT - 9;
+
 	id = dax_read_lock();
 
-	da = dax_direct_access(wc->ssd_dev->dax_dev, 0, p, &wc->memory_map, &pfn);
+	da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
 	if (da < 0) {
 		wc->memory_map = NULL;
 		r = da;
@@ -269,7 +277,7 @@ static int persistent_memory_claim(struc
 		i = 0;
 		do {
 			long daa;
-			daa = dax_direct_access(wc->ssd_dev->dax_dev, i, p - i,
+			daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
 						NULL, &pfn);
 			if (daa <= 0) {
 				r = daa ? daa : -EINVAL;
