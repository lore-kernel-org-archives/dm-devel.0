Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3549C001DC
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480513;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=joal5RkoV34fm+T6M+e2eCG68rdYFuuzo+u2IQFQGn4=;
	b=eolYscBOGAJqQr0UrIel90YChWaq83nxW3JOBXwvYNbxNdWrhJvVcUxkbksMCeFGCAIYuf
	21tgR25DdqNsgYCjPnGMU8lnC6cKppeGZNvBNnM8KzhrAYEXoQkoCn03NA50WgRJGwSXeG
	CGn48pRPkRq8JgexZXj57Bwwy0V0Bow=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-xHrSSYpdNwiKglITOJ1E8w-1; Thu, 27 Jul 2023 13:55:03 -0400
X-MC-Unique: xHrSSYpdNwiKglITOJ1E8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91548104D517;
	Thu, 27 Jul 2023 17:54:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B27C4200BA73;
	Thu, 27 Jul 2023 17:54:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B30A19452C6;
	Thu, 27 Jul 2023 17:54:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 712DF1946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 09:13:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B943C2C858; Thu, 27 Jul 2023 09:13:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51A0DC2C856
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 09:13:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 270F7805BC3
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 09:13:25 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-XK02lsu0MhSQm34jlGw9uA-1; Thu, 27 Jul 2023 05:13:22 -0400
X-MC-Unique: XK02lsu0MhSQm34jlGw9uA-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-6862d4a1376so201874b3a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 02:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690449201; x=1691054001;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ab3i02uMNDVjAVrJgavtDQnv7B+TbSMr9u4LPtdCXIk=;
 b=IgccdMG6QJ+ksd2Z9cvH2nwI2CKGs7Q77ITaJg/p+eIL91MVf0LfHvAbPS9YY90oGD
 4LiSxBUxb570rhi4yEgJBu0VlZj1kD6GxdI3xLFhHBZaySqMYfznqK17QwGH4FitrIFJ
 sPN8dwcw3uNMb/T9UJi6hDS1rWmzA+wWnsGQxwe0KwOHn5a55ESo/i9KgLW6sUlTb6cj
 xeG+WI1egDxXfXey1rhUNspj1Qx7NiS/JLawaZFu90qi/OkSHgIj+a8eO7No/dgeN/f/
 RGoSabRyn8pza0VKYKb8FjSAZZGx4BXYmCaClOL3LOS39YgnJPvaGmyP9WBrOr9/1ehr
 MgdA==
X-Gm-Message-State: ABy/qLbMcz5Z892sptP+VQVsJxm/zvZG8Em4poUJgsYKcFk3r6XXpRaK
 1qMNbAXSd/u2BU0Au5PtEeLsuQ==
X-Google-Smtp-Source: APBJJlGBn5Xl2QFHzxgRMihSAaLd28csKz8Em946xGdOgBfe3ljiGqu5+YaMyvDFvdIkqmZPd3zpbQ==
X-Received: by 2002:a05:6a00:4792:b0:668:834d:4bd with SMTP id
 dh18-20020a056a00479200b00668834d04bdmr4787709pfb.0.1690449201600; 
 Thu, 27 Jul 2023 02:13:21 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 m26-20020a056a00165a00b006687b41c4dasm1017146pfc.110.2023.07.27.02.13.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 Jul 2023 02:13:21 -0700 (PDT)
Message-ID: <961f6055-a395-8490-4c22-765a30668460@bytedance.com>
Date: Thu, 27 Jul 2023 17:13:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu, steven.price@arm.com,
 cel@kernel.org, senozhatsky@chromium.org, yujie.liu@intel.com,
 gregkh@linuxfoundation.org, muchun.song@linux.dev
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-28-zhengqi.arch@bytedance.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-28-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: Re: [dm-devel] [PATCH v3 27/49] dm: dynamically allocate the
 dm-bufio shrinker
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/7/27 16:04, Qi Zheng wrote:
> In preparation for implementing lockless slab shrink, use new APIs to
> dynamically allocate the dm-bufio shrinker, so that it can be freed
> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
> read-side critical section when releasing the struct dm_bufio_client.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   drivers/md/dm-bufio.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index bc309e41d074..5a9124b83d53 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -963,7 +963,7 @@ struct dm_bufio_client {
>   
>   	sector_t start;
>   
> -	struct shrinker shrinker;
> +	struct shrinker *shrinker;
>   	struct work_struct shrink_work;
>   	atomic_long_t need_shrink;
>   
> @@ -2368,7 +2368,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
>   {
>   	struct dm_bufio_client *c;
>   
> -	c = container_of(shrink, struct dm_bufio_client, shrinker);
> +	c = shrink->private_data;
>   	atomic_long_add(sc->nr_to_scan, &c->need_shrink);
>   	queue_work(dm_bufio_wq, &c->shrink_work);
>   
> @@ -2377,7 +2377,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
>   
>   static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>   {
> -	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
> +	struct dm_bufio_client *c = shrink->private_data;
>   	unsigned long count = cache_total(&c->cache);
>   	unsigned long retain_target = get_retain_buffers(c);
>   	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
> @@ -2490,15 +2490,19 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
>   	INIT_WORK(&c->shrink_work, shrink_work);
>   	atomic_long_set(&c->need_shrink, 0);
>   
> -	c->shrinker.count_objects = dm_bufio_shrink_count;
> -	c->shrinker.scan_objects = dm_bufio_shrink_scan;
> -	c->shrinker.seeks = 1;
> -	c->shrinker.batch = 0;
> -	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
> -			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
> -	if (r)
> +	c->shrinker = shrinker_alloc(0, "dm-bufio:(%u:%u)",
> +				     MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
> +	if (!c->shrinker)

Here should set r to -ENOMEM, will fix.

>   		goto bad;
>   
> +	c->shrinker->count_objects = dm_bufio_shrink_count;
> +	c->shrinker->scan_objects = dm_bufio_shrink_scan;
> +	c->shrinker->seeks = 1;
> +	c->shrinker->batch = 0;
> +	c->shrinker->private_data = c;
> +
> +	shrinker_register(c->shrinker);
> +
>   	mutex_lock(&dm_bufio_clients_lock);
>   	dm_bufio_client_count++;
>   	list_add(&c->client_list, &dm_bufio_all_clients);
> @@ -2537,7 +2541,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
>   
>   	drop_buffers(c);
>   
> -	unregister_shrinker(&c->shrinker);
> +	shrinker_free(c->shrinker);
>   	flush_work(&c->shrink_work);
>   
>   	mutex_lock(&dm_bufio_clients_lock);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

