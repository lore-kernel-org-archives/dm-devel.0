Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24296C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 00:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646096336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z2wIwZEIn/l5lxw9URbETGemTZ2VagCxTA05sRNujSg=;
	b=FtZBPdS6e310FsE6AzUI/r06TYVX9jKF6+sRbbEfmXX9TETp0xQ85eFCbCaQIw7TpL3h9E
	uBEouP8308ue7juRtubYG7st1Lp7ODNeorW+A+otMcOmbMBrSnVQMSGHKO9tZ1TF4G2W+x
	o2AbToebUxomSdOXMXVkRYxGSCet4dU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-sNgGsC_UPGOyGdHVSsm6uQ-1; Mon, 28 Feb 2022 19:58:52 -0500
X-MC-Unique: sNgGsC_UPGOyGdHVSsm6uQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE659180A088;
	Tue,  1 Mar 2022 00:58:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 040F06E6F1;
	Tue,  1 Mar 2022 00:58:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BA024A701;
	Tue,  1 Mar 2022 00:58:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2210wfie026740 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 19:58:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CE01B7A241; Tue,  1 Mar 2022 00:58:41 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 099DA5C3E2;
	Tue,  1 Mar 2022 00:58:25 +0000 (UTC)
Date: Tue, 1 Mar 2022 08:58:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yh1vrWXlaTnEcrNd@T590>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
	<Yhz4AGXcn0DUeSwq@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yhz4AGXcn0DUeSwq@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH V3 0/3] block/dm: support bio polling
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

On Mon, Feb 28, 2022 at 11:27:44AM -0500, Mike Snitzer wrote:
> On Wed, Jun 23 2021 at  3:40P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > Hello Guys,
> > 
> > Based on Christoph's bio based polling model[1], implement DM bio polling
> > with one very simple approach.
> > 
> > Patch 1 adds helper of blk_queue_poll().
> > 
> > Patch 2 adds .bio_poll() callback to block_device_operations, so bio
> > driver can implement its own logic for io polling.
> > 
> > Patch 3 implements bio polling for device mapper.
> > 
> > 
> > V3:
> > 	- patch style change as suggested by Christoph(2/3)
> > 	- fix kernel panic issue caused by nested dm polling, which is found
> > 	  & figured out by Jeffle Xu (3/3)
> > 	- re-organize setup polling code (3/3)
> > 	- remove RFC
> > 
> > V2:
> > 	- drop patch to add new fields into bio
> > 	- support io polling for dm native bio splitting
> > 	- add comment
> > 
> > Ming Lei (3):
> >   block: add helper of blk_queue_poll
> >   block: add ->poll_bio to block_device_operations
> >   dm: support bio polling
> > 
> >  block/blk-core.c         |  18 +++---
> >  block/blk-sysfs.c        |   4 +-
> >  block/genhd.c            |   2 +
> >  drivers/md/dm-table.c    |  24 +++++++
> >  drivers/md/dm.c          | 131 ++++++++++++++++++++++++++++++++++++++-
> >  drivers/nvme/host/core.c |   2 +-
> >  include/linux/blkdev.h   |   2 +
> >  7 files changed, 170 insertions(+), 13 deletions(-)
> > 
> > -- 
> > 2.31.1
> > 
> 
> Hey Ming,
> 
> I'd like us to follow-through with adding bio-based polling support.
> Kind of strange none of us that were sent this V3 ever responded,
> sorry about that!
> 
> Do you have interest in rebasing this patchset (against linux-dm.git's
> "dm-5.18" branch since there has been quite some churn)?  Or are you
> OK with me doing the rebase?

Hi Mike,

Actually I have one local v5.17 rebase:

https://github.com/ming1/linux/tree/my_v5.17-dm-io-poll

Also one for-5.18/block rebase which is done just now:

https://github.com/ming1/linux/tree/my_v5.18-dm-bio-poll

In my previous test on v5.17 rebase, the IOPS improvement is a bit small,
so I didn't post it out. Recently not get time to investigate
the performance further, so please feel free to work on it.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

