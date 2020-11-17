Return-Path: <SRS0=GP7Z=EX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBF2C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 17 Nov 2020 17:03:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2E1722447
	for <dm-devel@archiver.kernel.org>; Tue, 17 Nov 2020 17:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0ZP2O6v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2E1722447
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605632604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v7gbBEvIlvX6HaQ27WkFjvDU/Kko5SEoqhPp7dFhFXQ=;
	b=K0ZP2O6vU1SoHRlH9dD1GJbh8mtGDfvhfF6DUlMvErGLADiAja0khpq3AcaLltk087Ax1T
	0aHkvaRNmBYjJqNyog5ThL04Gtpf1pe8JZGl4Tyuab8lt0RzbdQd8f9fDPCFQHlTU6vjjt
	m+opduatgo02It72OvcNriwwLiMiQiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-wA_bZ4aVMoqfmwn8GCQOAw-1; Tue, 17 Nov 2020 12:03:19 -0500
X-MC-Unique: wA_bZ4aVMoqfmwn8GCQOAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A355188C137;
	Tue, 17 Nov 2020 17:03:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 799946FEFF;
	Tue, 17 Nov 2020 17:03:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F288F8C7AC;
	Tue, 17 Nov 2020 17:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AHGVpnW031103 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Nov 2020 11:31:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A5B595D9EF; Tue, 17 Nov 2020 16:31:51 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AA145D9E8;
	Tue, 17 Nov 2020 16:31:48 +0000 (UTC)
Date: Tue, 17 Nov 2020 11:31:47 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <20201117163147.GA27243@redhat.com>
References: <20201113225228.20563-1-rdunlap@infradead.org>
	<344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
	<c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
MIME-Version: 1.0
In-Reply-To: <c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 16 2020 at  6:00pm -0500,
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/15/20 11:30 PM, Christian Borntraeger wrote:
> > 
> > 
> > On 13.11.20 23:52, Randy Dunlap wrote:
> >> Building on arch/s390/ flags this as an error, so add the
> >> __noreturn attribute modifier to prevent the build error.
> >>
> >> cc1: some warnings being treated as errors
> >> ../drivers/md/dm-writecache.c: In function 'persistent_memory_claim':
> >> ../drivers/md/dm-writecache.c:323:1: error: no return statement in function returning non-void [-Werror=return-type]
> > 
> > ok with me, but I am asking why
> > 
> > the unreachable macro is not good enough. For x86 it obviously is.
> > 
> > form arch/s390/include/asm/bug.h
> > #define BUG() do {                                      \
> >         __EMIT_BUG(0);                                  \
> >         unreachable();                                  \
> > } while (0)
> > 
> 
> Hi Christian,
> 
> Good question.
> I don't see any guidance about when to use one or the other etc.
> 
> I see __noreturn being used 109 times and unreachable();
> being used 33 times, but only now that I look at them.
> That had nothing to do with why I used __noreturn in the patch.

But doesn't that speak to the proper fix being needed in unreachable()?
Or at a minimum the fix is needed to arch/s390/include/asm/bug.h's BUG.

I really don't think we should be papering over that by sprinkling
__noreturn around the kernel's BUG() callers.

Maybe switch arch/s390/include/asm/bug.h's BUG to be like
arch/mips/include/asm/bug.h?  It itself uses __noreturn with a 'static
inline' function definition rather than #define.

Does that fix the issue?

Thanks,
Mike

p.s. you modified dm-writecache.c (not dm-writeback, wich doesn't
exist).

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

