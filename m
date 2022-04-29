Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3701BC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:37:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-44RUSCphOwGXVD2fZB6YQQ-1; Fri, 29 Apr 2022 04:37:49 -0400
X-MC-Unique: 44RUSCphOwGXVD2fZB6YQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 084B9101AA46;
	Fri, 29 Apr 2022 08:37:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF30214A5060;
	Fri, 29 Apr 2022 08:37:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55ED9194704B;
	Fri, 29 Apr 2022 08:37:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C83B1947047
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Apr 2022 08:37:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CEC714A5066; Fri, 29 Apr 2022 08:37:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0932C14A5060
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 08:37:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3A603C01D86
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 08:37:45 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-RBbTh7niOtO4dPoAqpNFPA-1; Fri, 29 Apr 2022 04:37:42 -0400
X-MC-Unique: RBbTh7niOtO4dPoAqpNFPA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8516C62163;
 Fri, 29 Apr 2022 08:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16FC385A4;
 Fri, 29 Apr 2022 08:37:39 +0000 (UTC)
Date: Fri, 29 Apr 2022 10:37:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <Ymuj0Y2A6WHOi05c@kroah.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
 <YmeUXC3DZGLPJlWw@kroah.com>
 <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 28, 2022 at 12:22:26PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:
> 
> > On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > > Hi
> > 
> > Not really needed in a changelog text :)
> > 
> > > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > > and dm_wait_for_bios_completion") for the kernel 5.10.
> > 
> > Can you just make these 2 different patches?
> > 
> > > 
> > > The bugs fixed by these patches can cause random crashing when reloading
> > > dm table, so it is eligible for stable backport.
> > > 
> > > This patch is different from the upstream patches because the code
> > > diverged significantly.
> > > 
> > 
> > This change is _VERY_ different.  I would need acks from the maintainers
> > of this code before I could accept this, along with a much more detailed
> > description of why the original commits will not work here as well.
> > 
> > Same for the other backports.
> 
> Regarding backporting of 9f6dc633:
> 
> My reasoning was that introducing "md->pending_io" in the backported 
> stable kernels is useless - it will just degrade performance by consuming 
> one more cache line per I/O without providing any gain.
> 
> In the upstream kernels, Mike needs that "md->pending_io" variable for 
> other reasons (the I/O accounting was reworked there in order to avoid 
> some spikes with dm-crypt), but there is no need for it in the stable 
> kernels.
> 
> In order to fix that race condition, all we need to do is to make sure 
> that dm_stats_account_io is called before bio_end_io_acct - and the patch 
> does that - it swaps them.
> 
> Do you still insist that this useless percpu variable must be added to the 
> stable kernels? If you do, I can make it, but I think it's better to just 
> swap those two functions.

I am no insisting on anything, I want the dm maintainers to agree that
this change is acceptable to take as it is not what is in Linus's tree.
Every time we take a "not upstream" commit, the odds are 90% that it
ends up being wrong, so I need extra review and assurances that it is
acceptable before I can apply it.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

