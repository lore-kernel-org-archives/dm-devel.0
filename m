Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B11FC352A1
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670411964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PipUdBOpWWGwkbF1wAi6R+R4YuPXN8lBn5Ix9kFZVLE=;
	b=fGlJ+e2SlvWvWQmnGdyH5JBvFKz2guY9bhW8Rqy+VCClHmI7zkNv/6MknRCEJsG2xugg84
	gXwaBzK88Z3Jx753V7Q9A49BJewLUgRDdj3AoSjJkdlYIqFDSgvyPKiTqHVX+vCcsb2TZ8
	xnMrR6zDCn4kOchHB+mLFci/G4kgTBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-EbZe3p8FNYqfbh7NnvAoLA-1; Wed, 07 Dec 2022 06:19:23 -0500
X-MC-Unique: EbZe3p8FNYqfbh7NnvAoLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FC15800159;
	Wed,  7 Dec 2022 11:19:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 407B32027061;
	Wed,  7 Dec 2022 11:19:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F81119465B2;
	Wed,  7 Dec 2022 11:19:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2262119465B1
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Dec 2022 11:19:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 052DF2027062; Wed,  7 Dec 2022 11:19:19 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DE9B2027061;
 Wed,  7 Dec 2022 11:19:05 +0000 (UTC)
Date: Wed, 7 Dec 2022 19:19:00 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <Y5B2pCiYsWb5hdrI@T590>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061017epcas5p246a589e20eac655ac340cfda6028ff35@epcas5p2.samsung.com>
 <20221123055827.26996-3-nj.shetty@samsung.com>
 <Y33UAp6ncSPO84XI@T590> <20221123100712.GA26377@test-zns>
 <Y3607N6lDRK6WU7/@T590> <20221129114428.GA16802@test-zns>
 <20221207055400.GA6497@test-zns>
MIME-Version: 1.0
In-Reply-To: <20221207055400.GA6497@test-zns>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, kbusch@kernel.org,
 axboe@kernel.dk, joshi.k@samsung.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jth@kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 07, 2022 at 11:24:00AM +0530, Nitesh Shetty wrote:
> On Tue, Nov 29, 2022 at 05:14:28PM +0530, Nitesh Shetty wrote:
> > On Thu, Nov 24, 2022 at 08:03:56AM +0800, Ming Lei wrote:
> > > On Wed, Nov 23, 2022 at 03:37:12PM +0530, Nitesh Shetty wrote:
> > > > On Wed, Nov 23, 2022 at 04:04:18PM +0800, Ming Lei wrote:
> > > > > On Wed, Nov 23, 2022 at 11:28:19AM +0530, Nitesh Shetty wrote:
> > > > > > Introduce blkdev_issue_copy which supports source and destination bdevs,
> > > > > > and an array of (source, destination and copy length) tuples.
> > > > > > Introduce REQ_COPY copy offload operation flag. Create a read-write
> > > > > > bio pair with a token as payload and submitted to the device in order.
> > > > > > Read request populates token with source specific information which
> > > > > > is then passed with write request.
> > > > > > This design is courtesy Mikulas Patocka's token based copy
> > > > > 
> > > > > I thought this patchset is just for enabling copy command which is
> > > > > supported by hardware. But turns out it isn't, because blk_copy_offload()
> > > > > still submits read/write bios for doing the copy.
> > > > > 
> > > > > I am just wondering why not let copy_file_range() cover this kind of copy,
> > > > > and the framework has been there.
> > > > > 
> > > > 
> > > > Main goal was to enable copy command, but community suggested to add
> > > > copy emulation as well.
> > > > 
> > > > blk_copy_offload - actually issues copy command in driver layer.
> > > > The way read/write BIOs are percieved is different for copy offload.
> > > > In copy offload we check REQ_COPY flag in NVMe driver layer to issue
> > > > copy command. But we did missed it to add in other driver's, where they
> > > > might be treated as normal READ/WRITE.
> > > > 
> > > > blk_copy_emulate - is used if we fail or if device doesn't support native
> > > > copy offload command. Here we do READ/WRITE. Using copy_file_range for
> > > > emulation might be possible, but we see 2 issues here.
> > > > 1. We explored possibility of pulling dm-kcopyd to block layer so that we 
> > > > can readily use it. But we found it had many dependecies from dm-layer.
> > > > So later dropped that idea.
> > > 
> > > Is it just because dm-kcopyd supports async copy? If yes, I believe we
> > > can reply on io_uring for implementing async copy_file_range, which will
> > > be generic interface for async copy, and could get better perf.
> > >
> > 
> > It supports both sync and async. But used only inside dm-layer.
> > Async version of copy_file_range can help, using io-uring can be helpful
> > for user , but in-kernel users can't use uring.
> > 
> > > > 2. copy_file_range, for block device atleast we saw few check's which fail
> > > > it for raw block device. At this point I dont know much about the history of
> > > > why such check is present.
> > > 
> > > Got it, but IMO the check in generic_copy_file_checks() can be
> > > relaxed to cover blkdev cause splice does support blkdev.
> > > 
> > > Then your bdev offload copy work can be simplified into:
> > > 
> > > 1) implement .copy_file_range for def_blk_fops, suppose it is
> > > blkdev_copy_file_range()
> > > 
> > > 2) inside blkdev_copy_file_range()
> > > 
> > > - if the bdev supports offload copy, just submit one bio to the device,
> > > and this will be converted to one pt req to device
> > > 
> > > - otherwise, fallback to generic_copy_file_range()
> > >
> > 
> 
> Actually we sent initial version with single bio, but later community
> suggested two bio's is must for offload, main reasoning being

Is there any link which holds the discussion?

> dm-layer,Xcopy,copy across namespace compatibilty.

But dm kcopy has supported bdev copy already, so once your patch is
ready, dm kcopy can just sends one bio with REQ_COPY if the device
supports offload command, otherwise the current dm kcopy code can work
as before.

> 
> > We will check the feasibilty and try to implement the scheme in next versions.
> > It would be helpful, if someone in community know's why such checks were
> > present ? We see copy_file_range accepts only regular file. Was it
> > designed only for regular files or can we extend it to regular block
> > device.
> >
> 
> As you suggested we were able to integrate def_blk_ops and
> run with user application, but we see one main issue with this approach.
> Using blkdev_copy_file_range requires having 2 file descriptors, which
> is not possible for in kernel users such as fabrics/dm-kcopyd which has
> only bdev descriptors.
> Do you have any plumbing suggestions here ?

What is the fabrics kernel user? Any kernel target code(such as nvme target)
has file/bdev path available, vfs_copy_file_range() should be fine.

Also IMO, kernel copy user shouldn't be important long term, especially if
io_uring copy_file_range() can be supported, forwarding to userspace not
only gets better performance, but also cleanup kernel related copy code
much.


thanks, 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

