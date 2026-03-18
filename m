Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A151DDC2B
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 14:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773844328; cv=none; b=salDY9h6LVBjN9ignQnpydsI8+rI0VSRg2fG375deg3/QHkxWYV0w/Rlxw6s3/D4nDU1oqDXAVNWOm5v8Fq16SllhRZGT2zJ37dy3V0lGM03zjhsAzjLqffoxQC2XJ5tcO47/fMamognv5pYzbKuHmvPda9E5pH9UJjngsoaDtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773844328; c=relaxed/simple;
	bh=OD9w0w+6zc43bpT4jR0Oi97dlqgLlrjGLTXxpAhABw8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=G04LcqEFeDhALRwpcHNQhhbaQIbL3arYU4TQtXWNLJ7CjGrzJwbqocDrv1TMI4UAf/bTMfkS+d17q4aGrzM6BIKcY46d/+vZeF47onI+TmteQsU3hwt6Opa/wv93QnOMCuLMOwXjP54jCQTzpt68Qsvf8F13721a8w/0t9CMmJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fggBikNg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fggBikNg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773844326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKNEjCVEYDmnv+kphMmBD2+OAF3RA+GQC8vdfgYJmg0=;
	b=fggBikNguP9ueC5EK49K5GzEpWbbdeu5Y6WfuRgj405TBfnpmRGjTwDvN4gTePzxhMNhp0
	ljwrGqKt7Epa5uYZyRYsNJYjwT5QRZjqwJL4maVMBTDuC55Dnbr/N6hE4QnMbYL4qVt2Dy
	E1b9QPB6KIQP7rZQ52zq0n6yNnKTl/o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-SyeAa_s_MpSzkRWoWt92GQ-1; Wed,
 18 Mar 2026 10:32:02 -0400
X-MC-Unique: SyeAa_s_MpSzkRWoWt92GQ-1
X-Mimecast-MFC-AGG-ID: SyeAa_s_MpSzkRWoWt92GQ_1773844321
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 799931956089;
	Wed, 18 Mar 2026 14:32:01 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAA881800351;
	Wed, 18 Mar 2026 14:31:59 +0000 (UTC)
Date: Wed, 18 Mar 2026 15:31:55 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH v3] dm: make "dmsetup remove_all" interruptible
In-Reply-To: <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>
Message-ID: <54739cf3-acf1-f309-9d12-b7f59c0ca127@redhat.com>
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com> <79941ba6-cac8-4283-82b6-807c20729e76@acm.org> <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com> <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ww-ZyMiMRZQ66626JBSgTAxwske549XyF9bWYVBtJ1s_1773844321
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The command "dmsetup remove_all" may take a long time (a minute for
removing 1000 devices), so make it interruptible with fatal signals.

For better readability, the bool arguments were changed to flags.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-03-17 22:17:23.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-03-18 15:26:35.000000000 +0100
@@ -64,7 +64,11 @@ struct vers_iter {
 static struct rb_root name_rb_tree = RB_ROOT;
 static struct rb_root uuid_rb_tree = RB_ROOT;
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred);
+#define DM_REMOVE_KEEP_OPEN_DEVICES	1
+#define DM_REMOVE_MARK_DEFERRED		2
+#define DM_REMOVE_ONLY_DEFERRED		4
+#define DM_REMOVE_INTERRUPTIBLE		8
+static int dm_hash_remove_all(unsigned flags);
 
 /*
  * Guards access to both hash tables.
@@ -78,7 +82,7 @@ static DEFINE_MUTEX(dm_hash_cells_mutex)
 
 static void dm_hash_exit(void)
 {
-	dm_hash_remove_all(false, false, false);
+	dm_hash_remove_all(0);
 }
 
 /*
@@ -333,7 +337,7 @@ static struct dm_table *__hash_remove(st
 	return table;
 }
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred)
+static int dm_hash_remove_all(unsigned flags)
 {
 	int dev_skipped;
 	struct rb_node *n;
@@ -347,12 +351,17 @@ retry:
 	down_write(&_hash_lock);
 
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		if (flags & DM_REMOVE_INTERRUPTIBLE && fatal_signal_pending(current)) {
+			up_write(&_hash_lock);
+			return -EINTR;
+		}
+
 		hc = container_of(n, struct hash_cell, name_node);
 		md = hc->md;
 		dm_get(md);
 
-		if (keep_open_devices &&
-		    dm_lock_for_deletion(md, mark_deferred, only_deferred)) {
+		if (flags & DM_REMOVE_KEEP_OPEN_DEVICES &&
+		    dm_lock_for_deletion(md, !!(flags & DM_REMOVE_MARK_DEFERRED), !!(flags & DM_REMOVE_ONLY_DEFERRED))) {
 			dm_put(md);
 			dev_skipped++;
 			continue;
@@ -368,7 +377,7 @@ retry:
 		}
 		dm_ima_measure_on_device_remove(md, true);
 		dm_put(md);
-		if (likely(keep_open_devices))
+		if (likely(flags & DM_REMOVE_KEEP_OPEN_DEVICES))
 			dm_destroy(md);
 		else
 			dm_destroy_immediate(md);
@@ -384,8 +393,10 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped && !only_deferred)
+	if (dev_skipped && !(flags & DM_REMOVE_ONLY_DEFERRED))
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
+
+	return 0;
 }
 
 /*
@@ -513,7 +524,7 @@ static struct mapped_device *dm_hash_ren
 
 void dm_deferred_remove(void)
 {
-	dm_hash_remove_all(true, false, true);
+	dm_hash_remove_all(DM_REMOVE_KEEP_OPEN_DEVICES | DM_REMOVE_ONLY_DEFERRED);
 }
 
 /*
@@ -529,9 +540,13 @@ typedef int (*ioctl_fn)(struct file *fil
 
 static int remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false);
+	int r;
+	int flags = DM_REMOVE_KEEP_OPEN_DEVICES | DM_REMOVE_INTERRUPTIBLE;
+	if (param->flags & DM_DEFERRED_REMOVE)
+		flags |= DM_REMOVE_MARK_DEFERRED;
+	r = dm_hash_remove_all(flags);
 	param->data_size = 0;
-	return 0;
+	return r;
 }
 
 /*

