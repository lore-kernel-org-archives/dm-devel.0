Return-Path: <SRS0=F0YI=IP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E828C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 19:13:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D49364F10
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 19:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D49364F10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616008419;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lqvWGbYfYWuBCh6yfK4L2NlBGqG2OSL21bmw2br4SCA=;
	b=i5zcnH5zwk0yTdrpqNjj8vEnmgAbBTDWp1mFTEQaz1gUqVp1V5Oh5V7KNdLrd7vfb0qZiB
	MUBryzfz5tKb664blWz8ELr7DzDj9NlaKGDaFk4ppNo3yl3mVzX4yOmCFfsMpmmkcVnSht
	9PI/Qya0yVJZsv44e9UidLMgnhuDUdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-DzlY6WYvO4y2wAlU7_9RyA-1; Wed, 17 Mar 2021 15:13:35 -0400
X-MC-Unique: DzlY6WYvO4y2wAlU7_9RyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CA99107ACCA;
	Wed, 17 Mar 2021 19:13:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B03D60C13;
	Wed, 17 Mar 2021 19:13:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B44771809C83;
	Wed, 17 Mar 2021 19:13:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12HJDRt1014689 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Mar 2021 15:13:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 11CDA10023B2; Wed, 17 Mar 2021 19:13:27 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 796A71007625;
	Wed, 17 Mar 2021 19:13:20 +0000 (UTC)
Date: Wed, 17 Mar 2021 15:13:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210317191319.GA30376@redhat.com>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-3-git-send-email-sergei.shtepa@veeam.com>
	<YFBnypYemiR08A/c@T590> <20210316163544.GA31272@veeam.com>
	<YFFxdz84esfiTvNk@T590> <20210317122217.GA31781@veeam.com>
	<20210317150441.GB29481@redhat.com>
	<20210317181413.GB31781@veeam.com>
MIME-Version: 1.0
In-Reply-To: <20210317181413.GB31781@veeam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 2/3] block: add bdev_interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 17 2021 at  2:14pm -0400,
Sergei Shtepa <sergei.shtepa@veeam.com> wrote:

