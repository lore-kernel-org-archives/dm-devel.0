Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538D1C433C1
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:37:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB4BE619F8
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB4BE619F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-W3bEr6ZPM_6lu2K1PQB6VA-1; Wed, 24 Mar 2021 12:37:27 -0400
X-MC-Unique: W3bEr6ZPM_6lu2K1PQB6VA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B858D1005D46;
	Wed, 24 Mar 2021 16:37:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 893435D766;
	Wed, 24 Mar 2021 16:37:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3912E1809C83;
	Wed, 24 Mar 2021 16:37:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OGbIk5004375 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 12:37:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 825F121CAC70; Wed, 24 Mar 2021 16:37:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BE4521CAC6D
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 16:37:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00D2C805F47
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 16:37:16 +0000 (UTC)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
	[209.85.208.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-6S4fHMGjM3eyoZaL8tnE4A-1; Wed, 24 Mar 2021 12:37:13 -0400
X-MC-Unique: 6S4fHMGjM3eyoZaL8tnE4A-1
Received: by mail-ed1-f52.google.com with SMTP id h13so28356991eds.5
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 09:37:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=F78F4/Kq+ndIvAG3q41JlNnbimm1afFKY1uPrkgKEKE=;
	b=Lc7i4XPTq+DKcgLFvQvnek2goZ7zzyKYl7mmYId0c4IIyku4+gavSKtw2ChAU085X/
	QByhPZXqDLV1UEZUJXW/OL44oQ9OsYiw4LRnmq6LLGZ45Nlo7LBGjJ7N/UvdKoCx0f3j
	mc2jNPTFDk4pwFk4tbj7/dWdN6yKWwXjxXMmWSFpcesOdmP6mTAtCucD4prH9Hwr6XNE
	olb2djdtVKQkBaqQ+uTIYxi1acrxDQ8nXEgnRKj4s1eYzyvG9acMZ/63/Zlrto7tG3Ss
	KV7C6jMF3/1xVWiEOdmP6EVqEnfDXiIUwFPgeLXJp7ZHTvWQu6ffCvuT5qjIy+9ugLqm
	3oqQ==
X-Gm-Message-State: AOAM533GkpqgbQgleRwM7GyNU0uVsnLaIXfmTXYh0CxLceEpP8GM5JGn
	SOWTTz2BKHwkQQ1nr7j8t/beF+TCtGb2wkHWH9QAtw==
X-Google-Smtp-Source: ABdhPJy0i6T+2AM1FhaOe2x1NOEA+VihVGm8Q0AyYdTDg9DUntxFo3NhisOlYTqdDwwzXOKs7/wWOwG2TBuN7zwJqD8=
X-Received: by 2002:a05:6402:4301:: with SMTP id
	m1mr4548882edc.210.1616603832460; 
	Wed, 24 Mar 2021 09:37:12 -0700 (PDT)
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
	<CAPcyv4jhUU3NVD8HLZnJzir+SugB6LnnrgJZ-jP45BZrbJ1dJQ@mail.gmail.com>
	<20210324074751.GA1630@lst.de>
In-Reply-To: <20210324074751.GA1630@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Mar 2021 09:37:01 -0700
Message-ID: <CAPcyv4hOrYCW=wjkxkCP+JbyD+A_Po0rW-61qQWAOm3zp_eyUQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 24, 2021 at 12:48 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Mar 23, 2021 at 07:19:28PM -0700, Dan Williams wrote:
> > So I think the path forward is:
> >
> > - teach memory_failure() to allow for ranged failures
> >
> > - let interested drivers register for memory failure events via a
> > blocking_notifier_head
>
> Eww.  As I said I think the right way is that the file system (or
> other consumer) can register a set of callbacks for opening the device.

How does that solve the problem of the driver being notified of all
pfn failure events? Today pmem only finds out about the ones that are
notified via native x86 machine check error handling via a notifier
(yes "firmware-first" error handling fails to do the right thing for
the pmem driver), or the ones that are eventually reported via address
range scrub, but only for the nvdimms that implement range scrubbing.
memory_failure() seems a reasonable catch all point to route pfn
failure events, in an arch independent way, to interested drivers.

I'm fine swapping out dax_device blocking_notiier chains for your
proposal, but that does not address all the proposed reworks in my
list which are:

- delete "drivers/acpi/nfit/mce.c"

- teach memory_failure() to be able to communicate range failure

- enable memory_failure() to defer to a filesystem that can say
"critical metadata is impacted, no point in trying to do file-by-file
isolation, bring the whole fs down".

> I have a series I need to finish and send out to do that for block
> devices.  We probably also need the concept of a holder for the dax
> device to make it work nicely, as otherwise we're going to have a bit
> of a mess.

Ok, I'll take a look at adding a holder.

>
> > This obviously does not solve Dave's desire to get this type of error
> > reporting on block_devices, but I think there's nothing stopping a
> > parallel notifier chain from being created for block-devices, but
> > that's orthogonal to requirements and capabilities provided by
> > dax-devices.
>
> FYI, my series could easily accomodate that if we ever get a block
> driver that actually could report such errors.

Sure, whatever we land for a dax_device could easily be adopted for a
block device.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

