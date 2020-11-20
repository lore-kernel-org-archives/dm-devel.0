Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9911C5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 14:09:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 654782223F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 14:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7e7Mu0S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 654782223F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605881340;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SCFWnc7KHNmocesFP2J4HFzECIWr7aSG35Tn43ac4dg=;
	b=L7e7Mu0S9Wa4PcN1Rus8Lfv4Ocw/qNzOV0TSQCeyi32qsSpX4pUsSMCayZopar/anAO0ej
	85Wmt54mG6msxz72edShU28XsRgDlS0fnJLZzcoIF9oItPwaRpVZnKdRVkY8obiFYtWMsf
	LJXSaJnGM62cGcnUghzO8GwQOKathGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-VS7KjQMnO3efks1KL-7taw-1; Fri, 20 Nov 2020 09:08:56 -0500
X-MC-Unique: VS7KjQMnO3efks1KL-7taw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 701D61005D60;
	Fri, 20 Nov 2020 14:08:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B56225D6AD;
	Fri, 20 Nov 2020 14:08:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD42C180954D;
	Fri, 20 Nov 2020 14:08:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKE8fb9002664 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 09:08:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0DA9C19D80; Fri, 20 Nov 2020 14:08:41 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7663519C46;
	Fri, 20 Nov 2020 14:08:37 +0000 (UTC)
Date: Fri, 20 Nov 2020 09:08:20 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20201120140819.GA7359@redhat.com>
References: <20201113225228.20563-1-rdunlap@infradead.org>
	<344abf76-9405-58ba-2dc4-27cab88c974d@de.ibm.com>
	<c29eeb5d-0683-49eb-f729-38b14fac7745@infradead.org>
	<20201117163147.GA27243@redhat.com>
	<20201118154944.GB545@redhat.com> <20201118160748.GA754@redhat.com>
	<alpine.LRH.2.02.2011181611470.16933@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2011181611470.16933@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 18 2020 at  4:24pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 18 Nov 2020, Mike Snitzer wrote:
> 
> > On Wed, Nov 18 2020 at 10:49am -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > I don't think my suggestion will help.. given it'd still leave
> > > persistent_memory_claim() without a return statement.
> > > 
> > > Think it worthwhile to just add a dummy 'return 0;' after the BUG().
> > 
> > Decided to go with this, now staged for 5.11:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.11&id=a1e4865b4dda7071f3707f7e551289ead66e38b1
> 
> Hi
> 
> I would just use "return -EOPNOTSUPP;" and drop the "#ifdef 
> DM_WRITECACHE_HAS_PMEM" that you added.
> 
> That BUG/return -EOPNOTSUPP code can't happen at all - if 
> DM_WRITECACHE_HAS_PMEM is not defined, WC_MODE_PMEM(wc) always returns 
> false - so persistent_memory_claim and BUG() can't ever be called. And if 
> it can't be called, you don't need to add a code that prints an error in 
> that case.
> 
> If we don't have DM_WRITECACHE_HAS_PMEM, the compiler optimizer will 
> remove all the code guarded with if (WC_MODE_PMEM(wc)) as unreachable.
> 
> Mikulas

Fair enough.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

