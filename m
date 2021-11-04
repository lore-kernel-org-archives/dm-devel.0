Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE001C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:09:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90DCE60D43
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 90DCE60D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-X1C5EXRhOvujFVH2r9EvLg-1; Thu, 04 Nov 2021 12:09:06 -0400
X-MC-Unique: X1C5EXRhOvujFVH2r9EvLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47FC0806688;
	Thu,  4 Nov 2021 16:09:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4373D67842;
	Thu,  4 Nov 2021 16:08:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F3B91806D03;
	Thu,  4 Nov 2021 16:08:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4G8s1k025074 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 12:08:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B35A840D1B9F; Thu,  4 Nov 2021 16:08:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF57F40D1B9E
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:08:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9807A802818
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:08:54 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
	[209.85.215.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-498-SbOkB2bgP-KtiqOnDN23hw-1; Thu, 04 Nov 2021 12:08:53 -0400
X-MC-Unique: SbOkB2bgP-KtiqOnDN23hw-1
Received: by mail-pg1-f182.google.com with SMTP id p8so4495453pgh.11
	for <dm-devel@redhat.com>; Thu, 04 Nov 2021 09:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=yJc11Y8854aO1pDJriycOvwdVvyzfDm/4ES7HzJB+FM=;
	b=X/NkDz/ILlWvsc1raZNz7ZUDIYwSFCMW6bAu4RAkc8WpgLMsfTbez5zo5O9OknkofW
	mc1RyyTHrIGknka6da1B0Gy3gLYM5x5mP03aoOclGGMiVbK1S907Ig5BFImu8iMbesu1
	qMg50IhlNU+OwAAQKW1pnBW49+x67iCPsJvDTQJSKzA8cP9mMlaAYXqZAnpO9Et92kiB
	q68UqHhdJywXFhOVTuE/a0FW0k+dwXvcB04BlLpNhpL29r7jiqlG3sYI8dZ6DX5GA294
	RT7Bxt9+XXI7xBbdKz42WHA9D/YTeaaqkjvvLeSvvdsqXVTL+/MMcV6By2yivuLXqVK3
	PNmQ==
X-Gm-Message-State: AOAM531goLpbg1JMncOjKqEzf/NGSSE4ABmI1bpHx/rizCVLfzScV2U7
	TVDmDrGCVwqi9sk4SQLXSzUUcgt1TF6F5cJLDARGXg==
X-Google-Smtp-Source: ABdhPJyuzAAG5CU7otzDHpwNiRjP4pLsoDhcZ+jrxhUJJnHdOCa7XkPGXqg6HNGSe8SXKVxET1je/GYiOS8VYyK+gAE=
X-Received: by 2002:a63:6302:: with SMTP id x2mr22207191pgb.5.1636042131973;
	Thu, 04 Nov 2021 09:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org>
	<dfca8558-ad70-41d5-1131-63db66b70542@oracle.com>
	<CAPcyv4jLn4_SYxLtp_cUT=mm6Y3An22BA+sqex1S-CBnAm6qGA@mail.gmail.com>
	<YYObn+0juAFvH7Fk@infradead.org>
In-Reply-To: <YYObn+0juAFvH7Fk@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 09:08:41 -0700
Message-ID: <CAPcyv4jaCj=qDw-MHEcYjVGHYGvX8wbJ_d3kv5nnv7agHnMViQ@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 4, 2021 at 1:36 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 03, 2021 at 11:21:39PM -0700, Dan Williams wrote:
> > The concern I have with dax_clear_poison() is that it precludes atomic
> > error clearing.
>
> atomic as in clear poison and write the actual data?  Yes, that would
> be useful, but it is not how the Intel pmem support actually works, right?

Yes, atomic clear+write new data. The ability to atomic clear requires
either a CPU with the ability to overwrite cachelines without doing a
RMW cycle (MOVDIR64B), or it requires a device with a suitable
slow-path mailbox command like the one defined for CXL devices (see
section 8.2.9.5.4.3 Clear Poison in CXL 2.0).

I don't know why you think these devices don't perform wear-leveling
with spare blocks?

> > Also, as Boris and I discussed, poisoned pages should
> > be marked NP (not present) rather than UC (uncacheable) [1].
>
> This would not really have an affect on the series, right?  But yes,
> that seems like the right thing to do.

It would because the implementations would need to be careful to clear
poison in an entire page before any of it could be accessed. With an
enlightened write-path RWF flag or custom fault handler it could do
sub-page overwrites of poison. Not that I think the driver should
optimize for multiple failed cachelines in a page, but it does mean
dax_clear_poison() fails in more theoretical scenarios.

> > With
> > those 2 properties combined I think that wants a custom pmem fault
> > handler that knows how to carefully write to pmem pages with poison
> > present, rather than an additional explicit dax-operation. That also
> > meets Christoph's requirement of "works with the intended direct
> > memory map use case".
>
> So we have 3 kinds of accesses to DAX memory:
>
>  (1) user space mmap direct access.
>  (2) iov_iter based access (could be from kernel or userspace)
>  (3) open coded kernel access using ->direct_access
>
> One thing I noticed:  (2) could also work with kernel memory or pages,
> but that doesn't use MC safe access.

Yes, but after the fight to even get copy_mc_to_kernel() to exist for
pmem_copy_to_iter() I did not have the nerve to push for wider usage.

> Which seems like a major independent
> of this discussion.
>
> I suspect all kernel access could work fine with a copy_mc_to_kernel
> helper as long as everyone actually uses it,

All kernel accesses do use it. They either route to
pmem_copy_to_iter(), or like dm-writecache, call it directly. Do you
see a kernel path that does not use that helper?

> missing required bits of (2) and (3) together with something like the
> ->clear_poison series from Jane. We just need to think hard what we
> want to do for userspace mmap access.

dax_clear_poison() is at least ready to go today and does not preclude
adding the atomic and finer grained support later.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

