Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00AFC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 00:46:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6994060E73
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 00:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6994060E73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-2RLFTmH5MgeVGkgyXAXnSQ-1; Thu, 04 Nov 2021 20:46:38 -0400
X-MC-Unique: 2RLFTmH5MgeVGkgyXAXnSQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA2D71006AAC;
	Fri,  5 Nov 2021 00:46:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A22660C13;
	Fri,  5 Nov 2021 00:46:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 030BB1806D03;
	Fri,  5 Nov 2021 00:46:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A50kTAY010674 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 20:46:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B711340CFD10; Fri,  5 Nov 2021 00:46:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1AFD40CFD0A
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 00:46:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98FDA1064E6F
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 00:46:29 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
	[209.85.216.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-508-2i6NJqy7NHGhtYG9J-ZN6A-1; Thu, 04 Nov 2021 20:46:28 -0400
X-MC-Unique: 2i6NJqy7NHGhtYG9J-ZN6A-1
Received: by mail-pj1-f51.google.com with SMTP id
	x16-20020a17090a789000b001a69735b339so2201447pjk.5
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 17:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=+MDx1GrQOub7zJ6Bty8NHKGO6IrOVwg4Q81dxTNGuQk=;
	b=CSJRqeSEnmrn9F3nvY64yH0+6jz8Pu1AgXzWmEMlz4vQp8wigvOOA4p4vB6Wljc8z1
	4WyVDkqTXvUvVkdkU3bnoJs63eMl/yu0gY59IE6UFZjlgNTpiaNLH0KAQTM0iRVR+Qb3
	sJ4cMhaRjF7Eu45xkgHVi98jBBD/SbXHTkxzuQWNfLnjY6z2Yjl+F4h6cgEDOa63tAoW
	t98rVqD3Vrc2GyanysqHBcglwBoHUZ+N3k4v3YxEvC96bPiU1z5LoWY+lYcAPMQDvmDD
	HQ5t4c5DHJ72uKV3Yb9e0d77Sxf6qC9xUsNqr/WjHhyNSQrGyam46VfnDUPn5ERaQP7d
	4HAQ==
X-Gm-Message-State: AOAM531NZ3Rih82NjmdvWov2lXskILExclZYo0F0EoPyoJDYGzlpfa21
	COgkZkmDSWI28EdcA4IO8YV2kBrayGlV2f+Za9Qfyg==
X-Google-Smtp-Source: ABdhPJzBlY9sEgYPXRy5uLLbIJXLqIS5AXvLIJiE838XFcN7i811yjUHS7Ho7WZmKGzY4qGtN0/EXqtZX8wW5x0PKF4=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
	c23-20020a170902b69700b00141c7aae10fmr35263948pls.18.1636073186843;
	Thu, 04 Nov 2021 17:46:26 -0700 (PDT)
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
In-Reply-To: <342eb71c-0aff-77e5-3c71-92224d7d48e0@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 17:46:17 -0700
Message-ID: <CAPcyv4hVu+A0PXgXTwWj3SBimP5pjX_97g+sfGeT47P0-SJkiQ@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 1:27 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/4/2021 12:00 PM, Dan Williams wrote:
>
> >>
> >> If this understanding is in the right direction, then I'd like to
> >> propose below changes to
> >>     dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
> >>     and the dm layer copy_to/from_iter, dax_iomap_iter().
> >>
> >> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
> >>      is likely media error: if the API without DAX_F_RECOVERY returns
> >>      -EIO, then switch to recovery-read/write code.  In recovery code,
> >>      supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
> >>      'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.
> >
> > I like it. It allows for an atomic write+clear implementation on
> > capable platforms and coordinates with potentially unmapped pages. The
> > best of both worlds from the dax_clear_poison() proposal and my "take
> > a fault and do a slow-path copy".
> >
> >> 2. the _copy_to/from_iter implementation would be largely the same
> >>      as in my recent patch, but some changes in Christoph's
> >>      'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
> >>      virtual devices don't have the ability to clear poison, so no need
> >>      to complicate them.  And this also means that not every endpoint
> >>      dax device has to provide dax_op.copy_to/from_iter, they may use the
> >>      default.
> >
> > Did I miss this series or are you talking about this one?
> > https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/
>
> I was referring to
>
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> that has not come out yet, I said early on that I'll rebase on it,
> but looks like we still need pmem_copy_to/from_iter(), so.

Yeah, since the block-layer divorce gets rid of the old poison
clearing path, then we're back to pmem_copy_to_iter() (or something
like it) needing to pick up the slack for poison clearing. I do agree
it would be nice to clean up all the unnecessary boilerplate, but the
error-list coordination requires a driver specific callback. At least
the DAX_F_VIRTUAL flag can eliminate the virtiofs and fuse callbacks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

