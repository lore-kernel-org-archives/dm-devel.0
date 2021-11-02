Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C927C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 19:57:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9807C60F70
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 19:57:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9807C60F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-NcRPtK2kMA-I42UoFSHfpQ-1; Tue, 02 Nov 2021 15:57:39 -0400
X-MC-Unique: NcRPtK2kMA-I42UoFSHfpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6C5C10A8E00;
	Tue,  2 Nov 2021 19:57:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB2EB5BAE2;
	Tue,  2 Nov 2021 19:57:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73F1D4A704;
	Tue,  2 Nov 2021 19:57:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2JvRWu024596 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 15:57:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE36040D1B9E; Tue,  2 Nov 2021 19:57:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA0E140D1B9D
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 19:57:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B123A83395B
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 19:57:27 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
	[209.85.214.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-484-rq7gFFfnOm2Shj64DSWnzA-1; Tue, 02 Nov 2021 15:57:22 -0400
X-MC-Unique: rq7gFFfnOm2Shj64DSWnzA-1
Received: by mail-pl1-f182.google.com with SMTP id k4so500344plx.8
	for <dm-devel@redhat.com>; Tue, 02 Nov 2021 12:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=27/CElpQAMzqqxlHmQpeS6Xg/mCPIF70OaGp9omQL+c=;
	b=6M8qEeXiinhda9BRGFZOiJIXGGr3BAJATAx7kAAkRSSaTr5WciEKl1CkcwLAI8y5v/
	s7aGrWhskLsnVOndBNMHpgTAzq8dSFU+++iznqAsr4eobRpyRAM+DM136YoHWwpZvlwD
	5d4/ZR9g7nawQXGYzm2Q2d6bxaqLgz+4PH/H7hsufcYGxBsyNEe0fhqSba8shqO23E3b
	4veGMjxuwNy/nNb9/Ucd460QMUeXr7yiUA6g2mFYpgZY3cK8tMcAFGPfKTHucTwGn+PU
	ClECtZLh+tpeEDnlXoUsHGWDTqgfCPK6gAthQyOan89vlSxXcDUxPcc3MkEkSjJsJlfH
	HJNg==
X-Gm-Message-State: AOAM533NyL+ngE8xExsD9s/hpyGsHfnNZMvZmCHkuI7cw/hD83lyHqwG
	H3AhheDMiHZbDTsr+iCo2kkniv8y6tsfDqiZF1hv/A==
X-Google-Smtp-Source: ABdhPJzq586k0UH/EQKwqZQVt2ykdjLrrPOPnL+mNuoKsJoIKHfRoBAF8+snuu5yn1iHwpf7ywngttf1p1qav9DOqoI=
X-Received: by 2002:a17:90a:a085:: with SMTP id r5mr9265133pjp.8.1635883041063;
	Tue, 02 Nov 2021 12:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org>
In-Reply-To: <YYDYUCCiEPXhZEw0@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 12:57:10 -0700
Message-ID: <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
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
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 1, 2021 at 11:19 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Oct 27, 2021 at 05:24:51PM -0700, Darrick J. Wong wrote:
> > ...so would you happen to know if anyone's working on solving this
> > problem for us by putting the memory controller in charge of dealing
> > with media errors?
>
> The only one who could know is Intel..
>
> > The trouble is, we really /do/ want to be able to (re)write the failed
> > area, and we probably want to try to read whatever we can.  Those are
> > reads and writes, not {pre,f}allocation activities.  This is where Dave
> > and I arrived at a month ago.
> >
> > Unless you'd be ok with a second IO path for recovery where we're
> > allowed to be slow?  That would probably have the same user interface
> > flag, just a different path into the pmem driver.
>
> Which is fine with me.  If you look at the API here we do have the
> RWF_ API, which them maps to the IOMAP API, which maps to the DAX_
> API which then gets special casing over three methods.
>
> And while Pavel pointed out that he and Jens are now optimizing for
> single branches like this.  I think this actually is silly and it is
> not my point.
>
> The point is that the DAX in-kernel API is a mess, and before we make
> it even worse we need to sort it first.  What is directly relevant
> here is that the copy_from_iter and copy_to_iter APIs do not make
> sense.  Most of the DAX API is based around getting a memory mapping
> using ->direct_access, it is just the read/write path which is a slow
> path that actually uses this.  I have a very WIP patch series to try
> to sort this out here:
>
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
>
> But back to this series.  The basic DAX model is that the callers gets a
> memory mapping an just works on that, maybe calling a sync after a write
> in a few cases.  So any kind of recovery really needs to be able to
> work with that model as going forward the copy_to/from_iter path will
> be used less and less.  i.e. file systems can and should use
> direct_access directly instead of using the block layer implementation
> in the pmem driver.  As an example the dm-writecache driver, the pending
> bcache nvdimm support and the (horribly and out of tree) nova file systems
> won't even use this path.  We need to find a way to support recovery
> for them.  And overloading it over the read/write path which is not
> the main path for DAX, but the absolutely fast path for 99% of the
> kernel users is a horrible idea.
>
> So how can we work around the horrible nvdimm design for data recovery
> in a way that:
>
>    a) actually works with the intended direct memory map use case
>    b) doesn't really affect the normal kernel too much
>
> ?

Ok, now I see where you are going, but I don't see line of sight to
something better than RWF_RECOVER_DATA.

This goes back to one of the original DAX concerns of wanting a kernel
library for coordinating PMEM mmap I/O vs leaving userspace to wrap
PMEM semantics on top of a DAX mapping. The problem is that mmap-I/O
has this error-handling-API issue whether it is a DAX mapping or not.
I.e. a memory failure in page cache is going to signal the process the
same way and it will need to fall back to something other than mmap
I/O to make forward progress. This is not a PMEM, Intel or even x86
problem, it's a generic CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE problem.

CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE implies that processes will
receive SIGBUS + BUS_MCEERR_A{R,O} when memory failure is signalled
and then rely on readv(2)/writev(2) to recover. Do you see a readily
available way to improve upon that model without CPU instruction
changes? Even with CPU instructions changes, do you think it could
improve much upon the model of interrupting the process when a load
instruction aborts?

I do agree with you that DAX needs to separate itself from block, but
I don't think it follows that DAX also needs to separate itself from
readv/writev for when a kernel slow-path needs to get involved because
mmap I/O (just CPU instructions) does not have the proper semantics.
Even if you got one of the ARCH_SUPPORTS_MEMORY_FAILURE to implement
those semantics in new / augmented CPU instructions you will likely
not get all of them to move and certainly not in any near term
timeframe, so the kernel path will be around indefinitely.

Meanwhile, I think RWF_RECOVER_DATA is generically useful for other
storage besides PMEM and helps storage-drivers do better than large
blast radius "I/O error" completions with no other recourse.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

