Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21FB223316
	for <dm-devel@lists.linux.dev>; Fri, 12 Sep 2025 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757706993; cv=none; b=giYigt9zb6/aucKiQufA28OYuIAEjsNVQyxiYJLpgPOcGH8OLRudYVl1Tg4mBs3N7owWeUECmH/DUFHqPiBCZQJgbtDlnYvjzJnEgOIShrLeRcIoB/J7dE9syGOAo3JchfvyQtW0SfLcLomBPG6DZ9a9saGjc0Bph4flrPhRs9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757706993; c=relaxed/simple;
	bh=811gpV0VcoaZvLoueciwYTRWNqXys3/JPLp/qSw8uKk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EEoM1OotwVC2xWLgaCWLSX1bEpZ9im+5UUoIIzafYJBu+stC5uRuUC2FOkk7lFe2tOB8cH0FBXvR+LELi683bfhLan2ehvA2e6GJKLKF2CGa4+kjkVuhnHGm6vOzVP6JZlPcAODwTVQWB0u+b7HPDfQ92+bWxxXVp7jythrG9a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HUoP+CXK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HUoP+CXK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757706990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CW4OX8AHx4KZ0p3Lol64x0M/g949wN1HFJynmmUtx4k=;
	b=HUoP+CXKssVF8o5B0fyiTASYYt90isQVnE4b3OHrIhIsr/cTwFcF5eyRJFJFaNvi94cgCR
	GYWq8mSdV/grRVoogEiofZmcxyvnJDalOWMmcgRwPaf1m2sz/BghhaqJO4ro3jTl/cYlPy
	eZSyc3Bp+X86pTmtLvx3sNcmRMVFJJo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-4OfPNCQ_OIO4QWqduOoAtg-1; Fri,
 12 Sep 2025 15:56:29 -0400
X-MC-Unique: 4OfPNCQ_OIO4QWqduOoAtg-1
X-Mimecast-MFC-AGG-ID: 4OfPNCQ_OIO4QWqduOoAtg_1757706988
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E4131953943;
	Fri, 12 Sep 2025 19:56:28 +0000 (UTC)
Received: from [10.45.224.45] (unknown [10.45.224.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E85A300021A;
	Fri, 12 Sep 2025 19:56:26 +0000 (UTC)
Date: Fri, 12 Sep 2025 21:56:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v3] dm: optimize REQ_PREFLUSH with data when using the linear
 target
In-Reply-To: <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
Message-ID: <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org> <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bSOmZOKCo4Qz2r3Q3iyUdCkP9pMTytcBQ_YEOwtpQM8_1757706988
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 11 Sep 2025, Mikulas Patocka wrote:

> 
> 
> On Wed, 10 Sep 2025, Bart Van Assche wrote:
> 
> > The dm core splits REQ_PREFLUSH bios that have data into two bios.
> > First, a REQ_PREFLUSH bio with no data is submitted to all underlying
> > dm devices. Next, the REQ_PREFLUSH flag is cleared and the same bio is
> > resubmitted. This approach is essential if there are multiple underlying
> > devices to provide correct REQ_PREFLUSH semantics.
> > 
> > Splitting a bio into an empty flush bio and a non-flush data bio is
> > not necessary if there is only a single underlying device. Hence this
> > patch that does not split REQ_PREFLUSH bios if there is only one
> > underlying device.
> > 
> > This patch preserves the order of REQ_PREFLUSH writes if there is only
> > one underlying device and if one or more write bios have been queued
> > past the REQ_PREFLUSH bio before the REQ_PREFLUSH bio is processed.
> > 
> > Cc: Mike Snitzer <snitzer@kernel.org>
> > Cc: Damien Le Moal <dlemoal@kernel.org>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> > 
> > Changes compared to v1:
> >  - Made the patch description more detailed.
> >  - Removed the reference to write pipelining from the patch description.
> 
> Hi
> 
> I think that the problem here is that not all targets handle a PREFLUSH 
> bio with data (for example, dm-integrity doesn't handle it correctly; it 
> assumes that the PREFLUSH bio is empty).
> 
> I suggest that the logic should be changed to test that 
> "t->flush_bypasses_map == true" (that will rule out targets that don't 
> support flush optimization) and "dm_table_get_devices returns just one 
> device" - if both of these conditions are true, you can send the PREFLUSH 
> bio with data to the one device that dm_table_get_devices returned.
> 
> It will also optimize the case when you have multiple dm-linear targets 
> with just one underlying device.
> 
> Mikulas

Here I'm sending a patch that implements this logic. Please test it.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

If the table has only linear targets and there is just one underlying
device, we can optimize REQ_PREFLUSH with data - we don't have to split
it to two bios - a flush and a write. We can pass it to the linear target
directly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    1 +
 drivers/md/dm.c      |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-08-15 17:28:23.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2025-09-12 15:29:08.000000000 +0200
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
@@ -1996,11 +1993,19 @@ static void dm_split_and_process_bio(str
 	}
 	init_clone_info(&ci, io, map, bio, is_abnormal);
 
-	if (bio->bi_opf & REQ_PREFLUSH) {
+	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0)) {
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
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2025-07-06 15:02:23.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2025-09-12 15:19:36.000000000 +0200
@@ -291,6 +291,7 @@ struct dm_io {
 	struct dm_io *next;
 	struct dm_stats_aux stats_aux;
 	blk_status_t status;
+	bool requeue_flush_with_data;
 	atomic_t io_count;
 	struct mapped_device *md;
 

