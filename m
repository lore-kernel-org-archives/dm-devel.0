Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8C2C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 17 Oct 2022 19:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666036645;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=++io3kzLkS93ZdLWZRiNFA/c1/XvLYcpoVO5cyhxI4E=;
	b=Wz9BdP0qOaC0uP7cXnwvmg8SkWgsOAXUB1WTEWTk9FJR80dGCUWL7kuUkcoJhdlHkWc3rO
	Lm4BIIIdsCSpOE2ysyiff18iylZGKlO7O3HM6CCUGcwvtptzR/aakY6Vdj7ujRO+ht5gZZ
	GJiw3EC8H6+M+Pyw79lbYZK36Eb3lfc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-HqHqd7p3NsGVAtnonUwdtg-1; Mon, 17 Oct 2022 15:57:24 -0400
X-MC-Unique: HqHqd7p3NsGVAtnonUwdtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DF0F185A7A8;
	Mon, 17 Oct 2022 19:57:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 235D22166B29;
	Mon, 17 Oct 2022 19:56:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9AE41946594;
	Mon, 17 Oct 2022 19:56:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E35C194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Oct 2022 19:56:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 17F0D14657C4; Mon, 17 Oct 2022 19:56:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 106241402BD9
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 19:56:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CBE8857F92
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 19:56:54 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-52R_9T5EM9y5Sa8R4S9bOQ-1; Mon, 17 Oct 2022 15:56:48 -0400
X-MC-Unique: 52R_9T5EM9y5Sa8R4S9bOQ-1
Received: by mail-qk1-f199.google.com with SMTP id
 s14-20020a05620a0bce00b006ee7e19c44bso10455518qki.12
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 12:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=IgHMMU+6zmvDPQlAHGymAjD+HJf+7oSbMAE9s7LCacA=;
 b=e/NlOQSXomBiJaaEJaiVcdKXmr6ZvU0NIQMq7RWtLlJfbL0eND2biLmW8mzhIDLqWI
 so2RSP4RrVUAT+QGkgffSJpuFCAuEew/mLi0a5rFj64z0Qn0b8meEPEaRjICujaef/JI
 fNF7T2Q8sP5UEKQecSuUutos5IrxF/1/SqdlLxM/N3RePzM3gA6/EWJblyeaK0eLXS9M
 mQsb+He4hK6HHpp54dlRzxbQIj8H3SMWkAgUXBLFmON/N5tRKkUYyVzqUrq8Cwv0H93N
 Wow2v/2SJ38FB3rKMZfefacv9CYutAH9LTcH86zbuR8UBjn/No+jcrgmdDG8JiD4k3k4
 Gh2g==
X-Gm-Message-State: ACrzQf08loeXYhhmNb9Svl+7HoL2/tnshXZmXBZeakIK1z2OhMoEgIYG
 UDWSVTzwZruCj6siNBaNV1cmIlPPlm+4hUOmKdB/LY3cvKfGz8GCsQqlPOoNk8wu00Vw8gYwsEr
 XWq2BJXxTlrFKaQ==
X-Received: by 2002:a05:620a:4725:b0:6ee:bf5c:915a with SMTP id
 bs37-20020a05620a472500b006eebf5c915amr8809966qkb.326.1666036607536; 
 Mon, 17 Oct 2022 12:56:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6DbijIhTDQp7E8Vb8rgp+Vi8/v2IkrRadTNTeY1FVQ61oSd31D71j16bEPzA45dqGVDJ9y0Q==
X-Received: by 2002:a05:620a:4725:b0:6ee:bf5c:915a with SMTP id
 bs37-20020a05620a472500b006eebf5c915amr8809959qkb.326.1666036607280; 
 Mon, 17 Oct 2022 12:56:47 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 fb20-20020a05622a481400b0039442ee69c5sm437981qtb.91.2022.10.17.12.56.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Oct 2022 12:56:46 -0700 (PDT)
Date: Mon, 17 Oct 2022 15:56:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <Y02zebNyn73/MN1d@redhat.com>
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221010144123.252329-1-luomeng@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
 multipath_message()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: snitzer@kernel.org, ejt@redhat.com, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 10 2022 at 10:41P -0400,
Luo Meng <luomeng@huaweicloud.com> wrote:

