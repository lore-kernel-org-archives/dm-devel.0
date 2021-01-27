Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649C5C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 20:20:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7B5461488
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 20:20:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7B5461488
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611778828;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5R1f2Up06nUcnPPbWwWF/0Eg+f/oUIlbpuMdSAvfcyM=;
	b=CwiJT9OflLyz8mwBAPIiYoLNkIYuObPvUUTQ3+5yqVrNytuprn5CJT/QDG1k0E5/aV2WNa
	YEEb39KzHXdyP4aG1JCWZNhxEvUkszfML6yAz5a9Tlf7/NP/Q+VT3BEx0S9Sb+jy8REVkD
	GC6MF48Hy+7Vnc/S960tv6+nri6vtKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-N7Npb4uaPD2ddhIcy6swyQ-1; Wed, 27 Jan 2021 15:20:26 -0500
X-MC-Unique: N7Npb4uaPD2ddhIcy6swyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D3E780A5C0;
	Wed, 27 Jan 2021 20:20:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F09165D6A1;
	Wed, 27 Jan 2021 20:20:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA4041809CA0;
	Wed, 27 Jan 2021 20:20:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10RKGIAk006947 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 15:16:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A2C9B5C1D0; Wed, 27 Jan 2021 20:16:18 +0000 (UTC)
Received: from pick.fieldses.org (ovpn-118-194.rdu2.redhat.com [10.10.118.194])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2206D5C1BB;
	Wed, 27 Jan 2021 20:16:14 +0000 (UTC)
Received: by pick.fieldses.org (Postfix, from userid 2815)
	id 7858F120467; Wed, 27 Jan 2021 15:16:13 -0500 (EST)
Date: Wed, 27 Jan 2021 15:16:13 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20210127201613.GB1339677@pick.fieldses.org>
References: <alpine.LRH.2.02.2101131540250.10680@file01.intranet.prod.int.rdu2.redhat.com>
	<20210113213746.GH9978@pick.fieldses.org>
	<20210113230849.GA42761@pick.fieldses.org>
	<20210114224239.GA63697@pick.fieldses.org>
	<20210115155840.GA95264@pick.fieldses.org>
	<20210115164016.GB95264@pick.fieldses.org>
	<alpine.LRH.2.02.2101151142550.30218@file01.intranet.prod.int.rdu2.redhat.com>
	<20210115204319.GC95264@pick.fieldses.org>
	<20210115224735.GD95264@pick.fieldses.org>
	<alpine.LRH.2.02.2101230917360.5678@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2101230917360.5678@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm writecache: fix performance degradation
	in ssd mode
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

Sorry for the delay testing:

On Sat, Jan 23, 2021 at 09:19:56AM -0500, Mikulas Patocka wrote:
> On Fri, 15 Jan 2021, J. Bruce Fields wrote:
> 
> > Any recommendations?  I spent some time with blktrace/blkparse/btt and
> > can't make head or tails of them, I'm afraid.
> > 
> > --b.
> 
> Hi
> 
> Try this patch:

Looks good!

I applied this to Fedora's 5.10.7-200.fc33.x86_64 and timed an untar of
linux-5.9.tar.gz onto an NFS export of my dm-writecache setup and got
5m14s, where without the patch it took nearly 2 hours.

For comparison, the same untar took about 100 minutes to an export of
the backend hard drives, and 3m47s to an export of the caching device
(an Optane MEMPEK1W016GA).

I also looked again at a trace of an untar of the smaller nfs-utils
source, and saw that knfsd's vfs_sync_range()s were mainly returning in
a few hundred microseconds with the occasional latency of up to 3ms,
where before they frequently taking about 15ms.

(This is all nice because it means a $20 piece of hardware plus any old
hard drives can get me acceptable NFS server performance, whereas once
upon a time it would have required a drive array with battery-backed RAM
cache, or more recently an enterprise SSD with power loss protection).

Thanks for the persistence!  (In both senses.)

--b.

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Fix a thinko in ssd_commit_superblock. region.count is in sectors, not
> bytes. This bug doesn't corrupt data, but it causes performance
> degradation.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: dc8a01ae1dbd ("dm writecache: optimize superblock write")
> Cc: stable@vger.kernel.org	# v5.7
> Reported-by: J. Bruce Fields <bfields@redhat.com>
> 
> ---
>  drivers/md/dm-writecache.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c	2021-01-23 10:51:31.000000000 +0100
> +++ linux-2.6/drivers/md/dm-writecache.c	2021-01-23 15:16:53.000000000 +0100
> @@ -523,7 +523,7 @@ static void ssd_commit_superblock(struct
>  
>  	region.bdev = wc->ssd_dev->bdev;
>  	region.sector = 0;
> -	region.count = PAGE_SIZE;
> +	region.count = PAGE_SIZE >> SECTOR_SHIFT;
>  
>  	if (unlikely(region.sector + region.count > wc->metadata_sectors))
>  		region.count = wc->metadata_sectors - region.sector;

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

