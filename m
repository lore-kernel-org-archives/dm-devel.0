Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DEA28980A
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764623601; cv=none; b=M35hI34mEu2Y45/9bTTtmvDHfJl6FyaNkRsbrzRrcpf51wzT0QeZlAaUNLut0Nsptbmq1LdRQtye1HyXBlgbNLjoz6cEhVtSL3AgT6Y6NtnUbzagP8ToQ5kD7ioqqbzOduzFTBNvBbrv3nE4Sy6ngFkFMaEOQucVRpXk0Ck8LAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764623601; c=relaxed/simple;
	bh=Xsm/e7Li11E1CA+OKutzNCyhFTlOgFDBT2xZLfEYipc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Z6tbhG1YedvCdBTnJBKsGFbDawfEvxa7c8NaqdEo3+7y49dpiPrNRQ+TBQOvH/oDgWVclwZCH0gv6MWTALERSrVHQ0Jr6SsK2vO6y/4g+pWPCWlTy9VXt2gvYepTwLHSuP8Vepx3WKDQJnrE3xFNgiPhq8C0UwnhO3Q09PsoCKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GmNBCEFZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmNBCEFZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764623598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=j9k4rR1Wm2027dup6BzzA8juFHizRTNARQkbVdksdl0=;
	b=GmNBCEFZsx5mMMyab9tMYF8YwaK/LyIiQ88IqlxhtE91eZjnGPD1WfCVi+qk1r4LR/U/3n
	JkuOtbMBR6qcp69286vPyZFwiLvcaD1dWQcxpzZGaMJuXfy62+tMtOHQCMiGCLvRdiizMC
	70MFeTiPjrPcYz4zEKVJjk4Lilhpvgg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-m34OkS8vPe-m3iQIl0lcTw-1; Mon,
 01 Dec 2025 16:13:16 -0500
X-MC-Unique: m34OkS8vPe-m3iQIl0lcTw-1
X-Mimecast-MFC-AGG-ID: m34OkS8vPe-m3iQIl0lcTw_1764623595
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A12918011EF;
	Mon,  1 Dec 2025 21:13:15 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 222F430001A4;
	Mon,  1 Dec 2025 21:13:12 +0000 (UTC)
Date: Mon, 1 Dec 2025 22:13:10 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Jiping Ma <jiping.ma2@windriver.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-snapshot: fix 'scheduling while atomic' on real-time
 kernels
Message-ID: <747444e7-6884-cc1b-a761-c1e3bb7b888f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ihqchqxeg4QTzbdSzEbl_PbfItdsPxyOj5dVm8jR-jQ_1764623595
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There is reported 'scheduling while atomic' bug when using dm-snapshot on
real-time kernels. The reason for the bug is that the hlist_bl code does
preempt_disable() when taking the lock and the kernel attempts to take
other spinlocks while holding the hlist_bl lock.

