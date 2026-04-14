Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B911C84A0
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 01:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776129929; cv=none; b=f69VkRgfXHloqbFK56QWj4fESJ5K4k+OFax9XuJx1O560FaEzLe2GqvyVWOFHnnpriGtCld49DrWXHJkj9IATUgighdqJSLulO43qr0mvN+Dl8JqBVwrBT3JLqh3BHYB5Qtc7D/cDeKCYpZSk7uBUl9Ftmsg0ZT788mDEJXo8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776129929; c=relaxed/simple;
	bh=YAYb9y/TTjBWHdZIb4mdpDSVQ4V596B7tbzcj3SXob4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUFaNX36Nk3JvBT7VEZgmzsrf1GFznJZPktsKPWzU64dvb0gQk8g/ZAth9/dd97BNu0IkaamI14c5EsVLV75G4cGaBWwZsp2uMXF8vlNbWUAn+MHOf3qCJZ+RjypKfxoJJiEkVT7LzDS0rVpU9lx9zcq/7ZUNZrFsTYa7uATprk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fvmmW2Dt7zKHLyK
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 09:25:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id ABF0E4056B
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 09:25:22 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgB3JL5_l91pFCFMAQ--.10291S3;
	Tue, 14 Apr 2026 09:25:21 +0800 (CST)
Message-ID: <0e53701a-2471-9b72-eef8-27b168a0f3ea@huaweicloud.com>
Date: Tue, 14 Apr 2026 09:25:19 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid5: Don't set bi_status on STRIPE_WAIT_RESHAPE
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
 Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 Xiao Ni <xni@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
References: <20260413224556.1914504-1-bmarzins@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260413224556.1914504-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3JL5_l91pFCFMAQ--.10291S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF15Jw4fGw4xJFykAr1kXwb_yoW8WF4kpa
	y09a1a9wn0qrykK39rJ3yUuFZ0g397try5Kan7tw4xXr1YqryF9r43JrW5WF1UZa4v93y3
	Jr1rZryDGF4YqrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/14 6:45, Benjamin Marzinski 写道:
> When make_stripe_request() encounters a clone bio that crosses the
> reshape position while the reshape cannot make progress, it was setting
> bi->bi_status to BLK_STS_RESOURCE when returning STRIPE_WAIT_RESHAPE.
> This will update the original bio's bi_status in md_end_clone_io().
> Afterwards, md_handle_request() will wait for the device to become
> unsuspended and submit a new cloned bio. However, even if that clone
> completes successfully, it will not clear the original bio's bi_status.
> 
> There's no need to set bi_status when retrying the bio. md will already
> error out the bio correctly if it is set REQ_NOWAIT. Otherwise it will
> be retried. dm-raid will already end the bio with DM_MAPIO_REQUEUE.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   drivers/md/raid5.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc0c680ca199..690c65cd1e29 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6042,7 +6042,6 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>   	raid5_release_stripe(sh);
>   out:
>   	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
> -		bi->bi_status = BLK_STS_RESOURCE;
>   		ret = STRIPE_WAIT_RESHAPE;
>   		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
>   	}

The link below leads to the same patch, which Kuai has already replied to.

https://lore.kernel.org/all/20260203095156.2349174-1-yangxiuwei@kylinos.cn/

-- 
Thanks,
Nan

