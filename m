Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8BFC64E7B
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 22:30:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 890802076E
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 22:30:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPDfbO4K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 890802076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606775417;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aVil9XQH8kJZP7JzxlJuLlGSxI7Fe1eeFTxEBSizHzI=;
	b=gPDfbO4KOUWBZ9Qwi+dHxyY6oykL09GsgOSFV9cmbLUUw1MwbKTD+6O8HQq66bT7K0ncLr
	ocEp2KWjI4BJqca6cLh79tB5UoqwfDduXNt/gpOecGUlbgKZUXLCOkarKe38y51QOvEfyo
	tldKrKnFip2gFXcc4bL+V+yqS2UuCPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-yOAs2e8_O-yaqOvjmzDmnw-1; Mon, 30 Nov 2020 17:30:15 -0500
X-MC-Unique: yOAs2e8_O-yaqOvjmzDmnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2134B8103;
	Mon, 30 Nov 2020 22:30:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21DAF5C1A3;
	Mon, 30 Nov 2020 22:30:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CCDD74A7C6;
	Mon, 30 Nov 2020 22:30:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUMU2qY006154 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 17:30:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9523D110FBF9; Mon, 30 Nov 2020 22:30:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90A5E110FBF8
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 22:30:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 449F2858295
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 22:30:00 +0000 (UTC)
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
	[209.85.222.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-337-z-YEw8SeOsmb95K0ktyBEg-1; Mon, 30 Nov 2020 17:29:58 -0500
X-MC-Unique: z-YEw8SeOsmb95K0ktyBEg-1
Received: by mail-ua1-f70.google.com with SMTP id c19so3751604uav.2
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=knaqw/9lD9ntN23QxFefYpGlkOToINJvMLw1LQDC8TU=;
	b=qhfu1Q94vPjszylGU6l8tVGI3UVMmvnT6ahyY4QSZeojbWxaJFJ99ZJWRcwra1uyPl
	gctrh2N64LnRjBwp5CTJaXgICB+rctyyF3x9+44o+xTqkCWNT0+XKWwwymXSWOYAyPZ2
	ewiwpIceI2nrRCs5+LCteDUDYbjrlErDRyVSwSKS2IJ52Z0sqmG43AZ6iWSK9+Twcu/J
	YTLEXFqL0ZDSBgES9CyeMAStkv6UBbjKQUgq/dEdJina5jA6zzsusofh5PB5hCsyfQY+
	CHKx+69VQER0F0IN9jCW6yi9Gnpxx5WFMKkrUuV50ACIKRJLsQKDAHCxRF3yOYeXlxaZ
	3sHA==
X-Gm-Message-State: AOAM533WXWB7swHE7+GfXfQTYi9kiL9x3J/PBgxrVAJiL1uUvsDYnHsj
	FnDdyzyw8j2dkOtJ+E5HgoM6lI5pum9oG/IGLkni36xhBe6zYDbVemoEh5AcUFVOQat1ITaqTf8
	PqANKsr554GD7K7xhldZBxGDxtLeFHHA=
X-Received: by 2002:a05:6102:1cb:: with SMTP id
	s11mr7525325vsq.7.1606775396351; 
	Mon, 30 Nov 2020 14:29:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB/KEWMLizO6WMvEejkp32NXcFD3qYmoTMKqU6dtdfcb91SEl8YmQHqwad4oKUIl/ocsrR+pY9o6F+3RQXUKY=
X-Received: by 2002:a05:6102:1cb:: with SMTP id
	s11mr7525304vsq.7.1606775396166; 
	Mon, 30 Nov 2020 14:29:56 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2011261003400.11630@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011271240290.31117@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011301217010.17848@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2011301217010.17848@file01.intranet.prod.int.rdu2.redhat.com>
From: John Dorminy <jdorminy@redhat.com>
Date: Mon, 30 Nov 2020 17:29:45 -0500
Message-ID: <CAMeeMh9-J5T06nKNWQPqMs0Hxb=xtM9fXdwgXcU-owKD6+m81g@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I am the first to admit I don't understand all the subtleties of the
block layer, but I'm worried about a deadlock in close analogy to that
described in bio_alloc_bioset.
https://elixir.bootlin.com/linux/latest/source/block/bio.c#L463
Hopefully ya'll can clear up my understanding...

Specifically, if a segment of a target blocks in its map function, I
believe that risks deadlock due to memory congestion. Such a action
blocks the rest of the IO being submitted by the current thread, and
the other IO currently being submitted may potentially be to other
segments which may make progress and free memory.

As a example, suppose something submits a bio to a device; the device
submits three child bios in its map / submit_bio function, some with
their own data allocated, to different devices, which add up to all
the reclaimable memory on the system. The first of these bios gets
blocked by the target (perhaps because it needs memory, or is at
capacity). Because submit_bio_noacct() traverses bio submittals
depth-first, the other two child bios will not be submitted to their,
different, devices until the first of these bios finishes being
submitted; although were those other two bios allowed to make
progress, they might complete and free memory. (Admittedly, they might
need to make further memory allocations to make progress. But in
theory the mempool / bio_set reserve should allow forward progress on
these other bios, I think.).

Even this limit only reduces, not eliminates, the problem. Consider a
machine where fewer than 32768 bios exhausts the available memory;
additional IOs will be accepted, but will be blocked by trying to
allocate memory; that memory may be necessary to service the requests
already in progress, causing a similar starvation of other
memory-requiring work on the machine. It may be less likely on a
well-tuned machine for there to be less memory than needed for
dm-crypt to service 32768 IOs, but it's still possible.

I think it would be safer to stash excess bios on a list for future
work, and, when congestion support exists again (I don't think it
currently does, but I haven't kept good track), perhaps use that
mechanism to signal when the device is at capacity. But I am probably
being too paranoid and missing some subtlety above.

Less major, and hopefully clearer, thoughts:

dm-crypt already has a concept of the max number of pages allocatable
for currently active IOs -- specifically DM_CRYPT_MEMORY_PERCENT per
cpu. If you're trying to scale by amount of memory on the system,
perhaps going off DM_CRYPT_MEMORY_PERCENT is safer. I'm somewhat
baffled why that mechanism isn't enough for the observed problem, tbh.

Perhaps it would be better to add a maximum allocatable objects
mechanism, if it's safe, to mempool, dm, or bioset. If it were in
bio_alloc_bioset, it could take advantage of the same rescuer
workqueue to keep from blocking, potentially.

Your patch format doesn't work when I try to apply them via git apply
patchfile for testing, while most patches do... Not sure if it's you
or me, but it seems most patches from git send-email / git
format-patch have some stats about inserts/deletes after the ---
marker, which marker seems missing from your messages. (Also,
traditionally, I think the changes between patch versions go after the
--- marker, so they don't go in the change description of the commit.)

Thanks!

John Dorminy

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

