Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CBFC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649804471;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D1jV6mlg15LzSwqJKxH6REOybVAuwGI0VPNnD1wm8Bw=;
	b=bUdyL8lyBGS/8pfvbUErrKuGboLv9Fz3EFDwJs4kL4ocLq0L0c9UVjAjSOfyq+Pi1C7T3f
	DAq0EQkaS9Nnuk4gqzNKqmTUdM+CE7z7ophVPbQbwVlKkzPT6EmKHo+KbWWziI8DY3JPom
	f3TuffVvQfIzwVtkfAM4MGi0IWBnC+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-afV_npcMNtuQGU9Stkx5jg-1; Tue, 12 Apr 2022 19:01:07 -0400
X-MC-Unique: afV_npcMNtuQGU9Stkx5jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A892B101AA42;
	Tue, 12 Apr 2022 23:01:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54FA840CFD1E;
	Tue, 12 Apr 2022 23:01:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C55A1949763;
	Tue, 12 Apr 2022 23:01:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 143E41947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 23:01:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF5C5416363; Tue, 12 Apr 2022 23:01:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB096416174
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 23:01:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D14C986B8A3
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 23:01:03 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-JZFkzuGoMNqCHqxUrNFbNQ-1; Tue, 12 Apr 2022 19:01:02 -0400
X-MC-Unique: JZFkzuGoMNqCHqxUrNFbNQ-1
Received: by mail-qv1-f72.google.com with SMTP id
 gh5-20020a05621429c500b004443be8db85so319680qvb.11
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 16:01:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gtZTurHW3+UJgerzL/YePT7n1vG3KGrW52nG09u/8dc=;
 b=lkX3+0Z6baRSHmb/BJt6m331F5+ffyUvdygwSgpc0STtxct8UZKkmRODctD4yE1g9z
 eRRyPR6FKZ70a7X85JR8s4QpeyhydHDd57Ol7CnWKnV6eHfDs9uh3VhRDlO9Vs7/IVZi
 BQmmA49ETRvhUcmyML9V/F4iEww1xw12zBCVziX1tlvFngaIW5YBA2Jm3QHhoiRhKKUn
 KMDUyGRX+gFzvUxyz6wZhQF0Qcffz+h+urOGgwTHTMgKbWSfT+yaqmLILAy128wlW4Wu
 UV6pq/awgUq5RKfD8sMHqUyPTUaIZRAxO2Zn0qBcFwkscD830v7ikzeiYkRZTVhs5J9+
 gZBQ==
X-Gm-Message-State: AOAM5304O/ZJ2I+Ck2fJbxVmCQDwPuTWnB7Vm6wmsUIaBZWFVZbPQ/Oi
 8t0/QVZzepTwjnILVi0l3qQSHBbjkVs64yq6gSrqxNN2xtgbwvQfyDEKZ8OMck0SZOvKY1HySPu
 u9nLo6Q+sLZq/9w==
X-Received: by 2002:a05:622a:34c:b0:2e1:df18:b837 with SMTP id
 r12-20020a05622a034c00b002e1df18b837mr5169617qtw.96.1649804461894; 
 Tue, 12 Apr 2022 16:01:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygoHceLuBkgh44dxh633bwkp1AbYrrDsYNfb2O0i6d+W4oWXAOgVCddazPoY35EFraqMFD/g==
X-Received: by 2002:a05:622a:34c:b0:2e1:df18:b837 with SMTP id
 r12-20020a05622a034c00b002e1df18b837mr5169557qtw.96.1649804461218; 
 Tue, 12 Apr 2022 16:01:01 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 br35-20020a05620a462300b0067e890073cbsm24308599qkb.6.2022.04.12.16.00.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 16:01:00 -0700 (PDT)
Date: Tue, 12 Apr 2022 19:00:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YlYEq0XC2XL6bv2b@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com>
 <c4c83c0f-a4fc-2b37-180f-ccb272085fca@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <c4c83c0f-a4fc-2b37-180f-ccb272085fca@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12 2022 at  6:38P -0400,
Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:

