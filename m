Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42962C4167E
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 06:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667544614;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=738lKewMaD/aAXigNG4YfxZOg54MY5XLJD8PPaks3Cw=;
	b=Qsc0U91RTI4S6dGSHGu2AXsYJQ64G2mOjBwRVetjzljx03DcPvWZNVtAHCVqjcF9/YfC2/
	ismdVwfaDPxr61aPIFvlntJZX2u7dzlDjKUhEVsqODOtcCHAtRo8VdJuKzOJDoMMvm2w1G
	O8kqIVpSheZoDt1WltVpE70gL3ILjJY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-AJyrqAYENyKfzgztRr3lPA-1; Fri, 04 Nov 2022 02:50:10 -0400
X-MC-Unique: AJyrqAYENyKfzgztRr3lPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B504B85A5A6;
	Fri,  4 Nov 2022 06:50:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0F3111E3E6;
	Fri,  4 Nov 2022 06:50:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 91B26194705B;
	Fri,  4 Nov 2022 06:50:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D97301946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:41:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9817492B27; Thu,  3 Nov 2022 16:41:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB19492B28
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:41:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45D57805AC5
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:41:52 +0000 (UTC)
Received: from hermod.demsh.org (hermod.demsh.org [45.140.147.175]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-596-nX4hGud-PtGp0BYCX0iROQ-1; Thu,
 03 Nov 2022 12:41:48 -0400
X-MC-Unique: nX4hGud-PtGp0BYCX0iROQ-1
Received: from xps.demsh.org (algiz.demsh.org [94.103.82.47])
 by hermod.demsh.org (OpenSMTPD) with ESMTPSA id c712456e
 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO) auth=yes user=me; 
 Thu, 3 Nov 2022 16:41:43 +0000 (UTC)
Date: Thu, 3 Nov 2022 19:41:40 +0300
From: Dmitrii Tcvetkov <me@demsh.org>
To: Keith Busch <kbusch@meta.com>
Message-ID: <20221103194140.06ce3d36@xps.demsh.org>
In-Reply-To: <20221103152559.1909328-1-kbusch@meta.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 04 Nov 2022 06:50:05 +0000
Subject: Re: [dm-devel] [PATCH 0/3] fix direct io errors on dm-crypt
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, stefanha@redhat.com,
 Keith Busch <kbusch@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 3 Nov 2022 08:25:56 -0700
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> The 6.0 kernel made some changes to the direct io interface to allow
> offsets in user addresses. This based on the hardware's capabilities
> reported in the request_queue's dma_alignment attribute.
> 
> dm-crypt requires direct io be aligned to the block size. Since it was
> only ever using the default 511 dma mask, this requirement may fail if
> formatted to something larger, like 4k, which will result in
> unexpected behavior with direct-io.
> 
> There are two parts to fixing this:
> 
>   First, the attribute needs to be moved to the queue_limit so that it
>   can properly stack with device mappers.
> 
>   Second, dm-crypt provides its minimum required limit to match the
>   logical block size.
> 
> Keith Busch (3):
>   block: make dma_alignment a stacking queue_limit
>   dm-crypt: provide dma_alignment limit in io_hints
>   block: make blk_set_default_limits() private
> 
>  block/blk-core.c       |  1 -
>  block/blk-settings.c   |  9 +++++----
>  block/blk.h            |  1 +
>  drivers/md/dm-crypt.c  |  1 +
>  include/linux/blkdev.h | 16 ++++++++--------
>  5 files changed, 15 insertions(+), 13 deletions(-)
> 

Applied on top 6.1-rc3, after that issue[1] doesn't reproduce.

[1] https://lore.kernel.org/linux-block/20221101001558.648ee024@xps.demsh.org/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