> From: Luo Meng <luomeng12@huawei.com>
> 
> If dm_get_device() create dd in multipath_message(),
> and then call table_deps() after dm_put_table_device(),
> it will lead to concurrency UAF bugs.
> 
> One of the concurrency UAF can be shown as below:
> 
>          (USE)                        |    (FREE)
>                                       |  target_message
>                                       |    multipath_message
>                                       |      dm_put_device
>                                       |        dm_put_table_device #
>                                       |          kfree(td)  # table_device *td
> ioctl # DM_TABLE_DEPS_CMD             |         ...
>   table_deps                          |         ...
>   dm_get_live_or_inactive_table       |         ...
>     retrieve_dep                      |         ...
>     list_for_each_entry               |         ...
>       deps->dev[count++] =            |         ...
>           huge_encode_dev             |         ...
>           (dd->dm_dev->bdev->bd_dev)  |        list_del(&dd->list)
>                                       |        kfree(dd) # dm_dev_internal
> 
> The root cause of UAF bugs is that find_device() failed in
> dm_get_device() and will create dd and refcount set 1, kfree()
> in dm_put_table() is not protected. When td, which there are
> still pointers point to, is released, the concurrency UAF bug
> will happen.
> 
> This patch add a flag to determine whether to create a new dd.
> 
> Fixes: 8215d6ec5fee(dm table: remove unused dm_get_device range parameters)
> Signed-off-by: Luo Meng <luomeng12@huawei.com>
> ---
>  drivers/md/dm-mpath.c         |  2 +-
>  drivers/md/dm-table.c         | 43 +++++++++++++++++++++--------------
>  include/linux/device-mapper.h |  2 ++
>  3 files changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 0e325469a252..1f51059520ac 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2001,7 +2001,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
>  		goto out;
>  	}
>  
> -	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
> +	r = __dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev, false);
>  	if (r) {
>  		DMWARN("message: error getting device %s",
>  		       argv[1]);
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index d8034ff0cb24..ad18a41f1608 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -338,12 +338,8 @@ dev_t dm_get_dev_t(const char *path)
>  }
>  EXPORT_SYMBOL_GPL(dm_get_dev_t);
>  
> -/*
> - * Add a device to the list, or just increment the usage count if
> - * it's already present.
> - */
> -int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> -		  struct dm_dev **result)
> +int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> +		    struct dm_dev **result, bool create_dd)
>  {
>  	int r;
>  	dev_t dev;
> @@ -367,19 +363,21 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  
>  	dd = find_device(&t->devices, dev);
>  	if (!dd) {
> -		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> -		if (!dd)
> -			return -ENOMEM;
> -
> -		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> -			kfree(dd);
> -			return r;
> -		}
> +		if (create_dd) {
> +			dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> +			if (!dd)
> +				return -ENOMEM;
>  
> -		refcount_set(&dd->count, 1);
> -		list_add(&dd->list, &t->devices);
> -		goto out;
> +			if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> +				kfree(dd);
> +				return r;
> +			}
>  
> +			refcount_set(&dd->count, 1);
> +			list_add(&dd->list, &t->devices);
> +			goto out;
> +		} else
> +			return -ENODEV;
>  	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
>  		r = upgrade_mode(dd, mode, t->md);
>  		if (r)
> @@ -390,6 +388,17 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  	*result = dd->dm_dev;
>  	return 0;
>  }
> +EXPORT_SYMBOL(__dm_get_device);
> +
> +/*
> + * Add a device to the list, or just increment the usage count if
> + * it's already present.
> + */
> +int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> +		  struct dm_dev **result)
> +{
> +	return __dm_get_device(ti, path, mode, result, true);
> +}
>  EXPORT_SYMBOL(dm_get_device);
>  
>  static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 04c6acf7faaa..ef4031a844b6 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -178,6 +178,8 @@ dev_t dm_get_dev_t(const char *path);
>  int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		  struct dm_dev **result);
>  void dm_put_device(struct dm_target *ti, struct dm_dev *d);
> +int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> +		    struct dm_dev **result, bool create_dd);
>  
>  /*
>   * Information about a target type
> -- 
> 2.31.1
> 

This patch is treating the one multipath case like it is only consumer
of dm_get_device() that might have this issue. It feels too focused on
an instance where dm_get_device()'s side-effect of creating the device
is unwelcome. Feels like you're treating the symptom rather than the
problem (e.g. that the "kfree() in dm_put_table() is not protected"?)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

