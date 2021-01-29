Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3198AC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 15:59:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B11064DFA
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 15:59:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B11064DFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-cU_4iuo_PiqW54i1SxBMnQ-1; Fri, 29 Jan 2021 10:59:18 -0500
X-MC-Unique: cU_4iuo_PiqW54i1SxBMnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD70510054FF;
	Fri, 29 Jan 2021 15:59:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A174B5D705;
	Fri, 29 Jan 2021 15:59:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 544401809C9F;
	Fri, 29 Jan 2021 15:59:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10TFxBmk008448 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 10:59:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0955110D18FB; Fri, 29 Jan 2021 15:59:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 053DA10D18EA
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 15:59:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8786800B3A
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 15:59:07 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-100-5K-0vzxUM1q1lWy21fotrg-1;
	Fri, 29 Jan 2021 10:59:03 -0500
X-MC-Unique: 5K-0vzxUM1q1lWy21fotrg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id D4B7A4129A;
	Fri, 29 Jan 2021 10:58:57 -0500 (EST)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Fri, 29 Jan 2021 16:58:55 +0100
Date: Fri, 29 Jan 2021 18:58:52 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210129155852.GB32240@veeam.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<1611853955-32167-2-git-send-email-sergei.shtepa@veeam.com>
	<BL0PR04MB6514943D2E257F88778C389CE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB6514943D2E257F88778C389CE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265667563
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: blk_interposer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 01/29/2021 04:21, Damien Le Moal wrote:
> On 2021/01/29 2:23, Sergei Shtepa wrote:
> > The block layer interposer allows to intercept bio requests.
> > This allows to connect device mapper and other kernel modules
> > to the block device stack on the fly.
> > 
> > changes:
> >   * new BIO_INTERPOSED bio flag.
> >   * new function __submit_bio_interposed() implements the interposers
> >     logic.
> >   * new function blk_mq_is_queue_frozen() allow to assert that
> >     the queue is frozen.
> >   * functions blk_interposer_attach() and blk_interposer_detach()
> >     allow to attach and detach interposers.
> 
> The changelog should not be part of the commit message. If you need a changelog
> for a single patch, add it between the commit message end "---" and the patch
> stats. git will ignore that part.
> 
> > Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> > ---
> >  block/bio.c               |  2 +
> >  block/blk-core.c          | 29 ++++++++++++++
> >  block/blk-mq.c            | 13 +++++++
> >  block/genhd.c             | 82 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/blk-mq.h    |  1 +
> >  include/linux/blk_types.h |  6 ++-
> >  include/linux/genhd.h     | 19 +++++++++
> >  7 files changed, 150 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/bio.c b/block/bio.c
> > index 1f2cc1fbe283..f6f135eb84b5 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -684,6 +684,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
> >  	bio_set_flag(bio, BIO_CLONED);
> >  	if (bio_flagged(bio_src, BIO_THROTTLED))
> >  		bio_set_flag(bio, BIO_THROTTLED);
> > +	if (bio_flagged(bio_src, BIO_INTERPOSED))
> > +		bio_set_flag(bio, BIO_INTERPOSED);
> >  	bio->bi_opf = bio_src->bi_opf;
> >  	bio->bi_ioprio = bio_src->bi_ioprio;
> >  	bio->bi_write_hint = bio_src->bi_write_hint;
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 7663a9b94b80..07ec82d8fe57 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1032,6 +1032,32 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> >  	return ret;
> >  }
> >  
> > +static blk_qc_t __submit_bio_interposed(struct bio *bio)
> > +{
> > +	struct bio_list bio_list[2] = { };
> > +	blk_qc_t ret = BLK_QC_T_NONE;
> > +
> > +	current->bio_list = bio_list;
> > +	if (likely(bio_queue_enter(bio) == 0)) {
> > +		struct gendisk *disk = bio->bi_disk;
> > +
> > +		bio_set_flag(bio, BIO_INTERPOSED);
> > +		if (likely(blk_has_interposer(disk)))
> > +			disk->interposer->ip_submit_bio(bio);
> 
> Why do you check again blk_has_interposer() here ? That is checked already in
> submit_bio_noacct() and the interposer attach/detach cannot run without the
> queue frozen. So I do not think you need to check again. If you do, then you
> definitely have a race condition here.

There is no problem here.
The first call to blk_has_interposer() allows not to call the __submit_bio_interposed()
function if the interposer is not specified.
Changing the disk->interpreter field is blocked by the bio_queue_enter() and
blk_queue_exit() functions. Therefore, a second check of blk_has_interposer()
is needed after calling bio_queue_enter().
But I think setting the BIO_INTERPOSED flag should be moved below, just before
calling ip_submit_bio().

> 
> > +		else /* interposer was removed */
> > +			bio_list_add(&current->bio_list[0], bio);
> > +
> > +		blk_queue_exit(disk->queue);
> > +	}
> > +	current->bio_list = NULL;
> > +
> > +	/* Resubmit remaining bios */
> > +	while ((bio = bio_list_pop(&bio_list[0])))
> > +		ret = submit_bio_noacct(bio);
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> >   * @bio:  The bio describing the location in memory and on the device.
> > @@ -1057,6 +1083,9 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
> >  		return BLK_QC_T_NONE;
> >  	}
> >  
> > +	if (blk_has_interposer(bio->bi_disk) &&
> > +	    !bio_flagged(bio, BIO_INTERPOSED))
> > +		return __submit_bio_interposed(bio);
> 
> OK. I *think* that this is to handle stacked devices, right ? Otherwise, this
> condition does not make much sense. Why not just:
> 
> 	if (blk_has_interposer(bio->bi_disk))
> 		return __submit_bio_interposed(bio);
> 
> So at least adding some comments here may be good.

