Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD7EC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 06:05:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-9QJm9KwgOoakW0XOxUb3fQ-1; Fri, 04 Feb 2022 01:05:48 -0500
X-MC-Unique: 9QJm9KwgOoakW0XOxUb3fQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EF161091DA1;
	Fri,  4 Feb 2022 06:05:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDD085DB96;
	Fri,  4 Feb 2022 06:05:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60D221809CB9;
	Fri,  4 Feb 2022 06:05:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21463pl3026618 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 01:03:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 44B1F40F9D78; Fri,  4 Feb 2022 06:03:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40CB940F9D6D
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:03:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2751585A5BC
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:03:51 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
	[209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-141-jQMUe3hcMEOhst8jDVg4sQ-1; Fri, 04 Feb 2022 01:03:49 -0500
X-MC-Unique: jQMUe3hcMEOhst8jDVg4sQ-1
Received: by mail-pf1-f181.google.com with SMTP id c194so4204822pfb.12
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 22:03:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=6l4Se70qE+syqGJMrB/AsP3g/MR2GzyK9H999D6OCfQ=;
	b=arSBegJD0ctOyizBBI/dlOEg70pH1Kyqq6e/iWJSIsbt736Ue/qQWi8onVoknwLx4S
	iS3kPjRkl0o+FbAS2wIULY21BbUt1DRR5xviT9ufhfdqqpgFSJW/7QBMtwnJvpOoiW8u
	vOe5cc4sVT4ZPOIXihrgNYs3H+n1MQXy9NKV5QiPCAT+lJo/0NG3JW3u3fm01resYNMD
	QdrR3iZE1NoymmV7CDMTlCoqIz4ayelt1J+cvXfwAA8d2SOxIBzpgAZC1Tss9uprTXVM
	qfUNWA+dOO5ujD3Q/WbqIkIQErHLzPaHfdOrkmDvHP6s7CbSWnGZnk8/XSj6Jn3BOL8A
	fAUw==
X-Gm-Message-State: AOAM530UFm3hgUc34toTSAJcwyL6SQU9xXZX0ez4d03d+035jB3BMxmA
	0i03pO0oXAOhryViPUFfeMW61xgyXtMZx/1pfR35cQ==
X-Google-Smtp-Source: ABdhPJzjeIgvLiv+7Q+Z36tObcCbqLcIUwq8r4zgIpIDVk4uTWYWTdh9zto49CaVa1EjbgHgLmkXgdhhNjk2Px33Rsw=
X-Received: by 2002:a63:550f:: with SMTP id j15mr1228156pgb.40.1643954628595; 
	Thu, 03 Feb 2022 22:03:48 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-5-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-5-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 22:03:36 -0800
Message-ID: <CAPcyv4hFyoHgX9mo=NwOj_FPnfD8zkg_svM1sJZLn41vBm4Z8w@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH v5 4/7] dax: add dax_recovery_write to dax_op
 and dm target type
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> dax_recovery_write() dax op is only required for DAX device that
> export DAXDEV_RECOVERY indicating its capability to recover from
> poisons.
>
> DM may be nested, if part of the base dax devices forming a DM
> device support dax recovery, the DM device is marked with such
> capability.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
[..]
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 2fc776653c6e..1b3d6ebf3e49 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -30,6 +30,9 @@ struct dax_operations {
>                         sector_t, sector_t);
>         /* zero_page_range: required operation. Zero page range   */
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
> +       /* recovery_write: optional operation. */
> +       size_t (*recovery_write)(struct dax_device *, pgoff_t, void *, size_t,
> +                               struct iov_iter *);

The removal of the ->copy_{to,from}_iter() operations set the
precedent that dax ops should not be needed when the operation can be
carried out generically. The only need to call back to the pmem driver
is so that it can call nvdimm_clear_poison(). nvdimm_clear_poison() in
turn only needs the 'struct device' hosting the pmem and the physical
address to be cleared. The physical address is already returned by
dax_direct_access(). The device is something that could be added to
dax_device, and the pgmap could host the callback that pmem fills in.
Something like:


diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 58eda16f5c53..36486ba4753a 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -694,6 +694,7 @@ static int __nvdimm_setup_pfn(struct nd_pfn
*nd_pfn, struct dev_pagemap *pgmap)
                .end = nsio->res.end - end_trunc,
        };
        pgmap->nr_range = 1;
+       pgmap->owner = &nd_pfn->dev;
        if (nd_pfn->mode == PFN_MODE_RAM) {
                if (offset < reserve)
                        return -EINVAL;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 58d95242a836..95e1b6326f88 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -481,6 +481,7 @@ static int pmem_attach_disk(struct device *dev,
        }
        set_dax_nocache(dax_dev);
        set_dax_nomc(dax_dev);
+       set_dax_pgmap(dax_dev, &pmem->pgmap);
        if (is_nvdimm_sync(nd_region))
                set_dax_synchronous(dax_dev);
        rc = dax_add_host(dax_dev, disk);
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 1fafcc38acba..8cb59b5df38b 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -81,6 +81,11 @@ struct dev_pagemap_ops {

 #define PGMAP_ALTMAP_VALID     (1 << 0)

+struct dev_pagemap_operations {
+       size_t (*recovery_write)(struct dev_pagemap *pgmap, void *, size_t,
+                                struct iov_iter *);
+};
+
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
@@ -111,12 +116,15 @@ struct dev_pagemap {
        const struct dev_pagemap_ops *ops;
        void *owner;
        int nr_range;
+       struct dev_pagemap_operations ops;
        union {
                struct range range;
                struct range ranges[0];
        };
 };

...then DM does not need to be involved in the recovery path, fs/dax.c
just does dax_direct_access(..., DAX_RECOVERY, ...) and then looks up
the pgmap to generically coordinate the recovery_write(). The pmem
driver would be responsible for setting pgmap->recovery_write() to a
function that calls nvdimm_clear_poison().

This arch works for anything that can be described by a pgmap, and
supports error clearing, it need not be limited to the pmem block
driver.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

