Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0106C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KklYI1vSuhkSDGGM8aLJy22KObexiI+Kj7EucSkjh+U=;
	b=YbvBAeeQf1e5o0KAlpmzwuAKpOB158Ub0Wv5WUY0IslmqhXCIxmwWxUyyprlez2gwZGnOu
	ZAnur7Dw2srRJDk9mDr4TQIvSGuUCRxJ0aE3kN9yRYHW05D3pMJOqluMy7TOVOjBSq3IZ6
	8MJdgiXkDzd9YXd0zFrQk13xjHMy3QY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-P5jUTxcKNiKk799vjjMexA-1; Tue, 15 Nov 2022 10:17:24 -0500
X-MC-Unique: P5jUTxcKNiKk799vjjMexA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 644AA3C1025E;
	Tue, 15 Nov 2022 15:16:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F5AE1121325;
	Tue, 15 Nov 2022 15:16:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40EBC19465A0;
	Tue, 15 Nov 2022 15:16:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F8091946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Nov 2022 18:12:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF21D40E9786; Mon, 14 Nov 2022 18:12:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D83AF40E9783
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 18:12:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD51E29AA3AE
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 18:12:34 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-qhxT21UiOCm1EBIjpG_xHg-1; Mon, 14 Nov 2022 13:12:25 -0500
X-MC-Unique: qhxT21UiOCm1EBIjpG_xHg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 484FDB810A9;
 Mon, 14 Nov 2022 18:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BD8C433D6;
 Mon, 14 Nov 2022 18:12:21 +0000 (UTC)
Date: Mon, 14 Nov 2022 11:12:18 -0700
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <Y3KFAr16W/LfJ5ms@kbusch-mbp.dhcp.thefacebook.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
 <Y26PSYu2nY/AE5Xh@redhat.com>
 <Y26U91eH7NcXTlbj@kbusch-mbp.dhcp.thefacebook.com>
 <alpine.LRH.2.21.2211140627080.25281@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2211140627080.25281@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 15 Nov 2022 15:16:01 +0000
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, Mike Snitzer <snitzer@redhat.com>,
 Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, stefanha@redhat.com, me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 14, 2022 at 06:31:36AM -0500, Mikulas Patocka wrote:
> 
> 
> On Fri, 11 Nov 2022, Keith Busch wrote:
> 
> > > There are other DM targets that override logical_block_size in their
> > > .io_hints hook (writecache, ebs, zoned). Have you reasoned through why
> > > those do _not_ need updating too?
> > 
> > Yeah, that's a good question. The ones that have a problem all make
> > assumptions about a bio's bv_offset being logical block size aligned,
> > and each of those is accounted for here. Everything else looks fine with
> > respect to handling offsets.
> 
> Unaligned bv_offset should work - because XFS is sending such bios. If you 
> compile the kernel with memory debugging, kmalloc returns unaligned 
> memory. XFS will allocate a buffer with kmalloc, test if it crosses a page 
> boundary, if not, use the buffer, if yes, free the buffer and allocate a 
> full page.
> 
> There have been device mapper problems about unaligned bv_offset in the 
> past and I have fixed them.
> 
> Unaligned bv_length is a problem for the affected targets.

kmalloc is physically contiguous, and bio's support multi-page bvecs for
these, so the bv_len is always aligned if the kmalloc is sized
correctly. The unaligned offsets become a problem with virtually
contiguous buffers since individual bv lengths might not be block size
aligned when bv offsets exist.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