Checking the BIO_INTERPOSED flag is necessary here.
The device mapper can re-send an intercepted request, or generate new ones
that should not be intercepted.
I'll think about a comment for this line.

> 
> >  	if (!bio->bi_disk->fops->submit_bio)
> >  		return __submit_bio_noacct_mq(bio);
> >  	return __submit_bio_noacct(bio);
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index f285a9123a8b..924ec26fae5f 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -161,6 +161,19 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
> >  }
> >  EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
> >  
> > +
> > +bool blk_mq_is_queue_frozen(struct request_queue *q)
> > +{
> > +	bool ret;
> > +
> > +	mutex_lock(&q->mq_freeze_lock);
> > +	ret = percpu_ref_is_dying(&q->q_usage_counter) && percpu_ref_is_zero(&q->q_usage_counter);
> > +	mutex_unlock(&q->mq_freeze_lock);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_mq_is_queue_frozen);
> 
> Maybe move this change to its own patch preceding this one ?

Yes, if it makes the review easier.

> 
> > +
> >  /*
> >   * Guarantee no request is in use, so we can change any data structure of
> >   * the queue afterward.
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 419548e92d82..d3459582f56c 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -30,6 +30,7 @@
> >  static struct kobject *block_depr;
> >  
> >  DECLARE_RWSEM(bdev_lookup_sem);
> > +DEFINE_MUTEX(bdev_interposer_mutex);
> >  
> >  /* for extended dynamic devt allocation, currently only one major is used */
> >  #define NR_EXT_DEVT		(1 << MINORBITS)
> > @@ -2148,3 +2149,84 @@ static void disk_release_events(struct gendisk *disk)
> >  	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
> >  	kfree(disk->ev);
> >  }
> > +
> > +/**
> > + * blk_interposer_attach - Attach interposer to disk
> > + * @disk: target disk
> > + * @interposer: block device interposer
> > + * @ip_submit_bio: hook for submit_bio()
> > + *
> > + * Returns:
> > + *     -EINVAL if @interposer is NULL.
> > + *     -EPERM if queue is not frozen.
> > + *     -EBUSY if the block device already has @interposer.
> > + *     -EALREADY if the block device already has @interposer with same callback.
> > + *
> > + * Disk must be frozen by blk_mq_freeze_queue().
> > + */
> > +int blk_interposer_attach(struct gendisk *disk, struct blk_interposer *interposer,
> > +			  const ip_submit_bio_t ip_submit_bio)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!interposer)
> > +		return -EINVAL;
> 
> Is this really necessary ? If some user of this function has interposer == NULL,
> that caller needs debugging...

Right. I`ll add WARN_ON() at this place for debugging, but avoid the kernel drop.

> 
> > +
> > +	if (!blk_mq_is_queue_frozen(disk->queue))
> > +		return -EPERM;
> 
> Why not do the queue freeze here ?

In the very first version, the freeze was here. But the state when the queue is frozen
is also very convenient for executing other code. In order not to create new locks,
the freeze was placed in dm_interposer_attach_dev().

> 
> > +
> > +	mutex_lock(&bdev_interposer_mutex);
> > +	if (blk_has_interposer(disk)) {
> > +		if (disk->interposer->ip_submit_bio == ip_submit_bio)
> > +			ret = -EALREADY;
> > +		else
> > +			ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	interposer->ip_submit_bio = ip_submit_bio;
> > +	interposer->disk = disk;
> > +
> > +	disk->interposer = interposer;
> > +out:
> > +	mutex_unlock(&bdev_interposer_mutex);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_interposer_attach);
> > +
> > +/**
> > + * blk_interposer_detach - Detach interposer from disk
> > + * @interposer: block device interposer
> > + * @ip_submit_bio: hook for submit_bio()
> > + *
> > + * Disk must be frozen by blk_mq_freeze_queue().
> > + */
> > +void blk_interposer_detach(struct blk_interposer *interposer,
> > +			  const ip_submit_bio_t ip_submit_bio)
> > +{
> 
> The interface is weird. Why not passing the gendisk ?

Passing interposer will be more safety.
The kernel module (device mapper) owns the "interposer" object and passes it
to the function.
In addition, need to reset the interposer->disk. This is a sign that interposer
has been detached.

> 
> > +	struct gendisk *disk;
> > +
> > +	if (WARN_ON(!interposer))
> > +		return;
> 
> Same comment as above. This should not be necessary.

I think it`s necessary in case detach will be called twice.
It allow to avoid the kernel drop.

