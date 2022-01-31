Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188F6C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:19:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-HPmX_IeCODCNcLQ_Qaw85Q-1; Wed, 02 Feb 2022 01:19:09 -0500
X-MC-Unique: HPmX_IeCODCNcLQ_Qaw85Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1C411083F64;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D8C56A81;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 69E1F1802E34;
	Wed,  2 Feb 2022 06:19:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VEHusY002038 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 09:17:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A441F401E3D; Mon, 31 Jan 2022 14:17:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0515401E3C
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 14:17:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 867FA85A5BA
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 14:17:56 +0000 (UTC)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
	[209.85.218.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-647-BLco4u2IND2CS4DNlkgljg-1; Mon, 31 Jan 2022 09:17:54 -0500
X-MC-Unique: BLco4u2IND2CS4DNlkgljg-1
Received: by mail-ej1-f50.google.com with SMTP id m4so43587869ejb.9
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 06:17:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=mTDCObLZiJqqNd5/Xm8EoHS2mhf1Esr2zwHrRGTOotI=;
	b=BJVUXh7bItDnPx2dVNcH743ml4v9fTxM3zQa9+/68dQEkIqFIFKFYHL3IoiH9Ym7mt
	smO/ZFYDs/zQST87LAPseIm5tcgIGgACDLu0O4KsPp5qOX4wuBB85TC57giEglOpW+o1
	TvQHHkmY/awAIiDiD91YIgp0/RlVS+iAum+kR+DEQBOx2HuQyFN/Y0U1hA+xaQ8kPi3t
	422AZBRXNNUtLcZ1updsZ+OwFgyWmuLGB154HIqBzZbRrBt8p4/KrswBAArRz+7/XN7O
	+xhED6+ifJPZfJfsEKyIoAZSj5mn9vLlapXeo2CZEaPD28SSPbe1Pk8MRPjBMV0FSuSl
	4HcA==
X-Gm-Message-State: AOAM5310MhvxiQo56UM1gpYfb3ITXtU/O+Ztzm71e+TPzaIbcCji7b+1
	Ch9bSOoALkkXZZNGRZT5dk0oLfXkOJPTVvaNIWxupEXmInLMYw==
X-Google-Smtp-Source: ABdhPJw57VoVmQlHI/WE2YiNtWnr1tGBJpC/hgZFws6gJW13Zq0wtbMT38h9enYhWHQOyGdP/AJ+5oyy/RN/YJ63pmo=
X-Received: by 2002:a17:907:1a42:: with SMTP id
	mf2mr17060738ejc.103.1643638673024; 
	Mon, 31 Jan 2022 06:17:53 -0800 (PST)
MIME-Version: 1.0
References: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<20220126192234.572058-1-bgeffon@google.com>
In-Reply-To: <20220126192234.572058-1-bgeffon@google.com>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 31 Jan 2022 09:17:17 -0500
Message-ID: <CADyq12yugY0g2EMYvyrPVn98x3Tp4PR+eVddmmjZpKSYyrrzag@mail.gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Cc: dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH] dm: introduce a DM_ENFORCE_OPEN_COUNT flag.
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

On Wed, Jan 26, 2022 at 2:22 PM Brian Geffon <bgeffon@google.com> wrote:
>
> This change introduces a new flag which can be used with
> DM_DEV_CREATE to establish the maximum open count allowed
> for a device. When this flag is set on DM_DEV_CREATE the
> open_count on dm_ioctl will be intrpreted as an input
> parameter. This value must be >= 1 or DM_DEV_CREATE will
> return -ERANGE.
>
> When this flag is set when the open count is equal to
> the max open count any future opens will result in an
> -EBUSY.
>

Hi Alasdair,
I was curious if you had any thoughts on this particular alternative
approach to this problem, I'm open to any suggestions of alternative
implementations.

Thank you in advance,
Brian


