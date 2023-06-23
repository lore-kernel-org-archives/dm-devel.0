Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A31C04A94
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971633;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x10M8k8BpBGrzDyLsfGGBtgFtHt9gPtwSGCQVjoe1pc=;
	b=iFoBmS2zCST+qff6fIZasEDIowFSRUq1Rp55fKi5GxZXjxN6qZ/0KiB059STnbv05feGvt
	hOk1LRHbom6ZTtIg8qXYzeNrXgJSoAaSG19nNeO1Taz8Wpf3NVnMYhtCL4QDKg4sgBtPVc
	9EX/KMFy9VKc1MPIoOVc56UvsN0bDCk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-oU9LrQpSNXGz601KM_JK-Q-1; Mon, 10 Jul 2023 02:47:10 -0400
X-MC-Unique: oU9LrQpSNXGz601KM_JK-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F23786F124;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3619EC575E0;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E7861946586;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A03E1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 10:09:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C305F5AE2; Fri, 23 Jun 2023 10:09:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 757A1F5AC5
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 10:09:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F36F3C01BA8
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 10:09:00 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
 relay.mimecast.com with ESMTP id us-mta-645-2Cq7B8sFNk6NN7eCf1iLKg-1; Fri,
 23 Jun 2023 06:08:58 -0400
X-MC-Unique: 2Cq7B8sFNk6NN7eCf1iLKg-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61950C14;
 Fri, 23 Jun 2023 03:02:02 -0700 (PDT)
Received: from [10.1.30.17] (e122027.cambridge.arm.com [10.1.30.17])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E25C23F64C;
 Fri, 23 Jun 2023 03:01:13 -0700 (PDT)
Message-ID: <35f80572-0ba2-be54-c947-fcbe2d71ed5e@arm.com>
Date: Fri, 23 Jun 2023 11:01:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, vbabka@suse.cz, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
References: <20230622083932.4090339-1-qi.zheng@linux.dev>
 <20230622083932.4090339-6-qi.zheng@linux.dev>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20230622083932.4090339-6-qi.zheng@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 05/29] drm/panfrost: dynamically allocate the
 drm-panfrost shrinker
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
Cc: linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, dm-devel@redhat.com,
 linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, linux-bcache@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: arm.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 22/06/2023 09:39, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In preparation for implementing lockless slab shrink,
> we need to dynamically allocate the drm-panfrost shrinker,
> so that it can be freed asynchronously using kfree_rcu().
> Then it doesn't need to wait for RCU read-side critical
> section when releasing the struct panfrost_device.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_device.h    |  2 +-
>  .../gpu/drm/panfrost/panfrost_gem_shrinker.c  | 24 ++++++++++---------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
> index b0126b9fbadc..e667e5689353 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -118,7 +118,7 @@ struct panfrost_device {
>  
>  	struct mutex shrinker_lock;
>  	struct list_head shrinker_list;
> -	struct shrinker shrinker;
> +	struct shrinker *shrinker;
>  
>  	struct panfrost_devfreq pfdevfreq;
>  };
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> index bf0170782f25..2a5513eb9e1f 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> @@ -18,8 +18,7 @@
>  static unsigned long
>  panfrost_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
>  {
> -	struct panfrost_device *pfdev =
> -		container_of(shrinker, struct panfrost_device, shrinker);
> +	struct panfrost_device *pfdev = shrinker->private_data;
>  	struct drm_gem_shmem_object *shmem;
>  	unsigned long count = 0;
>  
> @@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
>  static unsigned long
>  panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
>  {
> -	struct panfrost_device *pfdev =
> -		container_of(shrinker, struct panfrost_device, shrinker);
> +	struct panfrost_device *pfdev = shrinker->private_data;
>  	struct drm_gem_shmem_object *shmem, *tmp;
>  	unsigned long freed = 0;
>  
> @@ -100,10 +98,15 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
>  void panfrost_gem_shrinker_init(struct drm_device *dev)
>  {
>  	struct panfrost_device *pfdev = dev->dev_private;
> -	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
> -	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
> -	pfdev->shrinker.seeks = DEFAULT_SEEKS;
> -	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
> +
> +	pfdev->shrinker = shrinker_alloc_and_init(panfrost_gem_shrinker_count,
> +						  panfrost_gem_shrinker_scan, 0,
> +						  DEFAULT_SEEKS, 0, pfdev);
> +	if (pfdev->shrinker &&
> +	    register_shrinker(pfdev->shrinker, "drm-panfrost")) {
> +		shrinker_free(pfdev->shrinker);
> +		WARN_ON(1);
> +	}

So we didn't have good error handling here before, but this is
significantly worse. Previously if register_shrinker() failed then the
driver could safely continue without a shrinker - it would waste memory
but still function.

However we now have two failure conditions:
 * shrinker_alloc_init() returns NULL. No warning and NULL deferences
   will happen later.

 * register_shrinker() fails, shrinker_free() will free pdev->shrinker
   we get a warning, but followed by a use-after-free later.

I think we need to modify panfrost_gem_shrinker_init() to be able to
return an error, so a change something like the below (untested) before
your change.

Steve

----8<---
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c
b/drivers/gpu/drm/panfrost/panfrost_drv.c
index bbada731bbbd..f705bbdea360 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -598,10 +598,14 @@ static int panfrost_probe(struct platform_device
*pdev)
 	if (err < 0)
 		goto err_out1;

-	panfrost_gem_shrinker_init(ddev);
+	err = panfrost_gem_shrinker_init(ddev);
+	if (err)
+		goto err_out2;

 	return 0;

+err_out2:
+	drm_dev_unregister(ddev);
 err_out1:
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h
b/drivers/gpu/drm/panfrost/panfrost_gem.h
index ad2877eeeccd..863d2ec8d4f0 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -81,7 +81,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
 void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);

-void panfrost_gem_shrinker_init(struct drm_device *dev);
+int panfrost_gem_shrinker_init(struct drm_device *dev);
 void panfrost_gem_shrinker_cleanup(struct drm_device *dev);

 #endif /* __PANFROST_GEM_H__ */
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
index bf0170782f25..90265b37636f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -97,13 +97,17 @@ panfrost_gem_shrinker_scan(struct shrinker
*shrinker, struct shrink_control *sc)
  *
  * This function registers and sets up the panfrost shrinker.
  */
-void panfrost_gem_shrinker_init(struct drm_device *dev)
+int panfrost_gem_shrinker_init(struct drm_device *dev)
 {
 	struct panfrost_device *pfdev = dev->dev_private;
+	int ret;
+
 	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
 	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
 	pfdev->shrinker.seeks = DEFAULT_SEEKS;
-	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
+	ret = register_shrinker(&pfdev->shrinker, "drm-panfrost");
+
+	return ret;
 }

 /**

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

