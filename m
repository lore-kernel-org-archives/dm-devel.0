Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B474C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 08:08:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-HblO9sU-MZyRzpbwAWgoCA-1; Tue, 14 Dec 2021 03:08:34 -0500
X-MC-Unique: HblO9sU-MZyRzpbwAWgoCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE4DF101F7A1;
	Tue, 14 Dec 2021 08:08:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9206B418E;
	Tue, 14 Dec 2021 08:08:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54B504BB7C;
	Tue, 14 Dec 2021 08:08:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BD8euPv005626 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 03:40:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AF9B953B3; Mon, 13 Dec 2021 08:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA72953B2
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:40:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD0151C00047
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:40:53 +0000 (UTC)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
	[209.85.166.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-31-H8sbKHt8OmuRPcx9n3SyWA-1; Mon, 13 Dec 2021 03:40:50 -0500
X-MC-Unique: H8sbKHt8OmuRPcx9n3SyWA-1
Received: by mail-io1-f48.google.com with SMTP id p65so17666323iof.3;
	Mon, 13 Dec 2021 00:40:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0PVpqCwIIzT5LiWPmRy0UQXlV25IiTTKjnxtrdOpjdg=;
	b=6frKiV7kF+hwyNkYNYgFEZahLNYxLeldWeKuH/4NPa5WTO3Sv//+7DdmeMIIGLi+iK
	XZsROkmivvbrQaPoRMYsoXcxZmVA9HGNgI7yQ0m+pUx5NT9CUuCEkFdZPppRJ+KaJ+6M
	5v31ll+P4uiznrdLvFxyyFIQ4oRCaTHh28T7N+JTwWi1Rzie0fmw28PdAAkj3bx1invp
	MnccaQpmppiTTLDKIupnSLpmy7Vy5rTGY5oxDWBKFt3e63OKF4XwwMo/KdeaBLjTvbjy
	HraMHHS0UlRd4vn07Ocr7L+IoAbISsu1bqqFWHRPRh2nuTzsxSv4TiKlno6Y9m5X0Xiy
	6/aQ==
X-Gm-Message-State: AOAM5305q+JuI3giGxlgQg9I4I63nCHpP0vtp27Rg+DjBSUImACygqwn
	OQ71t64D6sVtE5PpElmo08ctxiefTIcJ4c8b06c=
X-Google-Smtp-Source: ABdhPJwxmNvCoakg1QaCbmWr8rWWu/4Lgvkfd58YwUsQ9hg8VdK9DfCOvLxOD3zbQQIhWbew1Ez4p6CvOYdkco5t1Hs=
X-Received: by 2002:a6b:7711:: with SMTP id n17mr31597632iom.21.1639384849051; 
	Mon, 13 Dec 2021 00:40:49 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-4-hch@lst.de>
In-Reply-To: <20211209063828.18944-4-hch@lst.de>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 13 Dec 2021 09:40:38 +0100
Message-ID: <CAM9Jb+gVh09scB7BVRHaZ9n+XdF8QyKwVSSg5eAno6WkDAwQTw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 14 Dec 2021 03:08:25 -0500
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Mike Snitzer <snitzer@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] dax: remove the DAXDEV_F_SYNC flag
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

