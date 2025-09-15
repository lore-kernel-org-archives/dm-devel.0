Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C81E4BE
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757950979; cv=none; b=p7vGvHbKMrJRvV+RsGKFG/11ZkLSfQHNtZ7Xo2dz93sR4uSrfvKvSRRzgQFpat37DTyeFn3IrQkA/n7uQgp+W/xtN17O1oQlpAxfu4K+ovUILShM56fEFBZyFOQAeSj2NEzo+Tc74Dtk2dNQ97F1au4OXHugqsAIjN9qYGLN1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757950979; c=relaxed/simple;
	bh=CRdRITMjiW1NfrV383dllQG59NWvurtyOnRoES9LNVo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W14P1XEce1O5vQd8X9rzJBBoKEf01b/TWAVm9jxEor2YueUYdZcrjlVynw1gHyvxNxZjyp9nJ3yGTC/GWUJ7zTrI6sXNzsx3ssmXk4NkluQJCGyDedd7epjoe+inHl/klVvXT5YkFpQmmwvCEog5FSTrO2/p2PYVSbQCFSYjBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z8bvkpZi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8bvkpZi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757950977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUp6gZn7cSd8H759Nln0s+QHvxdFscW3Z+42DwjmW3M=;
	b=Z8bvkpZi/c7wT2l68VPYwx1Azar24ZCpbAcLmaBCKScF5OOA605m23nskBqlsGewQCSFAP
	hHshnoTtcDwf7dbjVzLQlN6sn5UTjSBMooBLkxkd9sNnTW2rmCGkc0CCXP7bsPDCNgsRCx
	IBBoMMhwF9PEHIx5OdI8AAisremW8BQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-fLv60YPkNHWmtHky2XWz8g-1; Mon,
 15 Sep 2025 11:42:53 -0400
X-MC-Unique: fLv60YPkNHWmtHky2XWz8g-1
X-Mimecast-MFC-AGG-ID: fLv60YPkNHWmtHky2XWz8g_1757950972
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D6E01953945;
	Mon, 15 Sep 2025 15:42:52 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE44630002D0;
	Mon, 15 Sep 2025 15:42:50 +0000 (UTC)
Date: Mon, 15 Sep 2025 17:42:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the linear
 target
In-Reply-To: <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
Message-ID: <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org> <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com> <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com> <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jS7LJz2kr50sDTiaAZ_t925npcR9hW4NKzWhBwFRlws_1757950972
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 12 Sep 2025, Bart Van Assche wrote:

