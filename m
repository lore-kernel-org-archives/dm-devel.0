Return-Path: <SRS0=y4zT=GP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073E0C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 20:22:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 708C42310F
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jan 2021 20:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 708C42310F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610482946;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gVU2JQPiVW63fRgUx/EA4Vx7bOwpnYZkmfakFUtjAPw=;
	b=JMA8AW34v9fABhSp8tHI5eUEer2QxTVkKpSf9J6jdNSgCDDO6bccos4udBW2d7s9/HC7Gz
	GGAZVJ650djhsmPQPYDENagiWvOxQYRJwVb2C+U3/S30EnGuuSg4x5J2aSHw2jTsrg4fc4
	jXnS/ACKYtlE76h2xsuMbQz7RO7C4FM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-jgmUw0JyM4OSaup4bG0uyA-1; Tue, 12 Jan 2021 15:22:24 -0500
X-MC-Unique: jgmUw0JyM4OSaup4bG0uyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B946180DE0E;
	Tue, 12 Jan 2021 20:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA371F0;
	Tue, 12 Jan 2021 20:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B67A4BB7B;
	Tue, 12 Jan 2021 20:22:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10CKMFCc006839 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 12 Jan 2021 15:22:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0CE111975E; Tue, 12 Jan 2021 20:22:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 341531851C;
	Tue, 12 Jan 2021 20:21:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 10CKLdFI008074; Tue, 12 Jan 2021 15:21:39 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 10CKLd7J008060; Tue, 12 Jan 2021 15:21:39 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 12 Jan 2021 15:21:39 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <20210112200417.GA15241@redhat.com>
Message-ID: <alpine.LRH.2.02.2101121508130.31583@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2101121453090.31583@file01.intranet.prod.int.rdu2.redhat.com>
	<20210112200417.GA15241@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-integrity: fix the maximum number of arguments
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



On Tue, 12 Jan 2021, Mike Snitzer wrote:

> On Tue, Jan 12 2021 at  2:54pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Advance the maximum number of arguments to 15.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org	# v4.19+
> > 
> > ---
> >  drivers/md/dm-integrity.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/md/dm-integrity.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-integrity.c	2021-01-12 20:45:23.000000000 +0100
> > +++ linux-2.6/drivers/md/dm-integrity.c	2021-01-12 20:46:15.000000000 +0100
> > @@ -3792,7 +3792,7 @@ static int dm_integrity_ctr(struct dm_ta
> >  	unsigned extra_args;
> >  	struct dm_arg_set as;
> >  	static const struct dm_arg _args[] = {
> > -		{0, 9, "Invalid number of feature args"},
> > +		{0, 15, "Invalid number of feature args"},
> >  	};
> >  	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
> >  	bool should_write_sb;
> 
> Can you please expand on which args weren't accounted for?

The kernel 4.19 added "meta_device" 
(356d9d52e1221ba0c9f10b8b38652f78a5298329) and "recalculate" 
(a3fcf7253139609bf9ff901fbf955fba047e75dd) flags.

The commit 468dfca38b1a6fbdccd195d875599cb7c8875cd9 added 
"sectors_per_bit" and "bitmap_flush_interval".

The commit 84597a44a9d86ac949900441cea7da0af0f2f473 added 
"allow_discards".

The commit d537858ac8aaf4311b51240893add2fc62003b97 added "fix_padding".

> Which commit introduced the problem? (I'd like a "Fixes:" reference)
> 
> Thanks,
> Mike

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

