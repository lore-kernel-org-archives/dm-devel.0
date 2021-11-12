Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFCFC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:36:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9226460F14
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 15:36:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9226460F14
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636731404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0cZKoFz2STOs2ghwxNsJE0OA/cC7jfCc5/Fs+btB3NE=;
	b=LxLuCSTpTgG2ace4yNr/OCl4HiNFJd1otS70ZQ5sne459Zd6G4cX2p+gzgS+LgXWT5/PXE
	T7x2UaT1eVpANj/EUadQ74aWTmEujPmjUNRD0LyVUnoYGPjX4yLYMILaa8pk7Vjd3cH5Av
	DVxPe3L17wlv2zz7H+SoHkMx63t1CMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-lxuLAqiIPzedAAqe05woLw-1; Fri, 12 Nov 2021 10:36:43 -0500
X-MC-Unique: lxuLAqiIPzedAAqe05woLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E03D56C8A;
	Fri, 12 Nov 2021 15:36:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08BCE19C59;
	Fri, 12 Nov 2021 15:36:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5F21181A1CF;
	Fri, 12 Nov 2021 15:36:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACFaZQd015967 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 10:36:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDFF740149A8; Fri, 12 Nov 2021 15:36:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C74E740CFD0E
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:36:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD776185A7BA
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 15:36:35 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-322-9OvQpIGiM9-AN-z2FOx9jQ-1; Fri, 12 Nov 2021 10:36:32 -0500
X-MC-Unique: 9OvQpIGiM9-AN-z2FOx9jQ-1
Received: by mail-qk1-f198.google.com with SMTP id
	h8-20020a05620a284800b0045ec745583cso6677475qkp.6
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=1yRNkydUNK+ZkSMdy54HzNSiQ/CpVQa1C/0YRKMDt6I=;
	b=KF+CEPM/Tw7Fa4pOhOcrDoXySJNJEp2itraSwkqaRqkm6uZUc21sGYqttbak7fXDEf
	+H35OyqFBY3klftRQiCiW+lHOCs1iT0NgJlx8GRaRTie0x+ZSN855l2EGIsd5X+M9D8e
	t1xnYYcPjGKJi1aQOVLf8bvjvtzP2e+4MhiH1Au4DPN3iD9f1Zu4GsSOLINjV7VvcUSZ
	98lj2HSDzJSnGSPsTJlfJtAOUBeutzHWGdS9P/A4knT6QCHi5b3C3OyGm8dGUu7220+J
	xvKG6tTp9VcJw6kJa1NQm2nArdtXt3ZUY9stNPwn+zNvO8IwwyDrfDMxDYq/CDWxsCpW
	NtUg==
X-Gm-Message-State: AOAM532xjYo3Qqee+T19moNXm0nmfyiVXzrpjTYxknqIbNVeKkQGSrhh
	m5D+RgaawhE/bA1iw9LPALeyTZNy6wBf9OABghxgJRvrKs1LJ13HsAEth0EpM9hAabYtn23H813
	RWg3/gCEnWij7bg==
X-Received: by 2002:a05:620a:2889:: with SMTP id
	j9mr13666559qkp.135.1636731391999; 
	Fri, 12 Nov 2021 07:36:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFKfis7Tfvod70r4n3+rCxCai5vb1NmzpAB89WVpeGak/SPYaHK+9rktro10Lf1pYOihkdQw==
X-Received: by 2002:a05:620a:2889:: with SMTP id
	j9mr13666538qkp.135.1636731391781; 
	Fri, 12 Nov 2021 07:36:31 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	j13sm2955023qkp.111.2021.11.12.07.36.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 12 Nov 2021 07:36:31 -0800 (PST)
Date: Fri, 12 Nov 2021 10:36:30 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YY6J/mdSmrfK8moV@redhat.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
	<CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
	<15f01d51-2611-3566-0d08-bdfbec53f88c@oracle.com>
	<CAPcyv4gwbZ=Z6xCjDCASpkPnw1EC8NMAJDh9_sa3n2PAG5+zAA@mail.gmail.com>
	<795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
MIME-Version: 1.0
In-Reply-To: <795a0ced-68b4-4ed8-439b-c539942b925e@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, "Weiny,
	Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 10 2021 at  1:26P -0500,
Jane Chu <jane.chu@oracle.com> wrote:

