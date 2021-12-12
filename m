Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BD1C433FE
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 14:22:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-2DPqSN6GN_64gZ28TCOagA-1; Sun, 12 Dec 2021 09:22:54 -0500
X-MC-Unique: 2DPqSN6GN_64gZ28TCOagA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E2EF2FD1B;
	Sun, 12 Dec 2021 14:22:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD50A1972E;
	Sun, 12 Dec 2021 14:22:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7839D1809CB8;
	Sun, 12 Dec 2021 14:22:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCEMa3k029649 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 09:22:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 331962026D2F; Sun, 12 Dec 2021 14:22:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E6E22026D46
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:22:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C19B85A5AA
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:22:33 +0000 (UTC)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
	[209.85.215.174]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-209-z5PpmB3NPqOUjgXFJtJ8qA-1; Sun, 12 Dec 2021 09:22:31 -0500
X-MC-Unique: z5PpmB3NPqOUjgXFJtJ8qA-1
Received: by mail-pg1-f174.google.com with SMTP id j11so12283193pgs.2
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 06:22:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=DZjYIL5Meh9WPTLeEH+cczxaNrQ4dGhT95FlbuKwOdM=;
	b=UUcFVxTMGqprTjjqQ+Ddm1Fh1QsuPDo6Z6oKncn+242ZCMB1vxqSuGOUXXNeUel+KN
	Vh3vfNg7acaFaErW0mGY99T1FjDMhG1iv7N94rfGXUcgK2DhImPr7rPQ0aqSczUrjvVx
	ngPnBJkBfaCmUye3xZJzQnaSREsajtxKa3A/cDs88QaL/MKWF3uBV5TaC41DYPMwxmRy
	O2n3Xi0S2VpWvp936ltfPbhu9wm4yqTOUcN03ZSmuI1qaYQGestLPmUm8UqKQhTGPaIF
	HfY3xbfl3LtDm7VfhMAiozc9KIJibRFbVQXk0m5x2kgb9qz4Nsmr+wGH/gViR2yJW36s
	8fQQ==
X-Gm-Message-State: AOAM533HhepWtmKg2HcVPLgGd7Aqp59UGuzm6cGwB4bGquNl0S8md3v2
	5SH3fjlmIs6TM4qCFaFI0UczzbuZYR5tk7hxwl1OSg==
X-Google-Smtp-Source: ABdhPJyxbhOi5AL5eM6jiu7484TwbdU5pKz4nFxYJvBebbsi3mSjMdfP5DTSAeCbzo51p2wcGaag8JGjamOTAXCXkd0=
X-Received: by 2002:a62:7ec4:0:b0:4a3:219b:7008 with SMTP id
	z187-20020a627ec4000000b004a3219b7008mr28747585pfc.3.1639318950463;
	Sun, 12 Dec 2021 06:22:30 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-2-hch@lst.de>
In-Reply-To: <20211209063828.18944-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:22:20 -0800
Message-ID: <CAPcyv4gwfVi389e+cES=E6O13+y36OffZPCe+iZguCT_gpjmZA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] uio: remove copy_from_iter_flushcache()
	and copy_mc_to_iter()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> These two wrappers are never used.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvdimm/pmem.c |  4 ++--
>  include/linux/uio.h   | 20 +-------------------
>  2 files changed, 3 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 4190c8c46ca88..8294f1c701baa 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -302,8 +302,8 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>  }
>
>  /*
> - * Use the 'no check' versions of copy_from_iter_flushcache() and
> - * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
> + * Use the 'no check' versions of _copy_from_iter_flushcache() and
> + * _copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
>   * checking, both file offset and device offset, is handled by
>   * dax_iomap_actor()
>   */

This comment change does not make sense since it is saying why pmem is
using the "_" versions. However, I assume this whole comment goes away
in a later patch.

> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 6350354f97e90..494d552c1d663 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -196,7 +196,7 @@ bool copy_from_iter_full_nocache(void *addr, size_t bytes, struct iov_iter *i)
>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>  /*
>   * Note, users like pmem that depend on the stricter semantics of
> - * copy_from_iter_flushcache() than copy_from_iter_nocache() must check for
> + * _copy_from_iter_flushcache() than _copy_from_iter_nocache() must check for
>   * IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) before assuming that the
>   * destination is flushed from the cache on return.
>   */

Same here.

> @@ -211,24 +211,6 @@ size_t _copy_mc_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
>  #define _copy_mc_to_iter _copy_to_iter
>  #endif
>
> -static __always_inline __must_check
> -size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
> -{
> -       if (unlikely(!check_copy_size(addr, bytes, false)))
> -               return 0;
> -       else
> -               return _copy_from_iter_flushcache(addr, bytes, i);
> -}
> -
> -static __always_inline __must_check
> -size_t copy_mc_to_iter(void *addr, size_t bytes, struct iov_iter *i)
> -{
> -       if (unlikely(!check_copy_size(addr, bytes, true)))
> -               return 0;
> -       else
> -               return _copy_mc_to_iter(addr, bytes, i);
> -}
> -
>  size_t iov_iter_zero(size_t bytes, struct iov_iter *);
>  unsigned long iov_iter_alignment(const struct iov_iter *i);
>  unsigned long iov_iter_gap_alignment(const struct iov_iter *i);
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

