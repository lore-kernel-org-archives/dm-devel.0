Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527BBC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639443242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IuVAoF5525HLeeXm4C3awCMtdxztqleC3EoVmvxzWWY=;
	b=eSYUU2tKZvjDr0qBlSCzDE3jfxU6Ttgn/LgjAT6G+4XdssGF0Y7smcXbIA+a9Zc7A4fUKL
	L7iA68ifsmfzxZ6tFCisCsQKIbeAM45ujLzCnmOrRmWUSzj7QPZ/TlsWb3EgL5oyjDT7xo
	WDD0x+awDtkWQKrk1rDyqgU9d3QBjT4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-3pxd0JHuO8qmMGTgFLYyQg-1; Mon, 13 Dec 2021 19:53:58 -0500
X-MC-Unique: 3pxd0JHuO8qmMGTgFLYyQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753931006AA2;
	Tue, 14 Dec 2021 00:53:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8540D45D88;
	Tue, 14 Dec 2021 00:53:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E9D5180B617;
	Tue, 14 Dec 2021 00:53:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BE0rnAR007258 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 19:53:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9E193100E125; Tue, 14 Dec 2021 00:53:49 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91D791007607;
	Tue, 14 Dec 2021 00:53:31 +0000 (UTC)
Date: Tue, 14 Dec 2021 08:53:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Message-ID: <YbfrBpcV4hasdqQB@T590>
References: <BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com>
	<BYAPR21MB1270DCE17A0FE017AF3272F1BF729@BYAPR21MB1270.namprd21.prod.outlook.com>
	<b80bfe9a-bece-1f32-3d2a-fb4d94b1fa8c@kernel.dk>
	<BYAPR21MB1270B5DAD526C42C070ECB9EBF729@BYAPR21MB1270.namprd21.prod.outlook.com>
	<Yba8nL4x9R6rmTYL@T590>
	<BYAPR21MB127006555030F7BFA47FDAABBF749@BYAPR21MB1270.namprd21.prod.outlook.com>
	<Ybb4X00rfsjRgHj7@T590>
	<BYAPR21MB12706DCD5ED9FC7AB3EE2EEABF759@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BYAPR21MB12706DCD5ED9FC7AB3EE2EEABF759@BYAPR21MB1270.namprd21.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Long Li <longli@microsoft.com>,
	"'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
	"Michael Kelley \(LINUX\)" <mikelley@microsoft.com>,
	"'linux-block@vger.kernel.org'" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [dm-devel] Random high CPU utilization in blk-mq with the none
	scheduler
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 14, 2021 at 12:31:23AM +0000, Dexuan Cui wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > Sent: Sunday, December 12, 2021 11:38 PM
> 
> Ming, thanks so much for the detailed analysis!
> 
> > From the log:
> > 
> > 1) dm-mpath:
> > - queue depth: 2048
> > - busy: 848, and 62 of them are in sw queue, so run queue is often
> >   caused
> > - nr_hw_queues: 1
> > - dm-2 is in use, and dm-1/dm-3 is idle
> > - dm-2's dispatch busy is 8, that should be the reason why excessive CPU
> > usage is observed when flushing plug list without commit dc5fc361d891 in
> > which hctx->dispatch_busy is just bypassed
> > 
> > 2) iscsi
> > - dispatch_busy is 0
> > - nr_hw_queues: 1
> > - queue depth: 113
> > - busy=~33, active_queues is 3, so each LUN/iscsi host is saturated
> > - 23 active LUNs, 23 * 33 = 759 in-flight commands
> > 
> > The high CPU utilization may be caused by:
> > 
> > 1) big queue depth of dm mpath, the situation may be improved much if it
> > is reduced to 1024 or 800. The max allowed inflight commands from iscsi
> > hosts can be figured out, if dm's queue depth is much more than this number,
> > the extra commands need to dispatch, and run queue can be scheduled
> > immediately, so high CPU utilization is caused.
> 
> I think you're correct:
> with dm_mod.dm_mq_queue_depth=256, the max CPU utilization is 8%.
> with dm_mod.dm_mq_queue_depth=400, the max CPU utilization is 12%. 
> with dm_mod.dm_mq_queue_depth=800, the max CPU utilization is 88%.
> 
> The performance with queue_depth=800 is poor.
> The performance with queue_depth=400 is good.
> The performance with queue_depth=256 is also good, and there is only a 
> small drop comared with the 400 case.

That should be the reason why the issue isn't triggered in case of real
io scheduler.

So far blk-mq doesn't provide way to adjust tags queue depth
dynamically.

But not understand reason of default dm_mq_queue_depth(2048), in this
situation, each LUN can just queue 113/3 requests at most, and 3 LUNs
are attached to single iscsi host.

Mike, can you share why the default dm_mq_queue_depth is so big? And
seems it doesn't consider the underlying queue's queue depth. What is
the biggest dm rq queue depth? which need to saturate all underlying paths?

> 
> > 2) single hw queue, so contention should be big, which should be avoided
> > in big machine, nvme-tcp might be better than iscsi here
> > 
> > 3) iscsi io latency is a bit big
> > 
> > Even CPU utilization is reduced by commit dc5fc361d891, io performance
> > can't be good too with v5.16-rc, I guess.
> > 
> > Thanks,
> > Ming
> 
> Actually the I/O performance of v5.16-rc4 (commit dc5fc361d891 is included)
> is good -- it's about the same as the case where v5.16-rc4 + reverting
> dc5fc361d891 + dm_mod.dm_mq_queue_depth=400 (or 256).

The single hw queue may be the root cause of your issue, and there
is only single run_work, which can be touched by all CPUs(~200) almost, so cache
ping-pong could be very serious. 

Jens patch may improve it more or less, please test it.

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

