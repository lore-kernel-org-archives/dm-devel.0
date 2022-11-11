Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A2EC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 14 Nov 2022 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668410020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PE9/bvKsLjIxI5+Vr0G841iKfa/kkQPS8hV5Qs0aTeM=;
	b=hDOdRdC75eDzE6JtX3hgC0kJX0zhB3i2uFi+DSF92Te1mgGCGbdUPu1SOinonGn+GtE1G9
	De5jak5CLfGeWnJPEGMeXkUPT8L75b/25pC72TG7kPC1Hj9imduMV5jjBTWiQn+uLrFfS2
	9TjW6lu8Fda0AtbMzzm7JmVehGuhjVA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-fGWWpCgSNouoLpOC6zecnA-1; Mon, 14 Nov 2022 02:13:37 -0500
X-MC-Unique: fGWWpCgSNouoLpOC6zecnA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C70800186;
	Mon, 14 Nov 2022 07:13:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C027249BB60;
	Mon, 14 Nov 2022 07:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 645DA1946589;
	Mon, 14 Nov 2022 07:13:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 442CD1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Nov 2022 18:31:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E457E200A384; Fri, 11 Nov 2022 18:31:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DCFFB20290AE
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 18:31:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB5263810D3D
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 18:31:28 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-VTRHVgwlM6C4xTB86ReC7g-1; Fri, 11 Nov 2022 13:31:25 -0500
X-MC-Unique: VTRHVgwlM6C4xTB86ReC7g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9D55D61F8B;
 Fri, 11 Nov 2022 18:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528BFC433D6;
 Fri, 11 Nov 2022 18:31:22 +0000 (UTC)
Date: Fri, 11 Nov 2022 11:31:19 -0700
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Y26U91eH7NcXTlbj@kbusch-mbp.dhcp.thefacebook.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
 <Y26PSYu2nY/AE5Xh@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y26PSYu2nY/AE5Xh@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 14 Nov 2022 07:13:32 +0000
Subject: Re: [dm-devel] [PATCHv2 0/5] fix direct io device mapper errors
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, Keith Busch <kbusch@meta.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com, mpatocka@redhat.com,
 stefanha@redhat.com, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 11, 2022 at 01:07:05PM -0500, Mike Snitzer wrote:
> On Thu, Nov 10 2022 at  1:44P -0500,
> Keith Busch <kbusch@meta.com> wrote:
> 
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The 6.0 kernel made some changes to the direct io interface to allow
> > offsets in user addresses. This based on the hardware's capabilities
> > reported in the request_queue's dma_alignment attribute.
> > 
> > dm-crypt, -log-writes and -integrity require direct io be aligned to the
> > block size. Since it was only ever using the default 511 dma mask, this
> > requirement may fail if formatted to something larger, like 4k, which
> > will result in unexpected behavior with direct-io.
> > 
> > Changes since v1: Added the same fix for -integrity and -log-writes
> > 
> > The first three were reported successfully tested by Dmitrii Tcvetkov,
> > but I don't have an official Tested-by: tag.
> > 
> >   https://lore.kernel.org/linux-block/20221103194140.06ce3d36@xps.demsh.org/T/#mba1d0b13374541cdad3b669ec4257a11301d1860
> > 
> > Keitio errors on Busch (5):
> >   block: make dma_alignment a stacking queue_limit
> >   dm-crypt: provide dma_alignment limit in io_hints
> >   block: make blk_set_default_limits() private
> >   dm-integrity: set dma_alignment limit in io_hints
> >   dm-log-writes: set dma_alignment limit in io_hints
> > 
> >  block/blk-core.c           |  1 -
> >  block/blk-settings.c       |  9 +++++----
> >  block/blk.h                |  1 +
> >  drivers/md/dm-crypt.c      |  1 +
> >  drivers/md/dm-integrity.c  |  1 +
> >  drivers/md/dm-log-writes.c |  1 +
> >  include/linux/blkdev.h     | 16 ++++++++--------
> >  7 files changed, 17 insertions(+), 13 deletions(-)
> > 
> > -- 
> > 2.30.2
> > 
> 
> There are other DM targets that override logical_block_size in their
> .io_hints hook (writecache, ebs, zoned). Have you reasoned through why
> those do _not_ need updating too?

Yeah, that's a good question. The ones that have a problem all make
assumptions about a bio's bv_offset being logical block size aligned,
and each of those is accounted for here. Everything else looks fine with
respect to handling offsets.

> Is there any risk of just introducing a finalization method in block
> core (that DM's .io_hints would call) that would ensure limits that
> are a funtion of another are always in sync?  Would avoid whack-a-mole
> issues in the future.

I don't think we can this particular limit issue. A lot of drivers and
devices can use a smaller dma_alignment than the logical block size, so
the generic block layer wouldn't really know the driver's intentions for
the relationship of these limits.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

