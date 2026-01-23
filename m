Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEB833AD86
	for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769130783; cv=none; b=tIBS4jdm6PQQiiFz5UAzqJz2/miNaswBGGeYR1nVMEJ8RAEjiP1yL+a0N4j7pksH6tspUgDzjJr7AyXmiRMUOEMSmV/8iAK7EPZH5H+kpy/FE29QxApDw2evwd58InJSywrcMUr9Zjjs7tu4BFHS+Moh0LqG/0K3WC/lyZ0yjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769130783; c=relaxed/simple;
	bh=nRqQh1e6kqXfsQKpQchv2Kr6fKHES4hgTe2NVIHYxhs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=o6s48RPmugjOVcirVZ0CzW97P3PKRmrhIbvxMFYf7cg+6yXmF7RMlwXIMa5gYNlKtPQTHhjPxJ1X5dUGeIpcUkq1Piikp4TO621969HCLMDgYYaqkBM0x8u6K+1o2yH4VeFRZaxwwE898LJFLDR723Kc+G87xdni60xP9eeqUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=IXchoiHI; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="IXchoiHI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EqSFwWaHj3BXE3atn7N/43CJSCDKjNteurpgL+F/ltw=;
	b=IXchoiHIYctXaQ8I7ortzFUuZWaiemL27TyNperRwJOTG53GEpsF4bY9R1CuMiP2Z0iQ+mBV4
	v54sCdyzQpuVcNJ8NlwCE9TYBZkPXBCgnQtTgR1A+xb9NMRlNYE7hlf6gM5CIYCmr+POMPFZSs1
	FRDP6LVnNj5/lYM2kerhX/g=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dy0Fj6Kp3zRhQR;
	Fri, 23 Jan 2026 09:09:29 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id DEC3740537;
	Fri, 23 Jan 2026 09:12:54 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemk500005.china.huawei.com (7.202.194.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Jan 2026 09:12:54 +0800
Subject: Re: [PATCH] dm: pass origin bio's bdev to bio_alloc_clone
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<bmarzins@redhat.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>, <lilingfeng3@huawei.com>
References: <20260116120744.908987-1-chengzhihao1@huawei.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <bb49f820-473a-a951-60b0-32dcd8fb0110@huawei.com>
Date: Fri, 23 Jan 2026 09:12:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260116120744.908987-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk500005.china.huawei.com (7.202.194.90)

ÔÚ 2026/1/16 20:07, Zhihao Cheng Ð´µÀ:

friendly ping

> The origin bio carries blk-cgroup information which could be set from
> foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
> control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
> bio_alloc_clone"). The synchronous io is still under control by blkcg,
> because 'bio->bi_blkg' is set by io submitting task which has been
> added into 'cgroup.procs'.
> 
> Fix it by passing origin bio's bdev to bio_alloc_clone.
> 
> Fetch a reproducer in [Link].
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
> Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>   drivers/md/dm.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b63279202260..e763e3b02a9f 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -574,7 +574,8 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio, gfp_t g
>   	struct dm_target_io *tio;
>   	struct bio *clone;
>   
> -	clone = bio_alloc_clone(NULL, bio, gfp_mask, &md->mempools->io_bs);
> +	clone = bio_alloc_clone(bio->bi_bdev, bio,
> +				gfp_mask, &md->mempools->io_bs);
>   	if (unlikely(!clone))
>   		return NULL;
>   	tio = clone_to_tio(clone);
> @@ -623,7 +624,7 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
>   		/* alloc_io() already initialized embedded clone */
>   		clone = &tio->clone;
>   	} else {
> -		clone = bio_alloc_clone(NULL, ci->bio, gfp_mask,
> +		clone = bio_alloc_clone(ci->bio->bi_bdev, ci->bio, gfp_mask,
>   					&md->mempools->bs);
>   		if (!clone)
>   			return NULL;
> 

