Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3C184C
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705541911; cv=none; b=WVE/N9o7N60HnpOi7l9qaXjEGEdqxPSL868oBp2DppSRrebrq+dWAYp0MCJJw8vhMCZeVwfrUm+6c4kc7BoE0mHJwR4ADYvEOE6nIZQx56wa45fZZe3DKj+D93nAwXkyhkVNbnU3sGpqU3udAEk1SrLSkYRJcTaxmLdeBNo/cuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705541911; c=relaxed/simple;
	bh=kvY6aq6aiZTEhNJ/hVQmhim6tnXRmjCZLKqNocrwsEk=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=sHc+Gu4qkU71jAaoFfV+ecrQ6ulOkbqkM9Vcl/essxUgBesAUGYJTzz7dLFWzy1OSFJyfpv3KYyhtI1DwHh2mpygNHk7+4ooelhpFtfZgC9YQpgZrYwSCvurgpUSce91LVgcZb+sipL6qp+H0mFNtb5H7a6HssUxjMZ6zMjtj5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TFlkk1qZMz4f3knc
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:38:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 061F51A017A
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:38:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBEQgahl7ZqsBA--.6704S3;
	Thu, 18 Jan 2024 09:38:25 +0800 (CST)
Subject: Re: [PATCH 4/7] md: call md_reap_sync_thread from __md_stop_writes
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <ceeca667-ecc5-a776-8c89-9bf6facb93c9@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e72fde6f-8556-a0ba-ecf4-c4b9102e8345@huaweicloud.com>
Date: Thu, 18 Jan 2024 09:38:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ceeca667-ecc5-a776-8c89-9bf6facb93c9@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBEQgahl7ZqsBA--.6704S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF48uFW3try5urWkKw1DAwb_yoW8GrWrpa
	yktFyfCr15ArW5Ary7W3WkZa4ru3W7trW7tryxC34rAr1UGwn8Jr1YgFW5XFyDCa48AF43
	Jr4rJFs5Zr4kJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU189N3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/18 2:20, Mikulas Patocka Ð´µÀ:
> The commit f52f5c71f3d4 ("md: fix stopping sync thread") breaks the LVM2
> test shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
> 
> There are many places that test for MD_RECOVERY_RUNNING or
> mddev->sync_thread. If we don't reap the thread, they would be confused.

Please stop this... make sure you understand the lifetime of
sync_thread before you send such patch. I already explained in
f52f5c71f3d4 why md_reap_sync_thread() can't be called here.

Thanks,
Kuai

> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Cc: stable@vger.kernel.org	# v6.7
> 
> ---
>   drivers/md/md.c |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -6308,6 +6308,12 @@ static void md_clean(struct mddev *mddev
>   static void __md_stop_writes(struct mddev *mddev)
>   {
>   	stop_sync_thread(mddev, true, false);
> +
> +	if (mddev->sync_thread) {
> +		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		md_reap_sync_thread(mddev);
> +	}
> +
>   	del_timer_sync(&mddev->safemode_timer);
>   
>   	if (mddev->pers && mddev->pers->quiesce) {
> 
> .
> 

