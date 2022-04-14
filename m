Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26B2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 00:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649896654;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=geDCZ7cjQgQkGfwLO+32h0XmmpVQWjplNeZffcwTGn4=;
	b=STt4rieLtC5Xq6p54hPULpwKOrFarrsw9w/sZy0rOVo966khhJq297xnf/GCSJAu1RkS+U
	aDVe2x3683/xF/2FEm/TxlCzvG6yv+lcRP9+0PkXeMel/hOuEiH5JzE6xiuyTfSC9FX2Im
	U6WbxPf2KMQBtvbC02QYcPY9c0T4ZHg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-gPmtf-YjNSm-W5eRUjUSrA-1; Wed, 13 Apr 2022 20:37:31 -0400
X-MC-Unique: gPmtf-YjNSm-W5eRUjUSrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4FB5833961;
	Thu, 14 Apr 2022 00:37:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31981404D2EE;
	Thu, 14 Apr 2022 00:37:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D1B011940347;
	Thu, 14 Apr 2022 00:37:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65F9C1940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 00:37:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2E8C2111D3CB; Thu, 14 Apr 2022 00:37:26 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B656111D3C8;
 Thu, 14 Apr 2022 00:37:03 +0000 (UTC)
Date: Thu, 14 Apr 2022 08:36:58 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yldsqh2YsclXYl3s@T590>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
 <YlZp3+VrP930VjIQ@redhat.com> <YlbBf0mJa/BPHSSq@T590>
 <YlcPXslr6Y7cHOSU@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlcPXslr6Y7cHOSU@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> On Wed, Apr 13 2022 at  8:26P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Wed, Apr 13, 2022 at 02:12:47AM -0400, Mike Snitzer wrote:
> > > On Tue, Apr 12 2022 at  9:56P -0400,
> > > Ming Lei <ming.lei@redhat.com> wrote:
> > > 
> > > > On Tue, Apr 12, 2022 at 04:52:40PM -0400, Mike Snitzer wrote:
> > > > > On Tue, Apr 12 2022 at  4:56P -0400,
> > > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > > 
> > > > > > The current DM codes setup ->orig_bio after __map_bio() returns,
> > > > > > and not only cause kernel panic for dm zone, but also a bit ugly
> > > > > > and tricky, especially the waiting until ->orig_bio is set in
> > > > > > dm_submit_bio_remap().
> > > > > > 
> > > > > > The reason is that one new bio is cloned from original FS bio to
> > > > > > represent the mapped part, which just serves io accounting.
> > > > > > 
> > > > > > Now we have switched to bdev based io accounting interface, and we
> > > > > > can retrieve sectors/bio_op from both the real original bio and the
> > > > > > added fields of .sector_offset & .sectors easily, so the new cloned
> > > > > > bio isn't necessary any more.
> > > > > > 
> > > > > > Not only fixes dm-zone's kernel panic, but also cleans up dm io
> > > > > > accounting & split a bit.
> > > > > 
> > > > > You're conflating quite a few things here.  DM zone really has no
> > > > > business accessing io->orig_bio (dm-zone.c can just as easily inspect
> > > > > the tio->clone, because it hasn't been remapped yet it reflects the
> > > > > io->origin_bio, so there is no need to look at io->orig_bio) -- but
> > > > > yes I clearly broke things during the 5.18 merge and it needs fixing
> > > > > ASAP.
> > > > 
> > > > You can just consider the cleanup part of this patches, :-)
> > > 
> > > I will.  But your following list doesn't reflect any "cleanup" that I
> > > saw in your patchset.  Pretty fundamental changes that are similar,
> > > but different, to the dm-5.19 changes I've staged.
> > > 
> > > > 1) no late assignment of ->orig_bio, and always set it in alloc_io()
> > > >
> > > > 2) no waiting on on ->origi_bio, especially the waiting is done in
> > > > fast path of dm_submit_bio_remap().
> > > 
> > > For 5.18 waiting on io->orig_bio just enables a signal that the IO was
> > > split and can be accounted.
> > > 
> > > For 5.19 I also plan on using late io->orig_bio assignment as an
> > > alternative to the full-blown refcounting currently done with
> > > io->io_count.  I've yet to quantify the gains with focused testing but
> > > in theory this approach should scale better on large systems with many
> > > concurrent IO threads to the same device (RCU is primary constraint
> > > now).
> > > 
> > > I'll try to write a bpfrace script to measure how frequently "waiting on
> > > io->orig_bio" occurs for dm_submit_bio_remap() heavy usage (like
> > > dm-crypt). But I think we'll find it is very rarely, if ever, waited
> > > on in the fast path.
> > 
> > The waiting depends on CPU and device's speed, if device is quicker than
> > CPU, the wait should be longer. Testing in one environment is usually
> > not enough.
> > 
> > > 
> > > > 3) no split for io accounting
> > > 
> > > DM's more recent approach to splitting has never been done for benefit
> > > or use of IO accounting, see this commit for its origin:
> > > 18a25da84354c6b ("dm: ensure bio submission follows a depth-first tree walk")
> > > 
> > > Not sure why you keep poking fun at DM only doing a single split when:
> > > that is the actual design.  DM splits off orig_bio then recurses to
> > > handle the remainder of the bio that wasn't issued.  Storing it in
> > > io->orig_bio (previously io->bio) was always a means of reflecting
> > > things properly. And yes IO accounting is one use, the other is IO
> > > completion. But unfortunately DM's IO accounting has always been a
> > > mess ever since the above commit. Changes in 5.18 fixed that.
> > > 
> > > But again, DM's splitting has _nothing_ to do with IO accounting.
> > > Splitting only happens when needed for IO submission given constraints
> > > of DM target(s) or underlying layers.
> > 
> > What I meant is that the bio returned from bio_split() is only for
> > io accounting. Yeah, the comment said it can be for io completion too,
> > but that is easily done without the splitted bio.
> >
> > > All said, I will look closer at your entire set and see if it better
> > > to go with your approach.  This patch in particular is interesting
> > > (avoids cloning and other complexity of bio_split + bio_chain):
> > > https://patchwork.kernel.org/project/dm-devel/patch/20220412085616.1409626-6-ming.lei@redhat.com/
> > 
> > That patch shows we can avoid the extra split, also shows that the
> > splitted bio from bio_split() is for io accounting only.
> 
> Yes I see that now.  But it also served to preserve the original bio
> for use in completion.  Not a big deal, but it did track the head of
> the bio_chain.
> 
> The bigger issue with this patch is that you've caused
> dm_submit_bio_remap() to go back to accounting the entire original bio
> before any split occurs.  That is a problem because you'll end up
> accounting that bio for every split, so in split heavy workloads the
> IO accounting won't reflect when the IO is actually issued and we'll
> regress back to having very inaccurate and incorrect IO accounting for
> dm_submit_bio_remap() heavy targets (e.g. dm-crypt).

Good catch, but we know the length of mapped part in original bio before
calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
something like the following delta change should address it:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index db23efd6bbf6..06b554f3104b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+
+	if (ci->sector_count > len) {
+		/* setup the mapped part for accounting */
+		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
+		ci->io->sectors = len;
+		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
+	}
 	__map_bio(clone);
 
 	ci->sector += len;
@@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (error || !ci.sector_count)
 		goto out;
 
-	/* setup the mapped part for accounting */
-	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
-	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
-	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
-
 	bio_trim(bio, ci.io->sectors, ci.sector_count);
 	trace_block_split(bio, bio->bi_iter.bi_sector);
 	bio_inc_remaining(bio);

-- 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

