Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C10C433DB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 19:01:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 28DCD23A81
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 19:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28DCD23A81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610132459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C9Baf0/CVTcGU+w9gLQpLeSUbDzWAOtPFUiGGxrB0pA=;
	b=WPcoFR4ybmYbFCF5cD75pOW9+JWQ2waE1f2E8SZuZOiK+1Iz/Aa2hOd7TwsneZIRav0JgL
	NI3+s0rMXQ7a+AHs1cgsqAyqHQu5/mIIG37ygWvyDvAVXGKsSqS+/+XG2kLhD38kk2S0Tv
	Q45yYs71a5ptwM4BzvB8a1Q2xAqEjlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-4NZHOUj4M3WAqolKz2QhZA-1; Fri, 08 Jan 2021 14:00:57 -0500
X-MC-Unique: 4NZHOUj4M3WAqolKz2QhZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F70D1926DA1;
	Fri,  8 Jan 2021 19:00:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C96310016F4;
	Fri,  8 Jan 2021 19:00:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58FF84E58E;
	Fri,  8 Jan 2021 19:00:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108J0nGh000301 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 14:00:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 746EB19809; Fri,  8 Jan 2021 19:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 477D912D7E;
	Fri,  8 Jan 2021 19:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 108J0mhZ009987; Fri, 8 Jan 2021 14:00:48 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 108J0mC1009980; Fri, 8 Jan 2021 14:00:48 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 8 Jan 2021 14:00:48 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210108183817.GA30360@redhat.com>
Message-ID: <alpine.LRH.2.02.2101081349400.2554@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201220140222.2f341344@gecko.fritz.box>
	<20210104203042.GB3721@redhat.com>
	<alpine.LRH.2.02.2101081104490.17896@file01.intranet.prod.int.rdu2.redhat.com>
	<20210108183817.GA30360@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 8 Jan 2021, Mike Snitzer wrote:

> > > Seems like a pretty bad oversight... but shouldn't you also make sure to
> > > flush the data device _before_ the metadata is flushed?
> > > 
> > > Mike
> > 
> > I think, ordering is not a problem.
> > 
> > A disk may flush its cache spontaneously anytime, so it doesn't matter in 
> > which order do we flush them. Similarly a dm-bufio buffer may be flushed 
> > anytime - if the machine is running out of memory and a dm-bufio shrinker 
> > is called.
> > 
> > I'll send another patch for this - I've created a patch that flushes the 
> > metadata device cache and data device cache in parallel, so that 
> > performance degradation is reduced.
> > 
> > My patch also doesn't use GFP_NOIO allocation - which can in theory 
> > deadlock if we are swapping on dm-integrity device.
> 
> OK, I see your patch, but my concern about ordering was more to do with
> crash consistency.  What if metadata is updated but data isn't?

In journal mode: do_journal_write will copy data from the journal to 
appropriate places and then flushes both data and metadata device. If a 
crash happens during flush, the journal will be replayed on next reboot - 
the replay operation will overwrite both data and metadata from the 
journal.

In bitmap mode: bitmap_flush_work will first issue flush on both data and 
metadata device, and then clear the dirty bits in a bitmap. If a crash 
happens during the flush, the bits in the bitmap are still set and the 
checksums will be recalculated on next reboot.

> On the surface, your approach of issuing the flushes in parallel seems
> to expose us to inconsistency upon recovery from a crash.
> If that isn't the case please explain why not.

The disk may flush its internal cache anytime. So, if you do 
"blkdev_issue_flush(disk1); blkdev_issue_flush(disk2);" there is no 
ordering guarantee at all. The firmware in disk2 may flush the cache 
spontaneously, before you called blkdev_issue_flush(disk1).

> Thanks,
> Mike

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

