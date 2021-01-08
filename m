Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EA7C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 18:38:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E274D2333E
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 18:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E274D2333E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610131114;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2P8F19m8RZX71m3VIXLTFTlmrKKXQ+8Abn1qEiON9y0=;
	b=JXKS8unLIet2JNf+GmP+sh11Jx1Q5L+IoGy+1hRw6M7VlQPjsfi3TmuwJ0nWKO5N6lEa1Y
	kzxymizhg+2M7aCdOo51LsfbuJk6riQyOFa/W+bPfYhfur2KSzWZl7I5Y3X3H0hz0XmsfX
	g68JC+8/t0Bze8/io6cR6XEZo+EwR24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-K5_x6ucmPZWbApY3MchCDg-1; Fri, 08 Jan 2021 13:38:32 -0500
X-MC-Unique: K5_x6ucmPZWbApY3MchCDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4BA18042A2;
	Fri,  8 Jan 2021 18:38:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80B7D5D9C0;
	Fri,  8 Jan 2021 18:38:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C488180954D;
	Fri,  8 Jan 2021 18:38:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108IcLpM030863 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 13:38:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E0F405D9E3; Fri,  8 Jan 2021 18:38:21 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81EE15D9C0;
	Fri,  8 Jan 2021 18:38:18 +0000 (UTC)
Date: Fri, 8 Jan 2021 13:38:17 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20210108183817.GA30360@redhat.com>
References: <20201220140222.2f341344@gecko.fritz.box>
	<20210104203042.GB3721@redhat.com>
	<alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 08 2021 at 11:12am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 4 Jan 2021, Mike Snitzer wrote:
> 
> > On Sun, Dec 20 2020 at  8:02am -0500,
> > Lukas Straub <lukasstraub2@web.de> wrote:
> > 
> > > With an external metadata device, flush requests aren't passed down
> > > to the data device.
> > > 
> > > Fix this by issuing flush in the right places: In integrity_commit
> > > when not in journal mode, in do_journal_write after writing the
> > > contents of the journal to the disk and in dm_integrity_postsuspend.
> > > 
> > > Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> > > ---
> > >  drivers/md/dm-integrity.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> > > index 5a7a1b90e671..a26ed65869f6 100644
> > > --- a/drivers/md/dm-integrity.c
> > > +++ b/drivers/md/dm-integrity.c
> > > @@ -2196,6 +2196,8 @@ static void integrity_commit(struct work_struct *w)
> > >  	if (unlikely(ic->mode != 'J')) {
> > >  		spin_unlock_irq(&ic->endio_wait.lock);
> > >  		dm_integrity_flush_buffers(ic);
> > > +		if (ic->meta_dev)
> > > +			blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> > >  		goto release_flush_bios;
> > >  	}
> > >  
> > > @@ -2410,6 +2412,9 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
> > >  	wait_for_completion_io(&comp.comp);
> > >  
> > >  	dm_integrity_flush_buffers(ic);
> > > +	if (ic->meta_dev)
> > > +		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> > > +
> > >  }
> > >  
> > >  static void integrity_writer(struct work_struct *w)
> > > @@ -2949,6 +2954,9 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
> > >  #endif
> > >  	}
> > >  
> > > +	if (ic->meta_dev)
> > > +		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO);
> > > +
> > >  	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
> > >  
> > >  	ic->journal_uptodate = true;
> > > -- 
> > > 2.20.1
> > 
> > 
> > Seems like a pretty bad oversight... but shouldn't you also make sure to
> > flush the data device _before_ the metadata is flushed?
> > 
> > Mike
> 
> I think, ordering is not a problem.
> 
> A disk may flush its cache spontaneously anytime, so it doesn't matter in 
> which order do we flush them. Similarly a dm-bufio buffer may be flushed 
> anytime - if the machine is running out of memory and a dm-bufio shrinker 
> is called.
> 
> I'll send another patch for this - I've created a patch that flushes the 
> metadata device cache and data device cache in parallel, so that 
> performance degradation is reduced.
> 
> My patch also doesn't use GFP_NOIO allocation - which can in theory 
> deadlock if we are swapping on dm-integrity device.

OK, I see your patch, but my concern about ordering was more to do with
crash consistency.  What if metadata is updated but data isn't?

On the surface, your approach of issuing the flushes in parallel seems
to expose us to inconsistency upon recovery from a crash.
If that isn't the case please explain why not.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

