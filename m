Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D10C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 16:13:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29F4760D42
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 16:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29F4760D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-MgOyPfmTOJqipUoAjBp6SA-1; Tue, 02 Nov 2021 12:13:13 -0400
X-MC-Unique: MgOyPfmTOJqipUoAjBp6SA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3381966322;
	Tue,  2 Nov 2021 16:13:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E26460C05;
	Tue,  2 Nov 2021 16:13:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9C621800FDD;
	Tue,  2 Nov 2021 16:13:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2GD5mu004517 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 12:13:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1982112131B; Tue,  2 Nov 2021 16:13:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD0131121314
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 16:13:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF4F7811E86
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 16:13:01 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
	[209.85.214.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-288-KJSBuILVNe6-_6S74WI5Jg-1; Tue, 02 Nov 2021 12:13:00 -0400
X-MC-Unique: KJSBuILVNe6-_6S74WI5Jg-1
Received: by mail-pl1-f180.google.com with SMTP id t11so17010516plq.11
	for <dm-devel@redhat.com>; Tue, 02 Nov 2021 09:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=pIALiqswCfSwk+/MEarCA9yLgBnLpJVqWRaUmM6jp5w=;
	b=TM8pXvXTC1H587zoSTjbGP328DFVAm3BWdHuFnlM4ZRwbJ4ClLrTH7BYHjVSbHoV2s
	ZUlGZQd8sLzYYksHEL/OJr7IW+IgnT8L+eEsSFnUZk35urohObewEBTxkJwO75Qcty2p
	zJbQkbqe25gVGInJLfNjyVqSfJFEv5Cdy/TIYKqShu3uGh4APa4zC0WzKLFvUmUwhxEb
	EN9+nZ9+7DXyXWNJTBxxMmaNd4qz1iQwGwrMDyAN2Gqbhei1oWRl1/nmzFmZmkh8W+SF
	J+gI9BvyTI4EDSBcT3zd+OJXudGgywgkbhwQ6B7k7a8JksYlIK5iULn26KY7FSfTMZzx
	QPWQ==
X-Gm-Message-State: AOAM533TvF+gEc07U/p30MAB94ubgXb89UNCw2X7LbTdHWu2zVvV2KBZ
	UjlSybUHvaKIbczQdUxT0PRCLCcUx2FKFHnozagsHA==
X-Google-Smtp-Source: ABdhPJyUerhRmPa3p6Y+5F6zaaUU9FmrqYmMRvdoPUtNZXczvAj1BoJWZcyxx8lp/uHInRyxjBoZleDZuAuNEyTgQ/Q=
X-Received: by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id
	ij16-20020a170902ab5000b0013f4c709322mr32351492plb.89.1635869579139;
	Tue, 02 Nov 2021 09:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<YXFPfEGjoUaajjL4@infradead.org>
	<e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
	<YXJN4s1HC/Y+KKg1@infradead.org>
	<2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
	<YXj2lwrxRxHdr4hb@infradead.org>
	<20211028002451.GB2237511@magnolia>
In-Reply-To: <20211028002451.GB2237511@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Nov 2021 09:12:48 -0700
Message-ID: <CAPcyv4ge8ebFn2tBtc9_ThEYXjCczLW4H8NYrOJKbGF_Y-Wg5w@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
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
Cc: Jane Chu <jane.chu@oracle.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
	RWF_RECOVERY_DATA flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 27, 2021 at 5:25 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Oct 26, 2021 at 11:49:59PM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 22, 2021 at 08:52:55PM +0000, Jane Chu wrote:
> > > Thanks - I try to be honest.  As far as I can tell, the argument
> > > about the flag is a philosophical argument between two views.
> > > One view assumes design based on perfect hardware, and media error
> > > belongs to the category of brokenness. Another view sees media
> > > error as a build-in hardware component and make design to include
> > > dealing with such errors.
> >
> > No, I don't think so.  Bit errors do happen in all media, which is
> > why devices are built to handle them.  It is just the Intel-style
> > pmem interface to handle them which is completely broken.
>
> Yeah, I agree, this takes me back to learning how to use DISKEDIT to
> work around a hole punched in a file (with a pen!) in the 1980s...
>
> ...so would you happen to know if anyone's working on solving this
> problem for us by putting the memory controller in charge of dealing
> with media errors?

What are you guys going on about? ECC memory corrects single-bit
errors in the background, multi-bit errors cause the memory controller
to signal that data is gone. This is how ECC memory has worked since
forever. Typically the kernel's memory-failure path is just throwing
away pages that signal data loss. Throwing away pmem pages is harder
because unlike DRAM the physical address of the page matters to upper
layers.

>
> > > errors in mind from start.  I guess I'm trying to articulate why
> > > it is acceptable to include the RWF_DATA_RECOVERY flag to the
> > > existing RWF_ flags. - this way, pwritev2 remain fast on fast path,
> > > and its slow path (w/ error clearing) is faster than other alternative.
> > > Other alternative being 1 system call to clear the poison, and
> > > another system call to run the fast pwrite for recovery, what
> > > happens if something happened in between?
> >
> > Well, my point is doing recovery from bit errors is by definition not
> > the fast path.  Which is why I'd rather keep it away from the pmem
> > read/write fast path, which also happens to be the (much more important)
> > non-pmem read/write path.
>
> The trouble is, we really /do/ want to be able to (re)write the failed
> area, and we probably want to try to read whatever we can.  Those are
> reads and writes, not {pre,f}allocation activities.  This is where Dave
> and I arrived at a month ago.
>
> Unless you'd be ok with a second IO path for recovery where we're
> allowed to be slow?  That would probably have the same user interface
> flag, just a different path into the pmem driver.
>
> Ha, how about a int fd2 = recoveryfd(fd); call where you'd get whatever
> speshul options (retry raid mirrors!  scrape the film off the disk if
> you have to!) you want that can take forever, leaving the fast paths
> alone?

I am still failing to see the technical argument for why
RWF_RECOVER_DATA significantly impacts the fast path, and why you
think this is somehow specific to pmem. In fact the pmem effort is
doing the responsible thing and trying to plumb this path while other
storage drivers just seem to be pretending that memory errors never
happen.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

