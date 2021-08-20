Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CF1C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:06:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F11FE61214
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:06:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F11FE61214
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-WYhH2wM1N7CqwiEUglvmvw-1; Fri, 20 Aug 2021 12:06:52 -0400
X-MC-Unique: WYhH2wM1N7CqwiEUglvmvw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335E2801AEB;
	Fri, 20 Aug 2021 16:06:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B57AD1A26A;
	Fri, 20 Aug 2021 16:06:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B96A181A1CE;
	Fri, 20 Aug 2021 16:06:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KG6iuL032306 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 12:06:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 847A510547D2; Fri, 20 Aug 2021 16:06:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FEB710545CA
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:06:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41693805A30
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:06:37 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
	[209.85.210.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-202-HSWsaGS-M0uNKRMBGaSD4g-1; Fri, 20 Aug 2021 12:06:35 -0400
X-MC-Unique: HSWsaGS-M0uNKRMBGaSD4g-1
Received: by mail-pf1-f176.google.com with SMTP id t13so8991643pfl.6
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 09:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=SE1PBWc7mAk6yXDwwX3HHPm6R0g9oeMCDvjQB1FSRU4=;
	b=jgWKAD+C8B93aYPszihy9xrQ8wbzq7B4cNTUr5OtTN8GQbOj1a1gscwreIRP4L2zWL
	1/LEJ+sgwIwqLY5CSj0nVqRCrL89UsyeRtfPfwL4ImgxF9EUt1caoRw3bib5G+xPOtcn
	K3ulR8ccwBEi4/u7X8/qTb067PQlJ/DQycTzTf8lW1pnOWid6BU2aEvbCI2fjciLl5MU
	idqhZA/VHQfI7ff+vwyMLH9Rdc53nBVYHhErwYDjAsW71H3DP1ax9dmLrmaisr0Kr3Um
	ab/GIKqZVERqb8hgfyRQXmW4fAhJHkQCpGYetEiy5fA3SoSxReaqAx1s0e0q8w/ittS1
	FfhQ==
X-Gm-Message-State: AOAM532ugca15W5xR76CrQ/K9sLrljTnmpVpZlcGtTakbg8m6KSKyb5g
	QfxVVX+hcGZNtgboU6tnsS+2YQveaZBTB9b6LA+tSA==
X-Google-Smtp-Source: ABdhPJzZwGSABeBQxV85uUQDyE877kBWKar9nuSTal+efpWConcEcwK48D/jgozGf+NtNUk6MXi23elgGDtpJtSZv9s=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
	l6-20020a056a0016c6b029032de1909dd0mr20235683pfc.70.1629475593581;
	Fri, 20 Aug 2021 09:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-3-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:06:22 -0700
Message-ID: <CAPcyv4gVpK2US=-FhZYccKN-9sVa9WC4k5TD+WNH0bBkjwhE2w@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Given the rarity of notification failures and the infrequency of
registration events I think it would be ok for this to be a global
lock rather than per-device. In fact there is already a global dax
lock, see dax_read_lock(). Let's convert that from srcu to rwsem and
add a dax_write_lock().

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
> +{
> +       int rc;
> +
> +       if (!dax_dev)
> +               return -ENXIO;

There also needs to be a dax_dev->alive check, which is only valid to
be checked under dax_read_lock().

Who would ever pass NULL to this function?

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

Same questions about NULL dax dev and ->alive checking.

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

Where is this API used? This result is not valid unless the caller is
holding the read lock.

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

