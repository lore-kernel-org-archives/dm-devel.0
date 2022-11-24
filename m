Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433B6C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 24 Nov 2022 00:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669248268;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zWAgZwMD2vwWuRUKCEJlaEU3uUGQ/3nHxpMTyna3I0U=;
	b=JfxrQutjuZ6CSuRu6cg1qDma8dKuiNLgdkFwHIVfhdaTy/xvFJXZxVQOoDjJ/ga0YQe/lW
	qpf+NHu41tMCdwCVggT/lo7gH/YYUh2emJvODZbwJqhpFTcTExEP/CDd3/yrbLznyB81kr
	/RxpPYr55bj4qh6xEjGGcNVugvlxqvQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-vbNB8CLDPqa410a0zYA4GA-1; Wed, 23 Nov 2022 19:04:25 -0500
X-MC-Unique: vbNB8CLDPqa410a0zYA4GA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0108D811E87;
	Thu, 24 Nov 2022 00:04:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E5BF1415114;
	Thu, 24 Nov 2022 00:04:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E74901946589;
	Thu, 24 Nov 2022 00:04:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50A1E1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Nov 2022 00:04:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C300C1908A; Thu, 24 Nov 2022 00:04:20 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DF81C15BB1;
 Thu, 24 Nov 2022 00:04:03 +0000 (UTC)
Date: Thu, 24 Nov 2022 08:03:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <Y3607N6lDRK6WU7/@T590>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061017epcas5p246a589e20eac655ac340cfda6028ff35@epcas5p2.samsung.com>
 <20221123055827.26996-3-nj.shetty@samsung.com>
 <Y33UAp6ncSPO84XI@T590> <20221123100712.GA26377@test-zns>
MIME-Version: 1.0
In-Reply-To: <20221123100712.GA26377@test-zns>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5 02/10] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 agk@redhat.com, naohiro.aota@wdc.com, sagi@grimberg.me, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, james.smart@broadcom.com,
 p.raghav@samsung.com, kch@nvidia.com, anuj20.g@samsung.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk,
 kbusch@kernel.org, axboe@kernel.dk, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jth@kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 23, 2022 at 03:37:12PM +0530, Nitesh Shetty wrote:
> On Wed, Nov 23, 2022 at 04:04:18PM +0800, Ming Lei wrote:
> > On Wed, Nov 23, 2022 at 11:28:19AM +0530, Nitesh Shetty wrote:
> > > Introduce blkdev_issue_copy which supports source and destination bdevs,
> > > and an array of (source, destination and copy length) tuples.
> > > Introduce REQ_COPY copy offload operation flag. Create a read-write
> > > bio pair with a token as payload and submitted to the device in order.
> > > Read request populates token with source specific information which
> > > is then passed with write request.
> > > This design is courtesy Mikulas Patocka's token based copy
> > 
> > I thought this patchset is just for enabling copy command which is
> > supported by hardware. But turns out it isn't, because blk_copy_offload()
> > still submits read/write bios for doing the copy.
> > 
> > I am just wondering why not let copy_file_range() cover this kind of copy,
> > and the framework has been there.
> > 
> 
> Main goal was to enable copy command, but community suggested to add
> copy emulation as well.
> 
> blk_copy_offload - actually issues copy command in driver layer.
> The way read/write BIOs are percieved is different for copy offload.
> In copy offload we check REQ_COPY flag in NVMe driver layer to issue
> copy command. But we did missed it to add in other driver's, where they
> might be treated as normal READ/WRITE.
> 
> blk_copy_emulate - is used if we fail or if device doesn't support native
> copy offload command. Here we do READ/WRITE. Using copy_file_range for
> emulation might be possible, but we see 2 issues here.
> 1. We explored possibility of pulling dm-kcopyd to block layer so that we 
> can readily use it. But we found it had many dependecies from dm-layer.
> So later dropped that idea.

Is it just because dm-kcopyd supports async copy? If yes, I believe we
can reply on io_uring for implementing async copy_file_range, which will
be generic interface for async copy, and could get better perf.

> 2. copy_file_range, for block device atleast we saw few check's which fail
> it for raw block device. At this point I dont know much about the history of
> why such check is present.

Got it, but IMO the check in generic_copy_file_checks() can be
relaxed to cover blkdev cause splice does support blkdev.

Then your bdev offload copy work can be simplified into:

1) implement .copy_file_range for def_blk_fops, suppose it is
blkdev_copy_file_range()

2) inside blkdev_copy_file_range()

- if the bdev supports offload copy, just submit one bio to the device,
and this will be converted to one pt req to device

- otherwise, fallback to generic_copy_file_range()

> 
> > When I was researching pipe/splice code for supporting ublk zero copy[1], I
> > have got idea for async copy_file_range(), such as: io uring based
> > direct splice, user backed intermediate buffer, still zero copy, if these
> > ideas are finally implemented, we could get super-fast generic offload copy,
> > and bdev copy is really covered too.
> > 
> > [1] https://lore.kernel.org/linux-block/20221103085004.1029763-1-ming.lei@redhat.com/
> > 
> 
> Seems interesting, We will take a look into this.

BTW, that is probably one direction of ublk's async zero copy IO too.


Thanks, 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

