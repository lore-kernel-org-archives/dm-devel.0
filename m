Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE5226D18
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752907756; cv=none; b=EsE6LQ4rTVbrHVpqpm7q3p42/hCm4y7DxBLdQuDOIeQW+hXcpkvYmMFuATsMrTgazzeVthBC0jXBSy4Tb4+Szb2IjlCWg330WCqV3ubWw/c49wrIvhRUf/+myIf7VoMwZZwBGA645ABdCBwWopMjmVRXQG+ZH/vqKlCCLiE9zgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752907756; c=relaxed/simple;
	bh=kxdB6V/A9iBSlknMAs0moABiseCV1oQqESUopgkYZn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q36Dr2ZFuq0JYPmdxHYKXdreGILvdwgjEweVni/x2TPIKQVxhfjUMmmWYS0MraVJ9I/LS4sZ0Sa7DYOCfRbPCE+rDE5WvT0HYAnIni2vkzor9Z+wOKI5YSSPUOG8xeTgiL/31xO/AMhwfjzvRNWq3zSZuRkCmskEsrK3yDekGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bkchQ0XtnzKHLyg
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 14:49:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B61401A12CF
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 14:49:08 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDnYhPiP3tonuMMAw--.29572S3;
	Sat, 19 Jul 2025 14:49:08 +0800 (CST)
Message-ID: <d1ee0f33-40e9-5586-36ec-88192747998f@huaweicloud.com>
Date: Sat, 19 Jul 2025 14:49:06 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, corbet@lwn.net, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai3@huawei.com, hare@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-7-yukuai1@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250718092336.3346644-7-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnYhPiP3tonuMMAw--.29572S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF43AF1DKw4xtw48Cr4fAFb_yoW5try3p3
	97JF9xCr4rJrWSqa17Xa4q9F1rZrn7trZayryIqw1rGrnrWrnxWa1FgF4Utw1kGa4xuF4D
	Zw45tr48Cr1j9F7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87
	Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/7/18 17:23, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently bitmap_ops is registered while allocating mddev, this is fine
> when there is only one bitmap_ops.
> 
> Delay setting bitmap_ops until creating bitmap, so that user can choose
> which bitmap to use before running the array.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   Documentation/admin-guide/md.rst |  3 ++
>   drivers/md/md.c                  | 82 +++++++++++++++++++++-----------
>   2 files changed, 56 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> index 356d2a344f08..03a9f5025f99 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -388,6 +388,9 @@ All md devices contain:
>        bitmap
>            The default internal bitmap
>   
> +If bitmap_type is not none, then additional bitmap attributes will be
> +created after md device KOBJ_CHANGE event.
> +
>   If bitmap_type is bitmap, then the md device will also contain:
>   
>     bitmap/location
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d8b0dfdb4bfc..639b0143cbb1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -674,9 +674,11 @@ static void no_op(struct percpu_ref *r) {}
>   
>   static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   {
> +	struct bitmap_operations *old = mddev->bitmap_ops;
>   	struct md_submodule_head *head;
>   
> -	if (mddev->bitmap_id == ID_BITMAP_NONE)
> +	if (mddev->bitmap_id == ID_BITMAP_NONE ||
> +	    (old && old->head.id == mddev->bitmap_id))
>   		return true;
>   
>   	xa_lock(&md_submodule);
> @@ -694,6 +696,18 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   
>   	mddev->bitmap_ops = (void *)head;
>   	xa_unlock(&md_submodule);
> +
> +	if (mddev->bitmap_ops->group) {
> +		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> +			pr_warn("md: cannot register extra bitmap attributes for %s\n",
> +				mdname(mddev));
> +		else
> +			/*
> +			 * Inform user with KOBJ_CHANGE about new bitmap
> +			 * attributes.
> +			 */
> +			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
> +	}
>   	return true;
>   
>   err:
> @@ -703,28 +717,25 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   
>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>   {
> +	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
> +		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +
>   	mddev->bitmap_ops = NULL;
>   }
>   
>   int mddev_init(struct mddev *mddev)
>   {
> -	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
> +	if (!IS_ENABLED(CONFIG_MD_BITMAP))
>   		mddev->bitmap_id = ID_BITMAP_NONE;
> -	} else {
> +	else
>   		mddev->bitmap_id = ID_BITMAP;

'bitmap_id' is set here.

> -		if (!mddev_set_bitmap_ops(mddev))
> -			return -EINVAL;
> -	}
>   
>   	if (percpu_ref_init(&mddev->active_io, active_io_release,
> -			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
>   		return -ENOMEM;
> -	}
>   
>   	if (percpu_ref_init(&mddev->writes_pending, no_op,
>   			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
>   		percpu_ref_exit(&mddev->active_io);
>   		return -ENOMEM;
>   	}
> @@ -752,6 +763,7 @@ int mddev_init(struct mddev *mddev)
>   	mddev->resync_min = 0;
>   	mddev->resync_max = MaxSector;
>   	mddev->level = LEVEL_NONE;
> +	mddev->bitmap_id = ID_BITMAP;
>   

This change is wrong.

-- 
Thanks,
Nan

