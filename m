Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6221C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:48:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E37D611C0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E37D611C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-infy-yZGNp-M1eb7cx9ZCA-1; Thu, 04 Nov 2021 13:48:35 -0400
X-MC-Unique: infy-yZGNp-M1eb7cx9ZCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09AAA100A642;
	Thu,  4 Nov 2021 17:48:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB9B16784F;
	Thu,  4 Nov 2021 17:48:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF7291806D03;
	Thu,  4 Nov 2021 17:48:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4Hhh26006500 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 13:43:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 81D312026D46; Thu,  4 Nov 2021 17:43:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B9B2026D67
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:43:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AFA7899EC2
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 17:43:40 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-510-WkIgtd11NHeEnOdWgkAWgg-1; Thu, 04 Nov 2021 13:43:36 -0400
X-MC-Unique: WkIgtd11NHeEnOdWgkAWgg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1migln-009hiW-DT; Thu, 04 Nov 2021 17:43:23 +0000
Date: Thu, 4 Nov 2021 10:43:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YYQbu6dOCVB7yS02@infradead.org>
References: <YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
	<CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
	<YYOaOBKgFQYzT/s/@infradead.org>
	<CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On Thu, Nov 04, 2021 at 09:24:15AM -0700, Dan Williams wrote:
> No, the big difference with every other modern storage device is
> access to byte-addressable storage. Storage devices get to "cheat"
> with guaranteed minimum 512-byte accesses. So you can arrange for
> writes to always be large enough to scrub the ECC bits along with the
> data. For PMEM and byte-granularity DAX accesses the "sector size" is
> a cacheline and it needed a new CPU instruction before software could
> atomically update data + ECC. Otherwise, with sub-cacheline accesses,
> a RMW cycle can't always be avoided. Such a cycle pulls poison from
> the device on the read and pushes it back out to the media on the
> cacheline writeback.

Indeed.  The fake byte addressability is indeed the problem, and the
fix is to not do that, at least on the second attempt.

> I don't understand what overprovisioning has to do with better error
> management? No other storage device has seen fit to be as transparent
> with communicating the error list and offering ways to proactively
> scrub it. Dave and Darrick rightly saw this and said "hey, the FS
> could do a much better job for the user if it knew about this error
> list". So I don't get what this argument about spare blocks has to do
> with what XFS wants? I.e. an rmap facility to communicate files that
> have been clobbered by cosmic rays and other calamities.

Well, the answer for other interfaces (at least at the gold plated
cost option) is so strong internal CRCs that user visible bits clobbered
by cosmic rays don't realisticly happen.  But it is a problem with the
cheaper ones, and at least SCSI and NVMe offer the error list through
the Get LBA status command (and I bet ATA too, but I haven't looked into
that).  Oddly enough there has never been much interested from the
fs community for those.

> > So far out of the low instrusiveness options Janes' previous series
> > to automatically retry after calling a clear_poison operation seems
> > like the best idea so far.  We just need to also think about what
> > we want to do for direct users of ->direct_access that do not use
> > the mcsafe iov_iter helpers.
> 
> Those exist? Even dm-writecache uses copy_mc_to_kernel().

I'm sorry, I have completely missed that it has been added.  And it's
been in for a whole year..

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

