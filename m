Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71117C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 16:44:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-25-8MbpdNuif4G69HOynTQ-1; Mon, 13 Dec 2021 11:43:55 -0500
X-MC-Unique: 25-8MbpdNuif4G69HOynTQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B451E1B2C983;
	Mon, 13 Dec 2021 16:43:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82F6945D93;
	Mon, 13 Dec 2021 16:43:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B7BF4BB7C;
	Mon, 13 Dec 2021 16:43:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDGhkUm017609 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 11:43:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7AFF540C1247; Mon, 13 Dec 2021 16:43:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 774B5400E109
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 16:43:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F73F800141
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 16:43:46 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
	[209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-32-O3YzvMyNMtq98KHReE94jQ-1; Mon, 13 Dec 2021 11:43:42 -0500
X-MC-Unique: O3YzvMyNMtq98KHReE94jQ-1
Received: by mail-pf1-f181.google.com with SMTP id x131so15382806pfc.12
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:43:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=vyYw8u6XfcAGXDXzJlsX3xmu/UHpiQrY1MTgK5iKFVw=;
	b=gxuwWW5eGal28xdgrQrM38k+IWwosdxBr5J39sgwxxwkmpYTYg+o/p4VBYk5EL5e/Z
	wIlUyONce0/ps/Q6Sc6rJ/4rauN5ZASzcUTHm0WEuHsWoS21Mci9TOrzQkPgVguS5hDJ
	a7bnuzqsNa/fLuGcP5RVH54V6TaBt+f+YDcpdwFIKIMjXN7B355t+JkxhIPwlrbeWMQy
	+WWhk/sk2NgMXJkz646H+Vp0GXb01PgGpV5EW87qDlaOZrZWM2v8bE7Q6KbtWRQWk3Cu
	KIfygP1eU9QsGpezD1ZL5lsG+DKfh4eSColZwUPXhxXkRKbx3pO4zvQrHn1KYf6S8Q8h
	fL4w==
X-Gm-Message-State: AOAM533qQR7zXxFboPJW4M/jZt3h1dBX9Bs9yDoBH+xRj7iFipzj6ujS
	zuA6u3cDRZYXLSaPtNvnjJSYtp8UAlMgtjrm8tagjg==
X-Google-Smtp-Source: ABdhPJx2n8q1onN4jQzvRQyQbTXEvg1DJxhgaWZFSAWB2OQ1hhJNCq2enXcdrfYzpDge5Iz394R2nbo3Ocn0tDkMu6w=
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id
	j10-20020aa78d0a000000b004a282d71695mr34765307pfe.86.1639413821384;
	Mon, 13 Dec 2021 08:43:41 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-6-hch@lst.de> <YbNejVRF5NQB0r83@redhat.com>
	<CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
	<20211213082020.GA21462@lst.de>
In-Reply-To: <20211213082020.GA21462@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Dec 2021 08:43:32 -0800
Message-ID: <CAPcyv4g-_hth2LMUS=k3FwMCfVsSkgFOJ53-uE1wzsDVuEs_eg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] dax: always use _copy_mc_to_iter in
	dax_copy_to_iter
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

On Mon, Dec 13, 2021 at 12:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Sun, Dec 12, 2021 at 06:48:05AM -0800, Dan Williams wrote:
> > On Fri, Dec 10, 2021 at 6:05 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> > > > While using the MC-safe copy routines is rather pointless on a virtual device
> > > > like virtiofs,
> > >
> > > I was wondering about that. Is it completely pointless.
> > >
> > > Typically we are just mapping host page cache into qemu address space.
> > > That shows as virtiofs device pfn in guest and that pfn is mapped into
> > > guest application address space in mmap() call.
> > >
> > > Given on host its DRAM, so I would not expect machine check on load side
> > > so there was no need to use machine check safe variant.
> >
> > That's a broken assumption, DRAM experiences multi-bit ECC errors.
> > Machine checks, data aborts, etc existed before PMEM.
>
> So the conclusion here is that we should always use the mc safe variant?

The proposal is one of the following:

1/ any paths not currently using the mc safe variant should continue
not using it to avoid the performance regression on older platforms,
i.e. drop this patch.

2/ add plumbing to switch to mcsafe variant, but only on newer
platforms, incremental new patch

3/ always use the mc safe variant, keep this patch

We could go with 3/ and see who screams, because 3/ is smallest
ongoing maintenance burden. However, I feel like 1/ is the path of
least resistance until the platforms with the need to do 'careful'
copying age out of use.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

