Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67641C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667493207;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UQyefovyi4WN/FAWT3nU6MYROHaGZzLZVtcxLy0YJxg=;
	b=W763rwQQ/oumYiagjtpT0IPz18cWY1LZteJLcwb4dmkX9idI7/OGeLbfa5Bj6+Xg3x2vky
	5pQ6b5pRE746/P5mJC+CrGMZ1UGs0SDeN7/KS9rSsrN/mITjZwbsbRhbVSIsRwYryFI3pP
	nNJj/me8N1R+yRgYG/3En/nUVvaW6mY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-2uatd-6MPdKpouZ2oGSVow-1; Thu, 03 Nov 2022 12:33:24 -0400
X-MC-Unique: 2uatd-6MPdKpouZ2oGSVow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E4E29AA3BF;
	Thu,  3 Nov 2022 16:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DFFB2024CC0;
	Thu,  3 Nov 2022 16:33:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32D861946597;
	Thu,  3 Nov 2022 16:33:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17A0B1946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:33:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED7F71415139; Thu,  3 Nov 2022 16:33:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7F301415123;
 Thu,  3 Nov 2022 16:33:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A3GXKK1011752; Thu, 3 Nov 2022 12:33:20 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A3GXJEQ011749; Thu, 3 Nov 2022 12:33:19 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 3 Nov 2022 12:33:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Keith Busch <kbusch@meta.com>
In-Reply-To: <20221103152559.1909328-1-kbusch@meta.com>
Message-ID: <alpine.LRH.2.21.2211031224060.10758@file01.intranet.prod.int.rdu2.redhat.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 dm-devel@redhat.com, stefanha@redhat.com, Keith Busch <kbusch@kernel.org>,
 me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

The patchset seems OK - but dm-integrity also has a limitation that the 
bio vectors must be aligned on logical block size.

dm-writecache and dm-verity seem to handle unaligned bioset, but you 
should check them anyway.

I'm not sure about dm-log-writes.

Mikulas


On Thu, 3 Nov 2022, Keith Busch wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> The 6.0 kernel made some changes to the direct io interface to allow
> offsets in user addresses. This based on the hardware's capabilities
> reported in the request_queue's dma_alignment attribute.
> 
> dm-crypt requires direct io be aligned to the block size. Since it was
> only ever using the default 511 dma mask, this requirement may fail if
> formatted to something larger, like 4k, which will result in unexpected
> behavior with direct-io.
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
> -- 
> 2.30.2
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

