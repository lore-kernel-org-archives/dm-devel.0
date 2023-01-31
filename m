Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4065C63797
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 23:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675209524;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dY7X3J46DWrMlLXKr5mrpvQ7tGaJuSq9oZOU7maXFBo=;
	b=TnokQceAl66osG46CEeUhlVTKhktsKPMSha6cTzTnash/KBEFr/56ojlAeUnSwGbHaahhT
	tM1sXpIA3Un7BLLUJkivSbRA3o5T6odaQXrT+GWcUKnP5ry8AAwPs4RjRFjvfP7uEkdDPB
	fqkAtrUg0TN8fbEhzmiYACbPssTbEJU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-YVc8r6cQNqitWv0C-q6JxA-1; Tue, 31 Jan 2023 18:58:40 -0500
X-MC-Unique: YVc8r6cQNqitWv0C-q6JxA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C20873C025D1;
	Tue, 31 Jan 2023 23:58:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B71B6492B05;
	Tue, 31 Jan 2023 23:58:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 617011946589;
	Tue, 31 Jan 2023 23:58:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 33BAF1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 23:58:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F4CA175A2; Tue, 31 Jan 2023 23:58:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0703B43FB3
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 23:58:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D980F380670A
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 23:58:34 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-WjLMOPH2N3K9qR-mA53l7g-1; Tue, 31 Jan 2023 18:58:30 -0500
X-MC-Unique: WjLMOPH2N3K9qR-mA53l7g-1
Received: by mail-qt1-f171.google.com with SMTP id c2so1958540qtw.5
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 15:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5vIQf0a6iEAUT12k4trn79P1fVoQICHB1aSjSKSg7wk=;
 b=ER7jgfmzJ2PQenZ4dEsqV04VfAgUDKR0ydIYI9FMESuKt/Rc9NfPrKCo+6odAmQ7Ii
 boOGKJlnpaTeuRLeqGHNju+TPPgZlRpi/GRL/BOTf1T5G0RteA9LevRVp5N97F1pK2i0
 MDb+zUqFWbIxAY8evUHa8Vrx1iMv5WpIVVqOK1v45iE4q9JtE0krtjAtwSZkwi6qoODX
 Zt3Aq68xQxsaNvkvDeempRbtXThVWBe5aH7XyqdZwTdSINPwwTxbOaAzLnAmzWW5sz2t
 RCNauxf/xGXHAoB1+5uDeWX/IPUSP0R/Fg2SY9Y9nNyT5OhXRkSt/lfSzQYi2QmZgOL+
 mojw==
X-Gm-Message-State: AO0yUKUW3YLw9pP+GcGdG2+3P+NAo0dVO/7TCzaPVuROvEb6eNM3OGwj
 I3uj6HeetXFBzKL3wXzII6JX0A4=
X-Google-Smtp-Source: AK7set9pRgnf40Mb2ZHzeSYJaZfnDJ+8lSeeU97IXIqs4L3d5aGqi7bIP2E3qtPVhbAnyYRyZOGPzw==
X-Received: by 2002:ac8:57d6:0:b0:3b8:6cd5:eda with SMTP id
 w22-20020ac857d6000000b003b86cd50edamr1086689qta.47.1675209509939; 
 Tue, 31 Jan 2023 15:58:29 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 e24-20020ac80118000000b003b848759ed8sm6729656qtg.47.2023.01.31.15.58.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 31 Jan 2023 15:58:29 -0800 (PST)
Date: Tue, 31 Jan 2023 18:58:28 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <Y9mrJJDFnMNWR7Vn@redhat.com>
References: <20221209142331.26395-1-sergei.shtepa@veeam.com>
 <20221209142331.26395-3-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <20221209142331.26395-3-sergei.shtepa@veeam.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 02/21] block,
 blkfilter: Block Device Filtering Mechanism
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
Cc: axboe@kernel.dk, linux-doc@vger.kernel.org, corbet@lwn.net,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 09 2022 at  9:23P -0500,
Sergei Shtepa <sergei.shtepa@veeam.com> wrote:

