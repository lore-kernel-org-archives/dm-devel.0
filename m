Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED98C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:08:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9691323A00
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:08:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9691323A00
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610125683;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l8C0ewWkPw5qNY5hw9Ep5Ed9cQ4gZc4J8SxQn9xLVuU=;
	b=ELOr11kkGVmPjDAtDJiQKYAS0+K2kizHvxUZvwBD+yBuLMIjsK9aDmovThJZXmSfMir2/y
	Wk6EdqXoiEFZ8G9fcN6WA4ykBAxGzDMLZdBTWvidFdxzaIzVf0ZZOaoyTeGdbLSsQcVR3l
	bSeju1YoD0AhjFrtfWiWQ54oebZCUQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-2ar14LR1OWqpJlW8j06vhg-1; Fri, 08 Jan 2021 12:08:01 -0500
X-MC-Unique: 2ar14LR1OWqpJlW8j06vhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AAB459;
	Fri,  8 Jan 2021 17:07:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBCD760CEE;
	Fri,  8 Jan 2021 17:07:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 774294E58E;
	Fri,  8 Jan 2021 17:07:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108H7sDH023207 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 12:07:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A9FF61001E73; Fri,  8 Jan 2021 17:07:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A1610013BD;
	Fri,  8 Jan 2021 17:07:48 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 108H7lgj032632; Fri, 8 Jan 2021 12:07:47 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 108H7lM0032628; Fri, 8 Jan 2021 12:07:47 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 8 Jan 2021 12:07:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: John Dorminy <jdorminy@redhat.com>
In-Reply-To: <CAMeeMh9-J5T06nKNWQPqMs0Hxb=xtM9fXdwgXcU-owKD6+m81g@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2101081148510.30283@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2011261003400.11630@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011271240290.31117@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011301217010.17848@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh9-J5T06nKNWQPqMs0Hxb=xtM9fXdwgXcU-owKD6+m81g@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v3] dm-crypt: fix deadlock when swapping to
 encrypted device
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi


On Mon, 30 Nov 2020, John Dorminy wrote:

> I am the first to admit I don't understand all the subtleties of the
> block layer, but I'm worried about a deadlock in close analogy to that
> described in bio_alloc_bioset.
> https://elixir.bootlin.com/linux/latest/source/block/bio.c#L463
> Hopefully ya'll can clear up my understanding...
> 
> Specifically, if a segment of a target blocks in its map function, I
> believe that risks deadlock due to memory congestion. Such a action
> blocks the rest of the IO being submitted by the current thread, and
> the other IO currently being submitted may potentially be to other
> segments which may make progress and free memory.

All the request-based drivers block in their map function if there's more 
than 128 requests (it is tunable in /sys/block/*/queue/nr_requests).

So, many of the device mapper targets block as well - for example, the 
linear target just passes a bio down to an underlying device - so it will 
block if the underlying device has more than 128 requests in flight.

If you don't block, kswapd will just send another bio - and that is the 
problem.

> As a example, suppose something submits a bio to a device; the device
> submits three child bios in its map / submit_bio function, some with
> their own data allocated, to different devices, which add up to all
> the reclaimable memory on the system. The first of these bios gets
> blocked by the target (perhaps because it needs memory, or is at
> capacity). Because submit_bio_noacct() traverses bio submittals
> depth-first, the other two child bios will not be submitted to their,
> different, devices until the first of these bios finishes being
> submitted; although were those other two bios allowed to make
> progress, they might complete and free memory. (Admittedly, they might
> need to make further memory allocations to make progress. But in
> theory the mempool / bio_set reserve should allow forward progress on
> these other bios, I think.).
> 
> Even this limit only reduces, not eliminates, the problem. Consider a
> machine where fewer than 32768 bios exhausts the available memory;
> additional IOs will be accepted, but will be blocked by trying to
> allocate memory; that memory may be necessary to service the requests
> already in progress, causing a similar starvation of other
> memory-requiring work on the machine. It may be less likely on a
> well-tuned machine for there to be less memory than needed for
> dm-crypt to service 32768 IOs, but it's still possible.
> 
> I think it would be safer to stash excess bios on a list for future
> work, and, when congestion support exists again (I don't think it

But if you don't block, you'll get more bios - so the list would grow 
beyond limit.

And the excessive amount of bios in flight will reduce system 
responsiveness.

> currently does, but I haven't kept good track), perhaps use that
> mechanism to signal when the device is at capacity. But I am probably
> being too paranoid and missing some subtlety above.
> 
> Less major, and hopefully clearer, thoughts:
> 
> dm-crypt already has a concept of the max number of pages allocatable
> for currently active IOs -- specifically DM_CRYPT_MEMORY_PERCENT per
> cpu. If you're trying to scale by amount of memory on the system,
> perhaps going off DM_CRYPT_MEMORY_PERCENT is safer. I'm somewhat
> baffled why that mechanism isn't enough for the observed problem, tbh.

Perhaps we could lower DM_CRYPT_MEMORY_PERCENT, perhaps we could remove it 
and make a limit using a semaphore.

> Perhaps it would be better to add a maximum allocatable objects
> mechanism, if it's safe, to mempool, dm, or bioset. If it were in
> bio_alloc_bioset, it could take advantage of the same rescuer
> workqueue to keep from blocking, potentially.

dm-crypt is currently doing it - see "ret = mempool_init(&cc->page_pool, 
BIO_MAX_PAGES, crypt_alloc_page, crypt_free_page, cc);"

> Your patch format doesn't work when I try to apply them via git apply
> patchfile for testing, while most patches do... Not sure if it's you
> or me, but it seems most patches from git send-email / git
> format-patch have some stats about inserts/deletes after the ---
> marker, which marker seems missing from your messages. (Also,
> traditionally, I think the changes between patch versions go after the
> --- marker, so they don't go in the change description of the commit.)

I use quilt, not git, to work on my patches.

> Thanks!
> 
> John Dorminy

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

