Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC0AC63697
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 14:39:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0ACFA24695
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 14:39:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ACFA24695
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-mU-tJzBHPRid2C1D2ILy0Q-1; Thu, 19 Nov 2020 09:39:42 -0500
X-MC-Unique: mU-tJzBHPRid2C1D2ILy0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCC35801AB5;
	Thu, 19 Nov 2020 14:39:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 573A860BE2;
	Thu, 19 Nov 2020 14:39:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08B64180954D;
	Thu, 19 Nov 2020 14:39:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJEdUIS013173 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 09:39:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F3F02026D11; Thu, 19 Nov 2020 14:39:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A9322026D5D
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 14:39:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DF0D80120A
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 14:39:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-502-T2gDxoMWN-m6WWmxDwS0TQ-1;
	Thu, 19 Nov 2020 09:39:23 -0500
X-MC-Unique: T2gDxoMWN-m6WWmxDwS0TQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3CBF6AA4F;
	Thu, 19 Nov 2020 14:39:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id E1C061E130B; Thu, 19 Nov 2020 15:39:21 +0100 (CET)
Date: Thu, 19 Nov 2020 15:39:21 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119143921.GX1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-16-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-16-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 15/20] block: merge struct block_device and
 struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:55, Christoph Hellwig wrote:
> Instead of having two structures that represent each block device with
> different lift time rules merged them into a single one.  This also
            ^^^ :) life     ^^^^ merge

> greatly simplifies the reference counting rules, as we can use the inode
> reference count as the main reference count for the new struct
> block_device, with the device model reference front ending it for device
> model interaction.  The percpu refcount in struct hd_struct is entirely
> gone given that struct block_device must be opened and thus valid for
> the duration of the I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch is kind of difficult to review due to the size of mostly
mechanical changes mixed with not completely mechanical changes. Can we
perhaps split out the mechanical bits? E.g. the rq->part => rq->bdev
renaming is mechanical and notable part of the patch. Similarly the
part->foo => part->bd_foo bits...

Also I'm kind of wondering: AFAIU the new lifetime rules, gendisk holds
bdev reference and bdev is created on gendisk allocation so bdev lifetime is
strictly larger than gendisk lifetime. But what now keeps bdev->bd_disk
reference safe in presence device hot unplug? In most cases we are still
protected by gendisk reference taken in __blkdev_get() but how about
disk->lookup_sem and disk->flags dereferences before we actually grab the
reference?

Also I find it rather non-obvious (although elegant ;) that bdev->bd_device
rules the lifetime of gendisk. Can you perhaps explain this in the
changelog and probably also add somewhere to source a documentation about
the new lifetime rules?

> diff --git a/block/blk.h b/block/blk.h
> index 09cee7024fb43e..90dd2047c6cd29 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -215,7 +215,15 @@ static inline void elevator_exit(struct request_queue *q,
>  	__elevator_exit(q, e);
>  }
>  
> -struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
> +static inline struct block_device *__bdget_disk(struct gendisk *disk,
> +		int partno)
> +{
> +	struct disk_part_tbl *ptbl = rcu_dereference(disk->part_tbl);
> +
> +	if (unlikely(partno < 0 || partno >= ptbl->len))
> +		return NULL;
> +	return rcu_dereference(ptbl->part[partno]);
> +}

I understand this is lower-level counterpart of bdget_disk() but it is
confusing to me that this has 'bdget' in the name and returns no bdev
reference. Can we call it like __bdev_from_disk() or something like that?

>  
>  ssize_t part_size_show(struct device *dev, struct device_attribute *attr,
>  		char *buf);


									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

