Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E927BF6C
	for <dm-devel@lists.linux.dev>; Sat, 24 Jan 2026 07:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769239421; cv=none; b=CAdTstMnX7el3xX52GVu1rDude5C1UPIXrpjdm91qJZGcLqxk1gzF1b7bNGO+G15p5imvl7cKKnreKOt0nLPHqb0UDpneg7NSeFPxxgChVvv/UGQrHfeZWbGzslI5fhmAMbr7qOXOerlgKz6QUVjHIH/ncEdJXlVQWl8HVPzj7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769239421; c=relaxed/simple;
	bh=TRotv7BHcQPB9g3ULUd4D12TlFbtZQu/XzHl5XyduwA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GIEu/e7AWivXkH35ZVc3xzOOXqAzz4StRKbMXgnDc/x6hJvWkZiS/Yt/IYdrNW1yz8gWSnenVoQYRZHguVuqR8f/4SvbI18W3XKzXUuBz1lZH1DgUNTNCvkTEkhOrwufxbLQOAVQd2uD0qQkTrhLgRCZSk79yV/FNA38TEj0V6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pEmOfFWd; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pEmOfFWd"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MfaiwJ1SK1SD6c/fEYnCRn7c352L2HDgDTtc8ot6HMU=;
	b=pEmOfFWdkY47bDh36dnJSAkGDeMZMKYSksRidTiDumy2kiSE79t90/h6V7B+2M3YIIAomV5SW
	JnpT2gnHUxpuOSDXSMJxqY1WqTJ2vvI1Y/LMd3ayJBHDGWC0NzJEcK+M20A3uBjXHYLCav8aFwL
	It0fo/u/74XkRtD/Ek8z4t4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dymQp0ttBz1prLp;
	Sat, 24 Jan 2026 15:20:02 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BEEA40570;
	Sat, 24 Jan 2026 15:23:29 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemk500005.china.huawei.com (7.202.194.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 24 Jan 2026 15:23:28 +0800
Subject: Re: [PATCH] dm: pass origin bio's bdev to bio_alloc_clone
To: Mikulas Patocka <mpatocka@redhat.com>
CC: <agk@redhat.com>, <snitzer@kernel.org>, <bmarzins@redhat.com>,
	<dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>, <lilingfeng3@huawei.com>
References: <20260116120744.908987-1-chengzhihao1@huawei.com>
 <bb49f820-473a-a951-60b0-32dcd8fb0110@huawei.com>
 <b3731751-c286-f61e-95ab-c59f9aba98d0@redhat.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <2ae755f4-43ea-1e8d-48f8-dffb38ee9773@huawei.com>
Date: Sat, 24 Jan 2026 15:23:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b3731751-c286-f61e-95ab-c59f9aba98d0@redhat.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500005.china.huawei.com (7.202.194.90)

在 2026/1/24 0:16, Mikulas Patocka 写道:
> 
> 
> On Fri, 23 Jan 2026, Zhihao Cheng wrote:
> 
>> 在 2026/1/16 20:07, Zhihao Cheng 写道:
>>
>> friendly ping
> 
> Hi
> 
> I find it quite hacky to set bi_bdev and overwrite it later. I came up
> with this patch that clones the control group association explictely, it
> fixes your testcase. Please test it and report if it works for you.
> 
> Mikulas
> 

Thanks for the patch, it works.

Tested-by: Zhihao Cheng <chengzhihao1@huawei.com>

> 
> dm: use bio_clone_blkg_association
> 
> The origin bio carries blk-cgroup information which could be set from
> foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
> control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
> bio_alloc_clone"). The synchronous io is still under control by blkcg,
> because 'bio->bi_blkg' is set by io submitting task which has been added
> into 'cgroup.procs'.
> 
> Fix it by using bio_clone_blkg_association when submitting a cloned bio.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
> Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
> Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>   drivers/md/dm.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2026-01-06 15:55:41.000000000 +0100
> +++ linux-2.6/drivers/md/dm.c	2026-01-23 17:07:50.000000000 +0100
> @@ -1364,6 +1364,8 @@ void dm_submit_bio_remap(struct bio *clo
>   	if (!tgt_clone)
>   		tgt_clone = clone;
>   
> +	bio_clone_blkg_association(tgt_clone, io->orig_bio);
> +
>   	/*
>   	 * Account io->origin_bio to DM dev on behalf of target
>   	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
> 

