Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388BAC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:51:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C92D561131
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C92D561131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-a9-Bm0kUONCx_taSzrQayg-1; Fri, 20 Aug 2021 16:51:51 -0400
X-MC-Unique: a9-Bm0kUONCx_taSzrQayg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C4DD801AC0;
	Fri, 20 Aug 2021 20:51:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AF6A5D6B1;
	Fri, 20 Aug 2021 20:51:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F58B181A0F7;
	Fri, 20 Aug 2021 20:51:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KKpgXT022038 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 16:51:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 61A97117DB34; Fri, 20 Aug 2021 20:51:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D86E117DB31
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 20:51:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C128918A6580
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 20:51:38 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
	[209.85.216.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-517-3w-dBSZMMWiIif3Vfxg60g-1; Fri, 20 Aug 2021 16:51:34 -0400
X-MC-Unique: 3w-dBSZMMWiIif3Vfxg60g-1
Received: by mail-pj1-f51.google.com with SMTP id
	m24-20020a17090a7f98b0290178b1a81700so8110011pjl.4
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 13:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ULkGRivL56ptdhLg0qblOi29E6UuI3GKppQ73W5RcQM=;
	b=CjD836VpbmEy4g0Bh2BHHGoZlwlomXyxHtlmPfDNRGkhT9g5e9DwFAEiHnPkSzwkr6
	hzBlLN6ALJSZHfYD+y5UUPDkR3eTHwGmuogjD/AtdsjmHoPVkW/A/kAccnDl/oHTda3K
	FnbiK+DKIlMg9jgd2ODflkxry4EWXvtcKqX+5dPdG/8nINgtkKkPmzL90x73F2z/DD8W
	ptCUAjJ8GLsr5107TgagpMCkt2APn+k6zvnTmnfG3BLtBRZ3aQgm5TyoW5pIE3XrFvcm
	Rhu86Qxy6lISbXPowOBHlOJPBPdrTigE537wPGaknNc+6e7i3GUdW1S8VVnsMREcVBwL
	+/NQ==
X-Gm-Message-State: AOAM5320peaBDJfxOQ9GJahZ5nnhEvcX54sOrSWTU0oiDkBb9hRlRvH8
	s1QvE33DFbnDjgvaUsIpdlXQ452x0RM2HxmyHT7eCQ==
X-Google-Smtp-Source: ABdhPJzPJ2XQpEtJq+wbuCgzapFmXjO/y38fzH3RNB8Wj2SGZHiAnemQziTjbPerD3pCdyF6tyAETSGC8SlS9MQj/UI=
X-Received: by 2002:a17:902:e54e:b0:12d:cca1:2c1f with SMTP id
	n14-20020a170902e54e00b0012dcca12c1fmr17574055plf.79.1629492693543;
	Fri, 20 Aug 2021 13:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-5-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-5-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 13:51:22 -0700
Message-ID: <CAPcyv4hQgSV6n0nuiqm-cv7pvpwDgBgZMezW7TkdR9SaAiCNHg@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 4/9] pmem,
	mm: Implement ->memory_failure in pmem driver
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

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> With dax_holder notify support, we are able to notify the memory failure
> from pmem driver to upper layers.  If there is something not support in
> the notify routine, memory_failure will fall back to the generic hanlder.

How about:

"Any layer can return -EOPNOTSUPP to force memory_failure() to fall
back to its generic implementation."


>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/nvdimm/pmem.c | 13 +++++++++++++
>  mm/memory-failure.c   | 14 ++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 1e0615b8565e..fea4ffc333b8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -362,9 +362,22 @@ static void pmem_release_disk(void *__pmem)
>         del_gendisk(pmem->disk);
>  }
>
> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +               unsigned long pfn, unsigned long nr_pfns, int flags)
> +{
> +       struct pmem_device *pmem =
> +                       container_of(pgmap, struct pmem_device, pgmap);
> +       loff_t offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
> +
> +       return dax_holder_notify_failure(pmem->dax_dev, offset,
> +                                        page_size(pfn_to_page(pfn)) * nr_pfns,

I do not understand the usage of page_size() here? memory_failure()
assumes PAGE_SIZE pages. DAX pages also do not populate the compound
metadata yet, but even if they did I would expect memory_failure() to
be responsible for doing something like:

    pgmap->ops->memory_failure(pgmap, pfn, size >> PAGE_SHIFT, flags);

...where @size is calculated from dev_pagemap_mapping_shift().

> +                                        &flags);

Why is the local flags variable passed by reference? At a minimum the
memory_failure() flags should be translated to a new set dax-notify
flags, because memory_failure() will not be the only user of this
notification interface. See NVDIMM_REVALIDATE_POISON, and the
discussion Dave and I had about using this notification to signal
unsafe hot-removal of a memory device.


> +}
> +
>  static const struct dev_pagemap_ops fsdax_pagemap_ops = {
>         .kill                   = pmem_pagemap_kill,
>         .cleanup                = pmem_pagemap_cleanup,
> +       .memory_failure         = pmem_pagemap_memory_failure,
>  };
>
>  static int pmem_attach_disk(struct device *dev,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3bdfcb45f66e..ab3eda335acd 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1600,6 +1600,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>          */
>         SetPageHWPoison(page);
>
> +       /*
> +        * Call driver's implementation to handle the memory failure, otherwise
> +        * fall back to generic handler.
> +        */
> +       if (pgmap->ops->memory_failure) {
> +               rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
> +               /*
> +                * Fall back to generic handler too if operation is not
> +                * supported inside the driver/device/filesystem.
> +                */
> +               if (rc != EOPNOTSUPP)
> +                       goto out;
> +       }
> +
>         mf_generic_kill_procs(pfn, flags);
>  out:
>         /* drop pgmap ref acquired in caller */
> --
> 2.32.0
>
>
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

