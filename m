Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B8CC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jan 2022 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642626215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/TULcXkqvpfWe0WYQQxVqm2QTYwYmDnvl/VsNlml41o=;
	b=K6fT7ne6IKNliVlmpeHA3YaQPufsl4k6L/HXtnFGq6nptOKLPOjNoCAVDDpX7rZGSpCbZ6
	KTZnrjp3yk78iwu91Lc8HsKE3o7+pEnnz4ndpa0+7oHjYGGHIygx42jX0DxBj2AQbM+5+a
	sKFZEP8L5NiNQsfiGZhW+4sqimKtZhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-sbBY7l_TO2-ikx7XHSI84g-1; Wed, 19 Jan 2022 16:03:31 -0500
X-MC-Unique: sbBY7l_TO2-ikx7XHSI84g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC091811EEF;
	Wed, 19 Jan 2022 21:03:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06C85519D6;
	Wed, 19 Jan 2022 21:03:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 541711809CB8;
	Wed, 19 Jan 2022 21:03:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20JL3Kbq028941 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 Jan 2022 16:03:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6939CC08088; Wed, 19 Jan 2022 21:03:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6553FC08098
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 21:03:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49F5C8FA9A0
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 21:03:20 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-121-0xIDicDiPqGFT09z2otAfQ-1; Wed, 19 Jan 2022 16:03:18 -0500
X-MC-Unique: 0xIDicDiPqGFT09z2otAfQ-1
Received: by mail-qv1-f69.google.com with SMTP id
	q5-20020ad45745000000b0041b929322ecso4034044qvx.6
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 13:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=RclBE4j/l0I/3NwHx38MPLT8IFYI9e2HwkR+3iNqKtg=;
	b=TxzMKS1VEh/F0trfKzf4GR7H2oPMcvbSQplC8tr7+tsSKc26w0chwWwGA177yJShR2
	0szNNjL6MnxApkHoWCBb/iZxcXFmtSmhhpMD3yGQPntxyYSZ0ahnsHLDfmq+z3oQL9bS
	hyTxtkaUnw9PM22PrIz+myctuGWhq4ssbqXYnBihUxC7EKxrcfdkeQMqxhB+wHPMfaU2
	0WxyjB9ncdhdsCMMJYU1sG3aC/TPwKfPF71GBQQy65yA0pd0r3zSeRnIsWhF1qWtNbmk
	/0UmEGYGEg764YHPy2FUmbBHkjoDKeBHuAYgOLVYys1jgGBIKaUTNZGjYsQyjJaQXnjl
	UdEw==
X-Gm-Message-State: AOAM5309y/GcpOPxc+umfPWEAEQudOlkZLU4Bj0tyuYndKoai66HYFUu
	RjaXx0GCBCTK81JqHLHRafGOxVh2oGNS6N9K8r63ARTJ8p34gIto8h90O7voCuhjSkQCrWpiazB
	b4mihpVtPKAgd0Q==
X-Received: by 2002:a37:44cd:: with SMTP id r196mr22696144qka.90.1642626198298;
	Wed, 19 Jan 2022 13:03:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMQlq2CHwYQqUY+ubV1rButdo/mjYgi37vO2ELr0QtyVP0CLAc4/4GF1GPZIaw1sTQfZZXNQ==
X-Received: by 2002:a37:44cd:: with SMTP id r196mr22696123qka.90.1642626198034;
	Wed, 19 Jan 2022 13:03:18 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id p9sm395169qtk.39.2022.01.19.13.03.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 19 Jan 2022 13:03:17 -0800 (PST)
Date: Wed, 19 Jan 2022 16:03:16 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <Yeh8lKeb8Rl96FyN@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
	<YcuB4K8P2d9WFb83@redhat.com> <Yd1BFpYTBlQSPReW@infradead.org>
	<x49ee5ejfly.fsf@segfault.boston.devel.redhat.com>
	<YeUkZGw4vLqdB17p@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YeUkZGw4vLqdB17p@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 17 2022 at  3:10P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 11, 2022 at 01:23:53PM -0500, Jeff Moyer wrote:
> > Maybe I have bad taste, but the patches didn't look like cruft to me.
> > :)
> 
> They do to me.  The extend the corner case of request on request
> stacking that already is a bit of mess even more by adding yet another
> special case in the block layer.

Ming's first patch:
https://patchwork.kernel.org/project/dm-devel/patch/20211221141459.1368176-2-ming.lei@redhat.com/
is pure cleanup for the mess that went in this merge cycle.

All that dm-rq context aside, Ming's 1st patch is the correct way to
clean up the block core flags/state (internal vs external, etc).

But the 2nd paragraph of that first patch's header should be moved to
Ming's 2nd patch because it explains why DM needs the new
blk_alloc_disk_srcu() interface, e.g.:
"But dm queue is allocated before tagset is allocated"
(so it confirms it best to explain that in 2nd patch).

But really even Ming's 2nd patch:
https://patchwork.kernel.org/project/dm-devel/patch/20211221141459.1368176-3-ming.lei@redhat.com/
should _not_ need to be debated like this.

Fact is alloc_disk() has always mirrored blk_alloc_queue()'s args.  So
Ming's 2nd patch should be done anyway to expose meaningful control
over request_queue allocation.  If anything, the 2nd patch should just
add the 'alloc_srcu' arg to blk_alloc_disk() and change all but NVMe
callers to pass false.

Put another way: when the 'node_id' arg was added to blk_alloc_queue()
a new blk_alloc_disk_numa_node() wasn't added (despite most block
drivers still only using NUMA_NO_NODE).  This new 'alloc_srcu' flag is
seen to be more niche, but it really should be no different on an
interface symmetry and design level.

> > I'm not sure why we'd prevent users from using dm-mpath on nvmeof.  I
> > think there's agreement that the nvme native multipath implementation is
> > the preferred way (that's the default in rhel9, even), but I don't think
> > that's a reason to nack this patch set.
> > 
> > Or have I missed your point entirely?
> 
> No you have not missed the point.  nvme-multipath exists longer than
> the nvme-tcp driver and is the only supported one for it upstream for
> a good reason.  If RedHat wants to do their own weirdo setups they can
> patch their kernels, but please leave the upstrem code alone.

Patch 3 can be left out if you'd like to force your world view on
everyone... you've already "won", _pretty please_ stop being so
punitive by blocking reasonable change.  We really can get along if
we're all willing to be intellectually honest.

To restate: Ming's patches 1 and 2 really are not "cruft".  They
expose control over request_queue allocation that should be accessible
by both blk_alloc_queue() and blk_alloc_disk().

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

