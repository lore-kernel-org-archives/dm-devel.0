Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E80C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 16:41:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-auESu1ZOOYOqvfRLyC4Guw-1; Tue, 14 Dec 2021 11:41:53 -0500
X-MC-Unique: auESu1ZOOYOqvfRLyC4Guw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F8FB100CC89;
	Tue, 14 Dec 2021 16:41:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3BB384791;
	Tue, 14 Dec 2021 16:41:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01E1F1809CB8;
	Tue, 14 Dec 2021 16:41:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BEGfgX8019974 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 14 Dec 2021 11:41:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6FB28C23DB1; Tue, 14 Dec 2021 16:41:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BB7DC017DA
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 16:41:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50EA83C13C84
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 16:41:42 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
	[209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-241-8d8H5p61M4mipXnBTz3hEg-1; Tue, 14 Dec 2021 11:41:40 -0500
X-MC-Unique: 8d8H5p61M4mipXnBTz3hEg-1
Received: by mail-pl1-f170.google.com with SMTP id y7so13994288plp.0
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 08:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=t/nnzQN9F5r4zFSkk8iYiBeWCGCkT6Dn6wCuQkQZ9ZI=;
	b=3DTjh06VTxxcY8YR2l5qEp5cvO4CS8K7mC68KpXK96u5+8ds4yKtW/lxXSIT2uDuKd
	1Dw4dSMiur1Br0r1m/NGR6xedQnfQbe+aFeLVLh1AJYmECZqs/HAyhaKK67jFcqUpIEp
	U1GiRwec8ZKVQ87bbGjggcK+Q8w7CXPbUoiEKdL88mHUwc9LyH9Q5260Oqds/kxAkogh
	bNzPCiba2E6xrBLhCe+G5YN6LT0gI0HNYybinBC9QU1k8V5+rP/IODDrTqtK0K4WqPAy
	5Ad4+Fo2LDytFh1Sl1lBG1r3HvcxANzOCY1yALr4uR+CnxqUPOQgb9CpJHcoDhXyTzDz
	xVJw==
X-Gm-Message-State: AOAM532DRTo7bifK+xgrgcQGf6psBs+F2pKrHtiB4DrW98RXdUwk7jEP
	abxHCBXVUZBjoEir0QJwl7y2RC8w3BHbF1kZi5e/aw==
X-Google-Smtp-Source: ABdhPJw+O9j0H9UWQxoVKDQYePJLlAtoMN+dCn3S6Q/xMAfRBDp6O2XP6nSywAkX3lUHqDKzBphvkGiQvj7Lgmg0w8E=
X-Received: by 2002:a17:902:bb87:b0:148:a2e7:fb52 with SMTP id
	m7-20020a170902bb8700b00148a2e7fb52mr124861pls.147.1639500099392;
	Tue, 14 Dec 2021 08:41:39 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de> <YbNhPXBg7G/ridkV@redhat.com>
	<CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
	<20211213082318.GB21462@lst.de> <YbiosqZoG8e6rDkj@redhat.com>
In-Reply-To: <YbiosqZoG8e6rDkj@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Dec 2021 08:41:30 -0800
Message-ID: <CAPcyv4hFjKsPrPTB4NtLHiY8gyaELz9+45N1OFj3hz+uJ=9JnA@mail.gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 14, 2021 at 6:23 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 09:23:18AM +0100, Christoph Hellwig wrote:
> > On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> > > On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > Going forward, I am wondering should virtiofs use flushcache version as
> > > > well. What if host filesystem is using DAX and mapping persistent memory
> > > > pfn directly into qemu address space. I have never tested that.
> > > >
> > > > Right now we are relying on applications to do fsync/msync on virtiofs
> > > > for data persistence.
> > >
> > > This sounds like it would need coordination with a paravirtualized
> > > driver that can indicate whether the host side is pmem or not, like
> > > the virtio_pmem driver. However, if the guest sends any fsync/msync
> > > you would still need to go explicitly cache flush any dirty page
> > > because you can't necessarily trust that the guest did that already.
> >
> > Do we?  The application can't really know what backend it is on, so
> > it sounds like the current virtiofs implementation doesn't really, does it?
>
> Agreed that application does not know what backend it is on. So virtiofs
> just offers regular posix API where applications have to do fsync/msync
> for data persistence. No support for mmap(MAP_SYNC). We don't offer persistent
> memory programming model on virtiofs. That's not the expectation. DAX
> is used only to bypass guest page cache.
>
> With this assumption, I think we might not have to use flushcache version
> at all even if shared filesystem is on persistent memory on host.
>
> - We mmap() host files into qemu address space. So any dax store in virtiofs
>   should make corresponding pages dirty in page cache on host and when
>   and fsync()/msync() comes later, it should flush all the data to PMEM.
>
> - In case of file extending writes, virtiofs falls back to regular
>   FUSE_WRITE path (and not use DAX), and in that case host pmem driver
>   should make sure writes are flushed to pmem immediately.
>
> Are there any other path I am missing. If not, looks like we might not
> have to use flushcache version in virtiofs at all as long as we are not
> offering guest applications user space flushes and MAP_SYNC support.
>
> We still might have to use machine check safe variant though as loads
> might generate synchronous machine check. What's not clear to me is
> that if this MC safe variant should be used only in case of PMEM or
> should it be used in case of non-PMEM as well.

It should be used on any memory address that can throw exception on
load, which is any physical address, in paths that can tolerate
memcpy() returning an error code, most I/O paths, and can tolerate
slower copy performance on older platforms that do not support MC
recovery with fast string operations, to date that's only PMEM users.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

