Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA93BC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 06:22:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 43042611CB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 06:22:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43042611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-etav6IudN4yF-jEr66HVYg-1; Thu, 04 Nov 2021 02:22:08 -0400
X-MC-Unique: etav6IudN4yF-jEr66HVYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 107CE8066F0;
	Thu,  4 Nov 2021 06:22:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2637D79591;
	Thu,  4 Nov 2021 06:22:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73DFB1806D03;
	Thu,  4 Nov 2021 06:21:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46Lu1k003424 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:21:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB7AD2026D5D; Thu,  4 Nov 2021 06:21:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D56942026D46
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:21:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FE65899EC0
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:21:53 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
	[209.85.214.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-456-mc1QuVtSO1-3pUq10fPX0Q-1; Thu, 04 Nov 2021 02:21:51 -0400
X-MC-Unique: mc1QuVtSO1-3pUq10fPX0Q-1
Received: by mail-pl1-f173.google.com with SMTP id o14so5586223plg.5
	for <dm-devel@redhat.com>; Wed, 03 Nov 2021 23:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ZyuA6ddRdNnvNpvSUsN4hZr4Uf2uGmRKXvml9zPHv3U=;
	b=A3ITJTJH2fiRdigKbVoFfNwYifPj9YeASsb7CFC6uIkxW1Sx3NwkdY2S5BWKqlQfCA
	stJlep/VXEtn98a21wKD8zFpABwpmDbW2nzzeh2Gz+cqryOzVJ1fWpRzr1FHLioDxOue
	5afGNEd3ravtelY77j0OVO3qm28owQ0wxoH9S7xRMTl3p2pD6yXrwUcIwQoiYCKustN3
	Xps1d6t0/3TK3AoS5BtEFjYmHD5oeLMg4f4SY1FQay3ViwikSU/lQpnvYpZXTpA6FsLs
	k84IR2BYWzZxjZSc3Fp5XK5jFv3uua3u/k4f5sqrqW9KPiLEpamectnX+yejh1MuW0yu
	husw==
X-Gm-Message-State: AOAM531G9rXSCRtX53eUVknXriW9sb5WLBKWeflqr0Rs+wtZ4S1D6aff
	ilcHtqimLWvFXfh1PN+Q4GbVzvjS34ljkc+Um6t4CA==
X-Google-Smtp-Source: ABdhPJx4n/3hi5QSqYsscdoJBCM1f/g8m0p4vAuABjz6+mE+bZ+8hWcuD6Y6gRvy3XYJHICi5mkaZySCeaB3JPBO+/Q=
X-Received: by 2002:a17:90a:6c47:: with SMTP id
	x65mr3577541pjj.8.1636006910291; 
	Wed, 03 Nov 2021 23:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org>
	<dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
In-Reply-To: <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Nov 2021 23:21:39 -0700
Message-ID: <CAPcyv4jLn4_SYxLtp_cUT=mm6Y3An22BA+sqex1S-CBnAm6qGA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 3, 2021 at 11:10 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/1/2021 11:18 PM, Christoph Hellwig wrote:
> > On Wed, Oct 27, 2021 at 05:24:51PM -0700, Darrick J. Wong wrote:
> >> ...so would you happen to know if anyone's working on solving this
> >> problem for us by putting the memory controller in charge of dealing
> >> with media errors?
> >
> > The only one who could know is Intel..
> >
> >> The trouble is, we really /do/ want to be able to (re)write the failed
> >> area, and we probably want to try to read whatever we can.  Those are
> >> reads and writes, not {pre,f}allocation activities.  This is where Dave
> >> and I arrived at a month ago.
> >>
> >> Unless you'd be ok with a second IO path for recovery where we're
> >> allowed to be slow?  That would probably have the same user interface
> >> flag, just a different path into the pmem driver.
> >
> > Which is fine with me.  If you look at the API here we do have the
> > RWF_ API, which them maps to the IOMAP API, which maps to the DAX_
> > API which then gets special casing over three methods.
> >
> > And while Pavel pointed out that he and Jens are now optimizing for
> > single branches like this.  I think this actually is silly and it is
> > not my point.
> >
> > The point is that the DAX in-kernel API is a mess, and before we make
> > it even worse we need to sort it first.  What is directly relevant
> > here is that the copy_from_iter and copy_to_iter APIs do not make
> > sense.  Most of the DAX API is based around getting a memory mapping
> > using ->direct_access, it is just the read/write path which is a slow
> > path that actually uses this.  I have a very WIP patch series to try
> > to sort this out here:
> >
> > http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> >
> > But back to this series.  The basic DAX model is that the callers gets a
> > memory mapping an just works on that, maybe calling a sync after a write
> > in a few cases.  So any kind of recovery really needs to be able to
> > work with that model as going forward the copy_to/from_iter path will
> > be used less and less.  i.e. file systems can and should use
> > direct_access directly instead of using the block layer implementation
> > in the pmem driver.  As an example the dm-writecache driver, the pending
> > bcache nvdimm support and the (horribly and out of tree) nova file systems
> > won't even use this path.  We need to find a way to support recovery
> > for them.  And overloading it over the read/write path which is not
> > the main path for DAX, but the absolutely fast path for 99% of the
> > kernel users is a horrible idea.
> >
> > So how can we work around the horrible nvdimm design for data recovery
> > in a way that:
> >
> >     a) actually works with the intended direct memory map use case
> >     b) doesn't really affect the normal kernel too much
> >
> > ?
> >
>
> This is clearer, I've looked at your 'dax-devirtualize' patch which
> removes pmem_copy_to/from_iter, and as you mentioned before,
> a separate API for poison-clearing is needed. So how about I go ahead
> rebase my earlier patch
>
> https://lore.kernel.org/lkml/20210914233132.3680546-2-jane.chu@oracle.com/
> on 'dax-devirtualize', provide dm support for clear-poison?
> That way, the non-dax 99% of the pwrite use-cases aren't impacted at all
> and we resolve the urgent pmem poison-clearing issue?
>
> Dan, are you okay with this?  I am getting pressure from our customers
> who are basically stuck at the moment.

The concern I have with dax_clear_poison() is that it precludes atomic
error clearing. Also, as Boris and I discussed, poisoned pages should
be marked NP (not present) rather than UC (uncacheable) [1]. With
those 2 properties combined I think that wants a custom pmem fault
handler that knows how to carefully write to pmem pages with poison
present, rather than an additional explicit dax-operation. That also
meets Christoph's requirement of "works with the intended direct
memory map use case".

[1]: https://lore.kernel.org/r/CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

