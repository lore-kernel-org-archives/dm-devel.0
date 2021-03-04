Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6DEC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 10:09:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E091364F10
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 10:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E091364F10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614852582;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u+vLhO4hdLVLRJzzYGO+4alsuyNjxSIF+ZpPR9A4g9k=;
	b=aamSP+XfsgPiu6cAUaPoK51/7EsSY78OkvPJUw09fi4bqQE2w1lEDoh5At4Etu1FCOg+Lg
	6f5vbrLCMJkCpu733/WXpq5vN/Cyrm9dgfgYGDvtlmmIzflEMoxxlB9tzqohwHUtzMCzIg
	2Nyzbc0j91e2oLoyXuqblUpof/WvQjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-xScfhqq3MZmdpBQBYw3bGQ-1; Thu, 04 Mar 2021 05:09:41 -0500
X-MC-Unique: xScfhqq3MZmdpBQBYw3bGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA2431842149;
	Thu,  4 Mar 2021 10:09:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A3B18AAF;
	Thu,  4 Mar 2021 10:09:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A15874A714;
	Thu,  4 Mar 2021 10:09:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 124A9Tkf013468 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Mar 2021 05:09:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F120310023AF; Thu,  4 Mar 2021 10:09:29 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47364100E114;
	Thu,  4 Mar 2021 10:09:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 124A9PQ9007649; Thu, 4 Mar 2021 05:09:25 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 124A9Oo8007645; Thu, 4 Mar 2021 05:09:25 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 4 Mar 2021 05:09:24 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, caspar@linux.alibaba.com,
	hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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



On Thu, 4 Mar 2021, JeffleXu wrote:

> > __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
> > When we processed all the bios, we poll for the last cookie here:
> > 
> >         if (ci.poll_cookie != BLK_QC_T_NONE) {
> >                 while (atomic_read(&ci.io->io_count) > 1 &&
> >                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> >         }
> 
> So what will happen if one bio submitted to dm device crosses the device
> boundary among several target devices (e.g., dm-stripe)? Please refer
> the following call graph.
> 
> ```
> submit_bio
>   __submit_bio_noacct
>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
> call __split_and_process_non_flush() once, submitting the *first* split bio
>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
> call __split_and_process_non_flush() once, submitting the *second* split bio
>     ...
> ```
> 
> 
> So the loop is in __submit_bio_noacct(), rather than
> __split_and_process_bio(). Your design will send the first split bio,
> and then poll on this split bio, then send the next split bio, polling
> on this, go on and on...

No. It will send all the bios and poll for the last one.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

