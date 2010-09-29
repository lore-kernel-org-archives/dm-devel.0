From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] dm log userspace split flush queue
Date: Wed, 29 Sep 2010 09:06:49 -0500
Message-ID: <201009291406.o8TE6nV6005202@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

Patch name: dm-log-userspace-split-flush-queue.patch

This patch splits a list containing two different types of requests
into two lists containing distinct requests.

The device mapper log implementations (used by various DM targets) are
allowed to cache 'mark' and 'clear' requests until a 'flush' is
received.  Until now, these cached requests were kept in the same list.
They will now be put into distinct lists to facilitate group processing
of these requests (in the next patch).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -37,8 +37,15 @@ struct log_c {
 	 */
 	uint64_t in_sync_hint;
 
+	/*
+	 * Mark and clear requests are held until a flush is issued
+	 * so that we can group, and thereby limit, the amount of
+	 * network traffic between kernel and userspace.  The 'flush_lock'
+	 * is used to protect these lists.
+	 */
 	spinlock_t flush_lock;
-	struct list_head flush_list;  /* only for clear and mark requests */
+	struct list_head mark_list;
+	struct list_head clear_list;
 };
 
 static mempool_t *flush_entry_pool;
@@ -169,7 +176,8 @@ static int userspace_ctr(struct dm_dirty
 
 	strncpy(lc->uuid, argv[0], DM_UUID_LEN);
 	spin_lock_init(&lc->flush_lock);
-	INIT_LIST_HEAD(&lc->flush_list);
+	INIT_LIST_HEAD(&lc->mark_list);
+	INIT_LIST_HEAD(&lc->clear_list);
 
 	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
 	if (str_size < 0) {
@@ -363,14 +371,16 @@ static int userspace_flush(struct dm_dir
 	int r = 0;
 	unsigned long flags;
 	struct log_c *lc = log->context;
-	LIST_HEAD(flush_list);
+	LIST_HEAD(mark_list);
+	LIST_HEAD(clear_list);
 	struct flush_entry *fe, *tmp_fe;
 
 	spin_lock_irqsave(&lc->flush_lock, flags);
-	list_splice_init(&lc->flush_list, &flush_list);
+	list_splice_init(&lc->mark_list, &mark_list);
+	list_splice_init(&lc->clear_list, &clear_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
 
-	if (list_empty(&flush_list))
+	if (list_empty(&mark_list) && list_empty(&clear_list))
 		return 0;
 
 	/*
@@ -380,7 +390,16 @@ static int userspace_flush(struct dm_dir
 	 * do it one by one.
 	 */
 
-	list_for_each_entry(fe, &flush_list, list) {
+	list_for_each_entry(fe, &mark_list, list) {
+		r = userspace_do_request(lc, lc->uuid, fe->type,
+					 (char *)&fe->region,
+					 sizeof(fe->region),
+					 NULL, NULL);
+		if (r)
+			goto fail;
+	}
+
+	list_for_each_entry(fe, &clear_list, list) {
 		r = userspace_do_request(lc, lc->uuid, fe->type,
 					 (char *)&fe->region,
 					 sizeof(fe->region),
@@ -398,7 +417,11 @@ fail:
 	 * Calling code will receive an error and will know that
 	 * the log facility has failed.
 	 */
-	list_for_each_entry_safe(fe, tmp_fe, &flush_list, list) {
+	list_for_each_entry_safe(fe, tmp_fe, &mark_list, list) {
+		list_del(&fe->list);
+		mempool_free(fe, flush_entry_pool);
+	}
+	list_for_each_entry_safe(fe, tmp_fe, &clear_list, list) {
 		list_del(&fe->list);
 		mempool_free(fe, flush_entry_pool);
 	}
@@ -428,7 +451,7 @@ static void userspace_mark_region(struct
 	spin_lock_irqsave(&lc->flush_lock, flags);
 	fe->type = DM_ULOG_MARK_REGION;
 	fe->region = region;
-	list_add(&fe->list, &lc->flush_list);
+	list_add(&fe->list, &lc->mark_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
 
 	return;
@@ -465,7 +488,7 @@ static void userspace_clear_region(struc
 	spin_lock_irqsave(&lc->flush_lock, flags);
 	fe->type = DM_ULOG_CLEAR_REGION;
 	fe->region = region;
-	list_add(&fe->list, &lc->flush_list);
+	list_add(&fe->list, &lc->clear_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
 
 	return;
