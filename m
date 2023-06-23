Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCD1EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971626;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=osWCrL8kzENEWPzyeRcPHCPyby+yJlTyyaFTrIxUfg8=;
	b=OHvUwFdhgZ4hA39mIvS2rHz3V0uC1FQKo+/3KXdbhLKgDp7jlDmqVjWM3rYMg44bFWjOUf
	V4+SfqwxO+rnA/qeT+8Zj8K21WJQbKFIwcBhoABILxFuZvIudscJ/Fe6xiebdHJozrONlX
	08uPC11pYjM8eAfSsJ/mzPFD/emW51M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-VV4-y8u5Mi6v8c99NmCDcw-1; Mon, 10 Jul 2023 02:47:00 -0400
X-MC-Unique: VV4-y8u5Mi6v8c99NmCDcw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D008870D1;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E88FC4CD0C9;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A840A19451E3;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F9B91946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 13:33:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CFD3D2166B32; Fri, 23 Jun 2023 13:33:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C744F2166B25
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:33:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A81C3185A7A8
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:33:37 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-yoj_Fvq7Pli8wMqhxhEorA-1; Fri, 23 Jun 2023 09:33:36 -0400
X-MC-Unique: yoj_Fvq7Pli8wMqhxhEorA-1
Received: by mail-pl1-f172.google.com with SMTP id
 d9443c01a7336-1b5466bc5f8so910825ad.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687527214; x=1690119214;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ACoox6lHywQa9wO0MGPPVAOCZzDjfudqnGd2G0lw0os=;
 b=OxSm1+CYJ58TVAqDnJ0N4OoXg+jXZu8sufntqsGynojUWDbFBfeewqv/hHw66/UTR1
 QE+fCNtn8rZgS53kEVRarcF2abgezudd49uvTvdspiffBIuUlQl94nYSoCvd1A3zWZR2
 sszmo+xTwzsulMRewIdkYcYyDGgjPZ1NkROKTFPX4TD7oSTf9igBUYZK2t+/KXf+GvXx
 fLrTZMGnMk5RseGadlNq9Qsgi2dZfH/srGj2K3y263gMEqQtA6AVT8WbZKg1qJW7HsVE
 20QgFG1kl5UdQLpiOMfjH58QZhkD3xjMzlgThKcKNYHDoqgqk4G/Lne9130oLuCj47cj
 5xdw==
X-Gm-Message-State: AC+VfDwt/Pkyk9PZd4Z74VVfE/G+Zw4c1CIsPBAHVV5g8vNtwtntfW2Q
 htxdTSCwT9ut6phuhstP+2FZnA==
X-Google-Smtp-Source: ACHHUZ7fC8cfi9SbpxWbw1P19vY2WFeiY5bxjWE/lWxj83YOdeMLdFfAi7QBoo42W5+SZOFqK06Ryw==
X-Received: by 2002:a17:902:c945:b0:1ae:3ff8:7fa7 with SMTP id
 i5-20020a170902c94500b001ae3ff87fa7mr26069073pla.4.1687527213878; 
 Fri, 23 Jun 2023 06:33:33 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 kg14-20020a170903060e00b001b6a27dff99sm4341406plb.159.2023.06.23.06.33.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 06:33:33 -0700 (PDT)
Message-ID: <43a07dbe-5049-8596-da58-51e0a0d6243c@bytedance.com>
Date: Fri, 23 Jun 2023 21:33:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Steven Price <steven.price@arm.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-6-zhengqi.arch@bytedance.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230622085335.77010-6-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev, david@fromorbit.com,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, brauner@kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, vbabka@suse.cz,
 linux-nfs@vger.kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Steven,

The email you replied to was the failed version (due to the error
below), so I copied your reply and replied to you on this successful
version.

(4.7.1 Error: too many recipients from 49.7.199.173)

On 2023/6/23 18:01, Steven Price wrote:
 > On 22/06/2023 09:39, Qi Zheng wrote:
 >> From: Qi Zheng <zhengqi.arch@bytedance.com>
 >>
 >> In preparation for implementing lockless slab shrink,
 >> we need to dynamically allocate the drm-panfrost shrinker,
 >> so that it can be freed asynchronously using kfree_rcu().
 >> Then it doesn't need to wait for RCU read-side critical
 >> section when releasing the struct panfrost_device.
 >>
 >> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
 >> ---
 >>   drivers/gpu/drm/panfrost/panfrost_device.h    |  2 +-
 >>   .../gpu/drm/panfrost/panfrost_gem_shrinker.c  | 24 ++++++++++---------
 >>   2 files changed, 14 insertions(+), 12 deletions(-)
 >>
 >> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h 
b/drivers/gpu/drm/panfrost/panfrost_device.h
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
 >> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c 
