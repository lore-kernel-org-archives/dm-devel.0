Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D14C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:00:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4898F61A1A
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4898F61A1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-FTQ6evFAN1ClapVV4p1Ciw-1; Wed, 24 Mar 2021 14:00:42 -0400
X-MC-Unique: FTQ6evFAN1ClapVV4p1Ciw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DE7A107BEFE;
	Wed, 24 Mar 2021 18:00:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2FF4694CD;
	Wed, 24 Mar 2021 18:00:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46F671809C84;
	Wed, 24 Mar 2021 18:00:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OI0Xee012320 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 14:00:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9D1B0F51BA; Wed, 24 Mar 2021 18:00:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 962B9F51B9
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 18:00:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3D42805C1D
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 18:00:30 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
	[209.85.218.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-4-rx2UcIx2OketbRwBstiBWw-1; Wed, 24 Mar 2021 14:00:28 -0400
X-MC-Unique: rx2UcIx2OketbRwBstiBWw-1
Received: by mail-ej1-f52.google.com with SMTP id ce10so34376407ejb.6
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 11:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=2KFNkl1or0mmtXA1jvsRAF0OANfT9njIYX+exK4jOos=;
	b=OBL5lr7XjK5wrO1Pcl0wexwll23+6czqg40H5JH+gfJFLSmxco9UilGsL+lSfEPut+
	htO8h+5Lvv/ZGULSD2yBkcEvBp2c/GfvisLhEi310CZn1nK8+5JE+rOlI9pRVEYy86xh
	JtPifnHO+JZ7kZaJz+QCVlMGr3FGd0ZvxWh7uBppog26sGLCulSvkZ9xeGATcIyvW0Kl
	nezXg1OuQem66AejWDJn8KmMGKwla8KpXfeyDWuHtxEoGkW5UbIfJOuwCJQB2y0SG2zT
	zdp9fOr5xckfzMW2Llzmk8daXrTstgqnySInVBIRUjF+pB/01ljVUFSuryD1GN9gtPc/
	UfBw==
X-Gm-Message-State: AOAM533n+zNM8WJfbR/Q5RAJe0ousZtNILQrAJwWZ6PzamK2WlN43eV2
	l6ilu2LCp4YVaaO2Qf5FsGxl/I56abM23cIcqQ0EwA==
X-Google-Smtp-Source: ABdhPJy9J40IqLa/d+cck6PXVVGYBFPLo6iqEOA+v2R4s6asbN5wOCf5ZJ6fNNbFdsT8bCsuZH/tAzIMp5hm7zOGEdw=
X-Received: by 2002:a17:906:8447:: with SMTP id
	e7mr5154772ejy.523.1616608827202; 
	Wed, 24 Mar 2021 11:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
	<OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4iBnWbG0FYw6-K0MaH--rq62s7RY_yoT9rOYWMa94Yakw@mail.gmail.com>
	<OSBPR01MB29203F891F9584CC53616FB8F4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4gn_AvT6BA7g4jLKRFODSpt7_ORowVd3KgyWxyaFG0k9g@mail.gmail.com>
	<OSBPR01MB2920E46CBE4816CDF711E004F46F9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<OSBPR01MB29208779955B49F84D857F80F4689@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com>
	<20210324074751.GA1630@lst.de>
	<CAPcyv4hOrYCW=wjkxkCP+JbyD+A_Po0rW-61qQWAOm3zp_eyUQ@mail.gmail.com>
	<20210324173935.GB12770@lst.de>
In-Reply-To: <20210324173935.GB12770@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Mar 2021 11:00:16 -0700
Message-ID: <CAPcyv4iyS0EB0zLNxLwML1C0E2Eqk3TweHvmgpNWpZKVPVpz5Q@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
	"qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 24, 2021 at 10:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Mar 24, 2021 at 09:37:01AM -0700, Dan Williams wrote:
> > > Eww.  As I said I think the right way is that the file system (or
> > > other consumer) can register a set of callbacks for opening the device.
> >
> > How does that solve the problem of the driver being notified of all
> > pfn failure events?
>
> Ok, I probably just showed I need to spend more time looking at
> your proposal vs the actual code..
>
> Don't we have a proper way how one of the nvdimm layers own a
> spefific memory range and call directly into that instead of through
> a notifier?

So that could be a new dev_pagemap operation as Ruan has here. I was
thinking that other agents would be interested in non-dev_pagemap
managed ranges, but we could leave that for later and just make the
current pgmap->memory_failure() callback proposal range based.

>
> > Today pmem only finds out about the ones that are
> > notified via native x86 machine check error handling via a notifier
> > (yes "firmware-first" error handling fails to do the right thing for
> > the pmem driver),
>
> Did any kind of firmware-first error handling ever get anything
> right?  I wish people would have learned that by now.

Part of me wants to say if you use firmware-first you get to keep the
pieces, but it's not always the end user choice as far as I
understand.

> > or the ones that are eventually reported via address
> > range scrub, but only for the nvdimms that implement range scrubbing.
> > memory_failure() seems a reasonable catch all point to route pfn
> > failure events, in an arch independent way, to interested drivers.
>
> Yeah.
>
> > I'm fine swapping out dax_device blocking_notiier chains for your
> > proposal, but that does not address all the proposed reworks in my
> > list which are:
> >
> > - delete "drivers/acpi/nfit/mce.c"
> >
> > - teach memory_failure() to be able to communicate range failure
> >
> > - enable memory_failure() to defer to a filesystem that can say
> > "critical metadata is impacted, no point in trying to do file-by-file
> > isolation, bring the whole fs down".
>
> This all sounds sensible.

Ok, Ruan, I think this means rework your dev_pagemap_ops callback to
be range based. Add a holder concept for dax_devices and then layer
that on Christoph's eventual dax_device callback mechanism that a
dax_device holder can register.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

