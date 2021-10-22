Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FFBC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 05:57:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E35D46109E
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 05:57:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E35D46109E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-g5TvA_lwNHuB8XxLiGYhxA-1; Fri, 22 Oct 2021 01:57:34 -0400
X-MC-Unique: g5TvA_lwNHuB8XxLiGYhxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A250362F8;
	Fri, 22 Oct 2021 05:57:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB15C1002D6A;
	Fri, 22 Oct 2021 05:57:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AE761800B9E;
	Fri, 22 Oct 2021 05:57:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19M5vQdm011601 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 01:57:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C74D5D0192; Fri, 22 Oct 2021 05:57:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1C4FD016B
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 05:57:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 723AB1875069
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 05:57:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-lvp6uqN8OsqeawLnbf6DIQ-1; Fri, 22 Oct 2021 01:57:20 -0400
X-MC-Unique: lvp6uqN8OsqeawLnbf6DIQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mdnBN-009lTo-6z; Fri, 22 Oct 2021 05:33:33 +0000
Date: Thu, 21 Oct 2021 22:33:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YXJNLTmcPaShrLoT@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-5-jane.chu@oracle.com>
	<YXFOlKWUuwFUJxUZ@infradead.org>
	<325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
MIME-Version: 1.0
In-Reply-To: <325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/6] dm, dax,
 pmem: prepare dax_copy_to/from_iter() APIs with DAXDEV_F_RECOVERY
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 22, 2021 at 12:49:15AM +0000, Jane Chu wrote:
> I've looked through your "futher decouple DAX from block devices" series 
> and likes the use of xarray in place of the host hash list.
> Which upstream version is the series based upon?
> If it's based on your development repo, I'd be happy to take a clone
> and rebase my patches on yours if you provide a link. Please let me
> know the best way to cooperate.

It is based on linux-next from when it was posted.  A git tree is here:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-block-cleanup

> That said, I'm unclear at what you're trying to suggest with respect
> to the 'DAXDEV_F_RECOVERY' flag.  The flag came from upper dax-fs
> call stack to the dm target layer, and the dm targets are equipped
> with handling pmem driver specific task, so it appears that the flag 
> would need to be passed down to the native pmem layer, right?
> Am I totally missing your point?

We'll need to pass it through (assuming we want to keep supporting
dm, see the recent discussion with Dan).

FYI, here is a sketch where I'd like to move to, but this isn't properly
tested yet:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize

To support something like DAXDEV_F_RECOVERYwe'd need a separate
dax_operations methods.  Which to me suggest it probably should be
a different operation (fallocate / ioctl / etc) as Darrick did earlier.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

