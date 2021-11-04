Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534EDC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 12:31:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D878A610FC
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 12:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D878A610FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-7Vnppkn6Ma2BXcLi4cI2QQ-1; Thu, 04 Nov 2021 08:31:42 -0400
X-MC-Unique: 7Vnppkn6Ma2BXcLi4cI2QQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80EB31023F61;
	Thu,  4 Nov 2021 12:31:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95B5A6788F;
	Thu,  4 Nov 2021 12:31:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5761D57DC2;
	Thu,  4 Nov 2021 12:31:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4CVUZs004172 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 08:31:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA1D140D1B9E; Thu,  4 Nov 2021 12:31:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B61A440D1B9F
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 12:31:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 991381064E6B
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 12:31:30 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-581-pWxKCPlWNJibJbKV7i7pig-1; Thu, 04 Nov 2021 08:31:29 -0400
X-MC-Unique: pWxKCPlWNJibJbKV7i7pig-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mibrf-005rYi-P5; Thu, 04 Nov 2021 12:29:31 +0000
Date: Thu, 4 Nov 2021 12:29:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YYPSE4XACpqs21Yl@casper.infradead.org>
References: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
	<YYDYUCCiEPXhZEw0@infradead.org>
	<CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
	<YYK/tGfpG0CnVIO4@infradead.org>
	<CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
	<YYOaOBKgFQYzT/s/@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YYOaOBKgFQYzT/s/@infradead.org>
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
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 04, 2021 at 01:30:48AM -0700, Christoph Hellwig wrote:
> Well, the whole problem is that we should not have to manage this at
> all, and this is where I blame Intel.  There is no good reason to not
> slightly overprovision the nvdimms and just do internal bad page
> remapping like every other modern storage device.

What makes you think they don't?

The problem is persuading the CPU to do writes without doing reads.
That's where magic instructions or out of band IO is needed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

