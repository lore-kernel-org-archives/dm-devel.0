Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51261C07E9D
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664287754;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fezsFg7CJnPt0edo7dzMJ/mpP0DKxYwB3bGbkDajQzg=;
	b=aSKu6ICGlUNCChmTSL9+UAIdolEcxZdANSo6Dy27O6ydlk4p/LqBL+mXag1FRaL7wf3NSe
	cC+AbbCm8uU9fyOrDI7zd/bqOVv1ePwaWJsB89Q8pRu7FC9DhO/sVHFnN2SUmKSXxKWHFW
	rQD+IqQpRODadBqu6VEGxNGNTbTxBks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-ZbE-Or8nO-mojoiBVmgHPw-1; Tue, 27 Sep 2022 10:09:12 -0400
X-MC-Unique: ZbE-Or8nO-mojoiBVmgHPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73D46185A7B0;
	Tue, 27 Sep 2022 14:09:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D81492022C2B;
	Tue, 27 Sep 2022 14:09:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAAC319465B5;
	Tue, 27 Sep 2022 14:09:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E99519465B1
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 14:09:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12D3B4EA4D; Tue, 27 Sep 2022 14:09:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B033A42220;
 Tue, 27 Sep 2022 14:09:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28RE96AL029742; Tue, 27 Sep 2022 10:09:06 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28RE94Kb029738; Tue, 27 Sep 2022 10:09:04 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 27 Sep 2022 10:09:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <YyqfHfadJvxbB/JC@B-P7TQMD6M-0146.local>
Message-ID: <alpine.LRH.2.02.2209271006590.28431@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <YyqfHfadJvxbB/JC@B-P7TQMD6M-0146.local>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 0/4] brd: implement discard
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 21 Sep 2022, Gao Xiang wrote:

> On Tue, Sep 20, 2022 at 01:52:38PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending second version of the brd discard patches.
> 
> That is quite interesting.
> 
> btw, something out of topic, I once had some preliminary attempt
> to add DAX support to brd since brd works as ramdisk and brd-dax
> could have the following benefits:
> 
>  - DAX can be tested without PMEM devices;
>  - ramdisk fses can be accessed without double page cache;
>  - initrd use cases then can work well without extra page cache
>    and maybe it can perform better than initramfs (without unpack
>    process).
> 
> I wrote some hack stuff but don't have more time working on it...
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=erofs/initrd-fsdax
> 
> I'm not sure if others are interested in topic though.
> 
> It would be helpful to get rid of all brd page->index use cases
> first.
> 
> Thanks,
> Gao Xiang

Hi

Ramdisk DAX was there in the past, but it was removed in the kernel 4.15.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

