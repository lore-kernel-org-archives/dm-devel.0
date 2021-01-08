Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AEFC433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 16:12:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 82E242399C
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 16:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82E242399C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610122341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jd1THHCQrQKMMxcSQBeW6W7GQ2b3nJM/xcR+c6ArpsU=;
	b=R3sn86HEp9PP8qwGbO49V7/gaBqu+G+reYLHiyXWk47C0vUW5VKZIznotwgYNk1ZmFvtM0
	2PyEYIzNoQjRQMiMtL3jG6KxPrPpLQxKq9izwRgzKHHAqfDlXL/bj8bvNh4Pl/1ya9WT7H
	PbrVjJYcAk5dLsJf/cPhhAFuDxULW88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-T3nx_1xBNViXHj3TsKphbg-1; Fri, 08 Jan 2021 11:12:18 -0500
X-MC-Unique: T3nx_1xBNViXHj3TsKphbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5348107ACFE;
	Fri,  8 Jan 2021 16:12:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1906D19C9B;
	Fri,  8 Jan 2021 16:12:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAB77180954D;
	Fri,  8 Jan 2021 16:12:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108GC84T017373 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 11:12:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4CFA519C99; Fri,  8 Jan 2021 16:12:08 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D867012D7E;
	Fri,  8 Jan 2021 16:12:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 108GC1Jw026994; Fri, 8 Jan 2021 11:12:01 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 108GC03Z026990; Fri, 8 Jan 2021 11:12:00 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 8 Jan 2021 11:12:00 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210104203042.GB3721@redhat.com>
Message-ID: <alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201220140222.2f341344@gecko.fritz.box>
	<20210104203042.GB3721@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel <dm-devel@redhat.com>, Lukas Straub <lukasstraub2@web.de>
Subject: Re: [dm-devel] dm-integrity: Fix flush with external metadata device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 4 Jan 2021, Mike Snitzer wrote:

> On Sun, Dec 20 2020 at  8:02am -0500,
> Lukas Straub <lukasstraub2@web.de> wrote:
> 
> > With an external metadata device, flush requests aren't passed down
> > to the data device.
> > 
> > Fix this by issuing flush in the right places: In integrity_commit
> > when not in journal mode, in do_journal_write after writing the
> > contents of the journal to the disk and in dm_integrity_postsuspend.
> > 
> > Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> > ---
> >  drivers/md/dm-integrity.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> > index 5a7a1b90e671..a26ed65869f6 100644
> > --- a/drivers/md/dm-integrity.c
> > +++ b/drivers/md/dm-integrity.c
> > @@ -2196,6 +2196,8 @@ static void integrity_commit(struct work_struct *w)
> >  	if (unlikely(ic->mode != 'J')) {
> >  		spin_unlock_irq(&ic->endio_wait.lock);
> >  		dm_integrity_flush_buffers(ic);
> > +		if (ic->meta_dev)
> > +			blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> >  		goto release_flush_bios;
> >  	}
> >  
> > @@ -2410,6 +2412,9 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
> >  	wait_for_completion_io(&comp.comp);
> >  
> >  	dm_integrity_flush_buffers(ic);
> > +	if (ic->meta_dev)
> > +		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> > +
> >  }
> >  
> >  static void integrity_writer(struct work_struct *w)
> > @@ -2949,6 +2954,9 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
> >  #endif
> >  	}
> >  
> > +	if (ic->meta_dev)
> > +		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> > +
> >  	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
> >  
> >  	ic->journal_uptodate = true;
> > -- 
> > 2.20.1
> 
> 
> Seems like a pretty bad oversight... but shouldn't you also make sure to
> flush the data device _before_ the metadata is flushed?
> 
> Mike

I think, ordering is not a problem.

A disk may flush its cache spontaneously anytime, so it doesn't matter in 
which order do we flush them. Similarly a dm-bufio buffer may be flushed 
anytime - if the machine is running out of memory and a dm-bufio shrinker 
is called.

I'll send another patch for this - I've created a patch that flushes the 
metadata device cache and data device cache in parallel, so that 
performance degradation is reduced.

My patch also doesn't use GFP_NOIO allocation - which can in theory 
deadlock if we are swapping on dm-integrity device.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

