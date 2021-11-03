Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B107C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:59:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0843A610EA
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0843A610EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-dz2qMtsdNf6fDptAnoDkVw-1; Wed, 03 Nov 2021 12:59:00 -0400
X-MC-Unique: dz2qMtsdNf6fDptAnoDkVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 141741006AA3;
	Wed,  3 Nov 2021 16:58:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA76367852;
	Wed,  3 Nov 2021 16:58:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE6021800B9E;
	Wed,  3 Nov 2021 16:58:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A3GwcNP020932 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Nov 2021 12:58:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7E07340CFD07; Wed,  3 Nov 2021 16:58:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78D044010FE5
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 16:58:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58BFC1078463
	for <dm-devel@redhat.com>; Wed,  3 Nov 2021 16:58:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-347-Yetc7JZ0OaOArke95keuaA-1; Wed, 03 Nov 2021 12:58:36 -0400
X-MC-Unique: Yetc7JZ0OaOArke95keuaA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1miJam-005shC-K2; Wed, 03 Nov 2021 16:58:28 +0000
Date: Wed, 3 Nov 2021 09:58:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YYK/tGfpG0CnVIO4@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 02, 2021 at 12:57:10PM -0700, Dan Williams wrote:
> This goes back to one of the original DAX concerns of wanting a kernel
> library for coordinating PMEM mmap I/O vs leaving userspace to wrap
> PMEM semantics on top of a DAX mapping. The problem is that mmap-I/O
> has this error-handling-API issue whether it is a DAX mapping or not.

Semantics of writes through shared mmaps are a nightmare.  Agreed,
including agreeing that this is neither new nor pmem specific.  But
it also has absolutely nothing to do with the new RWF_ flag.

> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE implies that processes will
> receive SIGBUS + BUS_MCEERR_A{R,O} when memory failure is signalled
> and then rely on readv(2)/writev(2) to recover. Do you see a readily
> available way to improve upon that model without CPU instruction
> changes? Even with CPU instructions changes, do you think it could
> improve much upon the model of interrupting the process when a load
> instruction aborts?

The "only" think we need is something like the exception table we
use in the kernel for the uaccess helpers (and the new _nofault
kernel access helper).  But I suspect refitting that into userspace
environments is probably non-trivial.

> I do agree with you that DAX needs to separate itself from block, but
> I don't think it follows that DAX also needs to separate itself from
> readv/writev for when a kernel slow-path needs to get involved because
> mmap I/O (just CPU instructions) does not have the proper semantics.
> Even if you got one of the ARCH_SUPPORTS_MEMORY_FAILURE to implement
> those semantics in new / augmented CPU instructions you will likely
> not get all of them to move and certainly not in any near term
> timeframe, so the kernel path will be around indefinitely.

I think you misunderstood me.  I don't think pmem needs to be
decoupled from the read/write path.  But I'm very skeptical of adding
a new flag to the common read/write path for the special workaround
that a plain old write will not actually clear errors unlike every
other store interfac.

> Meanwhile, I think RWF_RECOVER_DATA is generically useful for other
> storage besides PMEM and helps storage-drivers do better than large
> blast radius "I/O error" completions with no other recourse.

How?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

