Return-Path: <SRS0=Ydjc=IG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7C8C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 18:02:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 00447652A7
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 18:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00447652A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-sKOvLE3UPViuJptptx6BJg-1; Mon, 08 Mar 2021 13:02:13 -0500
X-MC-Unique: sKOvLE3UPViuJptptx6BJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6900CC623;
	Mon,  8 Mar 2021 18:02:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 222EC5D9CD;
	Mon,  8 Mar 2021 18:02:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D9B4157DC0;
	Mon,  8 Mar 2021 18:02:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 128I21vh030730 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Mar 2021 13:02:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A43AB305A5; Mon,  8 Mar 2021 18:02:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E53630858
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 18:01:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E257F855211
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 18:01:58 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
	[209.85.208.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-243-GwnHJjxgPa-aoCLNrkrnFQ-1; Mon, 08 Mar 2021 13:01:56 -0500
X-MC-Unique: GwnHJjxgPa-aoCLNrkrnFQ-1
Received: by mail-ed1-f50.google.com with SMTP id bd6so16017123edb.10
	for <dm-devel@redhat.com>; Mon, 08 Mar 2021 10:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=+zcp9aSnYoFbyB3tMeqX2oxWSrOP4DQTmgBJZuYBvDA=;
	b=JL2kMDRKLv+Rs+KI4amYg8Km/cX/+9nn8H/nbCT6y4efLQvYTSs/7XE7LuWeXhJgMD
	MgHpIhlewrNUKucGH9ijuY/y19+Vr0UdA/hyypAFBYVid85xxC2ZmtgBFgJe3fUuETPE
	T7BQM6sheHKkkK5JJKjTLTeS5MnSBkH/i7z/N/1z58TAZ1TJ87lUMhhSbe9viJB/uRBs
	LERktMAlPrf4AvNIWoAoIyGhjKhAMnXfDlOk7bPdQaeqA+efKyTFdtr3anrO6hu/2JiM
	yHdbs99bTvv8qAP9pdBJipylgnGHCNKJ+9rAfKV5Lfhfd0F3k2aJIta2JVSpDK0FbkjF
	8JjQ==
X-Gm-Message-State: AOAM532yfcAUlB52gzvpeoZPmZ5FQtLcVsURRtV5J5QA3ACdU+n6NO3a
	JNBcQlW2nhsokSvoDvrJrEEVGUQYNFU3Woil1iukcw==
X-Google-Smtp-Source: ABdhPJyiH5A/Lsq6qgR2AevlyxpZfOCI02f/Sq+KNGBFf5iXaQ47vO/OVkIBwMUvOxYfFtKqEcOogvchILyJzJrHkW4=
X-Received: by 2002:a05:6402:11c9:: with SMTP id
	j9mr11617699edw.348.1615226515542; 
	Mon, 08 Mar 2021 10:01:55 -0800 (PST)
MIME-Version: 1.0
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
	<CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
	<OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4iBnWbG0FYw6-K0MaH--rq62s7RY_yoT9rOYWMa94Yakw@mail.gmail.com>
	<OSBPR01MB29203F891F9584CC53616FB8F4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29203F891F9584CC53616FB8F4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Mar 2021 10:01:52 -0800
Message-ID: <CAPcyv4gn_AvT6BA7g4jLKRFODSpt7_ORowVd3KgyWxyaFG0k9g@mail.gmail.com>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 8, 2021 at 3:34 AM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
> > > > >  1 file changed, 8 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > > index 79c49e7f5c30..0bcf2b1e20bd 100644
> > > > > --- a/include/linux/memremap.h
> > > > > +++ b/include/linux/memremap.h
> > > > > @@ -87,6 +87,14 @@ struct dev_pagemap_ops {
> > > > >          * the page back to a CPU accessible page.
> > > > >          */
> > > > >         vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> > > > > +
> > > > > +       /*
> > > > > +        * Handle the memory failure happens on one page.  Notify the processes
> > > > > +        * who are using this page, and try to recover the data on this page
> > > > > +        * if necessary.
> > > > > +        */
> > > > > +       int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> > > > > +                             int flags);
> > > > >  };
> > > >
> > > > After the conversation with Dave I don't see the point of this. If
> > > > there is a memory_failure() on a page, why not just call
> > > > memory_failure()? That already knows how to find the inode and the
> > > > filesystem can be notified from there.
> > >
> > > We want memory_failure() supports reflinked files.  In this case, we are not
> > > able to track multiple files from a page(this broken page) because
> > > page->mapping,page->index can only track one file.  Thus, I introduce this
> > > ->memory_failure() implemented in pmem driver, to call ->corrupted_range()
> > > upper level to upper level, and finally find out files who are
> > > using(mmapping) this page.
> > >
> >
> > I know the motivation, but this implementation seems backwards. It's
> > already the case that memory_failure() looks up the address_space
> > associated with a mapping. From there I would expect a new 'struct
> > address_space_operations' op to let the fs handle the case when there
> > are multiple address_spaces associated with a given file.
> >
>
> Let me think about it.  In this way, we
>     1. associate file mapping with dax page in dax page fault;

I think this needs to be a new type of association that proxies the
representation of the reflink across all involved address_spaces.

>     2. iterate files reflinked to notify `kill processes signal` by the
>           new address_space_operation;
>     3. re-associate to another reflinked file mapping when unmmaping
>         (rmap qeury in filesystem to get the another file).

Perhaps the proxy object is reference counted per-ref-link. It seems
error prone to keep changing the association of the pfn while the
reflink is in-tact.

> It did not handle those dax pages are not in use, because their ->mapping are
> not associated to any file.  I didn't think it through until reading your
> conversation.  Here is my understanding: this case should be handled by
> badblock mechanism in pmem driver.  This badblock mechanism will call
> ->corrupted_range() to tell filesystem to repaire the data if possible.

There are 2 types of notifications. There are badblocks discovered by
the driver (see notify_pmem()) and there are memory_failures()
signalled by the CPU machine-check handler, or the platform BIOS. In
the case of badblocks that needs to be information considered by the
fs block allocator to avoid / try-to-repair badblocks on allocate, and
to allow listing damaged files that need repair. The memory_failure()
notification needs immediate handling to tear down mappings to that
pfn and signal processes that have consumed it with
SIGBUS-action-required. Processes that have the poison mapped, but
have not consumed it receive SIGBUS-action-optional.

> So, we split it into two parts.  And dax device and block device won't be mixed
> up again.   Is my understanding right?

Right, it's only the filesystem that knows that the block_device and
the dax_device alias data at the same logical offset. The requirements
for sector error handling and page error handling are separate like
block_device_operations and dax_operations.

> But the solution above is to solve the hwpoison on one or couple pages, which
> happens rarely(I think).  Do the 'pmem remove' operation cause hwpoison too?
> Call memory_failure() so many times?  I havn't understood this yet.

I'm working on a patch here to call memory_failure() on a wide range
for the surprise remove of a dax_device while a filesystem might be
mounted. It won't be efficient, but there is no other way to notify
the kernel that it needs to immediately stop referencing a page.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

