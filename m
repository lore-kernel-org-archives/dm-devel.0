Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CF3C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 18:53:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6413561179
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 18:53:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6413561179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-AHpIlH1gO8-niqC5GqlzEw-1; Tue, 09 Nov 2021 13:53:01 -0500
X-MC-Unique: AHpIlH1gO8-niqC5GqlzEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C147A19251A9;
	Tue,  9 Nov 2021 18:52:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 773B760C05;
	Tue,  9 Nov 2021 18:52:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF0AC4EA2A;
	Tue,  9 Nov 2021 18:52:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9In4lq006284 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 13:49:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BDA4F400E113; Tue,  9 Nov 2021 18:49:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9C0D400E117
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 18:49:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58FC485A5B5
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 18:49:04 +0000 (UTC)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
	[209.85.215.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-54-VV_pzKtwOG2SHT2fOzoY8g-1; Tue, 09 Nov 2021 13:49:02 -0500
X-MC-Unique: VV_pzKtwOG2SHT2fOzoY8g-1
Received: by mail-pg1-f177.google.com with SMTP id q126so15362254pgq.13
	for <dm-devel@redhat.com>; Tue, 09 Nov 2021 10:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=9bp0YO5sOM+lpNoi642x1FUr5VchwTC78oq/dL28lzk=;
	b=Htlf+LI5hxZKZMrs+6r2MWTkaGCI16KKbzbN6ZGbdQZXGUQYaXKIVpq8NghF76Djcg
	xSAmvblOYD75iJlqXDR856NkLpm80lkMzfLIYcEfbbRep8R0QS/ioB6nCp+QCasJm0vt
	zaDq9eEBn9gjwy533z+tuAM7ubH2bPFMlENO+gpHaSA+iao25sjAhw/LLEfqGoUcjCTo
	tmGqB/3FjOTgzqgnB++9KCJYW9vZFhQbqdkUpW7g8sySkv00/rgGblvqOuopdc18ZKff
	5pBuHc9DfRzb32dWRGfRCfh0fd7omhSoaMR69+Bw2NWQ1Dms6VelmshAnGbVDnyn4z4G
	BDOg==
X-Gm-Message-State: AOAM5335MFaJaq8yl/wzZHjaiHfB+H2sbFz87+rC1u8Lg7Hgwul8kjiy
	aHyu1DDZBSl7szDnbAFUlQ3n/3xdroSWiCw5U/zfnv51bSxhrA==
X-Google-Smtp-Source: ABdhPJxiswkGl2pVIvWWZ6aSVUFazaiZRuYEfrTL3uF2sZNR2Ly4HeMeR//UR5dITrLxDj1E3LTcAsgeWYlO0yGvWG4=
X-Received: by 2002:a05:6a00:1a51:b0:4a0:3c1:4f45 with SMTP id
	h17-20020a056a001a5100b004a003c14f45mr4740999pfv.86.1636483741722;
	Tue, 09 Nov 2021 10:49:01 -0800 (PST)
MIME-Version: 1.0
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<YYoi2JiwTtmxONvB@infradead.org>
In-Reply-To: <YYoi2JiwTtmxONvB@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Nov 2021 10:48:51 -0800
Message-ID: <CAPcyv4hQrUEhDOK-Ys1_=Sxb8f+GJZvpKZHTUPKQvVMaMe8XMg@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
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
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 8, 2021 at 11:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
> >  static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
> >               void *addr, size_t bytes, struct iov_iter *i, int mode)
> >  {
> > +     phys_addr_t pmem_off;
> > +     size_t len, lead_off;
> > +     struct pmem_device *pmem = dax_get_private(dax_dev);
> > +     struct device *dev = pmem->bb.dev;
> > +
> > +     if (unlikely(mode == DAX_OP_RECOVERY)) {
> > +             lead_off = (unsigned long)addr & ~PAGE_MASK;
> > +             len = PFN_PHYS(PFN_UP(lead_off + bytes));
> > +             if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> > +                     if (lead_off || !(PAGE_ALIGNED(bytes))) {
> > +                             dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
> > +                                     addr, bytes);
> > +                             return (size_t) -EIO;
> > +                     }
> > +                     pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> > +                     if (pmem_clear_poison(pmem, pmem_off, bytes) !=
> > +                                             BLK_STS_OK)
> > +                             return (size_t) -EIO;
> > +             }
> > +     }
>
> This is in the wrong spot.  As seen in my WIP series individual drivers
> really should not hook into copying to and from the iter, because it
> really is just one way to write to a nvdimm.  How would dm-writecache
> clear the errors with this scheme?
>
> So IMHO going back to the separate recovery method as in your previous
> patch really is the way to go.  If/when the 64-bit store happens we
> need to figure out a good way to clear the bad block list for that.

I think we just make error management a first class citizen of a
dax-device and stop abstracting it behind a driver callback. That way
the driver that registers the dax-device can optionally register error
management as well. Then fsdax path can do:

        rc = dax_direct_access(..., &kaddr, ...);
        if (unlikely(rc)) {
                kaddr = dax_mk_recovery(kaddr);
                dax_direct_access(..., &kaddr, ...);
                return dax_recovery_{read,write}(..., kaddr, ...);
        }
        return copy_{mc_to_iter,from_iter_flushcache}(...);

Where, the recovery version of dax_direct_access() has the opportunity
to change the page permissions / use an alias mapping for the access,
dax_recovery_read() allows reading the good cachelines out of a
poisoned page, and dax_recovery_write() coordinates error list
management and returning a poison page to full write-back caching
operation when no more poisoned cacheline are detected in the page.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

