Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947C9C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:20:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2200E60F5E
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:20:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2200E60F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-wsCS6PYHNeq8ZnVYTEb3Ww-1; Fri, 20 Aug 2021 16:20:35 -0400
X-MC-Unique: wsCS6PYHNeq8ZnVYTEb3Ww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34275801AC5;
	Fri, 20 Aug 2021 20:20:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB5F369A;
	Fri, 20 Aug 2021 20:20:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F9634A7C8;
	Fri, 20 Aug 2021 20:20:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KKJTrh019246 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 16:19:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EEB8C20A3D50; Fri, 20 Aug 2021 20:19:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E663D20A3D53
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 20:19:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD102805A30
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 20:19:24 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
	[209.85.214.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-x75z2cbmNViwun1L2fBJRg-1; Fri, 20 Aug 2021 16:19:22 -0400
X-MC-Unique: x75z2cbmNViwun1L2fBJRg-1
Received: by mail-pl1-f180.google.com with SMTP id c4so6586802plh.7
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 13:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=BkGBH+Sk2bQQ3B5sfYf3Y77q6TOaLfRpAcPAwL8BdAo=;
	b=HEUgP8q7P9MPIBpa4542ylxODafzSO+6orr/8K19iRJ2mllIstcl4YnUYkh9fvOZVN
	BDvcCQWWCsBVOXnEjBmzLs6T5SNuyRgasckQuKEurWr+0mHC3fEh5xe8RFnaJa19T6XY
	V2YXTlIjXGRF4nwUUwNv5jFTRsxEHXpqPDUMdtS2G0Y9zoYXijmN13iTecWV/Z8MiyXp
	3FhHl559DtD1/gt/o37iBM/kkRE31WKFyVRz7DHjLViowoXd60Ziaf2mnVVSKM3PgfHi
	RPymTeETRlOsgerHWcxQYZ2WchpUZxUDbSO1ag8RZWVpTcnfOU8jwgFw9NaOhpgWhk4K
	42Ww==
X-Gm-Message-State: AOAM533O3ypsMqqOFV4QadVuVQioWJPIdwanlXcEkWUM2nsu2a99Js0o
	wHPNE+UOKKwIm3p0EVkifP8DSAlrXg8uhfT76ZEpxQ==
X-Google-Smtp-Source: ABdhPJzHkxMGpPeA9h8LIot15bFD38zvkcY7p2LLxN6VLnB4hejIZ98f8Ub0InyuHc2GQ/N4yQ3nMHLlOt8cA/d6bXM=
X-Received: by 2002:a17:902:c10a:b0:12d:97e1:f035 with SMTP id
	10-20020a170902c10a00b0012d97e1f035mr17854315pli.52.1629490761440;
	Fri, 20 Aug 2021 13:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 13:19:10 -0700
Message-ID: <CAPcyv4gd6O=Aaghn3bnAchc3o06J01SwPCg0KHPQLTTguoxdLw@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 2/9] dax: Introduce holder for
	dax_device
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

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
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
>  drivers/dax/super.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h | 17 +++++++++++++++++
>  2 files changed, 63 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 5fa6ae9dbc8b..00c32dfa5665 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -214,6 +214,8 @@ enum dax_device_flags {
>   * @cdev: optional character interface for "device dax"
>   * @host: optional name for lookups where the device path is not available
>   * @private: dax driver private data
> + * @holder_rwsem: prevent unregistration while holder_ops is in progress
> + * @holder_data: holder of a dax_device: could be filesystem or mapped device
>   * @flags: state and boolean properties
>   */
>  struct dax_device {
> @@ -222,8 +224,11 @@ struct dax_device {
>         struct cdev cdev;
>         const char *host;
>         void *private;
> +       struct rw_semaphore holder_rwsem;
> +       void *holder_data;
>         unsigned long flags;
>         const struct dax_operations *ops;
> +       const struct dax_holder_operations *holder_ops;
>  };
>
>  static ssize_t write_cache_show(struct device *dev,
> @@ -373,6 +378,25 @@ int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  }
>  EXPORT_SYMBOL_GPL(dax_zero_page_range);
>
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +                             size_t size, void *data)
I took a look at patch3 and had some questions about the api.

Can you add kernel-doc for this api and specifically clarify what is
@data used for vs dax_dev->holder_data?

I also think the holder needs to know whether this failure is being
signaled synchronously. or asynchronously. In the synchronous case a
process has consumed poison and action needs to be taken immediately.
In the asynchronous case the driver stack has encountered failed
address ranges and is notifying the holder to avoid those ranges, but
no immediate action needs to be taken to shoot down mappings. For
example, I would use the synchronous notification when
memory_failure() is invoked with the "action required" indication, and
the asynchronous notification when an NVDIMM_REVALIDATE_POISON event
fires, or the "action optional" memory_failure() case.

In short I think the interface just needs a flags argument.


> +{
> +       int rc;
> +
> +       if (!dax_dev)
> +               return -ENXIO;
> +
> +       if (!dax_dev->holder_data)
> +               return -EOPNOTSUPP;
> +
> +       down_read(&dax_dev->holder_rwsem);
> +       rc = dax_dev->holder_ops->notify_failure(dax_dev, offset,
> +                                                        size, data);
> +       up_read(&dax_dev->holder_rwsem);
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(dax_holder_notify_failure);
> +
>  #ifdef CONFIG_ARCH_HAS_PMEM_API
>  void arch_wb_cache_pmem(void *addr, size_t size);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
> @@ -603,6 +627,7 @@ struct dax_device *alloc_dax(void *private, const char *__host,
>         dax_add_host(dax_dev, host);
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> +       init_rwsem(&dax_dev->holder_rwsem);
>         if (flags & DAXDEV_F_SYNC)
>                 set_dax_synchronous(dax_dev);
>
> @@ -624,6 +649,27 @@ void put_dax(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(put_dax);
>
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +       if (!dax_dev)
> +               return;
> +       down_write(&dax_dev->holder_rwsem);
> +       dax_dev->holder_data = holder;
> +       dax_dev->holder_ops = ops;
> +       up_write(&dax_dev->holder_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(dax_set_holder);
> +
> +void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       if (!dax_dev)
> +               return NULL;
> +
> +       return dax_dev->holder_data;
> +}
> +EXPORT_SYMBOL_GPL(dax_get_holder);
> +
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @host: alternate name for the device registered by a dax driver
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index b52f084aa643..6f4b5c97ceb0 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,10 +38,17 @@ struct dax_operations {
>         int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>
> +struct dax_holder_operations {
> +       int (*notify_failure)(struct dax_device *, loff_t, size_t, void *);
> +};
> +
>  extern struct attribute_group dax_attribute_group;
>
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *dax_get_by_host(const char *host);
> +void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops);
> +void *dax_get_holder(struct dax_device *dax_dev);
>  struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags);
>  void put_dax(struct dax_device *dax_dev);
> @@ -77,6 +84,14 @@ static inline struct dax_device *dax_get_by_host(const char *host)
>  {
>         return NULL;
>  }
> +static inline void dax_set_holder(struct dax_device *dax_dev, void *holder,
> +               const struct dax_holder_operations *ops)
> +{
> +}
> +static inline void *dax_get_holder(struct dax_device *dax_dev)
> +{
> +       return NULL;
> +}
>  static inline struct dax_device *alloc_dax(void *private, const char *host,
>                 const struct dax_operations *ops, unsigned long flags)
>  {
> @@ -226,6 +241,8 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>                 size_t bytes, struct iov_iter *i);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>                         size_t nr_pages);
> +int dax_holder_notify_failure(struct dax_device *dax_dev, loff_t offset,
> +               size_t size, void *data);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
>
>  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> --
> 2.32.0
>
>
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

