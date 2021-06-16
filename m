Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EB8C48BDF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:47:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5241A61153
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 00:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5241A61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-EDly54RaMcumFbtw65sPiA-1; Tue, 15 Jun 2021 20:46:59 -0400
X-MC-Unique: EDly54RaMcumFbtw65sPiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE8CD801106;
	Wed, 16 Jun 2021 00:46:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69345D6AD;
	Wed, 16 Jun 2021 00:46:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE5094ED7B;
	Wed, 16 Jun 2021 00:46:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15G0ka5f000377 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 20:46:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4D26B2097D67; Wed, 16 Jun 2021 00:46:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4886B20962F8
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0571E811E9C
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 00:46:34 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
	[209.85.214.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-220-UV-A2JKQOBCBD49MxNOAig-1; Tue, 15 Jun 2021 20:46:31 -0400
X-MC-Unique: UV-A2JKQOBCBD49MxNOAig-1
Received: by mail-pl1-f181.google.com with SMTP id v13so226982ple.9
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=1UGOQAS/gnlRXyh5KGqeT8Vh25LI5tpduRj0+a7sMPk=;
	b=NX8tnivLYV7TTLRnLfVKRRoHSGzuCy8p0b7pDYWypljF8ELtNyC3IUVK8Rv90AOrSS
	X5wTiTXItqKR1dc9GwbBGDBzvldSNFlVGWqWLOd3bcGKQF6p0VLEXhCx1mfDETqAI6ew
	/JYp/lAVRwtrZ0uwipQTchAnlng7undY/77/asNYpumzqDc5YxnEdFlQoJWFwwYgaEow
	704XNQ+h5VFpJ/ZZV+Bq+fPVnvtayO5vfy2jWWUJunNLZ5HznXMzHUW1zNMg20VjW61y
	HjPh1LaJAwiNyUbEmlLdIY4++9FkpuuXB1kopNdZNCNAkft/q33kyLvZWgQQnuf3mq4b
	EmJQ==
X-Gm-Message-State: AOAM531SaG5Z/zKVT2iCOwWPNxG0WzmR+1xek3CTk6g2buWaiyrTzvsp
	4orvyhaxCp29hh/nDoKBHNxWnN2jMztlHAERLYjE4A==
X-Google-Smtp-Source: ABdhPJxnjJTq18+nazpJrwCbf8hmuZEuQ5kMFby00dnTlWpwUJ3rx4rFxrMADpX4C943d5rXD+aKPVKy1eqHRare17k=
X-Received: by 2002:a17:90a:ea8c:: with SMTP id
	h12mr7535174pjz.149.1623804390579; 
	Tue, 15 Jun 2021 17:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com>
	<20210604011844.1756145-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 17:46:19 -0700
Message-ID: <CAPcyv4jA8FW6PMxaETETQxjnpn9aE2Nevq-R96BJr8QzixYRsQ@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 02/10] dax: Introduce holder for dax_device
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

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> To easily track filesystem from a pmem device, we introduce a holder for
> dax_device structure, and also its operation.  This holder is used to
> remember who is using this dax_device:
>  - When it is the backend of a filesystem, the holder will be the
>    superblock of this filesystem.
>  - When this pmem device is one of the targets in a mapped device, the
>    holder will be this mapped device.  In this case, the mapped device
>    has its own dax_device and it will follow the first rule.  So that we
>    can finally track to the filesystem we needed.
>
> The holder and holder_ops will be set when filesystem is being mounted,
> or an target device is being activated.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 10 ++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 5fa6ae9dbc8b..d118e2a7dc70 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -222,8 +222,10 @@ struct dax_device {
>         struct cdev cdev;
>         const char *host;
>         void *private;

@private is likely too generic of a name now, it would be better to
call this @parent.

> +       void *holder;

This should probably be called holder_data, and this structure could
use some kernel-doc to clarify what the fields mean.

>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static ssize_t write_cache_show(struct device *dev,
> @@ -373,6 +375,24 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_corrupted_range(struct dax_device *dax_dev, struct block_device *bdev,
> +               loff_t offset, size_t size, void *data)

Why is @bdev an argument to this routine?  The primary motivation for
a 'struct dax_device' is to break the association with 'struct
block_device'. The filesystem may know that the logical addresses
associated with a given dax_dev alias with the logical addresses of a
given bdev, but that knowledge need not leak into the API.

> +{
> +       int rc = -ENXIO;
> +       if (!dax_dev)
> +               return rc;
> +
> +       if (dax_dev->holder) {
> +               rc = dax_dev->holder_ops->corrupted_range(dax_dev, bdev, offset,
> +                                                         size, data);

A bikeshed comment, but I do not like the name corrupted_range(),
because "corrupted" implies a permanent state. The source of this
notification is memory_failure() and that does not convey "permanent"
vs "transient" it just reports "failure". So, to keep the naming
consistent with the pgmap notification callback lets call this one
"notify_failure".

> +               if (rc == -ENODEV)
> +                       rc = -ENXIO;
> +       } else
> +               rc = -EOPNOTSUPP;
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_corrupted_range);

dax_holder_notify_failure() makes it clearer that this is
communicating a failure up the holder stack.

> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -624,6 +644,24 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_dev)
> +               return;
> +       dax_dev->holder = holder;
> +       dax_dev->holder_ops = ops;

I think there needs to be some synchronization here, perhaps a global
dax_dev_rwsem that is taken for read in the notification path and
write when adding a holder to the chain.

I also wonder if this should be an event that triggers a dax_dev stack
to re-report any failure notifications. For example the pmem driver
may have recorded a list of bad blocks at the beginning of time.
Likely the filesystem or other holder would like to get that
pre-existing list of failures at first registration. Have you given
thought about how the filesystem is told about pre-existing badblocks?

> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_dev)
> +               return NULL;
> +       return dax_dev->holder;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);

Where is this used?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

