Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC9DC433C1
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 02:19:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0522619CB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 02:19:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0522619CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-YYtgGNrjN2inz7SnLTdRoA-1; Tue, 23 Mar 2021 22:19:53 -0400
X-MC-Unique: YYtgGNrjN2inz7SnLTdRoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59057800D53;
	Wed, 24 Mar 2021 02:19:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1626A5C1C5;
	Wed, 24 Mar 2021 02:19:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 331141809C83;
	Wed, 24 Mar 2021 02:19:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12O2Jgpl015411 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 22:19:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7464DC2110; Wed, 24 Mar 2021 02:19:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D862BE5D1
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 02:19:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C929185A7B4
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 02:19:40 +0000 (UTC)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
	[209.85.218.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-111-QQJvd1VMP66qRpSEztKFrQ-1; Tue, 23 Mar 2021 22:19:37 -0400
X-MC-Unique: QQJvd1VMP66qRpSEztKFrQ-1
Received: by mail-ej1-f42.google.com with SMTP id u9so30321408ejj.7
	for <dm-devel@redhat.com>; Tue, 23 Mar 2021 19:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=O6pYt7i3ZfjZRsHKNRy9TSnJLBhdXZsjApsl7qVrkWA=;
	b=GXShxUaYMrJ9ofsFNBm4ly7rm9p6KmzDbPmcp8Ov9F2tZgUmzuI7Lty20d0fBiQ3jj
	f8Tmd+gDn90VazRygoSmOviGy+l9rQYy2kVQFjlXOUjOuZm549iLHwM9xqHh1wYsPajM
	DlFwJuNCu6IVc/RGsbpzBGYNFKG2TKqvZqhhMckbkk1uAFMGpaYdI2SqOLktH9IcSXeU
	aV/wmf54SUNefaL3AFFYm4TOHET0O2zxOYLKPgS5G8XmJef+DfUH2a2QQ5R4kp79qsqR
	XCnrCJjfU2Fkv6B7472uycWn/0RUw+A8LGt/ElfdOVNdRZMcgGqq4/gz0C2OQ146ZO3m
	THQQ==
X-Gm-Message-State: AOAM532G21llvZt6bZ65TZQwRgC9+x7A0ElAR/i4y6vgDV1kaY1mxpnG
	fEF6/SG5+PmQd5iaLQGgYPWvbo88uHvghFa+vX+SCQ==
X-Google-Smtp-Source: ABdhPJxD4PFaqvtvK1VRDwzCV3Hl7JUGp0Ljr770gbmSGeQf+7GIop0/MoqaotWJPaQPZgD8nzvxH/6snKVhCi2Z0VU=
X-Received: by 2002:a17:906:2ac1:: with SMTP id
	m1mr1187750eje.472.1616552376639; 
	Tue, 23 Mar 2021 19:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-2-ruansy.fnst@cn.fujitsu.com>
	<CAPcyv4jqEdPoF5YM+jSYJd74KqRTwbbEum7=moa3=Wyn6UyU9g@mail.gmail.com>
	<OSBPR01MB29207A1C06968705C2FEBACFF4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4iBnWbG0FYw6-K0MaH--rq62s7RY_yoT9rOYWMa94Yakw@mail.gmail.com>
	<OSBPR01MB29203F891F9584CC53616FB8F4939@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<CAPcyv4gn_AvT6BA7g4jLKRFODSpt7_ORowVd3KgyWxyaFG0k9g@mail.gmail.com>
	<OSBPR01MB2920E46CBE4816CDF711E004F46F9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
	<OSBPR01MB29208779955B49F84D857F80F4689@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29208779955B49F84D857F80F4689@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Mar 2021 19:19:28 -0700
Message-ID: <CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 18, 2021 at 7:18 PM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
>
>
> > -----Original Message-----
> > From: ruansy.fnst@fujitsu.com <ruansy.fnst@fujitsu.com>
> > Subject: RE: [PATCH v3 01/11] pagemap: Introduce ->memory_failure()
> > > > > > >
> > > > > > > After the conversation with Dave I don't see the point of this.
> > > > > > > If there is a memory_failure() on a page, why not just call
> > > > > > > memory_failure()? That already knows how to find the inode and
> > > > > > > the filesystem can be notified from there.
> > > > > >
> > > > > > We want memory_failure() supports reflinked files.  In this
> > > > > > case, we are not able to track multiple files from a page(this
> > > > > > broken
> > > > > > page) because
> > > > > > page->mapping,page->index can only track one file.  Thus, I
> > > > > > page->introduce this
> > > > > > ->memory_failure() implemented in pmem driver, to call
> > > > > > ->->corrupted_range()
> > > > > > upper level to upper level, and finally find out files who are
> > > > > > using(mmapping) this page.
> > > > > >
> > > > >
> > > > > I know the motivation, but this implementation seems backwards.
> > > > > It's already the case that memory_failure() looks up the
> > > > > address_space associated with a mapping. From there I would expect
> > > > > a new 'struct address_space_operations' op to let the fs handle
> > > > > the case when there are multiple address_spaces associated with a given
> > file.
> > > > >
> > > >
> > > > Let me think about it.  In this way, we
> > > >     1. associate file mapping with dax page in dax page fault;
> > >
> > > I think this needs to be a new type of association that proxies the
> > > representation of the reflink across all involved address_spaces.
> > >
> > > >     2. iterate files reflinked to notify `kill processes signal` by the
> > > >           new address_space_operation;
> > > >     3. re-associate to another reflinked file mapping when unmmaping
> > > >         (rmap qeury in filesystem to get the another file).
> > >
> > > Perhaps the proxy object is reference counted per-ref-link. It seems
> > > error prone to keep changing the association of the pfn while the reflink is
> > in-tact.
> > Hi, Dan
> >
> > I think my early rfc patchset was implemented in this way:
> >  - Create a per-page 'dax-rmap tree' to store each reflinked file's (mapping,
> > offset) when causing dax page fault.
> >  - Mount this tree on page->zone_device_data which is not used in fsdax, so
> > that we can iterate reflinked file mappings in memory_failure() easily.
> > In my understanding, the dax-rmap tree is the proxy object you mentioned.  If
> > so, I have to say, this method was rejected. Because this will cause huge
> > overhead in some case that every dax page have one dax-rmap tree.
> >
>
> Hi, Dan
>
> How do you think about this?  I am still confused.  Could you give me some advice?