b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 >> index bf0170782f25..2a5513eb9e1f 100644
 >> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 >> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 >> @@ -18,8 +18,7 @@
 >>   static unsigned long
 >>   panfrost_gem_shrinker_count(struct shrinker *shrinker, struct 
shrink_control *sc)
 >>   {
 >> -	struct panfrost_device *pfdev =
 >> -		container_of(shrinker, struct panfrost_device, shrinker);
 >> +	struct panfrost_device *pfdev = shrinker->private_data;
 >>   	struct drm_gem_shmem_object *shmem;
 >>   	unsigned long count = 0;
 >>
 >> @@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct 
drm_gem_object *obj)
 >>   static unsigned long
 >>   panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct 
shrink_control *sc)
 >>   {
 >> -	struct panfrost_device *pfdev =
 >> -		container_of(shrinker, struct panfrost_device, shrinker);
 >> +	struct panfrost_device *pfdev = shrinker->private_data;
 >>   	struct drm_gem_shmem_object *shmem, *tmp;
 >>   	unsigned long freed = 0;
 >>
 >> @@ -100,10 +98,15 @@ panfrost_gem_shrinker_scan(struct shrinker 
*shrinker, struct shrink_control *sc)
 >>   void panfrost_gem_shrinker_init(struct drm_device *dev)
 >>   {
 >>   	struct panfrost_device *pfdev = dev->dev_private;
 >> -	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
 >> -	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
 >> -	pfdev->shrinker.seeks = DEFAULT_SEEKS;
 >> -	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
 >> +
 >> +	pfdev->shrinker = shrinker_alloc_and_init(panfrost_gem_shrinker_count,
 >> +						  panfrost_gem_shrinker_scan, 0,
 >> +						  DEFAULT_SEEKS, 0, pfdev);
 >> +	if (pfdev->shrinker &&
 >> +	    register_shrinker(pfdev->shrinker, "drm-panfrost")) {
 >> +		shrinker_free(pfdev->shrinker);
 >> +		WARN_ON(1);
 >> +	}
 >
 > So we didn't have good error handling here before, but this is
 > significantly worse. Previously if register_shrinker() failed then the
 > driver could safely continue without a shrinker - it would waste memory
 > but still function.
 >
 > However we now have two failure conditions:
 >   * shrinker_alloc_init() returns NULL. No warning and NULL deferences
 >     will happen later.
 >
 >   * register_shrinker() fails, shrinker_free() will free pdev->shrinker
 >     we get a warning, but followed by a use-after-free later.
 >
 > I think we need to modify panfrost_gem_shrinker_init() to be able to
 > return an error, so a change something like the below (untested) before
 > your change.

Indeed. I will fix it in the v2.

Thanks,
Qi

 >
 > Steve
 >
 > ----8<---
 > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c
 > b/drivers/gpu/drm/panfrost/panfrost_drv.c
 > index bbada731bbbd..f705bbdea360 100644
 > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
 > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
 > @@ -598,10 +598,14 @@ static int panfrost_probe(struct platform_device
 > *pdev)
 >   	if (err < 0)
 >   		goto err_out1;
 >
 > -	panfrost_gem_shrinker_init(ddev);
 > +	err = panfrost_gem_shrinker_init(ddev);
 > +	if (err)
 > +		goto err_out2;
 >
 >   	return 0;
 >
 > +err_out2:
 > +	drm_dev_unregister(ddev);
 >   err_out1:
 >   	pm_runtime_disable(pfdev->dev);
 >   	panfrost_device_fini(pfdev);
 > diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h
 > b/drivers/gpu/drm/panfrost/panfrost_gem.h
 > index ad2877eeeccd..863d2ec8d4f0 100644
 > --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
 > +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
 > @@ -81,7 +81,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object 
*bo,
 >   void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
 >   void panfrost_gem_teardown_mappings_locked(struct 
panfrost_gem_object *bo);
 >
 > -void panfrost_gem_shrinker_init(struct drm_device *dev);
 > +int panfrost_gem_shrinker_init(struct drm_device *dev);
 >   void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
 >
 >   #endif /* __PANFROST_GEM_H__ */
 > diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 > b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 > index bf0170782f25..90265b37636f 100644
 > --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 > +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
 > @@ -97,13 +97,17 @@ panfrost_gem_shrinker_scan(struct shrinker
 > *shrinker, struct shrink_control *sc)
 >    *
 >    * This function registers and sets up the panfrost shrinker.
 >    */
 > -void panfrost_gem_shrinker_init(struct drm_device *dev)
 > +int panfrost_gem_shrinker_init(struct drm_device *dev)
 >   {
 >   	struct panfrost_device *pfdev = dev->dev_private;
 > +	int ret;
 > +
 >   	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
 >   	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
 >   	pfdev->shrinker.seeks = DEFAULT_SEEKS;
 > -	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
 > +	ret = register_shrinker(&pfdev->shrinker, "drm-panfrost");
 > +
 > +	return ret;
 >   }
 >
 >   /**
 >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

