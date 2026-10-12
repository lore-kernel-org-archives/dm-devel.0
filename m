Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F4D4A6885
	for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820575; cv=none; b=gkIJS56teg6MZRDW9cRqmSkKvrUhFST/g3uzXm0rJJov2t/wqSY6djCzT9dtOMOzwHRAHY+f288Nf4+mOVOmC/re22ysJwnLJbwEgLSvRjCJnNNy6hZSmKr90ZU142NcPL3k+Way2WLwahswNRyCXb0Kf9BQ3VhzjuPNQ0DGET8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820575; c=relaxed/simple;
	bh=uTUkAjGNvy38OQ7ZAQTSjFKDakMRNX4r5Imw6myp1Mc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=dUMLTvOAHaSJo5fNwi83JCEe7qHeiH84ugtuMkM/9mdPgpkePLsVHruKQJCKmra7zcyoWOJC049vJcX0PdQc2WrDimryfz+yXVWoHMFlTGqTU2j2JCviKu3uiJJVylpMpul+mWVG8T3gZakj7sNCngcELwZ/l6vek9KH/PHVWTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LnBvn+1Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LnBvn+1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791820573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=y2Ay8DMOFXywmmTJxafwXoCE8jCKdu51ycXFDpeYzlk=;
	b=LnBvn+1Yae5FY6L+HdVCj3mzygi/jkGURp2juChARFDTbKsbvfhbetFRL8TUhuAxFOy+jt
	cfke8sxFsELj4GxUOkQjVTaDK0D4esFe6WsyWN1h/Q8Im3gK3cv14HVhyvsOXsPrSFrT0R
	cBI/+1Sm/sMLDFbtYyFK6HJH8ClG+bA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-9jPFC8PFPAiXSylJFFxXPA-1; Mon,
 12 Oct 2026 15:56:11 +0000
X-MC-Unique: 9jPFC8PFPAiXSylJFFxXPA-1
X-Mimecast-MFC-AGG-ID: 9jPFC8PFPAiXSylJFFxXPA_1791820570
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAE2818001E6;
	Mon, 12 Oct 2026 15:56:10 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7808B5BC;
	Mon, 12 Oct 2026 15:56:09 +0000 (UTC)
Date: Mon, 12 Oct 2026 17:56:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-bufio: clean-up cache size reading
Message-ID: <e51e600f-e95b-00f3-3bdb-8cec202b423d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mdFKm1i2WPQ0jy3qABTNN_bjGRKpe66cLpdfzvd8_ik_1791820570
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

In the original dm-bufio, setting dm_bufio_cache_size to 0 meant to set
the default value. However, when the code was refactored in the commit
450e8dee51aa, the meaning of 0 is inconsistent, at some places, we just
read the variable dm_bufio_cache_size without testing it to zero.

This commit cleans up the zero handling, all reads of dm_bufio_cache_size
go through the function dm_budio_get_cache_size() and this function tests
the variable for zero and sets the default cache size in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-bufio.c |   59 ++++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 40 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -1044,12 +1044,6 @@ static unsigned long dm_bufio_default_ca
  */
 static unsigned long dm_bufio_cache_size;
 
-/*
- * A copy of dm_bufio_cache_size because dm_bufio_cache_size can change
- * at any time.  If it disagrees, the user has changed cache size.
- */
-static unsigned long dm_bufio_cache_size_latch;
-
 static DEFINE_SPINLOCK(global_spinlock);
 
 static unsigned int dm_bufio_max_age; /* No longer does anything */
@@ -1076,7 +1070,7 @@ static int dm_bufio_client_count;
 static LIST_HEAD(dm_bufio_all_clients);
 
 /*
- * This mutex protects dm_bufio_cache_size_latch and dm_bufio_client_count
+ * This mutex protects dm_bufio_client_count
  */
 static DEFINE_MUTEX(dm_bufio_clients_lock);
 
