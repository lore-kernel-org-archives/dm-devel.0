Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F03AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:58:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB3B161073
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 01:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BB3B161073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-zGvhNvDFP821iA-fzCRtXA-1; Thu, 21 Oct 2021 21:58:33 -0400
X-MC-Unique: zGvhNvDFP821iA-fzCRtXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 186F91006AA3;
	Fri, 22 Oct 2021 01:58:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6E1360C7F;
	Fri, 22 Oct 2021 01:58:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 454354A704;
	Fri, 22 Oct 2021 01:58:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M1wOKr025447 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 21:58:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1666D2166B25; Fri, 22 Oct 2021 01:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EF752166B2F
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:58:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C46718A01B1
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 01:58:21 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-347-oPgbBq4VNjOxMtJ2YVm8_g-1;
	Thu, 21 Oct 2021 21:58:19 -0400
X-MC-Unique: oPgbBq4VNjOxMtJ2YVm8_g-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED74B610A4;
	Fri, 22 Oct 2021 01:58:17 +0000 (UTC)
Date: Thu, 21 Oct 2021 18:58:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <20211022015817.GY24307@magnolia>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
MIME-Version: 1.0
In-Reply-To: <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 22, 2021 at 01:37:28AM +0000, Jane Chu wrote:
> On 10/21/2021 4:31 AM, Christoph Hellwig wrote:
> > Looking over the series I have serious doubts that overloading the
> > slow path clear poison operation over the fast path read/write
> > path is such a great idea.

Why would data recovery after a media error ever be considered a
fast/hot path?  A normal read/write to a fsdax file would not pass the
flag, which skips the poison checking with whatever MCE consequences
that has, right?

pwritev2(..., RWF_RECOVER_DATA) should be infrequent enough that
carefully stepping around dax_direct_access only has to be faster than
restoring from backup, I hope?

> Understood, sounds like a concern on principle. But it seems to me
> that the task of recovery overlaps with the normal write operation
> on the write part. Without overloading some write operation for
> 'recovery', I guess we'll need to come up with a new userland
> command coupled with a new dax API ->clear_poison and propagate the
> new API support to each dm targets that support dax which, again,
> is an idea that sounds too bulky if I recall Dan's earlier rejection
> correctly.
> 
> It is in my plan though, to provide pwritev2(2) and preadv2(2) man pages
> with description about the RWF_RECOVERY_DATA flag and specifically not
> recommending the flag for normal read/write operation - due to potential
> performance impact from searching badblocks in the range.

Yes, this will help much. :)

> That said, the badblock searching is turned on only if the pmem device
> contains badblocks(i.e. bb->count > 0), otherwise, the performance
> impact is next to none. And once the badblock search starts,
> it is a binary search over user provided range. The unwanted impact
> happens to be the case when the pmem device contains badblocks
> that do not fall in the user specified range, and in that case, the
> search would end in O(1).

(I wonder about improving badblocks to be less sector-oriented and not
have that weird 16-records-max limit, but that can be a later
optimization.)

--D

> Thanks!
> -jane
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