So I think the primary driver of this functionality is dax-devices and
the architectural model for memory failure where several architectures
and error handlers know how to route pfn failure to the
memory_failure() frontend.

Compare that to block-devices where sector failure has no similar
framework, and despite some initial interest about reusing 'struct
badblocks' for this type of scenario there has been no real uptake to
expand 'struct badblocks' outside of the pmem driver.

I think the work you have done for ->corrupted_range() just needs to
be repurposed away from a block-device operation to dax-device
infrastructure. Christoph's pushback on extending
block_device_operations makes sense to me because there is likely no
other user of this facility than the pmem driver, and the pmem driver
only needs it for the vestigial reason that filesystems mount on
block-devices and not dax-devices.

Recently Dave drove home the point that a filesystem can't do anything
with pfns, it needs LBAs. A dax-device does not have LBA's, but it
does operate on the concept of device-relative offsets. The filesystem
is allowed to assume that dax-device:PFN[device_byte_offset >>
PAGE_SHIFT] aliases the same data as the associated
block-device:LBA[device_byte_offset >> SECTOR_SHIFT]. He also
reiterated that this interface should be range based, which you
already had, but I did not include in my attempt to communicate the
mass failure of an entire surprise-removed device.

So I think the path forward is:

- teach memory_failure() to allow for ranged failures

- let interested drivers register for memory failure events via a
blocking_notifier_head

- teach memory_failure() to optionally let the notifier chain claim
the event vs its current default of walking page->mapping

- teach the pmem driver to register for memory_failure() events and
filter the ones that apply to pfns that the driver owns

- drop the nfit driver's usage of the mce notifier chain since
memory_failure() is a superset of what the mce notifier communicates

- augment the pmem driver's view of badblocks that it gets from
address range scrub with one's it gets from memory_failure() events

- when pmem handles a memory_failure() event or an address range scrub
event fire a new event on a new per-dax-device blocking_notifier_head
indicating the dax-relative offset ranges of the translated PFNs. This
notification can optionally indicate failure, offline (for removal),
and online (for repaired ranges).

- teach dm to receive dax-device notifier events from its leaf devices
and then translate them into dax-device notifications relative to the
dm-device offset. This would seem to be a straightforward conversion
of what you have done with ->corrupted_range()

- teach filesystems to register for dax-device notifiers

With all of that in place an interested filesystem can take ownership
of a memory failure that impacts a range of pfns it is responsible for
via a dax-device, but it also allows a not interested filesystem to
default to standard single-pfn-at-a-time error handling and
assumptions about page->mapping only referring to a single address
space.

This obviously does not solve Dave's desire to get this type of error
reporting on block_devices, but I think there's nothing stopping a
parallel notifier chain from being created for block-devices, but
that's orthogonal to requirements and capabilities provided by
dax-devices.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

