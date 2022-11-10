Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05204C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Nov 2022 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668104660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5V6AWUhj3K/C7fM0kWfOE2lIeIkWbdQA4cVnBmr7Qx4=;
	b=LXC0lpP2gUJgfn42t/717YmQxUF0o1bvIBRWhu8j6kzkvUU2RhHlvZUuAzdXA5O4oRNHJ7
	2787bgRUmNjK/8D+JTvbFyKeSBbxFq7InqNSb7GjL1sV5uemxUagocFjdBXVgv7Eva7Ykv
	AxW5EUmiN0iFYXuRPB7gU/TQEIB9IMY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-MijbmB2uNCG7GQ3Wdecg_Q-1; Thu, 10 Nov 2022 13:24:16 -0500
X-MC-Unique: MijbmB2uNCG7GQ3Wdecg_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A95B185A79C;
	Thu, 10 Nov 2022 18:24:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD42540C6F73;
	Thu, 10 Nov 2022 18:24:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 972221946589;
	Thu, 10 Nov 2022 18:24:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B5261946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Nov 2022 18:24:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DD3EC111F3C7; Thu, 10 Nov 2022 18:24:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D5AC51120ABB
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:24:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5BCE8027EA
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:24:12 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-vCr3sbknN1m9xrnDqFXvSg-1; Thu, 10 Nov 2022 13:24:09 -0500
X-MC-Unique: vCr3sbknN1m9xrnDqFXvSg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BB012B8224F;
 Thu, 10 Nov 2022 18:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E8AC433D6;
 Thu, 10 Nov 2022 18:24:05 +0000 (UTC)
Date: Thu, 10 Nov 2022 18:24:03 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@meta.com>
Message-ID: <Y21BwxCkeaONcYK5@gmail.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
MIME-Version: 1.0
In-Reply-To: <20221103152559.1909328-1-kbusch@meta.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 mpatocka@redhat.com, stefanha@redhat.com, Keith Busch <kbusch@kernel.org>,
 me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 03, 2022 at 08:25:56AM -0700, Keith Busch wrote:
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

Hi Keith, can you send out an updated version of this patch series that
addresses the feedback?

I'd really like for this bug to be fixed before 6.1 is released, so that there
isn't a known bug in STATX_DIOALIGN already upon release.

Thanks!

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

