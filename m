Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FD3C6FA86
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 07:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664435223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SZ6lOBDIiw6Zv4TjFHHFeQgoizaVEC+Ia4UAFWcHr78=;
	b=XfsjvTXA7vYmtIGaleip7miqm2RQ2RqMmcpd/+i7b/xhD0xqjLiAiBiWGVeyG1wOMrGxbr
	G06U1JAfOIZD/N9gKDpIl97+eP5JQfqNyBHBDSaD30Z8zK5EXtWeeVqkOizmOeZhIkUxdQ
	EhcFVi92uBef10x41GGFJeTE90UzzGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-DEH8Qv2HNDScifI9Jx_V9g-1; Thu, 29 Sep 2022 03:07:01 -0400
X-MC-Unique: DEH8Qv2HNDScifI9Jx_V9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2FF81C08977;
	Thu, 29 Sep 2022 07:06:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C143840C6EC2;
	Thu, 29 Sep 2022 07:06:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB4E81946A45;
	Thu, 29 Sep 2022 07:06:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87C2F1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Sep 2022 01:08:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3927342238; Wed, 28 Sep 2022 01:08:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3180142221
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 01:08:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 102DC380670B
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 01:08:51 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
 (out30-43.freemail.mail.aliyun.com [115.124.30.43]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256)
 id us-mta-296-WZ1Pe7ixP92W5dvNru8VyQ-1; Tue, 27 Sep 2022 21:08:49 -0400
X-MC-Unique: WZ1Pe7ixP92W5dvNru8VyQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VQtdSE5_1664327018
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VQtdSE5_1664327018) by smtp.aliyun-inc.com;
 Wed, 28 Sep 2022 09:03:40 +0800
Date: Wed, 28 Sep 2022 09:03:38 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YzOdau9e5HYcjQKf@B-P7TQMD6M-0146.local>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Zdenek Kabelac <zkabelac@redhat.com>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <YyqfHfadJvxbB/JC@B-P7TQMD6M-0146.local>
 <alpine.LRH.2.02.2209271006590.28431@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209271006590.28431@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 29 Sep 2022 07:06:56 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 27, 2022 at 10:09:04AM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 21 Sep 2022, Gao Xiang wrote:
> 
> > On Tue, Sep 20, 2022 at 01:52:38PM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > Here I'm sending second version of the brd discard patches.
> > 
> > That is quite interesting.
> > 
> > btw, something out of topic, I once had some preliminary attempt
> > to add DAX support to brd since brd works as ramdisk and brd-dax
> > could have the following benefits:
> > 
> >  - DAX can be tested without PMEM devices;
> >  - ramdisk fses can be accessed without double page cache;
> >  - initrd use cases then can work well without extra page cache
> >    and maybe it can perform better than initramfs (without unpack
> >    process).
> > 
> > I wrote some hack stuff but don't have more time working on it...
> > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=erofs/initrd-fsdax
> > 
> > I'm not sure if others are interested in topic though.
> > 
> > It would be helpful to get rid of all brd page->index use cases
> > first.
> > 
> > Thanks,
> > Gao Xiang
> 
> Hi
> 
> Ramdisk DAX was there in the past, but it was removed in the kernel 4.15.

Hi Mikulas!

Thanks for pointing out! I didn't realize that, although I think if we really
use brd driver in production, enabling DAX support for brd is much better to
remove double caching so that ramdisk can become a real ramdisk for most
regular files.

I have no idea how other people think about ramdisk DAX, or brd is just a
stuff for testing only now.  If it behaves like this, sorry about the
noise.

Thanks,
Gao Xiang

> 
> Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

