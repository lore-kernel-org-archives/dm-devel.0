Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609DEC4361B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:27:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C224E20656
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C224E20656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607963228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dh2FZMFXCtRt+ooKKEE56HGoKr8mQWUzgiRy83YhHYA=;
	b=Ya4rlpJNff0ysTInVAAHI2g0mx/BSvfiBPKf8Qt7KixS9Azbr4aMpWZwm54KmlS602yvn+
	oPvz6Tu2EW72vnzqEP2H6bwnJlsmPkWjOeIMz5I4TepO53Rl/FUn7FZNMEFWJM3uaVENhF
	gRwVE81yYixkwD88dDT96exJQkuKj/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-8mlighFHMGinW7S2KHBgBQ-1; Mon, 14 Dec 2020 11:27:05 -0500
X-MC-Unique: 8mlighFHMGinW7S2KHBgBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5D0E100E33B;
	Mon, 14 Dec 2020 16:26:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4FC634838;
	Mon, 14 Dec 2020 16:26:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4EAC4180954D;
	Mon, 14 Dec 2020 16:26:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BEGQWb2000648 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 11:26:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 62F267C5FE; Mon, 14 Dec 2020 16:26:32 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECEA87DDF8;
	Mon, 14 Dec 2020 16:26:31 +0000 (UTC)
Date: Mon, 14 Dec 2020 11:26:31 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20201214162631.GA2290@redhat.com>
References: <CAHk-=whCKhxNyKn1Arut8xUDKTwp3fWcCj_jbL5dbzkUmo45gQ@mail.gmail.com>
	<20201214053147.GA24093@codemonkey.org.uk>
	<X9b9ujh5T6U5+aBY@kroah.com> <20201214160247.GA2090@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201214160247.GA2090@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Linux 5.10
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 14 2020 at 11:02am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Dec 14 2020 at 12:52am -0500,
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Dec 14, 2020 at 12:31:47AM -0500, Dave Jones wrote:
> > > On Sun, Dec 13, 2020 at 03:03:29PM -0800, Linus Torvalds wrote:
> > >  > Ok, here it is - 5.10 is tagged and pushed out.
> > >  > 
> > >  > I pretty much always wish that the last week was even calmer than it
> > >  > was, and that's true here too. There's a fair amount of fixes in here,
> > >  > including a few last-minute reverts for things that didn't get fixed,
> > >  > but nothing makes me go "we need another week".
> > > 
> > > ...
> > > 
> > >  > Mike Snitzer (1):
> > >  >       md: change mddev 'chunk_sectors' from int to unsigned
> > > 
> > > Seems to be broken.  This breaks mounting my raid6 partition:
> > > 
> > > [   87.290698] attempt to access beyond end of device
> > >                md0: rw=4096, want=13996467328, limit=6261202944
> > > [   87.293371] attempt to access beyond end of device
> > >                md0: rw=4096, want=13998564480, limit=6261202944
> > > [   87.296045] BTRFS warning (device md0): couldn't read tree root
> > > [   87.300056] BTRFS error (device md0): open_ctree failed
> > > 
> > > Reverting it goes back to the -rc7 behaviour where it mounts fine.
> > 
> > If the developer/maintainer(s) agree, I can revert this and push out a
> > 5.10.1, just let me know.
> 
> Yes, these should be reverted from 5.10 via 5.10.1:
> 
> e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10
> f075cfb1dc59 md: change mddev 'chunk_sectors' from int to unsigned

Sorry, f075cfb1dc59 was my local commit id, the corresponding upstream
commit as staged by Jens is:

6ffeb1c3f82 md: change mddev 'chunk_sectors' from int to unsigned

So please revert:
6ffeb1c3f822 md: change mddev 'chunk_sectors' from int to unsigned
and then revert:
e0910c8e4f87 dm raid: fix discard limits for raid1 and raid10

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

