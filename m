Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7335FC07E8A
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pYGt4yoFUwAi9nrcJLbG3aPpUvBoWm84GlYc01ENQYg=;
	b=Q9AOyqsKiHfMCQamNpHJbqq0N8r+XnKqP75n/iuAE7qnhuJsjY/9c+Eq5dt0Yxkm6mb7I/
	cFJd8PJCQ7TD5wFO7eI91RzqVogFw0Q5Owh0GmikzZDyOgofpnmTrnC4hwQXaPjBUd8uVU
	y2n2YLzftupYaQeYpq5coistox2hBCU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-xmqvjMkSM8iMPq9h8GHfKA-1; Tue, 25 Jul 2023 02:43:26 -0400
X-MC-Unique: xmqvjMkSM8iMPq9h8GHfKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D6383505F;
	Tue, 25 Jul 2023 06:42:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D163DC2C85A;
	Tue, 25 Jul 2023 06:42:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C833D1946A7B;
	Tue, 25 Jul 2023 06:42:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 515D21946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Jul 2023 03:05:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0048840D296E; Tue, 25 Jul 2023 03:05:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC0A340D2962
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 03:05:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCD52293248B
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 03:05:27 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-fjIWNYIPM1qiSUBysKK-xw-1; Mon, 24 Jul 2023 23:05:25 -0400
X-MC-Unique: fjIWNYIPM1qiSUBysKK-xw-1
Received: by mail-pj1-f46.google.com with SMTP id
 98e67ed59e1d1-267f32e89a5so323667a91.0
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 20:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690254325; x=1690859125;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=niSMZqBCvW/Me9jsMaxXz5gtuZ44llk1Ot3soT0LhIs=;
 b=VZq7OMR09edKRR2F4bGIgJbawQ0tJUyYhD7mMPP3BTZZqPU8zH509bJHSoIBFjcrxX
 AIwuj0IxOOCB6g5sns2sjIeHVtKknvqlnMUvNeUG21tmt7WBBPFQY/flzXi5n461UN5m
 blRGwannX7UryFo7TNFuHNylDXR5ibdp28E+GPmwW+Ls9tSp0tR6Fa6IsMl8koo2IcGe
 7JUbNJZIQi1e9QuG7DKKu2s9acBrW5kxOVhzbCYdpoYJrTfwFu44Hqq72xInF8p6auTF
 BwIWDpa45yTxVvpjxu5T1inYXthV7DLxwWN7Rp5oQWPAvNxZXZ74E9BZlrEFoVFGBd8o
 0Yfg==
X-Gm-Message-State: ABy/qLZui80BZw7KSdBFL0o59tvmWPle+q8HBGnsI/lhqNK96xB4pJJU
 /mSmjGcFf51N/rI28ySIj/jLMQ==
X-Google-Smtp-Source: APBJJlFB/cQTGj3IlIfGF+HAM8hU50IJB+Lr29ujA3cHbbDSAB3N90HdGCOpa8iydTeMw+f8qxyL2Q==
X-Received: by 2002:a17:90a:1d46:b0:268:abc:83d5 with SMTP id
 u6-20020a17090a1d4600b002680abc83d5mr6012554pju.4.1690254324674; 
 Mon, 24 Jul 2023 20:05:24 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:1c25:884:3ed:e1db:b610?
 ([2408:8000:b001:1:1f:58ff:f102:103])
 by smtp.gmail.com with ESMTPSA id
 t10-20020a17090aba8a00b002681d44071csm2043968pjr.46.2023.07.24.20.05.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 24 Jul 2023 20:05:24 -0700 (PDT)
Message-ID: <6049aa99-aa47-5137-f66e-350bc4723914@bytedance.com>
Date: Tue, 25 Jul 2023 11:05:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Steven Price <steven.price@arm.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-25-zhengqi.arch@bytedance.com>
 <cdd08c9e-81d3-a85f-5426-5db738aa73ec@arm.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <cdd08c9e-81d3-a85f-5426-5db738aa73ec@arm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: Re: [dm-devel] [PATCH v2 24/47] drm/panfrost: dynamically allocate
 the drm-panfrost shrinker
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 brauner@kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, tytso@mit.edu, netdev@vger.kernel.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Steven,

