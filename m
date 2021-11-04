Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14025C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 19:05:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8BBD61051
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 19:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A8BBD61051
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-aCvpWiuwN4640QcwJIgxLQ-1; Thu, 04 Nov 2021 15:04:57 -0400
X-MC-Unique: aCvpWiuwN4640QcwJIgxLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A520F800053;
	Thu,  4 Nov 2021 19:04:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 578BF196AE;
	Thu,  4 Nov 2021 19:04:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C003D4EA2F;
	Thu,  4 Nov 2021 19:04:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4J4nAr015096 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 15:04:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 779B251E1; Thu,  4 Nov 2021 19:04:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7078E51E4
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 19:04:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91029802A5E
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 19:04:46 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-45-x2Hb12ZuOae2G9bmOf38qw-1; 
	Thu, 04 Nov 2021 15:04:45 -0400
X-MC-Unique: x2Hb12ZuOae2G9bmOf38qw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id B349D61051;
	Thu,  4 Nov 2021 19:04:43 +0000 (UTC)
Date: Thu, 4 Nov 2021 12:04:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211104190443.GK24333@magnolia>
References: <20211018044054.1779424-1-hch@lst.de>
	<21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
	<20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia>
	<20211104173559.GB31740@lst.de>
	<CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org, Eric Sandeen <sandeen@sandeen.net>,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] futher decouple DAX from block devices
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 04, 2021 at 11:10:19AM -0700, Dan Williams wrote:
> On Thu, Nov 4, 2021 at 10:36 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Thu, Nov 04, 2021 at 10:34:17AM -0700, Darrick J. Wong wrote:
> > > /me wonders, are block devices going away?  Will mkfs.xfs have to learn
> > > how to talk to certain chardevs?  I guess jffs2 and others already do
> > > that kind of thing... but I suppose I can wait for the real draft to
> > > show up to ramble further. ;)
> >
> > Right now I've mostly been looking into the kernel side.  An no, I
> > do not expect /dev/pmem* to go away as you'll still need it for a
> > not DAX aware file system and/or application (such as mkfs initially).
> >
> > But yes, just pointing mkfs to the chardev should be doable with very
> > little work.  We can point it to a regular file after all.
> 
> Note that I've avoided implementing read/write fops for dax devices
> partly out of concern for not wanting to figure out shared-mmap vs
> write coherence issues, but also because of a bet with Dave Hansen
> that device-dax not grow features like what happened to hugetlbfs. So
> it would seem mkfs would need to switch to mmap I/O, or bite the
> bullet and implement read/write fops in the driver.

That ... would require a fair amount of userspace changes, though at
least e2fsprogs has pluggable io drivers, which would make mmapping a
character device not too awful.

xfsprogs would be another story -- porting the buffer cache mignt not be
too bad, but mkfs and repair seem to issue pread/pwrite calls directly.
Note that xfsprogs explicitly screens out chardevs.

--D

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