> The 03/17/2021 18:04, Mike Snitzer wrote:
> > On Wed, Mar 17 2021 at  8:22am -0400,
> > Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> > 
> > > The 03/17/2021 06:03, Ming Lei wrote:
> > > > On Tue, Mar 16, 2021 at 07:35:44PM +0300, Sergei Shtepa wrote:
> > > > > The 03/16/2021 11:09, Ming Lei wrote:
> > > > > > On Fri, Mar 12, 2021 at 06:44:54PM +0300, Sergei Shtepa wrote:
> > > > > > > bdev_interposer allows to redirect bio requests to another devices.
> > > > > > > 
> > > > > > > Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> > > > > > > ---
> > > > > > >  block/bio.c               |  2 ++
> > > > > > >  block/blk-core.c          | 57 +++++++++++++++++++++++++++++++++++++++
> > > > > > >  block/genhd.c             | 54 +++++++++++++++++++++++++++++++++++++
> > > > > > >  include/linux/blk_types.h |  3 +++
> > > > > > >  include/linux/blkdev.h    |  9 +++++++
> > > > > > >  5 files changed, 125 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/block/bio.c b/block/bio.c
> > > > > > > index a1c4d2900c7a..0bfbf06475ee 100644
> > > > > > > --- a/block/bio.c
> > > > > > > +++ b/block/bio.c
> > > > > > > @@ -640,6 +640,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
> > > > > > >  		bio_set_flag(bio, BIO_THROTTLED);
> > > > > > >  	if (bio_flagged(bio_src, BIO_REMAPPED))
> > > > > > >  		bio_set_flag(bio, BIO_REMAPPED);
> > > > > > > +	if (bio_flagged(bio_src, BIO_INTERPOSED))
> > > > > > > +		bio_set_flag(bio, BIO_INTERPOSED);
> > > > > > >  	bio->bi_opf = bio_src->bi_opf;
> > > > > > >  	bio->bi_ioprio = bio_src->bi_ioprio;
> > > > > > >  	bio->bi_write_hint = bio_src->bi_write_hint;
> > > > > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > > > > index fc60ff208497..da1abc4c27a9 100644
> > > > > > > --- a/block/blk-core.c
> > > > > > > +++ b/block/blk-core.c
> > > > > > > @@ -1018,6 +1018,55 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> > > > > > >  	return ret;
> > > > > > >  }
> > > > > > >  
> > > > > > > +static noinline blk_qc_t submit_bio_interposed(struct bio *bio)
> > > > > > > +{
> > > > > > > +	blk_qc_t ret = BLK_QC_T_NONE;
> > > > > > > +	struct bio_list bio_list[2] = { };
> > > > > > > +	struct gendisk *orig_disk;
> > > > > > > +
> > > > > > > +	if (current->bio_list) {
> > > > > > > +		bio_list_add(&current->bio_list[0], bio);
> > > > > > > +		return BLK_QC_T_NONE;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	orig_disk = bio->bi_bdev->bd_disk;
> > > > > > > +	if (unlikely(bio_queue_enter(bio)))
> > > > > > > +		return BLK_QC_T_NONE;
> > > > > > > +
> > > > > > > +	current->bio_list = bio_list;
> > > > > > > +
> > > > > > > +	do {
> > > > > > > +		struct block_device *interposer = bio->bi_bdev->bd_interposer;
> > > > > > > +
> > > > > > > +		if (unlikely(!interposer)) {
> > > > > > > +			/* interposer was removed */
> > > > > > > +			bio_list_add(&current->bio_list[0], bio);
> > > > > > > +			break;
> > > > > > > +		}
> > > > > > > +		/* assign bio to interposer device */
> > > > > > > +		bio_set_dev(bio, interposer);
> > > > > > > +		bio_set_flag(bio, BIO_INTERPOSED);
> > > > > > > +
> > > > > > > +		if (!submit_bio_checks(bio))
> > > > > > > +			break;
> > > > > > > +		/*
> > > > > > > +		 * Because the current->bio_list is initialized,
> > > > > > > +		 * the submit_bio callback will always return BLK_QC_T_NONE.
> > > > > > > +		 */
> > > > > > > +		interposer->bd_disk->fops->submit_bio(bio);
> > > > > > 
> > > > > > Given original request queue may become live when calling attach() and
> > > > > > detach(), see below comment. bdev_interposer_detach() may be run
> > > > > > when running ->submit_bio(), meantime the interposer device is
> > > > > > gone during the period, then kernel oops.
> > > > > 
> > > > > I think that since the bio_queue_enter() function was called,
> > > > > q->q_usage_counter will not allow the critical code in the attach/detach
> > > > > functions to be executed, which is located between the blk_freeze_queue
> > > > > and blk_unfreeze_queue calls.
> > > > > Please correct me if I'm wrong.
> > > > > 
> > > > > > 
> > > > > > > +	} while (false);
> > > > > > > +
> > > > > > > +	current->bio_list = NULL;
> > > > > > > +
> > > > > > > +	blk_queue_exit(orig_disk->queue);
> > > > > > > +
> > > > > > > +	/* Resubmit remaining bios */
> > > > > > > +	while ((bio = bio_list_pop(&bio_list[0])))
> > > > > > > +		ret = submit_bio_noacct(bio);
> > > > > > > +
> > > > > > > +	return ret;
> > > > > > > +}
> > > > > > > +
> > > > > > >  /**
> > > > > > >   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> > > > > > >   * @bio:  The bio describing the location in memory and on the device.
> > > > > > > @@ -1029,6 +1078,14 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> > > > > > >   */
> > > > > > >  blk_qc_t submit_bio_noacct(struct bio *bio)
> > > > > > >  {
> > > > > > > +	/*
> > > > > > > +	 * Checking the BIO_INTERPOSED flag is necessary so that the bio
> > > > > > > +	 * created by the bdev_interposer do not get to it for processing.
> > > > > > > +	 */
> > > > > > > +	if (bdev_has_interposer(bio->bi_bdev) &&
> > > > > > > +	    !bio_flagged(bio, BIO_INTERPOSED))
> > > > > > > +		return submit_bio_interposed(bio);
> > > > > > > +
> > > > > > >  	if (!submit_bio_checks(bio))
> > > > > > >  		return BLK_QC_T_NONE;
> > > > > > >  
> > > > > > > diff --git a/block/genhd.c b/block/genhd.c
> > > > > > > index c55e8f0fced1..c840ecffea68 100644
> > > > > > > --- a/block/genhd.c
> > > > > > > +++ b/block/genhd.c
> > > > > > > @@ -30,6 +30,11 @@
> > > > > > >  static struct kobject *block_depr;
> > > > > > >  
> > > > > > >  DECLARE_RWSEM(bdev_lookup_sem);
> > > > > > > +/*
> > > > > > > + * Prevents different block-layer interposers from attaching or detaching
> > > > > > > + * to the block device at the same time.
> > > > > > > + */
> > > > > > > +static DEFINE_MUTEX(bdev_interposer_attach_lock);
> > > > > > >  
> > > > > > >  /* for extended dynamic devt allocation, currently only one major is used */
> > > > > > >  #define NR_EXT_DEVT		(1 << MINORBITS)
> > > > > > > @@ -1940,3 +1945,52 @@ static void disk_release_events(struct gendisk *disk)
> > > > > > >  	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
> > > > > > >  	kfree(disk->ev);
> > > > > > >  }
> > > > > > > +
> > > > > > > +int bdev_interposer_attach(struct block_device *original,
> > > > > > > +			   struct block_device *interposer)
> > > > > > > +{
> > > > > > > +	int ret = 0;
> > > > > > > +
> > > > > > > +	if (WARN_ON(((!original) || (!interposer))))
> > > > > > > +		return -EINVAL;
> > > > > > > +	/*
> > > > > > > +	 * interposer should be simple, no a multi-queue device
> > > > > > > +	 */
> > > > > > > +	if (!interposer->bd_disk->fops->submit_bio)
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > > +	if (WARN_ON(!blk_mq_is_queue_frozen(original->bd_disk->queue)))
> > > > > > > +		return -EPERM;
> > > > > > 
> > > > > > The original request queue may become live now...
> > > > > 
> > > > > Yes.
> > > > > I will remove the blk_mq_is_queue_frozen() function and use a different
> > > > > approach.
> > > > 
> > > > Looks what attach and detach needs is that queue is kept as frozen state
> > > > instead of being froze simply at the beginning of the two functions, so
> > > > you can simply call freeze/unfreeze inside the two functions.
> > > > 
> > > > But what if 'original' isn't a MQ queue?  queue usage counter is just
> > > > grabed when calling ->submit_bio(), and queue freeze doesn't guarantee there
> > > > isn't any io activity, is that a problem for bdev_interposer use case?
> > > > 
> > > > -- 
> > > > Ming
> > > > 
> > > 
> > > It makes sense to add freeze_bdev/thaw_bdev. This will be useful.
> > > For the main file systems, the freeze functions are defined 
> > > sb->s_op->freeze_super() or sb - >s_op->freeze_fs()
> > > (btrfs, ext2, ext4, f2fs, jfs, nilfs2, reiserfs, xfs).
> > > If the file system is frozen, then no new requests should be received.
> > > 
> > > But if the file system does not support freeze or the disk is used without
> > > a file system, as for some databases, freeze_bdev seems useless to me.
> > > In this case, we will need to stop working with the disk from user-space,
> > > for example, to freeze the database itself.
> > > 
> > > I can add dm_suspend() before bdev_interposer_detach(). This will ensure that
> > > all intercepted requests have been processed. Applying dm_suspend() before
> > > bdev_interposer_attach() is pointless. The attachment is made when the target
> > > is created, and at this time the target is not ready to work yet.
> > > There shouldn't be any bio requests, I suppose. In addition,
> > > sb->s_op->freeze_fs() for the interposer will not be called, because the file
> > > system is not mounted for the interposer device. It should not be able to
> > > be mounted. To do this, I will add an exclusive opening of the interposer
> > > device.
> > > 
> > > I'll add freeze_bdev() for the original device and dm_suspend() for the
> > > interposer to the DM code. For normal operation of bdev_interposer,
> > > it is enough to transfer blk_mq_freeze_queue and blk_mq_quiesce_queue to
> > > bdev_interposer_attach/bdev_interposer_detach.
> > > The lock on the counter q->q_usage_counter is enough to not catch NULL in
> > > bd_interposer.
> > > 
> > > Do you think this is enough?
> > > I think there are no other ways to stop the block device queue.
> > 
> > Either you're pretty confused, or I am... regardless.. I think we need
> > to cover the basics of how interposer is expected to be paired with
> > an "original" device.
> 
> Thank you Mike for your patience. I really appreciate it.
> I really may not understand something. Let me get this straight.
> 
> > 
> > Those "original" device are already active and potentially in use
> > right?  They may be either request-based blk-mq _or_ bio-based.
> 
> Yes. Exactly.
> 
> > 
> > So what confuses me is that you're making assertions about how actively
> > used bio-based DM devices aren't in use until the interposed device
> > create happens... this is all getting very muddled.
> 
> The original device is indeed already actively used and already mounted.
> This is most likely not a DM device.
> If it is a request-based blk-mq, then it is enough to stop its queue by
> blk_mq_freeze_queue(). 
> If it is a bio-based device, then we can try to stop it by freeze_bdev.
> But in both cases, if the blk_mq_freeze_bdev() function was called, bio cannot
> get into the critical section between bio_queue_enter() and blk_queue_exit().
> This allows to safely change the value of original->bd_interposer.

Even though bios cannot get into underlying blk-mq they are already
inflight on behalf of the upper-layer bio-based device. I'll look closer
at the code but it seems like there is potential for the original
device's bios to still be queued to original, past the ->submit_bio
entry, and waiting for blk-mq to unfreeze.  Meaning upon return from
what I _think_ you're saying will be sufficient: DM bio-based device
will carry on submitting IO to the blk-mq device that has since been
interposed.. that IO will _not_ complete in terms of the interposed
device.. so you'll have a split-brain dual completion of IO from the
original bio-based DM device _and_ the interposed device (for any new io
that hits ->submit_bio after the interposed device is in place).

I think you need to have original bio-based DM suspend, interpose
device, and then resume the original.  Anything entering original's
->submit_bio from that point will all get sent to interposed
device. Right?

> To intercept requests to the original device, we create a new md with
> the DM_INTERPOSE_FLAG flag. It is this interposer device that has not
> yet been initialized by this time. It just runs DM_TABLE_LOAD_CMD.
> That is why I think that the queue of this device should not be stopped,
> since this device has not yet been initialized.
> 
> > 
> > And your lack of understanding of these various IO flushing methods
> > (freeze/thaw, suspend/resume, etc) is showing.  Please slow down and
> > approach this more systematically.
> 
> For any block device, we can call the freeze_bdev() function. It will 
> allow to wait until the processing of previously sent requests is 
> completed and block the sending of new ones. blk_mq_freeze_queue() 
> allows to change the bd_interposer variable. This allow to attach/detach 
> the interposer to original device.

freeze_bdev/thaw_bdev are only relevant if a filesystem is layered
ontop.  A bio-based DM device can be used directly (by a database or
whatever).

> dm_suspend() is used to stop mapped device. This is what I plan to use
> before detaching the interposer. It will allow to wait for the
> completion of all the bios that were sent for the interposer.

Yes, but you need to suspend before attaching the interposer too, to
flush any in-flight bios that might be in-flight within the various DM
target code.

DM should be able to internalize all this when handling the
DM_INTERPOSE_FLAG during the new table load.  It'd call into
dm_internal_suspend_fast and then dm_internal_resume_fast for the
original md device.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