>
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> ---
>  drivers/md/dm-core.h          |  2 ++
>  drivers/md/dm-ioctl.c         | 13 ++++++++++++
>  drivers/md/dm.c               | 39 ++++++++++++++++++++++++++++++++---
>  drivers/md/dm.h               |  7 +++++++
>  include/uapi/linux/dm-ioctl.h |  9 +++++++-
>  5 files changed, 66 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 55dccdfbcb22..57922a80026e 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -57,6 +57,7 @@ struct mapped_device {
>
>         atomic_t holders;
>         atomic_t open_count;
> +       int max_open_count;
>
>         struct dm_target *immutable_target;
>         struct target_type *immutable_target_type;
> @@ -139,6 +140,7 @@ struct mapped_device {
>  #define DMF_SUSPENDED_INTERNALLY 7
>  #define DMF_POST_SUSPENDING 8
>  #define DMF_EMULATE_ZONE_APPEND 9
> +#define DMF_ENFORCE_OPEN_COUNT 10
>
>  void disable_discard(struct mapped_device *md);
>  void disable_write_same(struct mapped_device *md);
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 21fe8652b095..8ddf3ab99ef6 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -814,6 +814,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
>         if (dm_test_deferred_remove_flag(md))
>                 param->flags |= DM_DEFERRED_REMOVE;
>
> +       if (dm_test_enforce_open_count_flag(md))
> +               param->flags |= DM_ENFORCE_OPEN_COUNT_FLAG;
> +
>         param->dev = huge_encode_dev(disk_devt(disk));
>
>         /*
> @@ -866,6 +869,16 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
>         if (r)
>                 return r;
>
> +       if (param->flags & DM_ENFORCE_OPEN_COUNT_FLAG) {
> +               if (param->open_count < 1) {
> +                       dm_put(md);
> +                       dm_destroy(md);
> +                       return -ERANGE;
> +               }
> +
> +               dm_set_max_open_count(md, param->open_count);
> +       }
> +
>         r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
>         if (r) {
>                 dm_put(md);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 76d9da49fda7..718bc9fce7c1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -307,6 +307,7 @@ int dm_deleting_md(struct mapped_device *md)
>  static int dm_blk_open(struct block_device *bdev, fmode_t mode)
>  {
>         struct mapped_device *md;
> +       int ret = -ENXIO;
>
>         spin_lock(&_minor_lock);
>
> @@ -316,16 +317,28 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
>
>         if (test_bit(DMF_FREEING, &md->flags) ||
>             dm_deleting_md(md)) {
> -               md = NULL;
>                 goto out;
>         }
>
>         dm_get(md);
> +
> +       if (test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags)) {
> +               /*
> +                * No opens or closes can happen in parallel as both
> +                * paths hold the _minor_lock.
> +                */
> +               if (atomic_read(&md->open_count) + 1 > md->max_open_count) {
> +                       dm_put(md);
> +                       ret = -EBUSY;
> +                       goto out;
> +               }
> +       }
> +
>         atomic_inc(&md->open_count);
> +       ret = 0;
>  out:
>         spin_unlock(&_minor_lock);
> -
> -       return md ? 0 : -ENXIO;
> +       return ret;
>  }
>
>  static void dm_blk_close(struct gendisk *disk, fmode_t mode)
> @@ -2219,6 +2232,21 @@ void dm_put(struct mapped_device *md)
>  }
>  EXPORT_SYMBOL_GPL(dm_put);
>
> +/*
> + * dm_set_max_open count can only be called when the device is created,
> + * it cannot be changed once set.
> + */
> +void dm_set_max_open_count(struct mapped_device *md, int count)
> +{
> +       /*
> +        * The max open count cannot be changed
> +        */
> +       BUG_ON(test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags));
> +
> +       set_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags);
> +       md->max_open_count = count;
> +}
> +
>  static bool md_in_flight_bios(struct mapped_device *md)
>  {
>         int cpu;
> @@ -2795,6 +2823,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
>         return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
>  }
>
> +int dm_test_enforce_open_count_flag(struct mapped_device *md)
> +{
> +       return test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags);
> +}
> +
>  int dm_suspended(struct dm_target *ti)
>  {
>         return dm_suspended_md(ti->table->md);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 742d9c80efe1..82f56a066b83 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -84,6 +84,8 @@ void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
>  enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
>  struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
>
> +void dm_set_max_open_count(struct mapped_device *md, int count);
> +
>  int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
>
>  /*
> @@ -162,6 +164,11 @@ void dm_internal_resume(struct mapped_device *md);
>   */
>  int dm_test_deferred_remove_flag(struct mapped_device *md);
>
> +/*
> + * Test if the device is enforcing an open count.
> + */
> +int dm_test_enforce_open_count_flag(struct mapped_device *md);
> +
>  /*
>   * Try to remove devices marked for deferred removal.
>   */
> diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
> index c12ce30b52df..9da3700c0442 100644
> --- a/include/uapi/linux/dm-ioctl.h
> +++ b/include/uapi/linux/dm-ioctl.h
> @@ -123,7 +123,7 @@ struct dm_ioctl {
>                                  * relative to start of this struct */
>
>         __u32 target_count;     /* in/out */
> -       __s32 open_count;       /* out */
> +       __s32 open_count;       /* in/out, in on DM_DEV_CREATE only */
>         __u32 flags;            /* in/out */
>
>         /*
> @@ -382,4 +382,11 @@ enum {
>   */
>  #define DM_IMA_MEASUREMENT_FLAG        (1 << 19) /* In */
>
> +/*
> + * If set with DM_DEV_CREATE then the open_count on device creation
> + * will be set as the maximum concurrent opens allowed on the device.
> + * Once the open_count has been hit any new opens will result in
> + * -EBUSY until other users close the device.
> + */
> +#define DM_ENFORCE_OPEN_COUNT_FLAG      (1 << 20) /* In/Out */
>  #endif                         /* _LINUX_DM_IOCTL_H */
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

