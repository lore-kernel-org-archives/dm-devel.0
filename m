Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73501C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:23:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B532864E77
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 19:23:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B532864E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612985020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zfNjjdOovm6mBGMw/IX7hgFQtb315R/y6h6riYg5FHE=;
	b=V6nph8dEG0DGolVjbseiym0I5H4w8xeaMP6ON1XW2ge3PXjPmVXdjrSnPkMODpZV1JLHg9
	Yw6YBrJSVY1mMdl6f+snF1gohZjZtrP9QXDO4/N3xKaPyH9ApRX41W4x5aBkruFW2oE8y4
	O9hqIrb3R1mg7ohuf3nBf+bpvBQuLUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-nZUfcp1aMomLDvUAlRGIyQ-1; Wed, 10 Feb 2021 14:23:37 -0500
X-MC-Unique: nZUfcp1aMomLDvUAlRGIyQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17119CC621;
	Wed, 10 Feb 2021 19:23:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CD2912D7E;
	Wed, 10 Feb 2021 19:23:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 003C24E58E;
	Wed, 10 Feb 2021 19:23:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AJNRZS004842 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 14:23:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6C0A19CB0; Wed, 10 Feb 2021 19:23:27 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 102C06F92A;
	Wed, 10 Feb 2021 19:23:24 +0000 (UTC)
Date: Wed, 10 Feb 2021 14:23:23 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20210210192323.GC7904@redhat.com>
References: <alpine.LRH.2.02.2102101140420.30253@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102101140420.30253@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] dm: fix deadlock when swapping to encrypted device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 10 2021 at 11:50am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> Here I'm sending the patch that fixes swapping to dm-crypt.
> 
> The logic that limits the number of in-progress I/Os was moved to generic 
> device mapper. A dm target can activate it by setting ti->limit_swap. The 
> actual limit can be set in /sys/module/dm_mod/parameters/swap_ios.
> 
> This patch only limits swap bios (those with REQ_SWAP set). I don't limit 
> other bios, because limiting them causes performance degradation due to 
> cache line bouncing when taking the semaphore - and there are no reports 
> that non-swap I/O on dm crypt causes deadlocks.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The system would deadlock when swapping to a dm-crypt device. The reason
> is that for each incoming write bio, dm-crypt allocates memory that holds
> encrypted data. These excessive allocations exhaust all the memory and the
> result is either deadlock or OOM trigger.
> 
> This patch limits the number of in-flight swap bios, so that the memory
> consumed by dm-crypt is limited. The limit is enforced if the target set
> the "limit_swap" variable and if the bio has REQ_SWAP set.
> 
> Non-swap bios are not affected becuase taking the semaphore would cause
> performance degradation.
> 
> This is similar to request-based drivers - they will also block when the
> number of requests is over the limit.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-core.h          |    4 ++
>  drivers/md/dm-crypt.c         |    1 
>  drivers/md/dm.c               |   61 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device-mapper.h |    5 +++
>  4 files changed, 71 insertions(+)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2021-02-10 15:04:53.000000000 +0100
> +++ linux-2.6/drivers/md/dm.c	2021-02-10 16:29:04.000000000 +0100

> @@ -1271,6 +1307,15 @@ static blk_qc_t __map_bio(struct dm_targ
>  	atomic_inc(&io->io_count);
>  	sector = clone->bi_iter.bi_sector;
>  
> +	if (unlikely(swap_io_limit(ti, clone))) {
> +		struct mapped_device *md = io->md;
> +		int latch = get_swap_ios();
> +		if (unlikely(latch != md->swap_ios)) {
> +			__set_swap_io_limit(md, latch);
> +		}

Don't need these curly braces...

> +		down(&md->swap_ios_semaphore);
> +	}
> +
>  	r = ti->type->map(ti, clone);
>  	switch (r) {
>  	case DM_MAPIO_SUBMITTED:

> @@ -1814,6 +1868,10 @@ static struct mapped_device *alloc_dev(i
>  	init_waitqueue_head(&md->eventq);
>  	init_completion(&md->kobj_holder.completion);
>  
> +	md->swap_ios = get_swap_ios();
> +	sema_init(&md->swap_ios_semaphore, md->swap_ios);
> +	mutex_init(&md->swap_ios_lock);
> +
>  	md->disk->major = _major;
>  	md->disk->first_minor = minor;
>  	md->disk->fops = &dm_blk_dops;

This is only applicable for bio-based DM.  But probably not worth
avoiding the setup for request-based...

> @@ -3097,6 +3155,9 @@ MODULE_PARM_DESC(reserved_bio_based_ios,
>  module_param(dm_numa_node, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(dm_numa_node, "NUMA node for DM device memory allocations");
>  
> +module_param(swap_ios, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(swap_ios, "The number of swap I/Os in flight");
> +

Can you please rename this to modparam to "swap_bios"?  And rename other
variables/members, etc (e.g. "swap_bios_semaphore", "swap_bios_lock",
etc)?

> Index: linux-2.6/include/linux/device-mapper.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device-mapper.h	2020-11-25 13:40:44.000000000 +0100
> +++ linux-2.6/include/linux/device-mapper.h	2021-02-10 15:52:54.000000000 +0100
> @@ -325,6 +325,11 @@ struct dm_target {
>  	 * whether or not its underlying devices have support.
>  	 */
>  	bool discards_supported:1;
> +
> +	/*
> +	 * Set if we need to limit the number of in-flight bios when swapping.
> +	 */
> +	bool limit_swap:1;
>  };
>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);

Please rename to "limit_swap_bios".

Other than these nits this looks good to me.
Once you send v2 I can get it staged for 5.12.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

