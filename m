Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E679C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 21:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668635334;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JYJdqJKpDKwalXYu2N+zBGwsVHahjBVfpJdZze1grAc=;
	b=g1hurO/kvFas16nOgj9ka21WYlqTEYoCJmH2nZ6Ew/T7RNblT4X0FxiYJSE+4vO+nqfRDQ
	zM+blm5Ddy2kQN45OELdlzOlibIGnb8UuJbLZf6VS5dUESuhNheVINLWzZyDPXkcfYn4Pa
	GcqWqkIzh4I4HKcLKYYd18trxHdIVZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-ldhD5yqdMc2HkQjWdPZYMg-1; Wed, 16 Nov 2022 16:48:53 -0500
X-MC-Unique: ldhD5yqdMc2HkQjWdPZYMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E0E5858F13;
	Wed, 16 Nov 2022 21:48:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D7ECAC1E87F;
	Wed, 16 Nov 2022 21:48:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3ECB119465A3;
	Wed, 16 Nov 2022 21:48:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 927BE19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 21:48:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C05C112132C; Wed, 16 Nov 2022 21:48:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 23E7B1121325
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:48:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 052AF101A52A
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 21:48:46 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-u37soD6PNp-4gr9W4OfUUA-1; Wed, 16 Nov 2022 16:48:44 -0500
X-MC-Unique: u37soD6PNp-4gr9W4OfUUA-1
Received: by mail-qk1-f198.google.com with SMTP id
 w4-20020a05620a444400b006fa24b2f394so18705573qkp.15
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 13:48:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=gb7j/bSfwmKBgntX+bLM9T0km8Jf8pYUeq23+M2C16M=;
 b=DOOHZhp4GviDOLr6vnv+OK5gRnvqaZ5/48p6G6EKWj8pZgxg4hB7eUvN6tiNOEv7I0
 owUf94wwdd5KQyK6Q5zEMVCKIfyRbHC+YwiqkklTKIH7HJChiHqRvKtFycr85OF3X8uq
 JuHn3j8OHmgrnhg4hTUN4EZQbvlKsUpUpaln4fLqPnPn5svPycXb1ybcoLnGntZEtA3Y
 TV0qkciMgv3LJlLzjrqnKlvVsjiN/iQfm7j+q2hdPJnIhbVBQseCVOMvWIW7rL5MIm6s
 33k+XzU59hBvAGZ9IGP3MshbGlVAA50+9L7mgtA5wUbykojy2JsMdm2mUmggU7nkpmrj
 DNCw==
X-Gm-Message-State: ANoB5pkxDUz4ZztSizjOc8sPdob0mpLsbREKLqCioe8VyC/gHm6zCf0k
 dMbIJqTnAkEYXcK1302mcfH7R8p7wozW5Eh3WGwy32mpulU1boINNnmmUnlaLnIitDGGzjDDQ5R
 FV2H/JTW2GNcd4A==
X-Received: by 2002:ae9:ef0c:0:b0:6ea:8eb4:3898 with SMTP id
 d12-20020ae9ef0c000000b006ea8eb43898mr21421443qkg.588.1668635324215; 
 Wed, 16 Nov 2022 13:48:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7qRR7lyPfh1G9FP29Lbv7v+knDVgTkc535wRE4ZJ7VapZ3sEbuHbJgrTLOn4ZuOtuRz4HoJw==
X-Received: by 2002:ae9:ef0c:0:b0:6ea:8eb4:3898 with SMTP id
 d12-20020ae9ef0c000000b006ea8eb43898mr21421434qkg.588.1668635323996; 
 Wed, 16 Nov 2022 13:48:43 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 e7-20020a05622a110700b0038b684a1642sm9385264qty.32.2022.11.16.13.48.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 13:48:43 -0800 (PST)
Date: Wed, 16 Nov 2022 16:48:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Y3VaunS49xJvHflm@redhat.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
 <20221115141054.1051801-6-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221115141054.1051801-6-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v3 05/10] dm: make sure create and remove
 dm device won't race with open and close table
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
Cc: axboe@kernel.dk, yi.zhang@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 yukuai3@huawei.com, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 15 2022 at  9:10P -0500,
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> open_table_device() and close_table_device() is protected by
> table_devices_lock, hence use it to protect add_disk() and
> del_gendisk().
> 
> Prepare to track per-add_disk holder relations in dm.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/dm.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2917700b1e15..3728b56b364b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1952,7 +1952,14 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  		spin_unlock(&_minor_lock);
>  		if (dm_get_md_type(md) != DM_TYPE_NONE) {
>  			dm_sysfs_exit(md);
> +
> +			/*
> +			 * Hold lock to make sure del_gendisk() won't concurrent
> +			 * with open/close_table_device().
> +			 */
> +			mutex_lock(&md->table_devices_lock);
>  			del_gendisk(md->disk);
> +			mutex_unlock(&md->table_devices_lock);
>  		}
>  		dm_queue_destroy_crypto_profile(md->queue);
>  		put_disk(md->disk);
> @@ -2312,15 +2319,24 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  	if (r)
>  		return r;
>  
> +	/*
> +	 * Hold lock to make sure add_disk() and del_gendisk() won't concurrent
> +	 * with open_table_device() and close_table_device().
> +	 */
> +	mutex_lock(&md->table_devices_lock);
>  	r = add_disk(md->disk);
> +	mutex_unlock(&md->table_devices_lock);
>  	if (r)
>  		return r;
>  
>  	r = dm_sysfs_init(md);
>  	if (r) {
> +		mutex_lock(&md->table_devices_lock);
>  		del_gendisk(md->disk);
> +		mutex_unlock(&md->table_devices_lock);
>  		return r;
>  	}
> +
>  	md->type = type;
>  	return 0;
>  }
> -- 
> 2.31.1
> 

In the new comments added: s/concurrent/race/ ?

But otherwise:

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

