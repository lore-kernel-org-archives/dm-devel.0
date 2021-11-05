Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55337C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 03:32:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE44860EB4
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 03:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE44860EB4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-rqGGvG3ROwu4RiTE6_XwDA-1; Thu, 04 Nov 2021 23:32:45 -0400
X-MC-Unique: rqGGvG3ROwu4RiTE6_XwDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20A8710B3940;
	Fri,  5 Nov 2021 03:32:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14FB55D740;
	Fri,  5 Nov 2021 03:32:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D0A41806D03;
	Fri,  5 Nov 2021 03:32:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A53WXbO026498 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 23:32:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AE7DE2026D65; Fri,  5 Nov 2021 03:32:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA0AB2026D64
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 03:32:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0E3B800883
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 03:32:30 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-49-913Vf8mYPNuUm-tOlI9xAw-1; Thu, 04 Nov 2021 23:32:26 -0400
X-MC-Unique: 913Vf8mYPNuUm-tOlI9xAw-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mipvv-006JD0-HF; Fri, 05 Nov 2021 03:30:39 +0000
Date: Fri, 5 Nov 2021 03:30:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <YYSlU48wcKt4qixx@casper.infradead.org>
References: <20211018044054.1779424-1-hch@lst.de>
	<21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
	<20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia>
	<20211104173559.GB31740@lst.de>
	<CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
	<20211104190443.GK24333@magnolia> <YYSgX9FI0kaGLeR0@mit.edu>
MIME-Version: 1.0
In-Reply-To: <YYSgX9FI0kaGLeR0@mit.edu>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-erofs@lists.ozlabs.org,
	Mike Snitzer <snitzer@redhat.com>, linux-s390 <linux-s390@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@sandeen.net>,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 04, 2021 at 11:09:19PM -0400, Theodore Ts'o wrote:
> On Thu, Nov 04, 2021 at 12:04:43PM -0700, Darrick J. Wong wrote:
> > > Note that I've avoided implementing read/write fops for dax devices
> > > partly out of concern for not wanting to figure out shared-mmap vs
> > > write coherence issues, but also because of a bet with Dave Hansen
> > > that device-dax not grow features like what happened to hugetlbfs. So
> > > it would seem mkfs would need to switch to mmap I/O, or bite the
> > > bullet and implement read/write fops in the driver.
> > 
> > That ... would require a fair amount of userspace changes, though at
> > least e2fsprogs has pluggable io drivers, which would make mmapping a
> > character device not too awful.
> > 
> > xfsprogs would be another story -- porting the buffer cache mignt not be
> > too bad, but mkfs and repair seem to issue pread/pwrite calls directly.
> > Note that xfsprogs explicitly screens out chardevs.
> 
> It's not just e2fsprogs and xfsprogs.  There's also udev, blkid,
> potententially systemd unit generators to kick off fsck runs, etc.
> There are probably any number of user scripts which assume that file
> systems are mounted on block devices --- for example, by looking at
> the output of lsblk, etc.
> 
> Also note that block devices have O_EXCL support to provide locking
> against attempts to run mkfs on a mounted file system.  If you move
> dax file systems to be mounted on a character mode device, that would
> have to be replicated as well, etc.  So I suspect that a large number
> of subtle things would break, and I'd strongly recommend against going
> down that path.

Agreed.  There were reasons we decided to present pmem as "block
device with extra functionality" rather than try to cram all the block
layer functionality (eg submitting BIOs for filesystem metadata) into a
character device.  Some of those assumptions might be worth re-examining,
but I haven't seen anything that makes me say "this is obviously better
than what we did at the time".

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