> On 4/13/22 05:52, Mike Snitzer wrote:
> > On Tue, Apr 12 2022 at  4:56P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> >> The current DM codes setup ->orig_bio after __map_bio() returns,
> >> and not only cause kernel panic for dm zone, but also a bit ugly
> >> and tricky, especially the waiting until ->orig_bio is set in
> >> dm_submit_bio_remap().
> >>
> >> The reason is that one new bio is cloned from original FS bio to
> >> represent the mapped part, which just serves io accounting.
> >>
> >> Now we have switched to bdev based io accounting interface, and we
> >> can retrieve sectors/bio_op from both the real original bio and the
> >> added fields of .sector_offset & .sectors easily, so the new cloned
> >> bio isn't necessary any more.
> >>
> >> Not only fixes dm-zone's kernel panic, but also cleans up dm io
> >> accounting & split a bit.
> > 
> > You're conflating quite a few things here.  DM zone really has no
> > business accessing io->orig_bio (dm-zone.c can just as easily inspect
> > the tio->clone, because it hasn't been remapped yet it reflects the
> > io->origin_bio, so there is no need to look at io->orig_bio) -- but
> > yes I clearly broke things during the 5.18 merge and it needs fixing
> > ASAP.
> 
> Problem is that we need to look at the BIO op in submission AND completion
> path to handle zone append requests. So looking at the clone on submission
> is OK since its op is still the original one. But on the completion path,
> the clone may now be a regular write emulating a zone append op. And
> looking at the clone only does not allow detecting that zone append.
> 
> We could have the orig_bio op saved in dm_io to avoid completely looking
> at the orig_bio for detecting zone append.

Can you please try the following patch?

Really sorry for breaking dm-zone.c; please teach this man how to test
the basics of all things dm-zoned (is there a testsuite in the tools
or something?).

Thanks,
Mike

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index c1ca9be4b79e..896127366000 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -360,16 +360,20 @@ static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
 	return 0;
 }
 
+struct orig_bio_details {
+	unsigned int op;
+	unsigned int nr_sectors;
+};
+
 /*
  * First phase of BIO mapping for targets with zone append emulation:
  * check all BIO that change a zone writer pointer and change zone
  * append operations into regular write operations.
  */