> 
> > +
> > +	mutex_lock(&bdev_interposer_mutex);
> > +
> > +	/* Check if the interposer is still active. */
> > +	disk = interposer->disk;
> > +	if (WARN_ON(!disk))
> > +		goto out;
> > +
> > +	if (WARN_ON(!blk_mq_is_queue_frozen(disk->queue)))
> > +		goto out;
> > +
> > +	/* Check if it is really our interposer. */
> > +	if (WARN_ON(disk->interposer->ip_submit_bio != ip_submit_bio))
> > +		goto out;
> > +
> > +	disk->interposer = NULL;
> > +	interposer->disk = NULL;
> > +out:
> > +	mutex_unlock(&bdev_interposer_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(blk_interposer_detach);
> > diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> > index d705b174d346..9d1e8c4e922e 100644
> > --- a/include/linux/blk-mq.h
> > +++ b/include/linux/blk-mq.h
> > @@ -525,6 +525,7 @@ void blk_freeze_queue_start(struct request_queue *q);
> >  void blk_mq_freeze_queue_wait(struct request_queue *q);
> >  int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
> >  				     unsigned long timeout);
> > +bool blk_mq_is_queue_frozen(struct request_queue *q);
> >  
> >  int blk_mq_map_queues(struct blk_mq_queue_map *qmap);
> >  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index 866f74261b3b..6c1351d7b73f 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -227,7 +227,7 @@ struct bio {
> >  						 * top bits REQ_OP. Use
> >  						 * accessors.
> >  						 */
> > -	unsigned short		bi_flags;	/* status, etc and bvec pool number */
> > +	unsigned int		bi_flags;	/* status, etc and bvec pool number */
> >  	unsigned short		bi_ioprio;
> >  	unsigned short		bi_write_hint;
> >  	blk_status_t		bi_status;
> > @@ -304,6 +304,8 @@ enum {
> >  				 * of this bio. */
> >  	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
> >  	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
> > +	BIO_INTERPOSED,		/* bio has been interposed and can be moved to
> > +				 * a different disk */
> >  	BIO_FLAG_LAST
> >  };
> >  
> > @@ -322,7 +324,7 @@ enum {
> >   * freed.
> >   */
> >  #define BVEC_POOL_BITS		(3)
> > -#define BVEC_POOL_OFFSET	(16 - BVEC_POOL_BITS)
> > +#define BVEC_POOL_OFFSET	(32 - BVEC_POOL_BITS)
> >  #define BVEC_POOL_IDX(bio)	((bio)->bi_flags >> BVEC_POOL_OFFSET)
> >  #if (1<< BVEC_POOL_BITS) < (BVEC_POOL_NR+1)
> >  # error "BVEC_POOL_BITS is too small"
> > diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> > index 809aaa32d53c..8094af3a3db9 100644
> > --- a/include/linux/genhd.h
> > +++ b/include/linux/genhd.h
> > @@ -134,6 +134,14 @@ struct blk_integrity {
> >  	unsigned char				tag_size;
> >  };
> >  
> > +struct blk_interposer;
> 
> This is not needed.

Rigth.

> 
> > +typedef void (*ip_submit_bio_t) (struct bio *bio);
> 
> This hides the definition of the submit callback for no good reasons that I can
> see. Since the callback has a simple interface, I would prefer this to be dropped.

May be. But the ip_submit_bio_t type is used to describe the parameter of
the blk_interposer_attach() function. I would prefer that the types of
these objects are guaranteed to match.

> 
> > +
> > +struct blk_interposer {
> > +	ip_submit_bio_t ip_submit_bio;
> > +	struct gendisk *disk;
> 
> If you fix the interface of the detach function, you should not need this field.

No, I probably won't delete this field.
This field is a good indicator of whether the detach has occurred or not.
It allows not to detach someone else's "interposer" in case of an erroneous
re-call of detach.

> 
> > +};
> > +
> >  struct gendisk {
> >  	/* major, first_minor and minors are input parameters only,
> >  	 * don't use directly.  Use disk_devt() and disk_max_parts().
> > @@ -158,6 +166,7 @@ struct gendisk {
> >  
> >  	const struct block_device_operations *fops;
> >  	struct request_queue *queue;
> > +	struct blk_interposer *interposer;
> >  	void *private_data;
> >  
> >  	int flags;
> > @@ -346,4 +355,14 @@ static inline void printk_all_partitions(void)
> >  }
> >  #endif /* CONFIG_BLOCK */
> >  
> > +/*
> > + * block layer interposer
> > + */
> > +#define blk_has_interposer(d) ((d)->interposer != NULL)
> 
> Please make this an inline function.

I prefer inline functions, but I would prefer to stay it as it defined by Hannes.
In addition, such a define is useful for determining whether the kernel supports
blk_interposer or not.

> 
> > +
> > +int blk_interposer_attach(struct gendisk *disk, struct blk_interposer *interposer,
> > +			  const ip_submit_bio_t ip_submit_bio);
> > +void blk_interposer_detach(struct blk_interposer *interposer,
> > +			   const ip_submit_bio_t ip_submit_bio);
> > +
> >  #endif /* _LINUX_GENHD_H */
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

