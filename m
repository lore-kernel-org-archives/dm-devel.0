Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14AAC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:50:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E2436108C
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E2436108C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-3sjXgl0SOYCyunY9LshIgA-1; Sat, 06 Nov 2021 13:50:21 -0400
X-MC-Unique: 3sjXgl0SOYCyunY9LshIgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBF5E6A299;
	Sat,  6 Nov 2021 17:50:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 243D5ADFA;
	Sat,  6 Nov 2021 17:50:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EAC4B4E590;
	Sat,  6 Nov 2021 17:50:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6Ho72u009997 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 13:50:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3BCE340CFD15; Sat,  6 Nov 2021 17:50:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35FD440CFD13
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 17:50:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1828280A0B0
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 17:50:07 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
	[209.85.215.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-478-QmMGeAj4Mci8XKeHOUf4pw-1; Sat, 06 Nov 2021 12:48:51 -0400
X-MC-Unique: QmMGeAj4Mci8XKeHOUf4pw-1
Received: by mail-pg1-f171.google.com with SMTP id b4so11058891pgh.10
	for <dm-devel@redhat.com>; Sat, 06 Nov 2021 09:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=R7qTqnjZeJ3PhO4zL+B/3Z9KG2zg/h5ziZjbMP4gMkc=;
	b=Vvr1ZJzacljRauU+wgNPT/dtqp1qiRRG2QaLW1fz+2t+zKXF+nfIzj3fybbvqXhFGP
	zcTmGTR61WZYFG98VTFKAFD62Ne9V2vtbXyfm0w2c6yY92hhuaX+dXRvsM5zD5mL8mtA
	KHIRIqCIqniH0o4nNp1yhS27nmKhMV+JIx5N5PrZ7Dvvfw3VRdJ/XrEFz4uUt/4qCotW
	Hpebl+ojQ3Hfkw1WqU+A3qy4OQKVPwVFNVgPtxL7V0FcU2/wg9U9aQz1sqp8d5KXwV13
	trcbwOWXxsXOMObRJB69eQ+7VaRyGC4AsNkhxaiA0/9IiR9QbR8UjVa4ri5SsqqttVWD
	3OJg==
X-Gm-Message-State: AOAM532lPBiaTXFDx1fcnt4DDJ7I55mjDJIzj4/tK/yO/v9v4J5Pe47w
	ILUYVlX4ePQtdbJvSQNorrNk/8GosEQaNW/QIBD9NrBl4vUIgA==
X-Google-Smtp-Source: ABdhPJyVpGL/kpcfeEI/Nr3Xb6EdgK+j4sqLk0GA+BS/3MEn/0dlIKOmQEAYFjGMwnlaOHtt1UpglHaxqyrYLk6KLj8=
X-Received: by 2002:a63:6bc2:: with SMTP id
	g185mr50160127pgc.356.1636217330382; 
	Sat, 06 Nov 2021 09:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
In-Reply-To: <20211106011638.2613039-2-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 6 Nov 2021 09:48:40 -0700
Message-ID: <CAPcyv4jcgFxgoXFhWL9+BReY8vFtgjb_=Lfai-adFpdzc4-35Q@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
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

On Fri, Nov 5, 2021 at 6:17 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Introduce DAX_OP_NORMAL and DAX_OP_RECOVERY operation modes to
> {dax_direct_access, dax_copy_from_iter, dax_copy_to_iter}.
> DAX_OP_NORMAL is the default or the existing mode, and
> DAX_OP_RECOVERY is a new mode for data recovery purpose.
>
> When dax-FS suspects dax media error might be encountered
> on a read or write, it can enact the recovery mode read or write
> by setting DAX_OP_RECOVERY in the aforementioned APIs. A read
> in recovery mode attempts to fetch as much data as possible
> until the first poisoned page is encountered. A write in recovery
> mode attempts to clear poison(s) in a page-aligned range and
> then write the user provided data over.
>
> DAX_OP_NORMAL should be used for all non-recovery code path.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
[..]
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 324363b798ec..931586df2905 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -9,6 +9,10 @@
>  /* Flag for synchronous flush */
>  #define DAXDEV_F_SYNC (1UL << 0)
>
> +/* dax operation mode dynamically set by caller */
> +#define        DAX_OP_NORMAL           0

Perhaps this should be called DAX_OP_FAILFAST?

> +#define        DAX_OP_RECOVERY         1
> +
>  typedef unsigned long dax_entry_t;
>
>  struct dax_device;
> @@ -22,8 +26,8 @@ struct dax_operations {
>          * logical-page-offset into an absolute physical pfn. Return the
>          * number of pages available for DAX at that pfn.
>          */
> -       long (*direct_access)(struct dax_device *, pgoff_t, long,
> -                       void **, pfn_t *);
> +       long (*direct_access)(struct dax_device *, pgoff_t, long, int,

Would be nice if that 'int' was an enum, but I'm not sure a new
parameter is needed at all, see below...

> +                               void **, pfn_t *);
>         /*
>          * Validate whether this device is usable as an fsdax backing
>          * device.
> @@ -32,10 +36,10 @@ struct dax_operations {
>                         sector_t, sector_t);
>         /* copy_from_iter: required operation for fs-dax direct-i/o */
>         size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
> -                       struct iov_iter *);
> +                       struct iov_iter *, int);

I'm not sure the flag is needed here as the "void *" could carry a
flag in the pointer to indicate that is a recovery kaddr.

>         /* copy_to_iter: required operation for fs-dax direct-i/o */
>         size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
> -                       struct iov_iter *);
> +                       struct iov_iter *, int);

Same comment here.

>         /* zero_page_range: required operation. Zero page range   */
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
> @@ -186,11 +190,11 @@ static inline void dax_read_unlock(int id)
>  bool dax_alive(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
> -               void **kaddr, pfn_t *pfn);
> +               int mode, void **kaddr, pfn_t *pfn);

How about dax_direct_access() calling convention stays the same, but
the kaddr is optionally updated to carry a flag in the lower unused
bits. So:

void **kaddr = NULL; /* caller only cares about the pfn */

void *failfast = NULL;
void **kaddr = &failfast; /* caller wants -EIO not recovery */

void *recovery = (void *) DAX_OP_RECOVERY;
void **kaddr = &recovery; /* caller wants to carefully access page(s)
containing poison */

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

