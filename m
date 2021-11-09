Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F0DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 06:05:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EE6661184
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 06:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EE6661184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-C8UWpntLNTqg1ZUu8gpZcQ-1; Tue, 09 Nov 2021 01:05:03 -0500
X-MC-Unique: C8UWpntLNTqg1ZUu8gpZcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 216B515723;
	Tue,  9 Nov 2021 06:04:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1B265DEFB;
	Tue,  9 Nov 2021 06:04:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 43123181A1CF;
	Tue,  9 Nov 2021 06:04:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A964blP005247 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 01:04:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 584CE404727A; Tue,  9 Nov 2021 06:04:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 543554047272
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 06:04:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CF77801212
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 06:04:37 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
	[209.85.214.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-502-hd8SwzMmO52st5L4D_mxFw-1; Tue, 09 Nov 2021 01:04:35 -0500
X-MC-Unique: hd8SwzMmO52st5L4D_mxFw-1
Received: by mail-pl1-f180.google.com with SMTP id n8so19008479plf.4
	for <dm-devel@redhat.com>; Mon, 08 Nov 2021 22:04:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=NVge1Iw2DLICm/edhKMuLv0kwlblMX536VglZLVGuRY=;
	b=xiwoOpgVSFzxneelSn3Ityp6q+syjMOI3QvPRqOOfqPDgpYta++DbVnafuYfsCXsmt
	9aZ6Nw43mdlgDO0Zg8MuyHFs0A1G20xkjwHuAxLUWxgvAUmhroorMGE/BbYMqlInbxye
	STchbeK4D/lrqRML0ZVzAPG5iwaCMSS9pGmVocie+On2MN1OWGaMjk3fenWlYHWeuZ/C
	tCmVk8tfp3wkt3cMvkNGJnUgUf+3WCJSJ9s4boPKVkS9M6PC6CTqQ5rWuWBV8yH9abAj
	0ATLiP9jynAC0PKVHf7Hi+9E3DTMZZipj3bzhsTLrnow04bKcU1OmU+KdzvDk/awSrC3
	RAxQ==
X-Gm-Message-State: AOAM533dPd9q9yY6kG2dacorTMzgjbJJsHTbsuC+czTx5Zm+lrpByscV
	5R1968MpMwZDgoLKZfVJxt4GPj+mFsE5lYRCNNafTA==
X-Google-Smtp-Source: ABdhPJwCtlqgnkTVyH3ATYZHBwvXcSX7T/CMSvZ7vKetQyo9w+pCKsHLoVtp5/ayV5vOuQEKSBrDKVvV/RcSnLRvGBk=
X-Received: by 2002:a17:90b:1e07:: with SMTP id
	pg7mr4381475pjb.93.1636437874506; 
	Mon, 08 Nov 2021 22:04:34 -0800 (PST)
MIME-Version: 1.0
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
	<CAPcyv4jcgFxgoXFhWL9+BReY8vFtgjb_=Lfai-adFpdzc4-35Q@mail.gmail.com>
	<63f89475-7a1f-e79e-7785-ba996211615b@oracle.com>
	<20211109052640.GG3538886@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20211109052640.GG3538886@iweiny-DESK2.sc.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Nov 2021 22:04:23 -0800
Message-ID: <CAPcyv4j-EHz9Eg4UmD8v2-mPgNgE0uJSG_Wr2fzJsU-+Em6umw@mail.gmail.com>
To: Ira Weiny <ira.weiny@intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Dave Jiang <dave.jiang@intel.com>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dax: Introduce normal and recovery
	dax operation modes
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

On Mon, Nov 8, 2021 at 9:26 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Mon, Nov 08, 2021 at 09:02:29PM +0000, Jane Chu wrote:
> > On 11/6/2021 9:48 AM, Dan Williams wrote:
> > > On Fri, Nov 5, 2021 at 6:17 PM Jane Chu <jane.chu@oracle.com> wrote:
> > >>
> > >> Introduce DAX_OP_NORMAL and DAX_OP_RECOVERY operation modes to
> > >> {dax_direct_access, dax_copy_from_iter, dax_copy_to_iter}.
> > >> DAX_OP_NORMAL is the default or the existing mode, and
> > >> DAX_OP_RECOVERY is a new mode for data recovery purpose.
> > >>
> > >> When dax-FS suspects dax media error might be encountered
> > >> on a read or write, it can enact the recovery mode read or write
> > >> by setting DAX_OP_RECOVERY in the aforementioned APIs. A read
> > >> in recovery mode attempts to fetch as much data as possible
> > >> until the first poisoned page is encountered. A write in recovery
> > >> mode attempts to clear poison(s) in a page-aligned range and
> > >> then write the user provided data over.
> > >>
> > >> DAX_OP_NORMAL should be used for all non-recovery code path.
> > >>
> > >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> > > [..]
> > >> diff --git a/include/linux/dax.h b/include/linux/dax.h
> > >> index 324363b798ec..931586df2905 100644
> > >> --- a/include/linux/dax.h
> > >> +++ b/include/linux/dax.h
> > >> @@ -9,6 +9,10 @@
> > >>   /* Flag for synchronous flush */
> > >>   #define DAXDEV_F_SYNC (1UL << 0)
> > >>
> > >> +/* dax operation mode dynamically set by caller */
> > >> +#define        DAX_OP_NORMAL           0
> > >
> > > Perhaps this should be called DAX_OP_FAILFAST?
> >
> > Sure.
> >
> > >
> > >> +#define        DAX_OP_RECOVERY         1
> > >> +
> > >>   typedef unsigned long dax_entry_t;
> > >>
> > >>   struct dax_device;
> > >> @@ -22,8 +26,8 @@ struct dax_operations {
> > >>           * logical-page-offset into an absolute physical pfn. Return the
> > >>           * number of pages available for DAX at that pfn.
> > >>           */
> > >> -       long (*direct_access)(struct dax_device *, pgoff_t, long,
> > >> -                       void **, pfn_t *);
> > >> +       long (*direct_access)(struct dax_device *, pgoff_t, long, int,
> > >
> > > Would be nice if that 'int' was an enum, but I'm not sure a new
> > > parameter is needed at all, see below...
> >
> > Let's do your suggestion below. :)
> >
> > >
> > >> +                               void **, pfn_t *);
> > >>          /*
> > >>           * Validate whether this device is usable as an fsdax backing
> > >>           * device.
> > >> @@ -32,10 +36,10 @@ struct dax_operations {
> > >>                          sector_t, sector_t);
> > >>          /* copy_from_iter: required operation for fs-dax direct-i/o */
> > >>          size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
> > >> -                       struct iov_iter *);
> > >> +                       struct iov_iter *, int);
> > >
> > > I'm not sure the flag is needed here as the "void *" could carry a
> > > flag in the pointer to indicate that is a recovery kaddr.
> >
> > Agreed.
>
> Not sure if this is implied but I would like some macros or other helper
> functions to check these flags hidden in the addresses.
>
> For me I'm a bit scared about having flags hidden in the address like this
> because I can't lead to some confusions IMO.
>
> But if we have some macros or other calls which can make this more obvious of
> what is going on I think that would help.

You could go further and mark it as an 'unsigned long __bitwise' type
to get the compiler to help with enforcing accessors to strip off the
flag bits.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