-static bool dm_zone_map_bio_begin(struct mapped_device *md,
-				  struct bio *orig_bio, struct bio *clone)
+static bool dm_zone_map_bio_begin(struct mapped_device *md, unsigned int zno,
+				  struct bio *clone)
 {
 	sector_t zsectors = blk_queue_zone_sectors(md->queue);
-	unsigned int zno = bio_zone_no(orig_bio);
 	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
 
 	/*
@@ -384,7 +388,7 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 		WRITE_ONCE(md->zwp_offset[zno], zwp_offset);
 	}
 
-	switch (bio_op(orig_bio)) {
+	switch (bio_op(clone)) {
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_FINISH:
 		return true;
@@ -401,9 +405,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
 		 * target zone.
 		 */
 		clone->bi_opf = REQ_OP_WRITE | REQ_NOMERGE |
-			(orig_bio->bi_opf & (~REQ_OP_MASK));
-		clone->bi_iter.bi_sector =
-			orig_bio->bi_iter.bi_sector + zwp_offset;
+			(clone->bi_opf & (~REQ_OP_MASK));
+		clone->bi_iter.bi_sector += zwp_offset;
 		break;
 	default:
 		DMWARN_LIMIT("Invalid BIO operation");
@@ -423,11 +426,10 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
  * data written to a zone. Note that at this point, the remapped clone BIO
  * may already have completed, so we do not touch it.
  */
-static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
-					struct bio *orig_bio,
+static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int zno,
+					struct orig_bio_details *orig_bio_details,
 					unsigned int nr_sectors)
 {
-	unsigned int zno = bio_zone_no(orig_bio);
 	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
 
 	/* The clone BIO may already have been completed and failed */
@@ -435,7 +437,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
 		return BLK_STS_IOERR;
 
 	/* Update the zone wp offset */
-	switch (bio_op(orig_bio)) {
+	switch (orig_bio_details->op) {
 	case REQ_OP_ZONE_RESET:
 		WRITE_ONCE(md->zwp_offset[zno], 0);
 		return BLK_STS_OK;
@@ -452,7 +454,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
 		 * Check that the target did not truncate the write operation
 		 * emulating a zone append.
 		 */
-		if (nr_sectors != bio_sectors(orig_bio)) {
+		if (nr_sectors != orig_bio_details->nr_sectors) {
 			DMWARN_LIMIT("Truncated write for zone append");
 			return BLK_STS_IOERR;
 		}
@@ -488,7 +490,7 @@ static inline void dm_zone_unlock(struct request_queue *q,
 	bio_clear_flag(clone, BIO_ZONE_WRITE_LOCKED);
 }
 
-static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
+static bool dm_need_zone_wp_tracking(struct bio *clone)
 {
 	/*
 	 * Special processing is not needed for operations that do not need the
@@ -496,15 +498,15 @@ static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
 	 * zones and all operations that do not modify directly a sequential
 	 * zone write pointer.
 	 */
-	if (op_is_flush(orig_bio->bi_opf) && !bio_sectors(orig_bio))
+	if (op_is_flush(clone->bi_opf) && !bio_sectors(clone))
 		return false;
-	switch (bio_op(orig_bio)) {
+	switch (bio_op(clone)) {
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE:
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_FINISH:
 	case REQ_OP_ZONE_APPEND:
-		return bio_zone_is_seq(orig_bio);
+		return bio_zone_is_seq(clone);
 	default:
 		return false;
 	}
@@ -519,8 +521,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 	struct dm_target *ti = tio->ti;
 	struct mapped_device *md = io->md;
 	struct request_queue *q = md->queue;
-	struct bio *orig_bio = io->orig_bio;
 	struct bio *clone = &tio->clone;
+	struct orig_bio_details orig_bio_details;
 	unsigned int zno;
 	blk_status_t sts;
 	int r;
@@ -529,18 +531,21 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 	 * IOs that do not change a zone write pointer do not need
 	 * any additional special processing.
 	 */
-	if (!dm_need_zone_wp_tracking(orig_bio))
+	if (!dm_need_zone_wp_tracking(clone))
 		return ti->type->map(ti, clone);
 
 	/* Lock the target zone */
-	zno = bio_zone_no(orig_bio);
+	zno = bio_zone_no(clone);
 	dm_zone_lock(q, zno, clone);
 
+	orig_bio_details.nr_sectors = bio_sectors(clone);
+	orig_bio_details.op = bio_op(clone);
+
 	/*
 	 * Check that the bio and the target zone write pointer offset are
 	 * both valid, and if the bio is a zone append, remap it to a write.
 	 */
-	if (!dm_zone_map_bio_begin(md, orig_bio, clone)) {
+	if (!dm_zone_map_bio_begin(md, zno, clone)) {
 		dm_zone_unlock(q, zno, clone);
 		return DM_MAPIO_KILL;
 	}
@@ -560,7 +565,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 		 * The target submitted the clone BIO. The target zone will
 		 * be unlocked on completion of the clone.
 		 */
-		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
+		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
+					  *tio->len_ptr);
 		break;
 	case DM_MAPIO_REMAPPED:
 		/*
@@ -568,7 +574,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
 		 * unlock the target zone here as the clone will not be
 		 * submitted.
 		 */
-		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
+		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
+					  *tio->len_ptr);
 		if (sts != BLK_STS_OK)
 			dm_zone_unlock(q, zno, clone);
 		break;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

