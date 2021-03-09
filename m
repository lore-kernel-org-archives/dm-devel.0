Return-Path: <SRS0=+b8E=IH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1842C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:37:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DB7264F02
	for <dm-devel@archiver.kernel.org>; Tue,  9 Mar 2021 17:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DB7264F02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-pcKXjJ_oP4GoKsRMjvxX5w-1; Tue, 09 Mar 2021 12:37:47 -0500
X-MC-Unique: pcKXjJ_oP4GoKsRMjvxX5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC081009E25;
	Tue,  9 Mar 2021 17:37:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 667325C238;
	Tue,  9 Mar 2021 17:37:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 060FE1809C86;
	Tue,  9 Mar 2021 17:37:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 129Haf0B010126 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Mar 2021 12:36:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 87DC0110AF5A; Tue,  9 Mar 2021 17:36:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82FAD110AF50
	for <dm-devel@redhat.com>; Tue,  9 Mar 2021 17:36:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BF99803C9F
	for <dm-devel@redhat.com>; Tue,  9 Mar 2021 17:36:38 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-82-NUCHWsECNgKtipaGoExpcw-1; Tue, 09 Mar 2021 12:36:32 -0500
X-MC-Unique: NUCHWsECNgKtipaGoExpcw-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lJgGx-000rxw-Fk; Tue, 09 Mar 2021 17:35:58 +0000
Date: Tue, 9 Mar 2021 17:35:55 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
Message-ID: <20210309173555.GC201344@infradead.org>
References: <1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com>
	<1614774618-22410-5-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
In-Reply-To: <1614774618-22410-5-git-send-email-sergei.shtepa@veeam.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	linux-api@vger.kernel.org, pavel.tide@veeam.com,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 4/4] dm: add DM_INTERPOSED_FLAG
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 03, 2021 at 03:30:18PM +0300, Sergei Shtepa wrote:
> DM_INTERPOSED_FLAG allow to create dm targets on "the fly".
> Underlying block device opens without a flag FMODE_EXCL.
> Dm target receives bio from the original device via
> blk_interposer.
> 
> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> ---
>  drivers/md/dm-core.h          |   6 ++
>  drivers/md/dm-ioctl.c         |   9 +++
>  drivers/md/dm-table.c         | 115 +++++++++++++++++++++++++++++++---
>  drivers/md/dm.c               |  38 +++++++----
>  include/linux/device-mapper.h |   1 +
>  include/uapi/linux/dm-ioctl.h |   6 ++
>  6 files changed, 154 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 5953ff2bd260..e5c845f9b1df 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -21,6 +21,8 @@
>  
>  #define DM_RESERVED_MAX_IOS		1024
>  
> +struct dm_interposed_dev;
> +
>  struct dm_kobject_holder {
>  	struct kobject kobj;
>  	struct completion completion;
> @@ -114,6 +116,10 @@ struct mapped_device {
>  	bool init_tio_pdu:1;
>  
>  	struct srcu_struct io_barrier;
> +
> +	/* for interposers logic */
> +	bool is_interposed;
> +	struct dm_interposed_dev *ip_dev;
>  };
>  
>  void disable_discard(struct mapped_device *md);
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 5e306bba4375..2bcb316144a1 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1267,6 +1267,11 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
>  	return mode;
>  }
>  
> +static inline bool get_interposer_flag(struct dm_ioctl *param)
> +{
> +	return (param->flags & DM_INTERPOSED_FLAG);
> +}
> +
>  static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  		       struct dm_target_spec **spec, char **target_params)
>  {
> @@ -1338,6 +1343,8 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
>  	if (!md)
>  		return -ENXIO;
>  
> +	md->is_interposed = get_interposer_flag(param);
> +
>  	r = dm_table_create(&t, get_mode(param), param->target_count, md);
>  	if (r)
>  		goto err;
> @@ -2098,6 +2105,8 @@ int __init dm_early_create(struct dm_ioctl *dmi,
>  	if (r)
>  		goto err_hash_remove;
>  
> +	md->is_interposed = get_interposer_flag(dmi);
> +
>  	/* add targets */
>  	for (i = 0; i < dmi->target_count; i++) {
>  		r = dm_table_add_target(t, spec_array[i]->target_type,
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 95391f78b8d5..0b2f9b66ade5 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include "dm-core.h"
> +#include "dm-interposer.h"
>  
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
> @@ -225,12 +226,13 @@ void dm_table_destroy(struct dm_table *t)
>  /*
>   * See if we've already got a device in the list.
>   */
> -static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
> +static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev, bool is_interposed)
>  {
>  	struct dm_dev_internal *dd;
>  
>  	list_for_each_entry (dd, l, list)
> -		if (dd->dm_dev->bdev->bd_dev == dev)
> +		if ((dd->dm_dev->bdev->bd_dev == dev) &&
> +		    (dd->dm_dev->is_interposed == is_interposed))
>  			return dd;
>  
>  	return NULL;
> @@ -358,6 +360,90 @@ dev_t dm_get_dev_t(const char *path)
>  }
>  EXPORT_SYMBOL_GPL(dm_get_dev_t);
>  
> +/*
> + * Redirect bio from interposed device to dm device
> + */
> +static void dm_interpose_fn(struct dm_interposed_dev *ip_dev, struct bio *bio)
> +{
> +	struct mapped_device *md = ip_dev->private;
> +
> +	if (bio_flagged(bio, BIO_REMAPPED)) {
> +		/*
> +		 * Since bio has already been remapped, we need to subtract
> +		 * the block device offset from the beginning of the disk.
> +		 */
> +		bio->bi_iter.bi_sector -= get_start_sect(bio->bi_bdev);
> +
> +		bio_clear_flag(bio, BIO_REMAPPED);
> +	}

So instead of doing this shoudn't the imposer just always submit to the
whole device?  But if we keep it, the logic in this funtion should go
into a block layer helper, passing a block device instead of the
dm_interposed_dev.  This avoids having such fragile logic in drivers.

> +	if ((ofs + len) > bdev_nr_sectors(bdev)) {
> +		DMERR("The specified range of sectors exceeds of the size of the block device.");
> +		return -ERANGE;
> +	}
> +
> +	md->ip_dev = kzalloc(sizeof(struct dm_interposed_dev), GFP_KERNEL);
> +	if (!md->ip_dev)
> +		return -ENOMEM;
> +
> +	if ((ofs == 0) && (len == 0))

Lots of superflous inner braces.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

