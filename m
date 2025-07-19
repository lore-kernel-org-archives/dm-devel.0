Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1C226CFC;
	Sat, 19 Jul 2025 09:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752918318; cv=none; b=hvs920l2s5ZfJBlA2gpaymkm/4JJvzOhATcQLyCRcIPGnWB5YFLJracEi3Q0uGgKtD5EDZYkvUhY5ByPpuNIRxYkoKYDfYFuA2USRrnKkFzakYpvp5pu2Q64BtMzTxOeVqvCqQELtakX3pCnZqubfTKjBhTlSocaojhDwF4U96I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752918318; c=relaxed/simple;
	bh=iD7ucfJCLaeFWLd5pm5ybngWi/yYyikgLfWXPTI9zj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTaEClwiTyxILpI7rsIp+T23KhdhnF8pIYYqTkdaXiJZMa1++XBsikMRXQV3etKW2F3d+TcgvCgvXf2Wa4y4xCKa2tV2oQSU7su0VH1eIu5xVVdT7/frS3Q3hcS1iK1W2k4RDViSv6qra5MGUxivvNd+BEYwyyCGQouAUgtvobU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyLYGKvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyLYGKvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC20C4CEE3;
	Sat, 19 Jul 2025 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752918317;
	bh=iD7ucfJCLaeFWLd5pm5ybngWi/yYyikgLfWXPTI9zj8=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qyLYGKvTU3EK/wuhQzqnvKQhHuWxy9xNHTraSW1Bt9yXg82Fvs7W6xyfm8CDRyIm6
	 hVXMxr/m8UhhwQwZl8yjbM+2KHhDXqXtzmYai7UtT+yYOg/p8xssAh/vGR6bWD7QR2
	 9dL+dP68B6LBeRvS4jO2fH4qJyiUl6pGhs69vPnYzs5dSrYixAz4uLn7aLLQv6u0Vv
	 ZMHaoGxGcP3bIVFCYJmw0VXRTf8DHEIv5JyTgNxK/3YYRvpXwH9Q3yHG12nifpyLMI
	 jmZB/hkod30obPXlXTXqnNx2ZclFn8nM5GZvlg2p1Ez4vtkkHyWa27Mh+djU8WZ4Zz
	 vO20inDrhvmjQ==
Message-ID: <a41300dd-22af-4619-9b68-a5cd6f8aa259@kernel.org>
Date: Sat, 19 Jul 2025 17:45:06 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v3 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Li Nan <linan666@huaweicloud.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 corbet@lwn.net, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai3@huawei.com, hare@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-7-yukuai1@huaweicloud.com>
 <d1ee0f33-40e9-5586-36ec-88192747998f@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <d1ee0f33-40e9-5586-36ec-88192747998f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/7/19 14:49, Li Nan 写道:
>
>
> 在 2025/7/18 17:23, Yu Kuai 写道:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently bitmap_ops is registered while allocating mddev, this is fine
>> when there is only one bitmap_ops.
>>
>> Delay setting bitmap_ops until creating bitmap, so that user can choose
>> which bitmap to use before running the array.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   Documentation/admin-guide/md.rst |  3 ++
>>   drivers/md/md.c                  | 82 +++++++++++++++++++++-----------
>>   2 files changed, 56 insertions(+), 29 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/md.rst 
>> b/Documentation/admin-guide/md.rst
>> index 356d2a344f08..03a9f5025f99 100644
>> --- a/Documentation/admin-guide/md.rst
>> +++ b/Documentation/admin-guide/md.rst
>> @@ -388,6 +388,9 @@ All md devices contain:
>>        bitmap
>>            The default internal bitmap
>>   +If bitmap_type is not none, then additional bitmap attributes will be
>> +created after md device KOBJ_CHANGE event.
>> +
>>   If bitmap_type is bitmap, then the md device will also contain:
>>       bitmap/location
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index d8b0dfdb4bfc..639b0143cbb1 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -674,9 +674,11 @@ static void no_op(struct percpu_ref *r) {}
>>     static bool mddev_set_bitmap_ops(struct mddev *mddev)
>>   {
>> +    struct bitmap_operations *old = mddev->bitmap_ops;
>>       struct md_submodule_head *head;
>>   -    if (mddev->bitmap_id == ID_BITMAP_NONE)
>> +    if (mddev->bitmap_id == ID_BITMAP_NONE ||
>> +        (old && old->head.id == mddev->bitmap_id))
>>           return true;
>>         xa_lock(&md_submodule);
>> @@ -694,6 +696,18 @@ static bool mddev_set_bitmap_ops(struct mddev 
>> *mddev)
>>         mddev->bitmap_ops = (void *)head;
>>       xa_unlock(&md_submodule);
>> +
>> +    if (mddev->bitmap_ops->group) {
>> +        if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
>> +            pr_warn("md: cannot register extra bitmap attributes for 
>> %s\n",
>> +                mdname(mddev));
>> +        else
>> +            /*
>> +             * Inform user with KOBJ_CHANGE about new bitmap
>> +             * attributes.
>> +             */
>> +            kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
>> +    }
>>       return true;
>>     err:
>> @@ -703,28 +717,25 @@ static bool mddev_set_bitmap_ops(struct mddev 
>> *mddev)
>>     static void mddev_clear_bitmap_ops(struct mddev *mddev)
>>   {
>> +    if (mddev->bitmap_ops && mddev->bitmap_ops->group)
>> +        sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
>> +
>>       mddev->bitmap_ops = NULL;
>>   }
>>     int mddev_init(struct mddev *mddev)
>>   {
>> -    if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
>> +    if (!IS_ENABLED(CONFIG_MD_BITMAP))
>>           mddev->bitmap_id = ID_BITMAP_NONE;
>> -    } else {
>> +    else
>>           mddev->bitmap_id = ID_BITMAP;
>
> 'bitmap_id' is set here.
>
>> -        if (!mddev_set_bitmap_ops(mddev))
>> -            return -EINVAL;
>> -    }
>>         if (percpu_ref_init(&mddev->active_io, active_io_release,
>> -                PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -        mddev_clear_bitmap_ops(mddev);
>> +                PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
>>           return -ENOMEM;
>> -    }
>>         if (percpu_ref_init(&mddev->writes_pending, no_op,
>>                   PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> -        mddev_clear_bitmap_ops(mddev);
>>           percpu_ref_exit(&mddev->active_io);
>>           return -ENOMEM;
>>       }
>> @@ -752,6 +763,7 @@ int mddev_init(struct mddev *mddev)
>>       mddev->resync_min = 0;
>>       mddev->resync_max = MaxSector;
>>       mddev->level = LEVEL_NONE;
>> +    mddev->bitmap_id = ID_BITMAP;
>
> This change is wrong.

Yes, this line from v1 should be removed. Will change this in v3.

Thanks,
Kuai


