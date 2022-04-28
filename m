Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BA3C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651162957;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vPpFdTP4LmXwhAS7T277931/XPcGqY5AUVc8DP0m6IQ=;
	b=O0bwI6l+wGbhXosH5h6E2ASUXbYfpAXxekPVC6xSk2m906d9g7aXmcY1B5KVUC/uM+Aaiy
	rIFYVp6ouhNI/iGnS3qIaJkmrzPHNnz0MUSrewfZFqVMLv3W1R1pj7hEZ4u++ytmXTYlcS
	NFu/ctqhRTi7ftrjcoawohEqRRJCfnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-oP6BzWkXMFKothttOAL8hw-1; Thu, 28 Apr 2022 12:22:30 -0400
X-MC-Unique: oP6BzWkXMFKothttOAL8hw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C5D2833961;
	Thu, 28 Apr 2022 16:22:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8258715230A3;
	Thu, 28 Apr 2022 16:22:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DD671947046;
	Thu, 28 Apr 2022 16:22:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 197C919466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 16:22:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08A8E40D1B9E; Thu, 28 Apr 2022 16:22:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0107F40D1B99;
 Thu, 28 Apr 2022 16:22:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23SGMQr2010319; Thu, 28 Apr 2022 12:22:26 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23SGMQYV010316; Thu, 28 Apr 2022 12:22:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 28 Apr 2022 12:22:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <YmeUXC3DZGLPJlWw@kroah.com>
Message-ID: <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
 <YmeUXC3DZGLPJlWw@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v5.10] dm: fix mempool NULL pointer race when
 completing IO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:

> On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > Hi
> 
> Not really needed in a changelog text :)
> 
> > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > and dm_wait_for_bios_completion") for the kernel 5.10.
> 
> Can you just make these 2 different patches?
> 
> > 
> > The bugs fixed by these patches can cause random crashing when reloading
> > dm table, so it is eligible for stable backport.
> > 
> > This patch is different from the upstream patches because the code
> > diverged significantly.
> > 
> 
> This change is _VERY_ different.  I would need acks from the maintainers
> of this code before I could accept this, along with a much more detailed
> description of why the original commits will not work here as well.
> 
> Same for the other backports.

Regarding backporting of 9f6dc633:

My reasoning was that introducing "md->pending_io" in the backported 
stable kernels is useless - it will just degrade performance by consuming 
one more cache line per I/O without providing any gain.

In the upstream kernels, Mike needs that "md->pending_io" variable for 
other reasons (the I/O accounting was reworked there in order to avoid 
some spikes with dm-crypt), but there is no need for it in the stable 
kernels.

In order to fix that race condition, all we need to do is to make sure 
that dm_stats_account_io is called before bio_end_io_acct - and the patch 
does that - it swaps them.

Do you still insist that this useless percpu variable must be added to the 
stable kernels? If you do, I can make it, but I think it's better to just 
swap those two functions.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

