Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640FCC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:33:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC0C6613BD
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC0C6613BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-WPehTFyaNMaCZGiDFAFFrQ-1; Fri, 21 May 2021 02:33:48 -0400
X-MC-Unique: WPehTFyaNMaCZGiDFAFFrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBBCF107ACC7;
	Fri, 21 May 2021 06:33:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB5E5D76F;
	Fri, 21 May 2021 06:33:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2008C180B463;
	Fri, 21 May 2021 06:33:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L6Xfn9031327 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:33:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7111D212AA99; Fri, 21 May 2021 06:33:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C2B7212AAA5
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:33:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 260DB857D08
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:33:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-346-1SscrpJuON2ac395jUamHA-1;
	Fri, 21 May 2021 02:33:37 -0400
X-MC-Unique: 1SscrpJuON2ac395jUamHA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C9DB4AC87;
	Fri, 21 May 2021 06:15:41 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-13-hch@lst.de>
From: Coly Li <colyli@suse.de>
Message-ID: <d4f1c005-2ce0-51b5-c861-431f0ffb3dcf@suse.de>
Date: Fri, 21 May 2021 14:15:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-13-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14L6Xfn9031327
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, linux-m68k@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	linux-nvme@lists.infradead.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Joshua Morris <josh.h.morris@us.ibm.com>,
	linux-s390@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Matias Bjorling <mb@lightnvm.io>, Nitin Gupta <ngupta@vflare.org>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-xtensa@linux-xtensa.org,
	Alex Dubov <oakad@yahoo.com>, Heiko Carstens <hca@linux.ibm.com>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org, drbd-dev@tron.linbit.com,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>, linux-mmc@vger.kernel.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 12/26] bcache: convert to
	blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/21/21 1:51 PM, Christoph Hellwig wrote:
> Convert the bcache driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/bcache/super.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bea8c4429ae8..185246a0d855 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -890,13 +890,9 @@ static void bcache_device_free(struct bcache_device *d)
>  		if (disk_added)
>  			del_gendisk(disk);
>  
> -		if (disk->queue)
> -			blk_cleanup_queue(disk->queue);
> -
> +		blk_cleanup_disk(disk);
>  		ida_simple_remove(&bcache_device_idx,
>  				  first_minor_to_idx(disk->first_minor));
> -		if (disk_added)
> -			put_disk(disk);

The  above 2 lines are added on purpose to prevent an refcount
underflow. It is from commit 86da9f736740 ("bcache: fix refcount
underflow in bcache_device_free()").

Maybe add a parameter to blk_cleanup_disk() or checking (disk->flags &
GENHD_FL_UP) inside blk_cleanup_disk() ?

Coly Li


>  	}
>  
>  	bioset_exit(&d->bio_split);
> @@ -946,7 +942,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto err;
>  
> -	d->disk = alloc_disk(BCACHE_MINORS);
> +	d->disk = blk_alloc_disk(NUMA_NO_NODE);
>  	if (!d->disk)
>  		goto err;
>  
> @@ -955,14 +951,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= idx_to_first_minor(idx);
> +	d->disk->minors		= BCACHE_MINORS;
>  	d->disk->fops		= ops;
>  	d->disk->private_data	= d;
>  
> -	q = blk_alloc_queue(NUMA_NO_NODE);
> -	if (!q)
> -		return -ENOMEM;
> -
> -	d->disk->queue			= q;
> +	q = d->disk->queue;
>  	q->limits.max_hw_sectors	= UINT_MAX;
>  	q->limits.max_sectors		= UINT_MAX;
>  	q->limits.max_segment_size	= UINT_MAX;
> 

The rested looks fine to me.

Thanks.

Coly Li


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

