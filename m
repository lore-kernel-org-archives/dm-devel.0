Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9FFC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 19:00:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 38AE561212
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 19:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38AE561212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Ua-RNj5_PMegzhrmePv0uA-1; Thu, 04 Nov 2021 15:00:35 -0400
X-MC-Unique: Ua-RNj5_PMegzhrmePv0uA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B94F2362FE;
	Thu,  4 Nov 2021 19:00:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 131476784F;
	Thu,  4 Nov 2021 19:00:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 71CDD4E9F5;
	Thu,  4 Nov 2021 19:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4J0QF7014757 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 15:00:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6A0254010FE5; Thu,  4 Nov 2021 19:00:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 652CA40CFD0A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 19:00:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49753802A5E
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 19:00:26 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
	[209.85.214.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-165-lJhwC5dgOyiW5M4bDGeiXg-1; Thu, 04 Nov 2021 15:00:24 -0400
X-MC-Unique: lJhwC5dgOyiW5M4bDGeiXg-1
Received: by mail-pl1-f182.google.com with SMTP id u11so8838139plf.3
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 12:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=m2k2ICcLxOkYpmYgks+aaOogS3Up01M0dUCMOamz1iE=;
	b=an+jV5jpb6uEBk++sF8HJoI4KmrZrhjRKqiieOpFeTKq2JTRe3Jjk/av+SzC61D+hE
	gx6jZuzWtTrHYbGWOTYvovSmExxas5yNMZE12rpj9wFITZqFTbl9eeb4xHULZav960PS
	ct/NZw4dBtxWF/YUYVy6VVGOzjUoiwykwbyA9S/0hlURVnnrUXYgpuHHsb6aUunSOf83
	PXChQrcYiM8RVitUstvesDduQkntdRtD7MQeOJTmgKtY1IhSGkGiCnuiAmxrtUDu3TEV
	iN8ny3m3R3HhPRgwpRpK5Ni7IrVmQxquD9JQyMu335dJXmaXGxI2UflCYApgywXPRaJA
	XMlw==
X-Gm-Message-State: AOAM530OyC75jBGv9UAvrN9aBqEw1CVMh5npUfHRuUnhGVm3qLRyorCR
	blTVpMDLDYXNgGHE9cAe+iSXV0NJ/GSU8DtB3vI6Og==
X-Google-Smtp-Source: ABdhPJwQym6Y7uH09wOtDHKQhWIGrrYFIdBGyf7hiTeaJPAQpu4wAVAeAWHgNrP0Q55EM48GJgoNm4KYD5+8BlLUEcA=
X-Received: by 2002:a17:90b:1e49:: with SMTP id
	pi9mr1444333pjb.220.1636052423615; 
	Thu, 04 Nov 2021 12:00:23 -0700 (PDT)
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
In-Reply-To: <6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 12:00:12 -0700
Message-ID: <CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 11:34 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> Thanks for the enlightening discussion here, it's so helpful!
>
> Please allow me to recap what I've caught up so far -
>
> 1. recovery write at page boundary due to NP setting in poisoned
>     page to prevent undesirable prefetching
> 2. single interface to perform 3 tasks:
>       { clear-poison, update error-list, write }
>     such as an API in pmem driver.
>     For CPUs that support MOVEDIR64B, the 'clear-poison' and 'write'
>     task can be combined (would need something different from the
>     existing _copy_mcsafe though) and 'update error-list' follows
>     closely behind;
>     For CPUs that rely on firmware call to clear posion, the existing
>     pmem_clear_poison() can be used, followed by the 'write' task.
> 3. if user isn't given RWF_RECOVERY_FLAG flag, then dax recovery
>     would be automatic for a write if range is page aligned;
>     otherwise, the write fails with EIO as usual.
>     Also, user mustn't have punched out the poisoned page in which
>     case poison repairing will be a lot more complicated.
> 4. desirable to fetch as much data as possible from a poisoned range.
>
> If this understanding is in the right direction, then I'd like to
> propose below changes to
>    dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
>    and the dm layer copy_to/from_iter, dax_iomap_iter().
>
> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
>     is likely media error: if the API without DAX_F_RECOVERY returns
>     -EIO, then switch to recovery-read/write code.  In recovery code,
>     supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
>     'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.

I like it. It allows for an atomic write+clear implementation on
capable platforms and coordinates with potentially unmapped pages. The
best of both worlds from the dax_clear_poison() proposal and my "take
a fault and do a slow-path copy".

> 2. the _copy_to/from_iter implementation would be largely the same
>     as in my recent patch, but some changes in Christoph's
>     'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
>     virtual devices don't have the ability to clear poison, so no need
>     to complicate them.  And this also means that not every endpoint
>     dax device has to provide dax_op.copy_to/from_iter, they may use the
>     default.

Did I miss this series or are you talking about this one?
https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/

> I'm not sure about nova and others, if they use different 'write' other
> than via iomap, does that mean there will be need for a new set of
> dax_op for their read/write?

No, they're out-of-tree they'll adjust to the same interface that xfs
and ext4 are using when/if they go upstream.

> the 3-in-1 binding would always be
> required though. Maybe that'll be an ongoing discussion?

Yeah, let's cross that bridge when we come to it.

> Comments? Suggestions?

It sounds great to me!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