> On 9/12/25 12:56 PM, Mikulas Patocka wrote:
> > If the table has only linear targets and there is just one underlying
> > device, we can optimize REQ_PREFLUSH with data - we don't have to split
> > it to two bios - a flush and a write. We can pass it to the linear target
> > directly.
> 
> Thanks! Since this patch works fine on my test setup:
> 
> Tested-by: Bart Van Assche <bvanassche@acm.org>
> 
> > @@ -1996,11 +1993,19 @@ static void dm_split_and_process_bio(str
> >   	}
> >   	init_clone_info(&ci, io, map, bio, is_abnormal);
> >   -	if (bio->bi_opf & REQ_PREFLUSH) {
> > +	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0)) {
> > +		if (map->flush_bypasses_map) {
> 
> How map->flush_bypasses_map makes submitting REQ_PREFLUSH bios that have
> data safe is nontrivial so it's probably a good idea to explain this in
> a comment.
> 
> > +			struct list_head *devices = dm_table_get_devices(map);
> > +			if (devices->next == devices->prev)
> > +				goto send_preflush_with_data;
> 
> Should it be explained in a comment that devices->next == devices->prev
> checks whether there are either no elements or one element in the list
> and that we know that the devices list is not empty?
> 
> > +		}
> > +		if (bio->bi_iter.bi_size)
> > +			io->requeue_flush_with_data = true;
> >   		__send_empty_flush(&ci);
> >   		/* dm_io_complete submits any data associated with flush */
> >   		goto out;
> >   	}
> > +send_preflush_with_data:
> >     	if (static_branch_unlikely(&zoned_enabled) &&
> >   	    (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)) {
> 
> Isn't it recommended to leave a blank line above goto labels rather than
> below?
> 
> Thanks,
> 
> Bart.

OK. Here I added the comment and I am sending version 4 of the patch.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

If the table has only linear targets and there is just one underlying
device, we can optimize REQ_PREFLUSH with data - we don't have to split
it to two bios - a flush and a write. We can pass it to the linear target
directly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Bart Van Assche <bvanassche@acm.org>

---
 drivers/md/dm-core.h |    1 +
 drivers/md/dm.c      |   31 +++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-09-15 17:30:25.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2025-09-15 17:35:47.000000000 +0200
@@ -490,18 +490,13 @@ u64 dm_start_time_ns_from_clone(struct b
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
-static inline bool bio_is_flush_with_data(struct bio *bio)
-{
-	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
-}
-
 static inline unsigned int dm_io_sectors(struct dm_io *io, struct bio *bio)
 {
 	/*
 	 * If REQ_PREFLUSH set, don't account payload, it will be
 	 * submitted (and accounted) after this flush completes.
 	 */
-	if (bio_is_flush_with_data(bio))
+	if (io->requeue_flush_with_data)
 		return 0;
 	if (unlikely(dm_io_flagged(io, DM_IO_WAS_SPLIT)))
 		return io->sectors;
@@ -590,6 +585,7 @@ static struct dm_io *alloc_io(struct map
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
 	io->status = BLK_STS_OK;
+	io->requeue_flush_with_data = false;
 
 	/* one ref is for submission, the other is for completion */
 	atomic_set(&io->io_count, 2);
@@ -976,11 +972,12 @@ static void __dm_io_complete(struct dm_i
 	if (requeued)
 		return;
 
-	if (bio_is_flush_with_data(bio)) {
+	if (unlikely(io->requeue_flush_with_data)) {
 		/*
 		 * Preflush done for flush with data, reissue
 		 * without REQ_PREFLUSH.
 		 */
+		io->requeue_flush_with_data = false;
 		bio->bi_opf &= ~REQ_PREFLUSH;
 		queue_io(md, bio);
 	} else {
@@ -1996,12 +1993,30 @@ static void dm_split_and_process_bio(str
 	}
 	init_clone_info(&ci, io, map, bio, is_abnormal);
 
-	if (bio->bi_opf & REQ_PREFLUSH) {
+	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0)) {
+		/*
+		 * The "flush_bypasses_map" is set on targets where it is safe
+		 * to skip the map function and submit bios directly to the
+		 * underlying block devices - currently, it is set for dm-linear
+		 * and dm-stripe.
+		 *
+		 * If we have just one underlying device (i.e. there is one
+		 * linear target or multiple linear targets pointing to the same
+		 * device), we can send the flush with data directly to it.
+		 */
+		if (map->flush_bypasses_map) {
+			struct list_head *devices = dm_table_get_devices(map);
+			if (devices->next == devices->prev)
+				goto send_preflush_with_data;
+		}
+		if (bio->bi_iter.bi_size)
+			io->requeue_flush_with_data = true;
 		__send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
 	}
 
+send_preflush_with_data:
 	if (static_branch_unlikely(&zoned_enabled) &&
 	    (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)) {
 		error = __send_zone_reset_all(&ci);
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2025-09-15 17:30:25.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2025-09-15 17:30:25.000000000 +0200
@@ -291,6 +291,7 @@ struct dm_io {
 	struct dm_io *next;
 	struct dm_stats_aux stats_aux;
 	blk_status_t status;
+	bool requeue_flush_with_data;
 	atomic_t io_count;
 	struct mapped_device *md;
 

