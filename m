Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A976FC5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 15:50:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0918247A7
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 15:50:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/m63+nO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0918247A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605714603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=taxD4VMfruFwVIStrdWWKvKiLKqdBUSmzDO/sBJerp8=;
	b=T/m63+nOgxrnBoDu5qtqjnSSZNalB2sLYZOtEf6a7temzqcc4P81c8XUrcRAOA50mkiTx1
	UcAswv3NXAVjOOR5mZPfEJbgRq6WGpYF8jP1F0PG69z9HRXIUYSwg4Gr9PqgBiog4nDCcD
	FI73Cz3liymgOpj5EzvnoBUAYEErEQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-yprOG0gNN--XR9np3fdidA-1; Wed, 18 Nov 2020 10:50:00 -0500
X-MC-Unique: yprOG0gNN--XR9np3fdidA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5BF81005D4E;
	Wed, 18 Nov 2020 15:49:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A7221964B;
	Wed, 18 Nov 2020 15:49:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FF7186BE8;
	Wed, 18 Nov 2020 15:49:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AIFnrjC023424 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 10:49:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 391CB5D9F1; Wed, 18 Nov 2020 15:49:53 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DE655D9D2;
	Wed, 18 Nov 2020 15:49:45 +0000 (UTC)
Date: Wed, 18 Nov 2020 10:49:44 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <20201118154944.GB545@redhat.com>
References: <20201113225228.20563-1-rdunlap@infradead.org>
	<344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
	<c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
	<20201117163147.GA27243@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201117163147.GA27243@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, linux-kernel@vger.kernel.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] md: dm-writeback: add __noreturn to BUG-ging function
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

On Tue, Nov 17 2020 at 11:31am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 16 2020 at  6:00pm -0500,
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> > On 11/15/20 11:30 PM, Christian Borntraeger wrote:
> > > 
> > > 
> > > On 13.11.20 23:52, Randy Dunlap wrote:
> > >> Building on arch/s390/ flags this as an error, so add the
> > >> __noreturn attribute modifier to prevent the build error.
> > >>
> > >> cc1: some warnings being treated as errors
> > >> ../drivers/md/dm-writecache.c: In function 'persistent_memory_claim':
> > >> ../drivers/md/dm-writecache.c:323:1: error: no return statement in function returning non-void [-Werror=return-type]
> > > 
> > > ok with me, but I am asking why
> > > 
> > > the unreachable macro is not good enough. For x86 it obviously is.
> > > 
> > > form arch/s390/include/asm/bug.h
> > > #define BUG() do {                                      \
> > >         __EMIT_BUG(0);                                  \
> > >         unreachable();                                  \
> > > } while (0)
> > > 
> > 
> > Hi Christian,
> > 
> > Good question.
> > I don't see any guidance about when to use one or the other etc.
> > 
> > I see __noreturn being used 109 times and unreachable();
> > being used 33 times, but only now that I look at them.
> > That had nothing to do with why I used __noreturn in the patch.
> 
> But doesn't that speak to the proper fix being needed in unreachable()?
> Or at a minimum the fix is needed to arch/s390/include/asm/bug.h's BUG.
> 
> I really don't think we should be papering over that by sprinkling
> __noreturn around the kernel's BUG() callers.
> 
> Maybe switch arch/s390/include/asm/bug.h's BUG to be like
> arch/mips/include/asm/bug.h?  It itself uses __noreturn with a 'static
> inline' function definition rather than #define.
> 
> Does that fix the issue?
> 
> Thanks,
> Mike
> 
> p.s. you modified dm-writecache.c (not dm-writeback, wich doesn't
> exist).

I don't think my suggestion will help.. given it'd still leave
persistent_memory_claim() without a return statement.

Think it worthwhile to just add a dummy 'return 0;' after the BUG().

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