On 2023/7/24 19:17, Steven Price wrote:
> On 24/07/2023 10:43, Qi Zheng wrote:
>> In preparation for implementing lockless slab shrink, use new APIs to
>> dynamically allocate the drm-panfrost shrinker, so that it can be freed
>> asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
>> read-side critical section when releasing the struct panfrost_device.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> One nit below, but otherwise:
> 
> Reviewed-by: Steven Price <steven.price@arm.com>
> 
>> ---
>>   drivers/gpu/drm/panfrost/panfrost_device.h    |  2 +-
>>   drivers/gpu/drm/panfrost/panfrost_drv.c       |  6 +++-
>>   drivers/gpu/drm/panfrost/panfrost_gem.h       |  2 +-
>>   .../gpu/drm/panfrost/panfrost_gem_shrinker.c  | 32 ++++++++++++-------
>>   4 files changed, 27 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
>> index b0126b9fbadc..e667e5689353 100644
>> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
>> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
>> @@ -118,7 +118,7 @@ struct panfrost_device {
>>   
>>   	struct mutex shrinker_lock;
>>   	struct list_head shrinker_list;
>> -	struct shrinker shrinker;
>> +	struct shrinker *shrinker;
>>   
>>   	struct panfrost_devfreq pfdevfreq;
>>   };
>> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
>> index bbada731bbbd..f705bbdea360 100644
>> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
>> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
>> @@ -598,10 +598,14 @@ static int panfrost_probe(struct platform_device *pdev)
>>   	if (err < 0)
>>   		goto err_out1;
>>   
>> -	panfrost_gem_shrinker_init(ddev);
>> +	err = panfrost_gem_shrinker_init(ddev);
>> +	if (err)
>> +		goto err_out2;
>>   
>>   	return 0;
>>   
>> +err_out2:
>> +	drm_dev_unregister(ddev);
>>   err_out1:
>>   	pm_runtime_disable(pfdev->dev);
>>   	panfrost_device_fini(pfdev);
>> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
>> index ad2877eeeccd..863d2ec8d4f0 100644
>> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
>> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
>> @@ -81,7 +81,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
>>   void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
>>   void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);
>>   
>> -void panfrost_gem_shrinker_init(struct drm_device *dev);
>> +int panfrost_gem_shrinker_init(struct drm_device *dev);
>>   void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
>>   
>>   #endif /* __PANFROST_GEM_H__ */
>> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
>> index bf0170782f25..9a90dfb5301f 100644
>> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
>> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
>> @@ -18,8 +18,7 @@
>>   static unsigned long
>>   panfrost_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
>>   {
>> -	struct panfrost_device *pfdev =
>> -		container_of(shrinker, struct panfrost_device, shrinker);
>> +	struct panfrost_device *pfdev = shrinker->private_data;
>>   	struct drm_gem_shmem_object *shmem;
>>   	unsigned long count = 0;
>>   
>> @@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
>>   static unsigned long
>>   panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
>>   {
>> -	struct panfrost_device *pfdev =
>> -		container_of(shrinker, struct panfrost_device, shrinker);
>> +	struct panfrost_device *pfdev = shrinker->private_data;
>>   	struct drm_gem_shmem_object *shmem, *tmp;
>>   	unsigned long freed = 0;
>>   
>> @@ -97,13 +95,24 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
>>    *
>>    * This function registers and sets up the panfrost shrinker.
>>    */
>> -void panfrost_gem_shrinker_init(struct drm_device *dev)
>> +int panfrost_gem_shrinker_init(struct drm_device *dev)
>>   {
>>   	struct panfrost_device *pfdev = dev->dev_private;
>> -	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
>> -	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
>> -	pfdev->shrinker.seeks = DEFAULT_SEEKS;
>> -	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
>> +
>> +	pfdev->shrinker = shrinker_alloc(0, "drm-panfrost");
>> +	if (!pfdev->shrinker) {
>> +		WARN_ON(1);
> 
> I don't think this WARN_ON is particularly useful - if there's a failed
> memory allocation we should see output from the kernel anyway. And we're
> changing the semantics from "continue just without a shrinker" (which
> argueably justifies the warning) to "probe fails, device doesn't work"
> which will be obvious to the user so I don't feel we need the additional
> warn.

Make sense. Will delete this WARN_ON() in the next version.

Thanks,
Qi

> 
>> +		return -ENOMEM;
>> +	}
>> +
>> +	pfdev->shrinker->count_objects = panfrost_gem_shrinker_count;
>> +	pfdev->shrinker->scan_objects = panfrost_gem_shrinker_scan;
>> +	pfdev->shrinker->seeks = DEFAULT_SEEKS;
>> +	pfdev->shrinker->private_data = pfdev;
>> +
>> +	shrinker_register(pfdev->shrinker);
>> +
>> +	return 0;
>>   }
>>   
>>   /**
>> @@ -116,7 +125,6 @@ void panfrost_gem_shrinker_cleanup(struct drm_device *dev)
>>   {
>>   	struct panfrost_device *pfdev = dev->dev_private;
>>   
>> -	if (pfdev->shrinker.nr_deferred) {
>> -		unregister_shrinker(&pfdev->shrinker);
>> -	}
>> +	if (pfdev->shrinker)
>> +		shrinker_unregister(pfdev->shrinker);
>>   }
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