> On 11/9/2021 1:02 PM, Dan Williams wrote:
> > On Tue, Nov 9, 2021 at 11:59 AM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> On 11/9/2021 10:48 AM, Dan Williams wrote:
> >>> On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
> >>>>
> >>>> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
> >>>>>    static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
> >>>>>                 void *addr, size_t bytes, struct iov_iter *i, int mode)
> >>>>>    {
> >>>>> +     phys_addr_t pmem_off;
> >>>>> +     size_t len, lead_off;
> >>>>> +     struct pmem_device *pmem = dax_get_private(dax_dev);
> >>>>> +     struct device *dev = pmem->bb.dev;
> >>>>> +
> >>>>> +     if (unlikely(mode == DAX_OP_RECOVERY)) {
> >>>>> +             lead_off = (unsigned long)addr & ~PAGE_MASK;
> >>>>> +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
> >>>>> +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> >>>>> +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
> >>>>> +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
> >>>>> +                                     addr, bytes);
> >>>>> +                             return (size_t) -EIO;
> >>>>> +                     }
> >>>>> +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> >>>>> +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
> >>>>> +                                             BLK_STS_OK)
> >>>>> +                             return (size_t) -EIO;
> >>>>> +             }
> >>>>> +     }
> >>>>
> >>>> This is in the wrong spot.  As seen in my WIP series individual drivers
> >>>> really should not hook into copying to and from the iter, because it
> >>>> really is just one way to write to a nvdimm.  How would dm-writecache
> >>>> clear the errors with this scheme?
> >>>>
> >>>> So IMHO going back to the separate recovery method as in your previous
> >>>> patch really is the way to go.  If/when the 64-bit store happens we
> >>>> need to figure out a good way to clear the bad block list for that.
> >>>
> >>> I think we just make error management a first class citizen of a
> >>> dax-device and stop abstracting it behind a driver callback. That way
> >>> the driver that registers the dax-device can optionally register error
> >>> management as well. Then fsdax path can do:
> >>>
> >>>           rc = dax_direct_access(..., &kaddr, ...);
> >>>           if (unlikely(rc)) {
> >>>                   kaddr = dax_mk_recovery(kaddr);
> >>
> >> Sorry, what does dax_mk_recovery(kaddr) do?
> > 
> > I was thinking this just does the hackery to set a flag bit in the
> > pointer, something like:
> > 
> > return (void *) ((unsigned long) kaddr | DAX_RECOVERY)
> 
> Okay, how about call it dax_prep_recovery()?
> 
> > 
> >>
> >>>                   dax_direct_access(..., &kaddr, ...);
> >>>                   return dax_recovery_{read,write}(..., kaddr, ...);
> >>>           }
> >>>           return copy_{mc_to_iter,from_iter_flushcache}(...);
> >>>
> >>> Where, the recovery version of dax_direct_access() has the opportunity
> >>> to change the page permissions / use an alias mapping for the access,
> >>
> >> again, sorry, what 'page permissions'?  memory_failure_dev_pagemap()
> >> changes the poisoned page mem_type from 'rw' to 'uc-' (should be NP?),
> >> do you mean to reverse the change?
> > 
> > Right, the result of the conversation with Boris is that
> > memory_failure() should mark the page as NP in call cases, so
> > dax_direct_access() needs to create a UC mapping and
> > dax_recover_{read,write}() would sink that operation and either return
> > the page to NP after the access completes, or convert it to WB if the
> > operation cleared the error.
> 
> Okay,  will add a patch to fix set_mce_nospec().
> 
> How about moving set_memory_uc() and set_memory_np() down to
> dax_recovery_read(), so that we don't split the set_memory_X calls
> over different APIs, because we can't enforce what follows
> dax_direct_access()?
> 
> > 
> >>> dax_recovery_read() allows reading the good cachelines out of a
> >>> poisoned page, and dax_recovery_write() coordinates error list
> >>> management and returning a poison page to full write-back caching
> >>> operation when no more poisoned cacheline are detected in the page.
> >>>
> >>
> >> How about to introduce 3 dax_recover_ APIs:
> >>     dax_recover_direct_access(): similar to dax_direct_access except
> >>        it ignores error list and return the kaddr, and hence is also
> >>        optional, exported by device driver that has the ability to
> >>        detect error;
> >>     dax_recovery_read(): optional, supported by pmem driver only,
> >>        reads as much data as possible up to the poisoned page;
> > 
> > It wouldn't be a property of the pmem driver, I expect it would be a
> > flag on the dax device whether to attempt recovery or not. I.e. get
> > away from this being a pmem callback and make this a native capability
> > of a dax device.
> > 
> >>     dax_recovery_write(): optional, supported by pmem driver only,
> >>        first clear-poison, then write.
> >>
> >> Should we worry about the dm targets?
> > 
> > The dm targets after Christoph's conversion should be able to do all
> > the translation at direct access time and then dax_recovery_X can be
> > done on the resulting already translated kaddr.
> 
> I'm thinking about the mixed device dm where some provides
> dax_recovery_X, others don't, in which case we don't allow
> dax recovery because that causes confusion? or should we still
> allow recovery for part of the mixed devices?

I really don't like the all or nothing approach if it can be avoided.
I would imagine that if recovery possible it best to support it even
if the DM device happens to span a mix of devices with varying support
for recovery.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

