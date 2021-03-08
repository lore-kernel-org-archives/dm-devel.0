Return-Path: <SRS0=Ydjc=IG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EF4C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 05:24:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E817565134
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 05:24:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E817565134
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-fNbsE7ckNdWovCooAiQjzw-1; Mon, 08 Mar 2021 00:24:06 -0500
X-MC-Unique: fNbsE7ckNdWovCooAiQjzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ED67107465E;
	Mon,  8 Mar 2021 05:24:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD47D5C1CF;
	Mon,  8 Mar 2021 05:24:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88CD01809C86;
	Mon,  8 Mar 2021 05:23:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1285Nuwt014459 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Mar 2021 00:23:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 694911000D98; Mon,  8 Mar 2021 05:23:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64778110DBAE
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 05:23:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D9B8800B21
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 05:23:54 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-zaeg3ElXObWqAiMr1Z0FjA-1; Mon, 08 Mar 2021 00:23:51 -0500
X-MC-Unique: zaeg3ElXObWqAiMr1Z0FjA-1
Received: by mail-ej1-f51.google.com with SMTP id p7so6249435eju.6
	for <dm-devel@redhat.com>; Sun, 07 Mar 2021 21:23:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=4vk8NjZWUWMSC21zZsC5XhaD9emmq9PjiDCa5A5wz7c=;
	b=iPAOvb7M9HXDAAPOidHBcHsdjNuhxAYi0IY73CYawjVuUWp/aC8K9kDSiasJGSxzcF
	u/W78TuzanhyidiVN89iOZu3f5wExVaNE7JRmGWDVTOJShWwo9UwchF7VB5zkjtrub1X
	+9egglMGWifi2gt6qggcosYLVQI4Pq5rqRYUr/wnPv67HFUP6VjQp96t4FrM9UQ67y2f
	acg76+hJnn3sb9v5aL/MbIozlcG/63tBuJbyqWS8MO3DbzYiGkk1nnT6DN/vW8HySFtN
	IygXl9vePpD5HXHrwSoJaUIWlEDJTWkQIRD8Wbnj/lYYud7RqHxRsAOfgZIwyC5wvdM3
	UsSg==
X-Gm-Message-State: AOAM533O4vDIfORL0zH4MwcAaVeY+QYPTdKKIL0dOiyaUG/S5npdpwH5
	gCkDxHZY2fEznEgmBoTCnwlS10JUkj3+kK/aZXRyaA==
X-Google-Smtp-Source: ABdhPJxP4YeKftw4Lj6ZQkw1k0hTAM+QWLRj2zfFwlL8QUnJAuQwAg2fpXUMBBNPLZZXJqNMxEP+ZhTef3D9nTDkcKU=
X-Received: by 2002:a17:906:1bf2:: with SMTP id
	t18mr13449685ejg.418.1615181030278; 
	Sun, 07 Mar 2021 21:23:50 -0800 (PST)
MIME-Version: 1.0
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
	<CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
	<OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 7 Mar 2021 21:23:47 -0800
Message-ID: <CAPcyv4iBnWbG0FYw6-K0MaH--rq62s7RY_yoT9rOYWMa94Yakw@mail.gmail.com>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
	"qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 01/11] pagemap: Introduce
	->memory_failure()
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

On Sun, Mar 7, 2021 at 7:38 PM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
> > On Mon, Feb 8, 2021 at 2:55 AM Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
> > >
> > > When memory-failure occurs, we call this function which is implemented
> > > by each kind of devices.  For the fsdax case, pmem device driver
> > > implements it.  Pmem device driver will find out the block device where
> > > the error page locates in, and try to get the filesystem on this block
> > > device.  And finally call filesystem handler to deal with the error.
> > > The filesystem will try to recover the corrupted data if possiable.
> > >
> > > Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> > > ---
> > >  include/linux/memremap.h | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > index 79c49e7f5c30..0bcf2b1e20bd 100644
> > > --- a/include/linux/memremap.h
> > > +++ b/include/linux/memremap.h
> > > @@ -87,6 +87,14 @@ struct dev_pagemap_ops {
> > >          * the page back to a CPU accessible page.
> > >          */
> > >         vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> > > +
> > > +       /*
> > > +        * Handle the memory failure happens on one page.  Notify the processes
> > > +        * who are using this page, and try to recover the data on this page
> > > +        * if necessary.
> > > +        */
> > > +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> > > +                             int flags);
> > >  };
> >
> > After the conversation with Dave I don't see the point of this. If
> > there is a memory_failure() on a page, why not just call
> > memory_failure()? That already knows how to find the inode and the
> > filesystem can be notified from there.
>
> We want memory_failure() supports reflinked files.  In this case, we are not
> able to track multiple files from a page(this broken page) because
> page->mapping,page->index can only track one file.  Thus, I introduce this
> ->memory_failure() implemented in pmem driver, to call ->corrupted_range()
> upper level to upper level, and finally find out files who are
> using(mmapping) this page.
>

I know the motivation, but this implementation seems backwards. It's
already the case that memory_failure() looks up the address_space
associated with a mapping. From there I would expect a new 'struct
address_space_operations' op to let the fs handle the case when there
are multiple address_spaces associated with a given file.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

