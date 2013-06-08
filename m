From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: use __GFP_HIGHMEM in __vmalloc
Date: Sat, 8 Jun 2013 19:23:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1306081923150.19670@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm: use __GFP_HIGHMEM in __vmalloc

Pages allocated with __vmalloc can be allocated in high memory that is not
directly mapped to kernel space, so use __GFP_HIGHMEM just like vmalloc
does. This patch reduces memory pressure slightly because pages can be
allocated in the high zone.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    2 
 drivers/md/dm-ioctl.c |  189 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 188 insertions(+), 3 deletions(-)

Index: linux-3.9.5-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.9.5-fast.orig/drivers/md/dm-bufio.c	2013-06-09 01:16:45.000000000 +0200
+++ linux-3.9.5-fast/drivers/md/dm-bufio.c	2013-06-09 01:20:24.000000000 +0200
@@ -350,7 +350,7 @@ static void *alloc_buffer_data(struct dm
 	if (gfp_mask & __GFP_NORETRY)
 		noio_flag = memalloc_noio_save();
 
-	ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+	ptr = __vmalloc(c->block_size, gfp_mask | __GFP_HIGHMEM, PAGE_KERNEL);
 
 	if (gfp_mask & __GFP_NORETRY)
 		memalloc_noio_restore(noio_flag);
Index: linux-3.9.5-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.9.5-fast.orig/drivers/md/dm-ioctl.c	2013-06-09 01:20:14.000000000 +0200
+++ linux-3.9.5-fast/drivers/md/dm-ioctl.c	2013-06-09 01:20:32.000000000 +0200
@@ -1688,7 +1873,7 @@ static int copy_params(struct dm_ioctl _
 	if (!dmi) {
 		unsigned noio_flag;
 		noio_flag = memalloc_noio_save();
-		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH, PAGE_KERNEL);
+		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		memalloc_noio_restore(noio_flag);
 		if (dmi)
 			*param_flags |= DM_PARAMS_VMALLOC;
