Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC0FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:32:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF4DF60240
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF4DF60240
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635323525;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Md6lkBQFnuqumCr/l6P28tCfejAYbXnOKpzL82mzXcg=;
	b=brTIoOvRujqVRJU1xbNKD3CGXCPrKbptmi7KfeUfJDcgrrTqke5UKyhtJ9oa7urS0xO7dM
	pYgHshOTLrl9lZev+I+v5Q1ZyMbjS0w/7JB6/bYr9guhDLeVwhvdNh2Pz+Q59ky+RFX2xu
	Y5qFW+UFcoxYJhdPzeF60hvDDXFbaVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-pGMmt9hsPre4B76igM8ToA-1; Wed, 27 Oct 2021 04:32:00 -0400
X-MC-Unique: pGMmt9hsPre4B76igM8ToA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FFF8100CC92;
	Wed, 27 Oct 2021 08:31:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D911B60BF1;
	Wed, 27 Oct 2021 08:31:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6D62F4E9E2;
	Wed, 27 Oct 2021 08:31:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19R8Sb2N023471 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 04:28:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6CAE7196E6; Wed, 27 Oct 2021 08:28:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B192D19D9D;
	Wed, 27 Oct 2021 08:28:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 19R8S4eD010949; Wed, 27 Oct 2021 04:28:04 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 19R8S3sR010945; Wed, 27 Oct 2021 04:28:03 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 27 Oct 2021 04:28:03 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Dave Chinner <david@fromorbit.com>
In-Reply-To: <20211027050249.GC5111@dread.disaster.area>
Message-ID: <alpine.LRH.2.02.2110270421380.10452@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2109231539520.27863@file01.intranet.prod.int.rdu2.redhat.com>
	<20210924155822.GA10064@lst.de>
	<alpine.LRH.2.02.2110040851130.30719@file01.intranet.prod.int.rdu2.redhat.com>
	<20211012062049.GB17407@lst.de>
	<alpine.LRH.2.02.2110121516440.21015@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2110130524220.16882@file01.intranet.prod.int.rdu2.redhat.com>
	<20211027050249.GC5111@dread.disaster.area>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Zdenek Kabelac <zkabelac@redhat.com>,
	linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4] loop: don't print warnings if the
 underlying filesystem doesn't support discard
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 27 Oct 2021, Dave Chinner wrote:

> On Wed, Oct 13, 2021 at 05:28:36AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending version 4 of the patch. It adds #include <linux/falloc.h> 
> > to cifs and overlayfs to fix the bugs found out by the kernel test robot.
> > 
> > Mikulas
> > 
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > The loop driver checks for the fallocate method and if it is present, it 
> > assumes that the filesystem can do FALLOC_FL_ZERO_RANGE and 
> > FALLOC_FL_PUNCH_HOLE requests. However, some filesystems (such as fat, or 
> > tmpfs) have the fallocate method, but lack the capability to do 
> > FALLOC_FL_ZERO_RANGE and/or FALLOC_FL_PUNCH_HOLE.
> 
> This seems like a loopback driver level problem, not something
> filesystems need to solve. fallocate() is defined to return
> -EOPNOTSUPP if a flag is passed that it does not support and that's
> the mechanism used to inform callers that a fallocate function is
> not supported by the underlying filesystem/storage.
> 
> Indeed, filesystems can support hole punching at the ->fallocate(),
> but then return EOPNOTSUPP because certain dynamic conditions are
> not met e.g. CIFS needs sparse file support on the server to support
> hole punching, but we don't know this until we actually try to 
> sparsify the file. IOWs, this patch doesn't address all the cases
> where EOPNOTSUPP might actually get returned from filesystems and/or
> storage.
> 
> > This results in syslog warnings "blk_update_request: operation not 
> > supported error, dev loop0, sector 0 op 0x9:(WRITE_ZEROES) flags 0x800800 
> > phys_seg 0 prio class 0". The error can be reproduced with this command: 
> > "truncate -s 1GiB /tmp/file; losetup /dev/loop0 /tmp/file; blkdiscard -z 
> > /dev/loop0"
> 
> Which I'm assuming comes from this:
> 
> 	        if (unlikely(error && !blk_rq_is_passthrough(req) &&
>                      !(req->rq_flags & RQF_QUIET)))
>                 print_req_error(req, error, __func__);
> 
> Which means we could supress the error message quite easily in
> lo_fallocate() by doing:
> 
> out:
> 	if (ret == -EOPNOTSUPP)
> 		rq->rq_flags |= RQF_QUIET;
> 	return ret;

I did this (see 
https://lore.kernel.org/all/alpine.LRH.2.02.2109231539520.27863@file01.intranet.prod.int.rdu2.redhat.com/ 
) and Christoph Hellwig asked for a flag in the file_operations structure 
( https://lore.kernel.org/all/20210924155822.GA10064@lst.de/ ).

Mikulas

> And then we can also run blk_queue_flag_clear(QUEUE_FLAG_DISCARD)
> (and whatever else is needed to kill discards) to turn off future
> discard attempts on that loopback device. This way the problem is
> just quietly and correctly handled by the loop device and everything
> is good...
> 
> Thoughts?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

