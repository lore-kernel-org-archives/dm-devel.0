Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C9DC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 00:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646181969;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dZDI3ORfxFS+jxk8wizmh/iuS2zgNTnkpiG4KYIeoo0=;
	b=I2CWM9GLgqAq5W0xzjsoR9i106MbshFqkyC259E+Grd/gfP7plHWZWix1ev77wWIYyhvaF
	6Lu3xIiKKW+8N5XjL8mRckz0h8WsEXaGMLMTEUj05LPfQ9R1uXbQx2njUPHi7NIbx25Ocf
	55CKgjQV2GgkXn9ddML8hiGUptVDSDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-tUOF6TlJOJqB6JeZ5N4vbQ-1; Tue, 01 Mar 2022 19:46:05 -0500
X-MC-Unique: tUOF6TlJOJqB6JeZ5N4vbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ADC71854E27;
	Wed,  2 Mar 2022 00:45:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B224C4E2D5;
	Wed,  2 Mar 2022 00:45:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E90F4A701;
	Wed,  2 Mar 2022 00:45:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2220jrtt009251 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 19:45:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B15A7CADB; Wed,  2 Mar 2022 00:45:53 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98DBC7F7E2;
	Wed,  2 Mar 2022 00:45:22 +0000 (UTC)
Date: Wed, 2 Mar 2022 08:45:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Yh6+HUBnx62CUCSu@T590>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
	<Yhz4AGXcn0DUeSwq@redhat.com> <Yh1vrWXlaTnEcrNd@T590>
	<Yh6N7msbMBcANFxg@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yh6N7msbMBcANFxg@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 01, 2022 at 04:19:42PM -0500, Mike Snitzer wrote:
> On Mon, Feb 28 2022 at  7:58P -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Mon, Feb 28, 2022 at 11:27:44AM -0500, Mike Snitzer wrote:
> > > 
> > > Hey Ming,
> > > 
> > > I'd like us to follow-through with adding bio-based polling support.
> > > Kind of strange none of us that were sent this V3 ever responded,
> > > sorry about that!
> > > 
> > > Do you have interest in rebasing this patchset (against linux-dm.git's
> > > "dm-5.18" branch since there has been quite some churn)?  Or are you
> > > OK with me doing the rebase?
> > 
> > Hi Mike,
> > 
> > Actually I have one local v5.17 rebase:
> > 
> > https://github.com/ming1/linux/tree/my_v5.17-dm-io-poll
> > 
> > Also one for-5.18/block rebase which is done just now:
> > 
> > https://github.com/ming1/linux/tree/my_v5.18-dm-bio-poll
> > 
> > In my previous test on v5.17 rebase, the IOPS improvement is a bit small,
> > so I didn't post it out. Recently not get time to investigate
> > the performance further, so please feel free to work on it.
> 
> OK, I've rebased it on dm-5.18.
> 
> Can you please share the exact test(s) you were running?  I assume you
> were running directly against a request-based device and then
> comparing polling perf through dm-linear to the same underlying
> request-based device?

I run io_uring over dm-linear and dm-stripe, over two nvme disks with
2 poll_queues.

IOPS improvement can be observed, but not big.

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

