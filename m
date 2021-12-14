Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58645C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 14:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639491790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vta+OJ5mtT86Rvt4HK+jOHPAF1kF27YVFttc0YfhOXQ=;
	b=O7DzW/pEAojnISW7m6+BvdDvRNqEwpkx7JcdqwauJFZGr/vfaV/M0yvSkJkbJB3OEbIbPv
	j3SrF6dF87cs29jzjXgBZLIaUx/oXluaLW3QtHekJ+XV8bWe67MhGmUavZH6gf7TvsejzR
	RmyVY06sxc9qHnLo26IzgU17vK35Q1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-iSqXgeV-PZ-nUGgurts_rA-1; Tue, 14 Dec 2021 09:23:07 -0500
X-MC-Unique: iSqXgeV-PZ-nUGgurts_rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9D8D190A7A3;
	Tue, 14 Dec 2021 14:23:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A7F45D96;
	Tue, 14 Dec 2021 14:23:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12D754BB7C;
	Tue, 14 Dec 2021 14:23:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BEEMwbN006520 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 09:22:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBE7B61095; Tue, 14 Dec 2021 14:22:58 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.33.95])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 389FC60C9F;
	Tue, 14 Dec 2021 14:22:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id 926EA2233DF; Tue, 14 Dec 2021 09:22:42 -0500 (EST)
Date: Tue, 14 Dec 2021 09:22:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YbiosqZoG8e6rDkj@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de> <YbNhPXBg7G/ridkV@redhat.com>
	<CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
	<20211213082318.GB21462@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211213082318.GB21462@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] dax: remove the copy_from_iter and
 copy_to_iter methods
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

On Mon, Dec 13, 2021 at 09:23:18AM +0100, Christoph Hellwig wrote:
> On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> > On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > Going forward, I am wondering should virtiofs use flushcache version as
> > > well. What if host filesystem is using DAX and mapping persistent memory
> > > pfn directly into qemu address space. I have never tested that.
> > >
> > > Right now we are relying on applications to do fsync/msync on virtiofs
> > > for data persistence.
> > 
> > This sounds like it would need coordination with a paravirtualized
> > driver that can indicate whether the host side is pmem or not, like
> > the virtio_pmem driver. However, if the guest sends any fsync/msync
> > you would still need to go explicitly cache flush any dirty page
> > because you can't necessarily trust that the guest did that already.
> 
> Do we?  The application can't really know what backend it is on, so
> it sounds like the current virtiofs implementation doesn't really, does it?

Agreed that application does not know what backend it is on. So virtiofs
just offers regular posix API where applications have to do fsync/msync
for data persistence. No support for mmap(MAP_SYNC). We don't offer persistent
memory programming model on virtiofs. That's not the expectation. DAX 
is used only to bypass guest page cache.

With this assumption, I think we might not have to use flushcache version
at all even if shared filesystem is on persistent memory on host. 

- We mmap() host files into qemu address space. So any dax store in virtiofs
  should make corresponding pages dirty in page cache on host and when
  and fsync()/msync() comes later, it should flush all the data to PMEM.

- In case of file extending writes, virtiofs falls back to regular
  FUSE_WRITE path (and not use DAX), and in that case host pmem driver
  should make sure writes are flushed to pmem immediately.

Are there any other path I am missing. If not, looks like we might not
have to use flushcache version in virtiofs at all as long as we are not
offering guest applications user space flushes and MAP_SYNC support.

We still might have to use machine check safe variant though as loads
might generate synchronous machine check. What's not clear to me is
that if this MC safe variant should be used only in case of PMEM or
should it be used in case of non-PMEM as well.

Vivek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

