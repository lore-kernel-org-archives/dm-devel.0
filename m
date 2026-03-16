Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8713F3CCFCE
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773679095; cv=none; b=Psl57HNi+7EXs+zecFjzjg/tYjn7jjaAKOLlX8msMR+rP3+iRDMtvk9mqUtq4yAhUosDE2lWapAMgcUaUmPsSYIS14lX+rxhZgcSEA7hee4psk0FT6TeMxVETvUQIJZxbDeQ9zbh4uPXgbqKS6dAjdE8cr2GjLdzJTJBbpm1y8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773679095; c=relaxed/simple;
	bh=8suiN9IxN1aGlRxUuXEio4eXiVzJqnKoon8iiWZyFpQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XEyO7/C2s3/RGB+qpIf6HMmmiSFDBQY6LvA+6Npc5HK5tms6fBRvlQu/RZ/qRiZ/2ZymPPOUANpozlrKOqmUVp9YUdKgO7rWKyMdpBgxgE8k5ylgTb45qbZn4bvLLyDd72HWV1pfON47uBqhl/1Q78KQVseLbPvT31AMoWMAyJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VyD82hoY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VyD82hoY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773679092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EISrko7CA+wC/churIYPaFJzOxAxunC/d01yx11FWyg=;
	b=VyD82hoYFvySuPpRo21c2HWe2yNXuabqmICtqsdcTngYLlGypq8UK8r64Y/UfPSm0XC0Ik
	Z0qQkZf2QGtX5WN+FCTY/MPawcmynabX0muM8VGbjFdRo005BwbnbsE7zyz3PWZezRgjig
	DloAhS4yBIAWGu6+IRw4oD8/iEVLZVg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-UZ3R1l6iPXujzxew26AfIg-1; Mon,
 16 Mar 2026 12:38:06 -0400
X-MC-Unique: UZ3R1l6iPXujzxew26AfIg-1
X-Mimecast-MFC-AGG-ID: UZ3R1l6iPXujzxew26AfIg_1773679085
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B08411956055;
	Mon, 16 Mar 2026 16:38:05 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0302630001A2;
	Mon, 16 Mar 2026 16:38:03 +0000 (UTC)
Date: Mon, 16 Mar 2026 17:37:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH v2] dm: make "dmsetup remove_all" interruptible
In-Reply-To: <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
Message-ID: <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com>
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com> <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5E7GiK0kaM1bvS_vRVQlmJvnxRg2zy31MWLDAOj7PHk_1773679085
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 16 Mar 2026, Bart Van Assche wrote:

> 
> On 3/16/26 8:55 AM, Mikulas Patocka wrote:
> >   {
> > -	dm_hash_remove_all(false, false, false);
> > +	dm_hash_remove_all(false, false, false, false);
> >   }
> 
> Three boolean arguments in a row make dm_hash_remove_all() calls much harder
> to read than necessary. Has it been considered to combine the
> three boolean arguments into a single flags argument?
> 
> Thanks,
> 
> Bart.

OK - I can change it to flags.


From: Mikulas Patocka <mpatocka@redhat.com>

The command "dmsetup remove_all" may take a long time (a minute for
removing 1000 devices), so make it interruptible with fatal signals.

For better readability, the bool arguments were changed to flags.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-03-16 14:37:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-03-16 17:31:24.000000000 +0100
@@ -64,7 +64,11 @@ struct vers_iter {
 static struct rb_root name_rb_tree = RB_ROOT;
 static struct rb_root uuid_rb_tree = RB_ROOT;
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred);
+#define KEEP_OPEN_DEVICES	1
+#define MARK_DEFERRED		2
+#define ONLY_DEFERRED		4
+#define INTERRUPTIBLE		8
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
+		if (flags & INTERRUPTIBLE && fatal_signal_pending(current)) {
+			up_write(&_hash_lock);
+			return -EINTR;
+		}
+
 		hc = container_of(n, struct hash_cell, name_node);
 		md = hc->md;
 		dm_get(md);
 
-		if (keep_open_devices &&
-		    dm_lock_for_deletion(md, mark_deferred, only_deferred)) {
+		if (flags & KEEP_OPEN_DEVICES &&
+		    dm_lock_for_deletion(md, !!(flags & MARK_DEFERRED), !!(flags & ONLY_DEFERRED))) {
 			dm_put(md);
 			dev_skipped++;
 			continue;
@@ -368,7 +377,7 @@ retry:
 		}
 		dm_ima_measure_on_device_remove(md, true);
 		dm_put(md);
-		if (likely(keep_open_devices))
+		if (likely(flags & KEEP_OPEN_DEVICES))
 			dm_destroy(md);
 		else
 			dm_destroy_immediate(md);
@@ -384,8 +393,10 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped && !only_deferred)
+	if (dev_skipped && !(flags & ONLY_DEFERRED))
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
+
+	return 0;
 }
 
 /*
@@ -513,7 +524,7 @@ static struct mapped_device *dm_hash_ren
 
 void dm_deferred_remove(void)
 {
-	dm_hash_remove_all(true, false, true);
+	dm_hash_remove_all(KEEP_OPEN_DEVICES | ONLY_DEFERRED);
 }
 
 /*
@@ -529,9 +540,9 @@ typedef int (*ioctl_fn)(struct file *fil
 
 static int remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false);
+	int r = dm_hash_remove_all(KEEP_OPEN_DEVICES | (param->flags & DM_DEFERRED_REMOVE ? MARK_DEFERRED : 0) | INTERRUPTIBLE);
 	param->data_size = 0;
-	return 0;
+	return r;
 }
 
 /*