> Remove the DAXDEV_F_SYNC flag and thus the flags argument to alloc_dax and
> just let the drivers call set_dax_synchronous directly.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/bus.c            | 3 ++-
>  drivers/dax/super.c          | 6 +-----
>  drivers/md/dm.c              | 2 +-
>  drivers/nvdimm/pmem.c        | 7 +++----
>  drivers/s390/block/dcssblk.c | 4 ++--
>  fs/fuse/virtio_fs.c          | 2 +-
>  include/linux/dax.h          | 8 ++------
>  7 files changed, 12 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 6683d42c32c56..da2a14d096d29 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1324,11 +1324,12 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>          * No dax_operations since there is no access to this device outside of
>          * mmap of the resulting character device.
>          */
> -       dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
> +       dax_dev = alloc_dax(dev_dax, NULL);
>         if (IS_ERR(dax_dev)) {
>                 rc = PTR_ERR(dax_dev);
>                 goto err_alloc_dax;
>         }
> +       set_dax_synchronous(dax_dev);
>
>         /* a device_dax instance is dead while the driver is not attached */
>         kill_dax(dax_dev);
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e18155f43a635..e81d5ee57390f 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -345,8 +345,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
>         return dax_dev;
>  }
>
> -struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
> -               unsigned long flags)
> +struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
>         struct dax_device *dax_dev;
>         dev_t devt;
> @@ -366,9 +365,6 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
>
>         dax_dev->ops = ops;
>         dax_dev->private = private;
> -       if (flags & DAXDEV_F_SYNC)
> -               set_dax_synchronous(dax_dev);
> -
>         return dax_dev;
>
>   err_dev:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4e997c02bb0a0..f4b972af10928 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1765,7 +1765,7 @@ static struct mapped_device *alloc_dev(int minor)
>         sprintf(md->disk->disk_name, "dm-%d", minor);
>
>         if (IS_ENABLED(CONFIG_FS_DAX)) {
> -               md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
> +               md->dax_dev = alloc_dax(md, &dm_dax_ops);
>                 if (IS_ERR(md->dax_dev)) {
>                         md->dax_dev = NULL;
>                         goto bad;
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 8294f1c701baa..85b3339286bd8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -402,7 +402,6 @@ static int pmem_attach_disk(struct device *dev,
>         struct gendisk *disk;
>         void *addr;
>         int rc;
> -       unsigned long flags = 0UL;
>
>         pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
>         if (!pmem)
> @@ -495,13 +494,13 @@ static int pmem_attach_disk(struct device *dev,
>         nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
>         disk->bb = &pmem->bb;
>
> -       if (is_nvdimm_sync(nd_region))
> -               flags = DAXDEV_F_SYNC;
> -       dax_dev = alloc_dax(pmem, &pmem_dax_ops, flags);
> +       dax_dev = alloc_dax(pmem, &pmem_dax_ops);
>         if (IS_ERR(dax_dev)) {
>                 rc = PTR_ERR(dax_dev);
>                 goto out;
>         }
> +       if (is_nvdimm_sync(nd_region))
> +               set_dax_synchronous(dax_dev);
>         rc = dax_add_host(dax_dev, disk);
>         if (rc)
>                 goto out_cleanup_dax;
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index e65e83764d1ce..10823debc09bd 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -686,13 +686,13 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
>         if (rc)
>                 goto put_dev;
>
> -       dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops,
> -                       DAXDEV_F_SYNC);
> +       dev_info->dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
>         if (IS_ERR(dev_info->dax_dev)) {
>                 rc = PTR_ERR(dev_info->dax_dev);
>                 dev_info->dax_dev = NULL;
>                 goto put_dev;
>         }
> +       set_dax_synchronous(dev_info->dax_dev);
>         rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
>         if (rc)
>                 goto out_dax;
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 242cc1c0d7ed7..5c03a0364a9bb 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -850,7 +850,7 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>         dev_dbg(&vdev->dev, "%s: window kaddr 0x%px phys_addr 0x%llx len 0x%llx\n",
>                 __func__, fs->window_kaddr, cache_reg.addr, cache_reg.len);
>
> -       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops, 0);
> +       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
>         if (IS_ERR(fs->dax_dev))
>                 return PTR_ERR(fs->dax_dev);
>
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 3bd1fdb5d5f4b..c04f46478e3b5 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -6,9 +6,6 @@
>  #include <linux/mm.h>
>  #include <linux/radix-tree.h>
>
> -/* Flag for synchronous flush */
> -#define DAXDEV_F_SYNC (1UL << 0)
> -
>  typedef unsigned long dax_entry_t;
>
>  struct dax_device;
> @@ -42,8 +39,7 @@ struct dax_operations {
>  };
>
>  #if IS_ENABLED(CONFIG_DAX)
> -struct dax_device *alloc_dax(void *private, const struct dax_operations *ops,
> -               unsigned long flags);
> +struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
> @@ -64,7 +60,7 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>  }
>  #else
>  static inline struct dax_device *alloc_dax(void *private,
> -               const struct dax_operations *ops, unsigned long flags)
> +               const struct dax_operations *ops)
>  {
>         /*
>          * Callers should check IS_ENABLED(CONFIG_DAX) to know if this

Looks good.
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

