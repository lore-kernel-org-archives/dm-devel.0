Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823CEC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:17:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F376360C4B
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 16:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F376360C4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-v3y5Zx3QM86ideEun4C5yQ-1; Fri, 29 Oct 2021 12:16:59 -0400
X-MC-Unique: v3y5Zx3QM86ideEun4C5yQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BA7110151E0;
	Fri, 29 Oct 2021 16:16:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 148A15F4EC;
	Fri, 29 Oct 2021 16:16:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 880BE4EA2F;
	Fri, 29 Oct 2021 16:16:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TGGogR025611 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 12:16:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 77B0D40CFD10; Fri, 29 Oct 2021 16:16:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 712D340CFD0B
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 16:16:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B3DA18A01A5
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 16:16:50 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
	[209.85.214.178]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-280-3oepyvyaNRCIzpIFJMtAzg-1; Fri, 29 Oct 2021 12:16:48 -0400
X-MC-Unique: 3oepyvyaNRCIzpIFJMtAzg-1
Received: by mail-pl1-f178.google.com with SMTP id t21so7145224plr.6
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 09:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=UuiRv/Aqc9KWf66Wmwy2yVHjihLskj+s11srG8q1vD8=;
	b=I2J1b4//CnEL2LqOzKVfkEkRByVYCbK7yhr/te6+ZbzKjoBAqlLIWxNRGnnnT72ja/
	CEIPNMEo46YxjZYhtHbcfoozn00y+jRfZSBwAnFJUayEfiAMa5BJ/Gh9Ods/Je6pYXBI
	jLTIZDU0fwIt31rTVkT4GMDQMo1Z6NGWqCL9vH99wHX2lCz6FvN0T1U2M3TMCEWNfa9X
	2VayV5Q29CxSG69Mdk0wSvRdxpx8WMYppGv2nll01UH45ZYDgprbPCa9Xtqhnh4O7GK4
	zAuELWqJjjaiEZ2JuMAOANDC12Ny2q1zXRzniJJ9i9uwbj4PVpvo1AUtvgLlzF2DFjsy
	7kBg==
X-Gm-Message-State: AOAM5312orKyoVy4AZKefCAx0IXdKq0KsS+iHGqDN3N6B0qHusMq4hKf
	dsprJrD1qAsFuv8UEgv0CrihH3JFK2rubXbJAwxp35Ovh/0=
X-Google-Smtp-Source: ABdhPJy6oDDE8Tua+O/7LJsaoOuN022Twl1T27YRaF2rK5Jgwv2I/UmljReJn3ItDXvNR8dsDNU53ltbLhzG+bw6RwY=
X-Received: by 2002:a17:90b:350f:: with SMTP id
	ls15mr12425415pjb.220.1635524207375; 
	Fri, 29 Oct 2021 09:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<CAPcyv4iEt78-XSsKjTWcpy71zaduXyyigTro6f3fmRqqFOG98Q@mail.gmail.com>
	<20211029105139.1194bb7f@canb.auug.org.au>
	<CAPcyv4g8iEyN5UN1w1xBqQDYSb3HCh7_smsmjt-PiHORRK+X9Q@mail.gmail.com>
	<20211029155524.GE24307@magnolia>
In-Reply-To: <20211029155524.GE24307@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Oct 2021 09:16:35 -0700
Message-ID: <CAPcyv4hL7ox5a7L7pBs-uoj_h+9F7E_nBs-qnJKBbJ7PHpWAjw@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>,
	virtualization@lists.linux-foundation.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 29, 2021 at 8:55 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Oct 29, 2021 at 08:42:29AM -0700, Dan Williams wrote:
> > On Thu, Oct 28, 2021 at 4:52 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi Dan,
> > >
> > > On Wed, 27 Oct 2021 13:46:31 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > My merge resolution is here [1]. Christoph, please have a look. The
> > > > rebase and the merge result are both passing my test and I'm now going
> > > > to review the individual patches. However, while I do that and collect
> > > > acks from DM and EROFS folks, I want to give Stephen a heads up that
> > > > this is coming. Primarily I want to see if someone sees a better
> > > > strategy to merge this, please let me know, but if not I plan to walk
> > > > Stephen and Linus through the resolution.
> > >
> > > It doesn't look to bad to me (however it is a bit late in the cycle :-(
> > > ).  Once you are happy, just put it in your tree (some of the conflicts
> > > are against the current -rc3 based version of your tree anyway) and I
> > > will cope with it on Monday.
> >
> > Christoph, Darrick, Shiyang,
> >
> > I'm losing my nerve to try to jam this into v5.16 this late in the
> > cycle.
>
> Always a solid choice to hold off for a little more testing and a little
> less anxiety. :)
>
> I don't usually accept new code patches for iomap after rc4 anyway.
>
> > I do want to get dax+reflink squared away as soon as possible,
> > but that looks like something that needs to build on top of a
> > v5.16-rc1 at this point. If Linus does a -rc8 then maybe it would have
> > enough soak time, but otherwise I want to take the time to collect the
> > acks and queue up some more follow-on cleanups to prepare for
> > block-less-dax.
>
> I think that hwpoison-calls-xfs-rmap patchset is a prerequisite for
> dax+reflink anyway, right?  /me had concluded both were 5.17 things.

Ok, cool, sounds like a plan.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

