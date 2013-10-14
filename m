From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] bdi: test bdi_init failure
Date: Mon, 14 Oct 2013 12:14:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1310141213370.24159@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1310141138500.24159@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1310141210280.24159@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1310141211410.24159@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1310141212280.24159@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310141212280.24159@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Kay Sievers <kay.sievers@vrfy.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Ken Chen <kenchen@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

There were two places where return value from bdi_init was not tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/char_dev.c               |    3 ++-
 include/linux/backing-dev.h |    4 ++--
 mm/swap.c                   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h	2013-10-11 19:54:12.000000000 +0200
+++ linux-2.6/include/linux/backing-dev.h	2013-10-11 22:39:14.000000000 +0200
@@ -109,7 +109,7 @@ struct backing_dev_info {
 #endif
 };
 
-int bdi_init(struct backing_dev_info *bdi);
+int __must_check bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
 __printf(3, 4)
@@ -117,7 +117,7 @@ int bdi_register(struct backing_dev_info
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
-int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
+int __must_check bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
 void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
 			enum wb_reason reason);
 void bdi_start_background_writeback(struct backing_dev_info *bdi);
Index: linux-2.6/fs/char_dev.c
===================================================================
--- linux-2.6.orig/fs/char_dev.c	2013-10-11 19:54:12.000000000 +0200
+++ linux-2.6/fs/char_dev.c	2013-10-11 22:39:14.000000000 +0200
@@ -574,7 +574,8 @@ static struct kobject *base_probe(dev_t
 void __init chrdev_init(void)
 {
 	cdev_map = kobj_map_init(base_probe, &chrdevs_lock);
-	bdi_init(&directly_mappable_cdev_bdi);
+	if (bdi_init(&directly_mappable_cdev_bdi))
+		panic("Failed to init directly mappable cdev bdi");
 }
 
 
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2013-10-11 19:54:12.000000000 +0200
+++ linux-2.6/mm/swap.c	2013-10-11 22:39:14.000000000 +0200
@@ -934,7 +934,8 @@ void __init swap_setup(void)
 #ifdef CONFIG_SWAP
 	int i;
 
-	bdi_init(swapper_spaces[0].backing_dev_info);
+	if (bdi_init(swapper_spaces[0].backing_dev_info))
+		panic("Failed to init swap bdi");
 	for (i = 0; i < MAX_SWAPFILES; i++) {
 		spin_lock_init(&swapper_spaces[i].tree_lock);
 		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