@@ -1093,6 +1087,17 @@ static void buffer_record_stack(struct d
 
 /*----------------------------------------------------------------*/
 
+static unsigned long dm_budio_get_cache_size(void)
+{
+	unsigned long s = READ_ONCE(dm_bufio_cache_size);
+	if (unlikely(!s)) {
+		unsigned long d = dm_bufio_default_cache_size;
+		(void)cmpxchg(&dm_bufio_cache_size, 0, d);
+		s = d;
+	}
+	return s;
+}
+
 static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
 {
 	unsigned char data_mode;
@@ -1120,7 +1125,7 @@ static void adjust_total_allocated(struc
 		dm_bufio_peak_allocated = dm_bufio_current_allocated;
 
 	if (!unlink) {
-		if (dm_bufio_current_allocated > dm_bufio_cache_size)
+		if (dm_bufio_current_allocated > dm_budio_get_cache_size())
 			queue_work(dm_bufio_wq, &dm_bufio_replacement_work);
 	}
 
@@ -1128,28 +1133,6 @@ static void adjust_total_allocated(struc
 }
 
 /*
- * Change the number of clients and recalculate per-client limit.
- */
-static void __cache_size_refresh(void)
-{
-	if (WARN_ON(!mutex_is_locked(&dm_bufio_clients_lock)))
-		return;
-	if (WARN_ON(dm_bufio_client_count < 0))
-		return;
-
-	dm_bufio_cache_size_latch = READ_ONCE(dm_bufio_cache_size);
-
-	/*
-	 * Use default if set to 0 and report the actual cache size used.
-	 */
-	if (!dm_bufio_cache_size_latch) {
-		(void)cmpxchg(&dm_bufio_cache_size, 0,
-			      dm_bufio_default_cache_size);
-		dm_bufio_cache_size_latch = dm_bufio_default_cache_size;
-	}
-}
-
-/*
  * Allocating buffer data.
  *
  * Small buffers are allocated with kmem_cache, to use space optimally.
@@ -1618,7 +1601,7 @@ static struct dm_buffer *__alloc_buffer_
 	 * be allocated.
 	 */
 	while (1) {
-		if (dm_bufio_cache_size_latch != 1) {
+		if (dm_budio_get_cache_size() != 1) {
 			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC);
 			if (b)
 				return b;
@@ -1627,7 +1610,7 @@ static struct dm_buffer *__alloc_buffer_
 		if (nf == NF_PREFETCH)
 			return NULL;
 
-		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
+		if (dm_budio_get_cache_size() != 1 && !tried_noio_alloc) {
 			dm_bufio_unlock(c);
 			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 			dm_bufio_lock(c);
@@ -2616,7 +2599,6 @@ struct dm_bufio_client *dm_bufio_client_
 	mutex_lock(&dm_bufio_clients_lock);
 	dm_bufio_client_count++;
 	list_add(&c->client_list, &dm_bufio_all_clients);
-	__cache_size_refresh();
 	mutex_unlock(&dm_bufio_clients_lock);
 
 	return c;
@@ -2658,7 +2640,6 @@ void dm_bufio_client_destroy(struct dm_b
 
 	list_del(&c->client_list);
 	dm_bufio_client_count--;
-	__cache_size_refresh();
 
 	mutex_unlock(&dm_bufio_clients_lock);
 
@@ -2827,8 +2808,8 @@ static void check_watermarks(void)
 
 static void evict_old(void)
 {
-	unsigned long threshold = dm_bufio_cache_size -
-		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
+	unsigned long cs = dm_budio_get_cache_size();
+	unsigned long threshold = cs - cs / DM_BUFIO_LOW_WATERMARK_RATIO;
 	int unproductive = 0;
 
 	mutex_lock(&dm_bufio_clients_lock);
@@ -2889,10 +2870,8 @@ static int __init dm_bufio_init(void)
 #endif
 
 	dm_bufio_default_cache_size = mem;
-
-	mutex_lock(&dm_bufio_clients_lock);
-	__cache_size_refresh();
-	mutex_unlock(&dm_bufio_clients_lock);
+	if (!dm_bufio_cache_size)
+		dm_bufio_cache_size = mem;
 
 	dm_bufio_wq = alloc_workqueue("dm_bufio_cache",
 				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);

