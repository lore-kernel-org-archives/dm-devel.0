Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E60C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 05:24:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94BF861073
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 05:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 94BF861073
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-QKeLOq7DMe67oFbao3NiHg-1; Wed, 27 Oct 2021 01:24:18 -0400
X-MC-Unique: QKeLOq7DMe67oFbao3NiHg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8D05802B78;
	Wed, 27 Oct 2021 05:24:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8189060843;
	Wed, 27 Oct 2021 05:24:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A1E8180BAD2;
	Wed, 27 Oct 2021 05:24:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19R5O7cG007236 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 01:24:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A882151E1; Wed, 27 Oct 2021 05:24:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A338B51DD
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 05:24:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE147800141
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 05:24:01 +0000 (UTC)
Received: from mail106.syd.optusnet.com.au (mail106.syd.optusnet.com.au
	[211.29.132.42]) by relay.mimecast.com with ESMTP id
	us-mta-564-QLDPb11aNzqgzXDqhYG4oA-1; Wed, 27 Oct 2021 01:23:58 -0400
X-MC-Unique: QLDPb11aNzqgzXDqhYG4oA-1
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au
	[49.180.20.157])
	by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 64CC786330D;
	Wed, 27 Oct 2021 16:02:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mfb5N-001VI9-R0; Wed, 27 Oct 2021 16:02:49 +1100
Date: Wed, 27 Oct 2021 16:02:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20211027050249.GC5111@dread.disaster.area>
References: <alpine.LRH.2.02.2109231539520.27863@file01.intranet.prod.int.rdu2.redhat.com>
	<20210924155822.GA10064@lst.de>
	<alpine.LRH.2.02.2110040851130.30719@file01.intranet.prod.int.rdu2.redhat.com>
	<20211012062049.GB17407@lst.de>
	<alpine.LRH.2.02.2110121516440.21015@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2110130524220.16882@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2110130524220.16882@file01.intranet.prod.int.rdu2.redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6178dd7d
	a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
	a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
	a=nlNMiS1GOempI7xxVB0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 05:28:36AM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending version 4 of the patch. It adds #include <linux/falloc.h> 
> to cifs and overlayfs to fix the bugs found out by the kernel test robot.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The loop driver checks for the fallocate method and if it is present, it 
> assumes that the filesystem can do FALLOC_FL_ZERO_RANGE and 
> FALLOC_FL_PUNCH_HOLE requests. However, some filesystems (such as fat, or 
> tmpfs) have the fallocate method, but lack the capability to do 
> FALLOC_FL_ZERO_RANGE and/or FALLOC_FL_PUNCH_HOLE.

This seems like a loopback driver level problem, not something
filesystems need to solve. fallocate() is defined to return
-EOPNOTSUPP if a flag is passed that it does not support and that's
the mechanism used to inform callers that a fallocate function is
not supported by the underlying filesystem/storage.

Indeed, filesystems can support hole punching at the ->fallocate(),
but then return EOPNOTSUPP because certain dynamic conditions are
not met e.g. CIFS needs sparse file support on the server to support
hole punching, but we don't know this until we actually try to 
sparsify the file. IOWs, this patch doesn't address all the cases
where EOPNOTSUPP might actually get returned from filesystems and/or
storage.

> This results in syslog warnings "blk_update_request: operation not 
> supported error, dev loop0, sector 0 op 0x9:(WRITE_ZEROES) flags 0x800800 
> phys_seg 0 prio class 0". The error can be reproduced with this command: 
> "truncate -s 1GiB /tmp/file; losetup /dev/loop0 /tmp/file; blkdiscard -z 
> /dev/loop0"

Which I'm assuming comes from this:

	        if (unlikely(error && !blk_rq_is_passthrough(req) &&
                     !(req->rq_flags & RQF_QUIET)))
                print_req_error(req, error, __func__);

Which means we could supress the error message quite easily in
lo_fallocate() by doing:

out:
	if (ret == -EOPNOTSUPP)
		rq->rq_flags |= RQF_QUIET;
	return ret;

And then we can also run blk_queue_flag_clear(QUEUE_FLAG_DISCARD)
(and whatever else is needed to kill discards) to turn off future
discard attempts on that loopback device. This way the problem is
just quietly and correctly handled by the loop device and everything
is good...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

