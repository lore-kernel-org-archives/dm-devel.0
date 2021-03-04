Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DA1C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 15:12:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8A1864F90
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 15:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8A1864F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614870772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZhNofhDBAz8aHHJX674D/fl7NhaaopNrg4xZlplzqng=;
	b=TdQJACxPVqlQwYIaNl3k5Wj3BsMoM4HdH80TB5T0X8OnS4L+LvVjaaNSLCDx3uoB6TW0CU
	rQWtm2+mli4/pks2dY/WtMIcD18wAclaAArZKmd7fz8kXy0bw6Jf5OBWNNWVJRZn+g3e4o
	L5LrimpSpa+PrOHIAUiXl7P0U85m5oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-EOwXLsMzP9Gh2LsX3H1GhQ-1; Thu, 04 Mar 2021 10:12:50 -0500
X-MC-Unique: EOwXLsMzP9Gh2LsX3H1GhQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 296E792506;
	Thu,  4 Mar 2021 15:12:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2FE119D7C;
	Thu,  4 Mar 2021 15:12:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD15257DC2;
	Thu,  4 Mar 2021 15:12:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 124FChE2014135 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Mar 2021 10:12:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7548560CDF; Thu,  4 Mar 2021 15:12:43 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FED860CCB;
	Thu,  4 Mar 2021 15:12:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 124FCdF3007183; Thu, 4 Mar 2021 10:12:39 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 124FCdDr007179; Thu, 4 Mar 2021 10:12:39 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 4 Mar 2021 10:12:39 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <x49o8fzklnx.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LRH.2.02.2103041008440.31824@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<x49o8fzklnx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, caspar@linux.alibaba.com,
	hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	JeffleXu <jefflexu@linux.alibaba.com>, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 4 Mar 2021, Jeff Moyer wrote:

> Hi, Mikulas,
> 
> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > On Wed, 3 Mar 2021, JeffleXu wrote:
> >
> >> 
> >> 
> >> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> >> 
> >> > Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
> >> > cookie.
> >> > 
> >> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >> > 
> >> > ---
> >> >  drivers/md/dm.c |    5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> > 
> >> > Index: linux-2.6/drivers/md/dm.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> >> > +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> >> > @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
> >> >  		}
> >> >  	}
> >> >  
> >> > +	if (ci.poll_cookie != BLK_QC_T_NONE) {
> >> > +		while (atomic_read(&ci.io->io_count) > 1 &&
> >> > +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> >> > +	}
> >> > +
> >> >  	/* drop the extra reference count */
> >> >  	dec_pending(ci.io, errno_to_blk_status(error));
> >> >  }
> >> 
> >> It seems that the general idea of your design is to
> >> 1) submit *one* split bio
> >> 2) blk_poll(), waiting the previously submitted split bio complets
> >
> > No, I submit all the bios and poll for the last one.
> 
> What happens if the last bio completes first?  It looks like you will
> call blk_poll with a cookie that already completed, and I'm pretty sure
> that's invalid.
> 
> Thanks,
> Jeff

If the last bio completes first, the other bios will use interrupt-driven 
endio.

Calling blk_poll with already completed cookie is IMHO legal - it happens 
with the current direct-io code too. The direct-io code will check for bio 
completion and if the bio is not completed, call blk_poll. The bio may be 
completed from an interrupt after the check and before blk_poll - in this 
case, we will call blk_poll with already completed cookie.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

