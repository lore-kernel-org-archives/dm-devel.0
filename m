Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E474C3AE714
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676567; cv=none; b=DeFDUiPe63PAbnjfIwzad1JMSjxnESWFIBBJpEL8WwtYQMiB4qZgXuYPy9zIMtF4KvKjmFP9As4IZZmwfv1g3CxuYKm36FeGIZXD3u8EAtWoov7hdQLcuJD15kR2R2nvJ8PitpdrmY+lLXawW9OZxUoLUF5GNcuvjMyh3leELbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676567; c=relaxed/simple;
	bh=9exCGDvHGV9V7agI3mKSMcgO4LsJx5BcjER6igQ56vg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=NXw5gRstoCfKWo4770e20Y0ZrDhVe4ZtjozxFPAuX03AFdpqCv0/GEI0zNEguB/C6UN5zuEyyGwRaproAVYwWIaGpTSEaTFCbrRwoXqw+bvqz+L3k4jipxBQdJcm2Mipn9BVHpNzOFzl1QxV+3V0Tle3qGNEI5ZCXe/NCYi3wS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jWmvTCQR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWmvTCQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773676564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=oSW66eg+cF73seRx87+v6HtQuWVKNacH11R8GErmkz0=;
	b=jWmvTCQREzRFFolUTwHxjBtO3H3C9hO0DIjm/E5NzX4ykoo86IF6hnwLMZgH5zHVv3V9sk
	QIzL5ISgbpEXpnFbpGSXxeLZ+zpuYl84ZOmyA+pXvbBbv5JrrVPqvmqxCw+bl+FhopbyTV
	djUV8O6yxpGp762iFIYjOx3OQdKTgzg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-ErqXcR9hPrGCPA84z9iYug-1; Mon,
 16 Mar 2026 11:56:03 -0400
X-MC-Unique: ErqXcR9hPrGCPA84z9iYug-1
X-Mimecast-MFC-AGG-ID: ErqXcR9hPrGCPA84z9iYug_1773676562
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83A9A18002D0;
	Mon, 16 Mar 2026 15:56:02 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D9071800361;
	Mon, 16 Mar 2026 15:56:00 +0000 (UTC)
Date: Mon, 16 Mar 2026 16:55:54 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: make "dmsetup remove_all" interruptible
Message-ID: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rT8YNMFnFwO3jDUwPaFYfaE3oudB_2DcjmMudA20umA_1773676562
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The command "dmsetup remove_all" may take a long time (a minute for
removing 1000 devices), so make it interruptible with fatal signals.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2026-03-16 14:37:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2026-03-16 16:44:46.000000000 +0100
@@ -64,7 +64,7 @@ struct vers_iter {
 static struct rb_root name_rb_tree = RB_ROOT;
 static struct rb_root uuid_rb_tree = RB_ROOT;
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred);
+static int dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred, bool interruptible);
 
 /*
  * Guards access to both hash tables.
@@ -78,7 +78,7 @@ static DEFINE_MUTEX(dm_hash_cells_mutex)
 
 static void dm_hash_exit(void)
 {
-	dm_hash_remove_all(false, false, false);
+	dm_hash_remove_all(false, false, false, false);
 }
 
 /*
@@ -333,7 +333,7 @@ static struct dm_table *__hash_remove(st
 	return table;
 }
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred)
+static int dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred, bool interruptible)
 {
 	int dev_skipped;
 	struct rb_node *n;
@@ -347,6 +347,11 @@ retry:
 	down_write(&_hash_lock);
 
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
+		if (interruptible && fatal_signal_pending(current)) {
+			up_write(&_hash_lock);
+			return -EINTR;
+		}
+
 		hc = container_of(n, struct hash_cell, name_node);
 		md = hc->md;
 		dm_get(md);
@@ -386,6 +391,8 @@ retry:
 
 	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
+
+	return 0;
 }
 
 /*
@@ -513,7 +520,7 @@ static struct mapped_device *dm_hash_ren
 
 void dm_deferred_remove(void)
 {
-	dm_hash_remove_all(true, false, true);
+	dm_hash_remove_all(true, false, true, false);
 }
 
 /*
@@ -529,9 +536,9 @@ typedef int (*ioctl_fn)(struct file *fil
 
 static int remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false);
+	int r = dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false, true);
 	param->data_size = 0;
-	return 0;
+	return r;
 }
 
 /*

