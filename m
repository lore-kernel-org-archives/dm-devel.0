Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476A8C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:35:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D5D3861246
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 01:35:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5D3861246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-kYQjXCNQNE6cpIl-zTjhnA-1; Thu, 04 Nov 2021 21:35:29 -0400
X-MC-Unique: kYQjXCNQNE6cpIl-zTjhnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 631EACC624;
	Fri,  5 Nov 2021 01:35:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 137455DA60;
	Fri,  5 Nov 2021 01:35:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 574304A703;
	Fri,  5 Nov 2021 01:35:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A51ZMIU014491 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 21:35:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2475D40CFD10; Fri,  5 Nov 2021 01:35:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EB1840CFD0A
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 01:35:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02F171064C8D
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 01:35:22 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
	[209.85.214.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-220-MbqXX1l3NwGEJ6WR3ALqpw-1; Thu, 04 Nov 2021 21:35:20 -0400
X-MC-Unique: MbqXX1l3NwGEJ6WR3ALqpw-1
Received: by mail-pl1-f173.google.com with SMTP id r5so10159461pls.1
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 18:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=q+r8LSqikMIilQXxN0nyoS2okHlFhIR7lspEguCYFa0=;
	b=uEA1RdXNSd1Ac3DKxlFeyCGqd0uYxqUj8UV9njxeajtGz2Qxf+fx+qIYJGzIc4gELq
	Tp3Cq8FVCvl9rMxC7v8PucagMH/TdptmgchUBooi4gcyK2w0KPowHBnhG1ijkqc/zMt9
	cf6rXAcRZ35ucLVTMenoZtMeI7cwwKw50myk5kuKTvElckn5wl939r9+yTkJOPEqLwz0
	Cgtb13h3PB8NKxpXZYVdkiiKsN+3bCTpStTBFNsq2yj3XgmcCoXAP8SW4M8E4YboILAR
	4psnKZXOv3C8pb4Tv0my0PJqGHpjjp5PXp2/pL0LryR7ds1JO0usPq00bcSzf0hdAYr+
	CqGA==
X-Gm-Message-State: AOAM533XY1yRnmSWUZpEu0OPjutRaxzdFruHw7kUpi0Oe/Rl7MzWx/Wa
	+OFOEIdxZEsR973NTFem/w3+lZJRd1eYaJ4rrPDtCA==
X-Google-Smtp-Source: ABdhPJz1em1qltzKGt1ubVwIZtwjqPkj5fokslj5L/imxnRNQj9GTwkrfgkmhMUWrwfqIVtIAQM1IvqAgAXnAyo/9a8=
X-Received: by 2002:a17:90b:1e49:: with SMTP id
	pi9mr3596462pjb.220.1636076119266; 
	Thu, 04 Nov 2021 18:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
	<CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
	<YYOaOBKgFQYzT/s/@infradead.org>
	<CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
	<6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
	<CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
	<342eb71c-0aff-77e5-3c71-92224d7d48e0@oracle.com>
	<CAPcyv4hVu+A0PXgXTwWj3SBimP5pjX_97g+sfGeT47P0-SJkiQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hVu+A0PXgXTwWj3SBimP5pjX_97g+sfGeT47P0-SJkiQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 18:35:08 -0700
Message-ID: <CAPcyv4gLiaFEJW6W8XtDBH_Z4OPgHabdcWedmzy-_0Tqtjv5=A@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 5:46 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Nov 4, 2021 at 1:27 PM Jane Chu <jane.chu@oracle.com> wrote:
> >
> > On 11/4/2021 12:00 PM, Dan Williams wrote:
> >
> > >>
> > >> If this understanding is in the right direction, then I'd like to
> > >> propose below changes to
> > >>     dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
> > >>     and the dm layer copy_to/from_iter, dax_iomap_iter().
> > >>
> > >> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
> > >>      is likely media error: if the API without DAX_F_RECOVERY returns
> > >>      -EIO, then switch to recovery-read/write code.  In recovery code,
> > >>      supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
> > >>      'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.
> > >
> > > I like it. It allows for an atomic write+clear implementation on
> > > capable platforms and coordinates with potentially unmapped pages. The
> > > best of both worlds from the dax_clear_poison() proposal and my "take
> > > a fault and do a slow-path copy".
> > >
> > >> 2. the _copy_to/from_iter implementation would be largely the same
> > >>      as in my recent patch, but some changes in Christoph's
> > >>      'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
> > >>      virtual devices don't have the ability to clear poison, so no need
> > >>      to complicate them.  And this also means that not every endpoint
> > >>      dax device has to provide dax_op.copy_to/from_iter, they may use the
> > >>      default.
> > >
> > > Did I miss this series or are you talking about this one?
> > > https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/
> >
> > I was referring to
> >
> > http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> > that has not come out yet, I said early on that I'll rebase on it,
> > but looks like we still need pmem_copy_to/from_iter(), so.
>
> Yeah, since the block-layer divorce gets rid of the old poison
> clearing path, then we're back to pmem_copy_to_iter() (or something
> like it) needing to pick up the slack for poison clearing. I do agree
> it would be nice to clean up all the unnecessary boilerplate, but the
> error-list coordination requires a driver specific callback. At least
> the DAX_F_VIRTUAL flag can eliminate the virtiofs and fuse callbacks.

Although, if error management is generically implemented relative to a
'struct dax_device' then there wouldn't be a need to call all the way
back into the driver, and the cleanup could still move forward.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