> Allows to attach block device filters to the block devices. Kernel
> modules can use this functionality to extend the capabilities of the
> block layer.
> 
> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> ---
>  block/bdev.c              | 70 ++++++++++++++++++++++++++++++++++++++
>  block/blk-core.c          | 19 +++++++++--
>  include/linux/blk_types.h |  2 ++
>  include/linux/blkdev.h    | 71 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 160 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index d699ecdb3260..b820178824b2 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -427,6 +427,7 @@ static void init_once(void *data)
>  
>  static void bdev_evict_inode(struct inode *inode)
>  {
> +	bdev_filter_detach(I_BDEV(inode));
>  	truncate_inode_pages_final(&inode->i_data);
>  	invalidate_inode_buffers(inode); /* is it needed here? */
>  	clear_inode(inode);
> @@ -502,6 +503,7 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>  		return NULL;
>  	}
>  	bdev->bd_disk = disk;
> +	bdev->bd_filter = NULL;
>  	return bdev;
>  }
>  
> @@ -1092,3 +1094,71 @@ void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
>  
>  	blkdev_put_no_open(bdev);
>  }
> +
> +/**
> + * bdev_filter_attach - Attach the filter to the original block device.
> + * @bdev:
> + *	Block device.
> + * @flt:
> + *	Filter that needs to be attached to the block device.
> + *
> + * Before adding a filter, it is necessary to initialize &struct bdev_filter
> + * using a bdev_filter_init() function.
> + *
> + * The bdev_filter_detach() function allows to detach the filter from the block
> + * device.
> + *
> + * Return: 0 if succeeded, or -EALREADY if the filter already exists.
> + */
> +int bdev_filter_attach(struct block_device *bdev,
> +				     struct bdev_filter *flt)
> +{
> +	int ret = 0;
> +
> +	blk_mq_freeze_queue(bdev->bd_queue);
> +	blk_mq_quiesce_queue(bdev->bd_queue);
> +
> +	if (bdev->bd_filter)
> +		ret = -EALREADY;
> +	else
> +		bdev->bd_filter = flt;
> +
> +	blk_mq_unquiesce_queue(bdev->bd_queue);
> +	blk_mq_unfreeze_queue(bdev->bd_queue);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(bdev_filter_attach);
> +
> +/**
> + * bdev_filter_detach - Detach the filter from the block device.
> + * @bdev:
> + *	Block device.
> + *
> + * The filter should be added using the bdev_filter_attach() function.
> + *
> + * Return: 0 if succeeded, or -ENOENT if the filter was not found.
> + */
> +int bdev_filter_detach(struct block_device *bdev)
> +{
> +	int ret = 0;
> +	struct bdev_filter *flt = NULL;
> +
> +	blk_mq_freeze_queue(bdev->bd_queue);
> +	blk_mq_quiesce_queue(bdev->bd_queue);
> +
> +	flt = bdev->bd_filter;
> +	if (flt)
> +		bdev->bd_filter = NULL;
> +	else
> +		ret = -ENOENT;
> +
> +	blk_mq_unquiesce_queue(bdev->bd_queue);
> +	blk_mq_unfreeze_queue(bdev->bd_queue);
> +
> +	if (flt)
> +		bdev_filter_put(flt);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(bdev_filter_detach);

What about bio-based devices? (DM, MD, etc)

DM uses freeze_bdev() and thaw_bdev(), seems like you're missing some
work here.

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5487912befe8..284b295a7b23 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -678,9 +678,24 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>  	 * to collect a list of requests submited by a ->submit_bio method while
>  	 * it is active, and then process them after it returned.
>  	 */
> -	if (current->bio_list)
> +	if (current->bio_list) {
>  		bio_list_add(&current->bio_list[0], bio);
> -	else if (!bio->bi_bdev->bd_disk->fops->submit_bio)
> +		return;
> +	}
> +
> +	if (bio->bi_bdev->bd_filter && !bio_flagged(bio, BIO_FILTERED)) {

Shouldn't this be: if (unlikely(...))?

But that obviously assumes a fair amount about the only consumer
(temporary filter that lasts as long as it takes to do a backup).

> +		bool pass;
> +
> +		pass = bio->bi_bdev->bd_filter->fops->submit_bio_cb(bio);
> +		bio_set_flag(bio, BIO_FILTERED);
> +		if (!pass) {
> +			bio->bi_status = BLK_STS_OK;
> +			bio_endio(bio);
> +			return;
> +		}
> +	}
> +
> +	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
>  		__submit_bio_noacct_mq(bio);
>  	else
>  		__submit_bio_noacct(bio);

And you currently don't allow for blkfilter to be involved if a bio
recurses (which is how bio splitting works now).  Not sure it
matters, just mentioning it...

But taking a step back, in the hopes of stepping out of your way:

Myself and others on the DM team (past and present) have always hoped
all block devices could have the flexibility of DM. It was that hope
that caused my frustration when I first saw your blkfilter approach.

But I was too idealistic that a byproduct of your efforts
(blk-interposer before and blkfilter now) would usher in _all_ block
devices being able to comprehensively change their identity (and IO
processing) like DM enjoys.

DM showcases all the extra code needed to achieve its extreme IO
remapping and stacking flexibilty -- I don't yet see a way to distill
the essence of what DM achieves without imposing too much on all block
core.

So I do think blkfilter is a pragmatic way to achieve your goals.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

