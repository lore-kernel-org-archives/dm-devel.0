Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C20CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 23:00:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DDCE610E5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 23:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9DDCE610E5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-RHh1DgvzPcW-_DiocXC2oA-1; Thu, 28 Oct 2021 19:00:18 -0400
X-MC-Unique: RHh1DgvzPcW-_DiocXC2oA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5959A80A5C0;
	Thu, 28 Oct 2021 23:00:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6294E6A908;
	Thu, 28 Oct 2021 23:00:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1AE2D1800B9C;
	Thu, 28 Oct 2021 23:00:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19SN08kI003122 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Oct 2021 19:00:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DF9A340D1B9D; Thu, 28 Oct 2021 23:00:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB4EB40C1242
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 23:00:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1480185A79C
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 23:00:08 +0000 (UTC)
Received: from mail110.syd.optusnet.com.au (mail110.syd.optusnet.com.au
	[211.29.132.97]) by relay.mimecast.com with ESMTP id
	us-mta-586-MxSuvIKjNPOSeHCJqpZlzg-1; Thu, 28 Oct 2021 19:00:01 -0400
X-MC-Unique: MxSuvIKjNPOSeHCJqpZlzg-1
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au
	[49.180.20.157])
	by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 233FD10911C;
	Fri, 29 Oct 2021 09:59:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1mgENH-002C7K-TH; Fri, 29 Oct 2021 09:59:55 +1100
Date: Fri, 29 Oct 2021 09:59:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20211028225955.GA449541@dread.disaster.area>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
MIME-Version: 1.0
In-Reply-To: <20211028002451.GB2237511@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=617b2b6f
	a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
	a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
	a=k1Z2RRqN3eVEGd4K9SgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 27, 2021 at 05:24:51PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 26, 2021 at 11:49:59PM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote:
> > > Thanks - I try to be honest.  As far as I can tell, the argument
> > > about the flag is a philosophical argument between two views.
> > > One view assumes design based on perfect hardware, and media error
> > > belongs to the category of brokenness. Another view sees media
> > > error as a build-in hardware component and make design to include
> > > dealing with such errors.
> > 
> > No, I don't think so.  Bit errors do happen in all media, which is
> > why devices are built to handle them.  It is just the Intel-style
> > pmem interface to handle them which is completely broken.  
> 
> Yeah, I agree, this takes me back to learning how to use DISKEDIT to
> work around a hole punched in a file (with a pen!) in the 1980s...
> 
> ...so would you happen to know if anyone's working on solving this
> problem for us by putting the memory controller in charge of dealing
> with media errors?
> 
> > > errors in mind from start.  I guess I'm trying to articulate why
> > > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > > and its slow path (w/ error clearing) is faster than other alternative.
> > > Other alternative being 1 system call to clear the poison, and
> > > another system call to run the fast pwrite for recovery, what
> > > happens if something happened in between?
> > 
> > Well, my point is doing recovery from bit errors is by definition not
> > the fast path.  Which is why I'd rather keep it away from the pmem
> > read/write fast path, which also happens to be the (much more important)
> > non-pmem read/write path.
> 
> The trouble is, we really /do/ want to be able to (re)write the failed
> area, and we probably want to try to read whatever we can.  Those are
> reads and writes, not {pre,f}allocation activities.  This is where Dave
> and I arrived at a month ago.
> 
> Unless you'd be ok with a second IO path for recovery where we're
> allowed to be slow?  That would probably have the same user interface
> flag, just a different path into the pmem driver.

I just don't see how 4 single line branches to propage RWF_RECOVERY
down to the hardware is in any way an imposition on the fast path.
It's no different for passing RWF_HIPRI down to the hardware *in the
fast path* so that the IO runs the hardware in polling mode because
it's faster for some hardware.

IOWs, saying that we shouldn't implement RWF_RECOVERY because it
adds a handful of branches to the fast path is like saying that we
shouldn't implement RWF_HIPRI because it slows down the fast path
for non-polled IO....

Just factor the actual recovery operations out into a separate
function like:

static void noinline
pmem_media_recovery(...)
{
}

pmem_copy_from_iter()
{
	if ((unlikely)(flag & RECOVERY))
		pmem_media_recovery(...);
	return _copy_from_iter_flushcache(addr, bytes, i);
}
....

And there's basically zero overhead in the fast paths for normal
data IO operations, whilst supporting a simple, easy to use data
recovery IO operations for regions that have bad media...

> Ha, how about a int fd2 = recoveryfd(fd); call where you'd get whatever
> speshul options (retry raid mirrors!  scrape the film off the disk if
> you have to!) you want that can take forever, leaving the fast paths
> alone?

Why wouldn't we just pass RWF_RECOVERY down to a REQ_RECOVERY bio
flag and have raid devices use that to trigger scraping whatever
they can if there are errors? The io path through the VFS and
filesystem to get the scraped data out to the user *is exactly the
same*, so we're going to have to plumb this functionality into fast
paths *somewhere along the line*.

Really, I think this whole "flag propagation is too much overhead
for the fast path" argument is completely invalid - if 4 conditional
branches is too much overhead to add to the fast path, then we can't
add *anything ever again* to the IO path because it has too much
overhead and impact on the fast path.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

