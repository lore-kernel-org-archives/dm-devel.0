Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0E4C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 00:39:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C445D64EDB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 00:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C445D64EDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614127183;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=diQTx0Y2I+jWK0uJv5aiWGrNc1JEeNAjMdhnYoBqSPE=;
	b=cv5TGrN9HmMs7+MFH5XTHjgqvu35z2IICQdQ5MdVHDI6tfv4ABKKbJn7zv1WQtQoKbZ9ui
	+2HxfOvJCwkLBXmQB82TLAnuKAPMKC1OHVeYkXKKMWvUNjqe3ejgdUhoF2IBGIE9O9gtm9
	6AnSQPUnbKZCuPSRXKGF3zYbIO3OcdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-ABNUPGM2MKSR5as1vGD1qA-1; Tue, 23 Feb 2021 19:39:41 -0500
X-MC-Unique: ABNUPGM2MKSR5as1vGD1qA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A701E56D;
	Wed, 24 Feb 2021 00:39:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3484A19725;
	Wed, 24 Feb 2021 00:39:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1168E4E58E;
	Wed, 24 Feb 2021 00:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O0dVV5025767 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 19:39:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CF7F6FEF0; Wed, 24 Feb 2021 00:39:31 +0000 (UTC)
Received: from T590 (ovpn-12-117.pek2.redhat.com [10.72.12.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3B66F998;
	Wed, 24 Feb 2021 00:39:21 +0000 (UTC)
Date: Wed, 24 Feb 2021 08:39:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YDWgNbz9ZX2Rjc+X@T590>
References: <alpine.LRH.2.02.2102221312070.5407@file01.intranet.prod.int.rdu2.redhat.com>
	<YDSwyrLeiP/fKgZH@T590>
	<alpine.LRH.2.02.2102231125170.27597@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102231125170.27597@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mike Snitzer <msnitzer@redhat.com>,
	Marian Csontos <mcsontos@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] blk-settings: make sure that max_sectors
 is aligned on "logical_block_size" boundary
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 23, 2021 at 11:28:27AM -0500, Mikulas Patocka wrote:
> 
> 
> On Tue, 23 Feb 2021, Ming Lei wrote:
> 
> > I'd suggest to add a helper(such as, blk_round_down_sectors()) to round_down each
> > one.
> 
> Yes - Here I'm sending the updated patch.
> 
> > -- 
> > Ming
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> We get I/O errors when we run md-raid1 on the top of dm-integrity on the
> top of ramdisk.
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb
> 
> The ramdisk device has logical_block_size 512 and max_sectors 255. The
> dm-integrity device uses logical_block_size 4096 and it doesn't affect the
> "max_sectors" value - thus, it inherits 255 from the ramdisk. So, we have
> a device with max_sectors not aligned on logical_block_size.
> 
> The md-raid device sees that the underlying leg has max_sectors 255 and it
> will split the bios on 255-sector boundary, making the bios unaligned on
> logical_block_size.
> 
> In order to fix the bug, we round down max_sectors to logical_block_size.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  block/blk-settings.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Index: linux-2.6/block/blk-settings.c
> ===================================================================
> --- linux-2.6.orig/block/blk-settings.c	2021-02-23 17:18:59.000000000 +0100
> +++ linux-2.6/block/blk-settings.c	2021-02-23 17:23:58.000000000 +0100
> @@ -481,6 +481,14 @@ void blk_queue_io_opt(struct request_que
>  }
>  EXPORT_SYMBOL(blk_queue_io_opt);
>  
> +static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lbs)
> +{
> +	sectors = round_down(sectors, lbs >> SECTOR_SHIFT);
> +	if (sectors < PAGE_SIZE >> SECTOR_SHIFT)
> +		sectors = PAGE_SIZE >> SECTOR_SHIFT;
> +	return sectors;
> +}
> +
>  /**
>   * blk_stack_limits - adjust queue_limits for stacked devices
>   * @t:	the stacking driver limits (top device)
> @@ -607,6 +615,10 @@ int blk_stack_limits(struct queue_limits
>  		ret = -1;
>  	}
>  
> +	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
> +	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
> +	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);
> +
>  	/* Discard alignment and granularity */
>  	if (b->discard_granularity) {
>  		alignment = queue_limit_discard_alignment(b, start);

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

