From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Revert "raid5: make release_stripe lockless" because it
 causes test regression
Date: Fri, 22 Nov 2013 15:07:08 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311221502360.28281@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Revert 773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6 and
d265d9dc1d25a69affc21ae9fe5004b9d09c10ef.

The lvm testsuite (from 
ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.104.tgz) fails with unkillable 
lvm and dmsetup processes on kernel 3.12. The testsuite passes on 3.11. 
Bisect shows that the failure is caused by patch 
773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6. When I revert this patch on 3.12 
kernel, the testsuite finishes and there are no unkillable processes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org	# 3.12

---
 drivers/md/raid5.c |   70 +++--------------------------------------------------
 drivers/md/raid5.h |    3 --
 2 files changed, 5 insertions(+), 68 deletions(-)

Index: linux-3.12-fast/drivers/md/raid5.c
===================================================================
--- linux-3.12-fast.orig/drivers/md/raid5.c	2013-11-21 22:45:20.000000000 +0100
+++ linux-3.12-fast/drivers/md/raid5.c	2013-11-21 23:39:01.000000000 +0100
@@ -293,62 +293,12 @@ static void __release_stripe(struct r5co
 		do_release_stripe(conf, sh);
 }
 
-static struct llist_node *llist_reverse_order(struct llist_node *head)
-{
-	struct llist_node *new_head = NULL;
-
-	while (head) {
-		struct llist_node *tmp = head;
-		head = head->next;
-		tmp->next = new_head;
-		new_head = tmp;
-	}
-
-	return new_head;
-}
-
-/* should hold conf->device_lock already */
-static int release_stripe_list(struct r5conf *conf)
-{
-	struct stripe_head *sh;
-	int count = 0;
-	struct llist_node *head;
-
-	head = llist_del_all(&conf->released_stripes);
-	head = llist_reverse_order(head);
-	while (head) {
-		sh = llist_entry(head, struct stripe_head, release_list);
-		head = llist_next(head);
-		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
-		smp_mb();
-		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
-		/*
-		 * Don't worry the bit is set here, because if the bit is set
-		 * again, the count is always > 1. This is true for
-		 * STRIPE_ON_UNPLUG_LIST bit too.
-		 */
-		__release_stripe(conf, sh);
-		count++;
-	}
-
-	return count;
-}
-
 static void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
-	bool wakeup;
 
-	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
-		goto slow_path;
-	wakeup = llist_add(&sh->release_list, &conf->released_stripes);
-	if (wakeup)
-		md_wakeup_thread(conf->mddev->thread);
-	return;
-slow_path:
 	local_irq_save(flags);
-	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
 	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
 		do_release_stripe(conf, sh);
 		spin_unlock(&conf->device_lock);
@@ -596,8 +546,7 @@ get_active_stripe(struct r5conf *conf, s
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
-				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
-				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
+				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
@@ -4293,10 +4242,6 @@ static void raid5_unplug(struct blk_plug
 			 */
 			smp_mb__before_clear_bit();
 			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
-			/*
-			 * STRIPE_ON_RELEASE_LIST could be set here. In that
-			 * case, the count is always > 1 here
-			 */
 			__release_stripe(conf, sh);
 			cnt++;
 		}
@@ -5007,13 +4952,11 @@ static void raid5_do_work(struct work_st
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
-		int batch_size, released;
-
-		released = release_stripe_list(conf);
+		int batch_size;
 
 		batch_size = handle_active_stripes(conf, group_id, worker);
 		worker->working = false;
-		if (!batch_size && !released)
+		if (!batch_size)
 			break;
 		handled += batch_size;
 	}
@@ -5048,9 +4991,7 @@ static void raid5d(struct md_thread *thr
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct bio *bio;
-		int batch_size, released;
-
-		released = release_stripe_list(conf);
+		int batch_size;
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
@@ -5075,7 +5016,7 @@ static void raid5d(struct md_thread *thr
 		}
 
 		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
-		if (!batch_size && !released)
+		if (!batch_size)
 			break;
 		handled += batch_size;
 
@@ -5503,7 +5444,6 @@ static struct r5conf *setup_conf(struct 
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
-	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
Index: linux-3.12-fast/drivers/md/raid5.h
===================================================================
--- linux-3.12-fast.orig/drivers/md/raid5.h	2013-11-21 23:29:32.000000000 +0100
+++ linux-3.12-fast/drivers/md/raid5.h	2013-11-21 23:29:35.000000000 +0100
@@ -197,7 +197,6 @@ enum reconstruct_states {
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
-	struct llist_node	release_list;
 	struct r5conf		*raid_conf;
 	short			generation;	/* increments with every
 						 * reshape */
@@ -324,7 +323,6 @@ enum {
 	STRIPE_OPS_REQ_PENDING,
 	STRIPE_ON_UNPLUG_LIST,
 	STRIPE_DISCARD,
-	STRIPE_ON_RELEASE_LIST,
 };
 
 /*
@@ -463,7 +461,6 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
-	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