Fix this by converting a hlist_bl spinlock into a regular spinlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.h |    2 -
 drivers/md/dm-snap.c            |   73 ++++++++++++++++++----------------------
 2 files changed, 35 insertions(+), 40 deletions(-)

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-exception-store.h	2025-12-01 16:46:21.000000000 +0100
@@ -29,7 +29,7 @@ typedef sector_t chunk_t;
  * chunk within the device.
  */
 struct dm_exception {
-	struct hlist_bl_node hash_list;
+	struct hlist_node hash_list;
 
 	chunk_t old_chunk;
 	chunk_t new_chunk;
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2025-11-30 21:47:53.000000000 +0100
+++ linux-2.6/drivers/md/dm-snap.c	2025-12-01 21:48:42.000000000 +0100
@@ -40,10 +40,15 @@ static const char dm_snapshot_merge_targ
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
+struct dm_hlist_head {
+	struct hlist_head head;
+	spinlock_t lock;
+};
+
 struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned int hash_shift;
-	struct hlist_bl_head *table;
+	struct dm_hlist_head *table;
 };
 
 struct dm_snapshot {
@@ -628,8 +633,8 @@ static uint32_t exception_hash(struct dm
 
 /* Lock to protect access to the completed and pending exception hash tables. */
 struct dm_exception_table_lock {
-	struct hlist_bl_head *complete_slot;
-	struct hlist_bl_head *pending_slot;
+	spinlock_t *complete_slot;
+	spinlock_t *pending_slot;
 };
 
 static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
@@ -638,20 +643,20 @@ static void dm_exception_table_lock_init
 	struct dm_exception_table *complete = &s->complete;
 	struct dm_exception_table *pending = &s->pending;
 
-	lock->complete_slot = &complete->table[exception_hash(complete, chunk)];
-	lock->pending_slot = &pending->table[exception_hash(pending, chunk)];
+	lock->complete_slot = &complete->table[exception_hash(complete, chunk)].lock;
+	lock->pending_slot = &pending->table[exception_hash(pending, chunk)].lock;
 }
 
 static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
 {
-	hlist_bl_lock(lock->complete_slot);
-	hlist_bl_lock(lock->pending_slot);
+	spin_lock_nested(lock->complete_slot, 1);
+	spin_lock_nested(lock->pending_slot, 2);
 }
 
 static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
 {
-	hlist_bl_unlock(lock->pending_slot);
-	hlist_bl_unlock(lock->complete_slot);
+	spin_unlock(lock->pending_slot);
+	spin_unlock(lock->complete_slot);
 }
 
 static int dm_exception_table_init(struct dm_exception_table *et,
@@ -661,13 +666,15 @@ static int dm_exception_table_init(struc
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
-	et->table = kvmalloc_array(size, sizeof(struct hlist_bl_head),
+	et->table = kvmalloc_array(size, sizeof(struct dm_hlist_head),
 				   GFP_KERNEL);
 	if (!et->table)
 		return -ENOMEM;
 
-	for (i = 0; i < size; i++)
-		INIT_HLIST_BL_HEAD(et->table + i);
+	for (i = 0; i < size; i++) {
+		INIT_HLIST_HEAD(&et->table[i].head);
+		spin_lock_init(&et->table[i].lock);
+	}
 
 	return 0;
 }
@@ -675,16 +682,17 @@ static int dm_exception_table_init(struc
 static void dm_exception_table_exit(struct dm_exception_table *et,
 				    struct kmem_cache *mem)
 {
-	struct hlist_bl_head *slot;
+	struct dm_hlist_head *slot;
 	struct dm_exception *ex;
-	struct hlist_bl_node *pos, *n;
+	struct hlist_node *pos;
 	int i, size;
 
 	size = et->hash_mask + 1;
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
+		hlist_for_each_entry_safe(ex, pos, &slot->head, hash_list) {
+			hlist_del(&ex->hash_list);
 			kmem_cache_free(mem, ex);
 			cond_resched();
 		}
@@ -700,7 +708,7 @@ static uint32_t exception_hash(struct dm
 
 static void dm_remove_exception(struct dm_exception *e)
 {
-	hlist_bl_del(&e->hash_list);
+	hlist_del(&e->hash_list);
 }
 
 /*
@@ -710,12 +718,11 @@ static void dm_remove_exception(struct d
 static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 						chunk_t chunk)
 {
-	struct hlist_bl_head *slot;
-	struct hlist_bl_node *pos;
+	struct hlist_head *slot;
 	struct dm_exception *e;
 
-	slot = &et->table[exception_hash(et, chunk)];
-	hlist_bl_for_each_entry(e, pos, slot, hash_list)
+	slot = &et->table[exception_hash(et, chunk)].head;
+	hlist_for_each_entry(e, slot, hash_list)
 		if (chunk >= e->old_chunk &&
 		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
 			return e;
@@ -762,18 +769,17 @@ static void free_pending_exception(struc
 static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
-	struct hlist_bl_head *l;
-	struct hlist_bl_node *pos;
+	struct hlist_head *l;
 	struct dm_exception *e = NULL;
 
-	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
+	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
 
 	/* Add immediately if this table doesn't support consecutive chunks */
 	if (!eh->hash_shift)
 		goto out;
 
 	/* List is ordered by old_chunk */
-	hlist_bl_for_each_entry(e, pos, l, hash_list) {
+	hlist_for_each_entry(e, l, hash_list) {
 		/* Insert after an existing chunk? */
 		if (new_e->old_chunk == (e->old_chunk +
 					 dm_consecutive_chunk_count(e) + 1) &&
@@ -804,13 +810,13 @@ out:
 		 * Either the table doesn't support consecutive chunks or slot
 		 * l is empty.
 		 */
-		hlist_bl_add_head(&new_e->hash_list, l);
+		hlist_add_head(&new_e->hash_list, l);
 	} else if (new_e->old_chunk < e->old_chunk) {
 		/* Add before an existing exception */
-		hlist_bl_add_before(&new_e->hash_list, &e->hash_list);
+		hlist_add_before(&new_e->hash_list, &e->hash_list);
 	} else {
 		/* Add to l's tail: e is the last exception in this slot */
-		hlist_bl_add_behind(&new_e->hash_list, &e->hash_list);
+		hlist_add_behind(&new_e->hash_list, &e->hash_list);
 	}
 }
 
@@ -820,7 +826,6 @@ out:
  */
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
-	struct dm_exception_table_lock lock;
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
@@ -833,17 +838,7 @@ static int dm_add_exception(void *contex
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	/*
-	 * Although there is no need to lock access to the exception tables
-	 * here, if we don't then hlist_bl_add_head(), called by
-	 * dm_insert_exception(), will complain about accessing the
-	 * corresponding list without locking it first.
-	 */
-	dm_exception_table_lock_init(s, old, &lock);
-
-	dm_exception_table_lock(&lock);
 	dm_insert_exception(&s->complete, e);
-	dm_exception_table_unlock(&lock);
 
 	return 0;
 }
@@ -873,7 +868,7 @@ static int calc_max_buckets(void)
 	/* use a fixed size of 2MB */
 	unsigned long mem = 2 * 1024 * 1024;
 
-	mem /= sizeof(struct hlist_bl_head);
+	mem /= sizeof(struct dm_hlist_head);
 
 	return mem;
 }

