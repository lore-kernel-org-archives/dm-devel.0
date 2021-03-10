Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B55C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 10:18:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B00B64FDF
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 10:18:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B00B64FDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615371498;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3rcflq67WEqvqYqKzp3SwxVvKmua1Ax+lUb9/8F85Ic=;
	b=S506+XETQUxiTJmFyF3jBclGow2YzfTaaoQsvNKqBlg/jTV+c0nPTkdvugrXVX7Iv6rJV4
	wa2GynmzkHGUuf8k2/k/PiPvPnof3uYPfND6DFN08I+hUSmk4AxsvvVnUgcp4mkf151L65
	O7Ws7S77vd0tzx3pQuq5l9sj9hHEL9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-RuHeZq4DPSKBQm_9XzprqQ-1; Wed, 10 Mar 2021 05:18:16 -0500
X-MC-Unique: RuHeZq4DPSKBQm_9XzprqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3176B801817;
	Wed, 10 Mar 2021 10:18:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF3D1002391;
	Wed, 10 Mar 2021 10:18:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CEA81809C86;
	Wed, 10 Mar 2021 10:18:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12AAI8ON003764 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 05:18:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3B86C5452A; Wed, 10 Mar 2021 10:18:08 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5874F62A1B;
	Wed, 10 Mar 2021 10:18:04 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 12AAI3L6006966; Wed, 10 Mar 2021 05:18:03 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 12AAI3m3006962; Wed, 10 Mar 2021 05:18:03 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 10 Mar 2021 05:18:03 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <alpine.LRH.2.02.2103100516330.6862@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-ioctl: replace hash with red-black tree
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Zdenek reported that for high number of dm devices, the 64-entry hash
table has non-trivial overhead. This patch replaces the hash table with a
red-black tree.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |  256 +++++++++++++++++++++++++++-----------------------
 1 file changed, 143 insertions(+), 113 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2021-02-05 20:21:22.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2021-03-09 21:04:07.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/rbtree.h>
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
@@ -36,8 +37,10 @@ struct dm_file {
  * name or uuid.
  *---------------------------------------------------------------*/
 struct hash_cell {
-	struct list_head name_list;
-	struct list_head uuid_list;
+	struct rb_node name_node;
+	struct rb_node uuid_node;
+	bool name_set;
+	bool uuid_set;
 
 	char *name;
 	char *uuid;
@@ -53,10 +56,8 @@ struct vers_iter {
 };
 
 
-#define NUM_BUCKETS 64
-#define MASK_BUCKETS (NUM_BUCKETS - 1)
-static struct list_head _name_buckets[NUM_BUCKETS];
-static struct list_head _uuid_buckets[NUM_BUCKETS];
+static struct rb_root name_rb_tree = RB_ROOT;
+static struct rb_root uuid_rb_tree = RB_ROOT;
 
 static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred);
 
@@ -70,73 +71,110 @@ static DECLARE_RWSEM(_hash_lock);
  */
 static DEFINE_MUTEX(dm_hash_cells_mutex);
 
-static void init_buckets(struct list_head *buckets)
-{
-	unsigned int i;
-
-	for (i = 0; i < NUM_BUCKETS; i++)
-		INIT_LIST_HEAD(buckets + i);
-}
-
-static int dm_hash_init(void)
-{
-	init_buckets(_name_buckets);
-	init_buckets(_uuid_buckets);
-	return 0;
-}
-
 static void dm_hash_exit(void)
 {
 	dm_hash_remove_all(false, false, false);
 }
 
 /*-----------------------------------------------------------------
- * Hash function:
- * We're not really concerned with the str hash function being
- * fast since it's only used by the ioctl interface.
- *---------------------------------------------------------------*/
-static unsigned int hash_str(const char *str)
-{
-	const unsigned int hash_mult = 2654435387U;
-	unsigned int h = 0;
-
-	while (*str)
-		h = (h + (unsigned int) *str++) * hash_mult;
-
-	return h & MASK_BUCKETS;
-}
-
-/*-----------------------------------------------------------------
  * Code for looking up a device by name
  *---------------------------------------------------------------*/
 static struct hash_cell *__get_name_cell(const char *str)
 {
-	struct hash_cell *hc;
-	unsigned int h = hash_str(str);
+	struct rb_node *n = name_rb_tree.rb_node;
 
-	list_for_each_entry (hc, _name_buckets + h, name_list)
-		if (!strcmp(hc->name, str)) {
+	while (n) {
+		struct hash_cell *hc = container_of(n, struct hash_cell, name_node);
+		int c = strcmp(hc->name, str);
+		if (!c) {
 			dm_get(hc->md);
 			return hc;
 		}
+		n = c >= 0 ? n->rb_left : n->rb_right;
+	}
 
 	return NULL;
 }
 
 static struct hash_cell *__get_uuid_cell(const char *str)
 {
-	struct hash_cell *hc;
-	unsigned int h = hash_str(str);
+	struct rb_node *n = uuid_rb_tree.rb_node;
 
-	list_for_each_entry (hc, _uuid_buckets + h, uuid_list)
-		if (!strcmp(hc->uuid, str)) {
+	while (n) {
+		struct hash_cell *hc = container_of(n, struct hash_cell, uuid_node);
+		int c = strcmp(hc->uuid, str);
+		if (!c) {
 			dm_get(hc->md);
 			return hc;
 		}
+		n = c >= 0 ? n->rb_left : n->rb_right;
+	}
 
 	return NULL;
 }
 
+static void __unlink_name(struct hash_cell *hc)
+{
+	if (hc->name_set) {
+		hc->name_set = false;
+		rb_erase(&hc->name_node, &name_rb_tree);
+	}
+}
+
+static void __unlink_uuid(struct hash_cell *hc)
+{
+	if (hc->uuid_set) {
+		hc->uuid_set = false;
+		rb_erase(&hc->uuid_node, &uuid_rb_tree);
+	}
+}
+
+static void __link_name(struct hash_cell *new_hc)
+{
+	struct rb_node **n, *parent;
+
+	__unlink_name(new_hc);
+
+	new_hc->name_set = true;
+
+	n = &name_rb_tree.rb_node;
+	parent = NULL;
+
+	while (*n) {
+		struct hash_cell *hc = container_of(*n, struct hash_cell, name_node);
+		int c = strcmp(hc->name, new_hc->name);
+		BUG_ON(!c);
+		parent = *n;
+		n = c >= 0 ? &hc->name_node.rb_left : &hc->name_node.rb_right;
+	}
+
+	rb_link_node(&new_hc->name_node, parent, n);
+	rb_insert_color(&new_hc->name_node, &name_rb_tree);
+}
+
+static void __link_uuid(struct hash_cell *new_hc)
+{
+	struct rb_node **n, *parent;
+
+	__unlink_uuid(new_hc);
+
+	new_hc->uuid_set = true;
+
+	n = &uuid_rb_tree.rb_node;
+	parent = NULL;
+
+	while (*n) {
+		struct hash_cell *hc = container_of(*n, struct hash_cell, uuid_node);
+		int c = strcmp(hc->uuid, new_hc->uuid);
+		BUG_ON(!c);
+		parent = *n;
+		n = c > 0 ? &hc->uuid_node.rb_left : &hc->uuid_node.rb_right;
+	}
+
+	rb_link_node(&new_hc->uuid_node, parent, n);
+	rb_insert_color(&new_hc->uuid_node, &uuid_rb_tree);
+}
+
 static struct hash_cell *__get_dev_cell(uint64_t dev)
 {
 	struct mapped_device *md;
@@ -185,8 +223,7 @@ static struct hash_cell *alloc_cell(cons
 		}
 	}
 
-	INIT_LIST_HEAD(&hc->name_list);
-	INIT_LIST_HEAD(&hc->uuid_list);
+	hc->name_set = hc->uuid_set = false;
 	hc->md = md;
 	hc->new_map = NULL;
 	return hc;
@@ -226,16 +263,16 @@ static int dm_hash_insert(const char *na
 		goto bad;
 	}
 
-	list_add(&cell->name_list, _name_buckets + hash_str(name));
+	__link_name(cell);
 
 	if (uuid) {
 		hc = __get_uuid_cell(uuid);
 		if (hc) {
-			list_del(&cell->name_list);
+			__unlink_name(cell);
 			dm_put(hc->md);
 			goto bad;
 		}
-		list_add(&cell->uuid_list, _uuid_buckets + hash_str(uuid));
+		__link_uuid(cell);
 	}
 	dm_get(md);
 	mutex_lock(&dm_hash_cells_mutex);
@@ -256,9 +293,9 @@ static struct dm_table *__hash_remove(st
 	struct dm_table *table;
 	int srcu_idx;
 
-	/* remove from the dev hash */
-	list_del(&hc->uuid_list);
-	list_del(&hc->name_list);
+	/* remove from the dev trees */
+	__unlink_name(hc);
+	__unlink_uuid(hc);
 	mutex_lock(&dm_hash_cells_mutex);
 	dm_set_mdptr(hc->md, NULL);
 	mutex_unlock(&dm_hash_cells_mutex);
@@ -279,7 +316,8 @@ static struct dm_table *__hash_remove(st
 
 static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred)
 {
-	int i, dev_skipped;
+	int dev_skipped;
+	struct rb_node *n;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *t;
@@ -289,40 +327,39 @@ retry:
 
 	down_write(&_hash_lock);
 
-	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_entry(hc, _name_buckets + i, name_list) {
-			md = hc->md;
-			dm_get(md);
-
-			if (keep_open_devices &&
-			    dm_lock_for_deletion(md, mark_deferred, only_deferred)) {
-				dm_put(md);
-				dev_skipped++;
-				continue;
-			}
+	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		hc = container_of(n, struct hash_cell, name_node);
+		md = hc->md;
+		dm_get(md);
+
+		if (keep_open_devices &&
+		    dm_lock_for_deletion(md, mark_deferred, only_deferred)) {
+			dm_put(md);
+			dev_skipped++;
+			continue;
+		}
 
-			t = __hash_remove(hc);
+		t = __hash_remove(hc);
 
-			up_write(&_hash_lock);
+		up_write(&_hash_lock);
 
-			if (t) {
-				dm_sync_table(md);
-				dm_table_destroy(t);
-			}
-			dm_put(md);
-			if (likely(keep_open_devices))
-				dm_destroy(md);
-			else
-				dm_destroy_immediate(md);
-
-			/*
-			 * Some mapped devices may be using other mapped
-			 * devices, so repeat until we make no further
-			 * progress.  If a new mapped device is created
-			 * here it will also get removed.
-			 */
-			goto retry;
+		if (t) {
+			dm_sync_table(md);
+			dm_table_destroy(t);
 		}
+		dm_put(md);
+		if (likely(keep_open_devices))
+			dm_destroy(md);
+		else
+			dm_destroy_immediate(md);
+
+		/*
+		 * Some mapped devices may be using other mapped
+		 * devices, so repeat until we make no further
+		 * progress.  If a new mapped device is created
+		 * here it will also get removed.
+		 */
+		goto retry;
 	}
 
 	up_write(&_hash_lock);
@@ -340,7 +377,7 @@ static void __set_cell_uuid(struct hash_
 	hc->uuid = new_uuid;
 	mutex_unlock(&dm_hash_cells_mutex);
 
-	list_add(&hc->uuid_list, _uuid_buckets + hash_str(new_uuid));
+	__link_uuid(hc);
 }
 
 /*
@@ -354,14 +391,14 @@ static char *__change_cell_name(struct h
 	/*
 	 * Rename and move the name cell.
 	 */
-	list_del(&hc->name_list);
+	__unlink_name(hc);
 	old_name = hc->name;
 
 	mutex_lock(&dm_hash_cells_mutex);
 	hc->name = new_name;
 	mutex_unlock(&dm_hash_cells_mutex);
 
-	list_add(&hc->name_list, _name_buckets + hash_str(new_name));
+	__link_name(hc);
 
 	return old_name;
 }
@@ -505,7 +542,7 @@ static void *get_result_buffer(struct dm
 
 static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	unsigned int i;
+	struct rb_node *n;
 	struct hash_cell *hc;
 	size_t len, needed = 0;
 	struct gendisk *disk;
@@ -518,11 +555,10 @@ static int list_devices(struct file *fil
 	 * Loop through all the devices working out how much
 	 * space we need.
 	 */
-	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_entry (hc, _name_buckets + i, name_list) {
-			needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
-			needed += align_val(sizeof(uint32_t));
-		}
+	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		hc = container_of(n, struct hash_cell, name_node);
+		needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
+		needed += align_val(sizeof(uint32_t));
 	}
 
 	/*
@@ -540,21 +576,20 @@ static int list_devices(struct file *fil
 	/*
 	 * Now loop through filling out the names.
 	 */
-	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_entry (hc, _name_buckets + i, name_list) {
-			if (old_nl)
-				old_nl->next = (uint32_t) ((void *) nl -
-							   (void *) old_nl);
-			disk = dm_disk(hc->md);
-			nl->dev = huge_encode_dev(disk_devt(disk));
-			nl->next = 0;
-			strcpy(nl->name, hc->name);
-
-			old_nl = nl;
-			event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
-			*event_nr = dm_get_event_nr(hc->md);
-			nl = align_ptr(event_nr + 1);
-		}
+	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		hc = container_of(n, struct hash_cell, name_node);
+		if (old_nl)
+			old_nl->next = (uint32_t) ((void *) nl -
+						   (void *) old_nl);
+		disk = dm_disk(hc->md);
+		nl->dev = huge_encode_dev(disk_devt(disk));
+		nl->next = 0;
+		strcpy(nl->name, hc->name);
+
+		old_nl = nl;
+		event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
+		*event_nr = dm_get_event_nr(hc->md);
+		nl = align_ptr(event_nr + 1);
 	}
 	/*
 	 * If mismatch happens, security may be compromised due to buffer
@@ -1991,14 +2026,9 @@ int __init dm_interface_init(void)
 {
 	int r;
 
-	r = dm_hash_init();
-	if (r)
-		return r;
-
 	r = misc_register(&_dm_misc);
 	if (r) {
 		DMERR("misc_register failed for control device");
-		dm_hash_exit();
 		return r;
 	}
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

