Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3249DC43334
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658512769;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iJEE0zBohBTe0Uhr4VMNo24JEK8pPUNbC0yrOEEIoK4=;
	b=gF4xa35KITozsLiiNdDGuKjXnDzp6QKgaPVrYiLZMCoa9NH7kcCovu0k3up6wAV+U/UIWl
	SMjLoMRtrXzgOBWM1fNO+l8sLKkQzqy+5WbwlSxxenpfmczmKdoTFo3bQJdAQuO0s/5ZXh
	DjWzPpD08IOanQefT2yfDUMVazY4AhY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-j_1CUBCFOV6gLLsfZUY8Zg-1; Fri, 22 Jul 2022 13:59:22 -0400
X-MC-Unique: j_1CUBCFOV6gLLsfZUY8Zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B3D480600E;
	Fri, 22 Jul 2022 17:59:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5381121314;
	Fri, 22 Jul 2022 17:59:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DD7EC194704F;
	Fri, 22 Jul 2022 17:59:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBF151947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 17:59:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B81FC1121315; Fri, 22 Jul 2022 17:59:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4ED11121314
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 17:59:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5699A1C05AEB
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 17:59:18 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-bYVvQXMDNSCKD7t3xbD6Aw-1; Fri, 22 Jul 2022 13:59:11 -0400
X-MC-Unique: bYVvQXMDNSCKD7t3xbD6Aw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1oEvi7-007zu1-3e; Fri, 22 Jul 2022 16:41:07 +0000
Date: Fri, 22 Jul 2022 09:41:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nathan Huckleberry <nhuck@google.com>
Message-ID: <YtrTI/CJMoLihA/1@infradead.org>
References: <20220722093823.4158756-1-nhuck@google.com>
MIME-Version: 1.0
In-Reply-To: <20220722093823.4158756-1-nhuck@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 0/3] dm-verity: optionally use tasklets in
 dm-verity
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
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We've been tying to kill off task lets for about 15 years.  I don't
think adding new users will make you a whole lot of friends..

On Fri, Jul 22, 2022 at 09:38:20AM +0000, Nathan Huckleberry wrote:
> Using tasklets for disk verification can reduce IO latency.  When there are
> accelerated hash instructions it is often better to compute the hash immediately
> using a tasklet rather than deferring verification to a work-queue.  This
> reduces time spent waiting to schedule work-queue jobs, but requires spending
> slightly more time in interrupt context.
> 
> A tasklet can only be used for verification if all the required hashes are
> already in the dm-bufio cache.  If verification cannot be done in a tasklet, we
> fallback the existing work-queue implementation.
> 
> To allow tasklets to query the dm-bufio cache, the dm-bufio code must not sleep.
> This patchset adds a flag to dm-bufio that disallows sleeping.
> 
> The following shows a speed comparison of random reads on a dm-verity device.
> The dm-verity device uses a 1G ramdisk for data and a 1G ramdisk for hashes.
> One test was run using tasklets and one test was run using the existing
> work-queue solution.  Both tests were run when the dm-bufio cache was hot.  The
> tasklet implementation performs significantly better since there is no time
> waiting for work-queue jobs to be scheduled.
> 
> # /data/fio /data/tasklet.fio | grep READ
>    READ: bw=181MiB/s (190MB/s), 181MiB/s-181MiB/s (190MB/s-190MB/s), io=512MiB
>    (537MB), run=2827-2827msec
> # /data/fio /data/workqueue.fio | grep READ
>    READ: bw=23.6MiB/s (24.8MB/s), 23.6MiB/s-23.6MiB/s (24.8MB/s-24.8MB/s),
>    io=512MiB (537MB), run=21688-21688msec
> 
> Nathan Huckleberry (3):
>   dm-bufio: Add flags for dm_bufio_client_create
>   dm-bufio: Add DM_BUFIO_GET_CANT_SLEEP
>   dm-verity: Add try_verify_in_tasklet
> 
>  drivers/md/dm-bufio.c                         | 29 +++++--
>  drivers/md/dm-ebs-target.c                    |  3 +-
>  drivers/md/dm-integrity.c                     |  2 +-
>  drivers/md/dm-snap-persistent.c               |  2 +-
>  drivers/md/dm-verity-fec.c                    |  4 +-
>  drivers/md/dm-verity-target.c                 | 87 ++++++++++++++++---
>  drivers/md/dm-verity.h                        |  5 ++
>  drivers/md/persistent-data/dm-block-manager.c |  3 +-
>  include/linux/dm-bufio.h                      |  8 +-
>  9 files changed, 119 insertions(+), 24 deletions(-)
> 
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
---end quoted text---

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

