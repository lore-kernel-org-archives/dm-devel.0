Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C68C25E47D
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745917686; cv=none; b=GGWajrwfAoVf9ySRASM1m19wH+c1o4CsneTazgfbPaspgLz1HIV48Ba9kJUZBEWNIlCnFuW6y38fZSQRTHNmZdU1rCfRg1C2pvy0xJCX5QAQ0AmqN+szbOZJcn6Kk7h0gDHF6YvhpviOEYLiTi9s+Q+lLB4CaKDcP26dM8MuVXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745917686; c=relaxed/simple;
	bh=nOG64ITV9vXyXrwAzqO+s2gFVyK6Pd0RNJM0U1lskN0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hQm0fMdEU5bW09KEh0oTqg/OOtH2S6nKuzOhdyhPMkVQIYhPI0QNpEAsoqS8+EY/K4gho2S0PN2Vevtuyf2kQklDsteXOLN53Ruassy9PBkm5MfvDo9/04JGdXAg28uFIRFSSVX3miT1p9yO6/VcGZlI58fZljDBYta7fSJYCsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zmvbv5BLPzKHMm4
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 17:07:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ADA241A1769
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 17:07:54 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl_olhBoO4KgKw--.58664S3;
	Tue, 29 Apr 2025 17:07:54 +0800 (CST)
Subject: Re: [PATCH v2 4/9] block: cleanup blk_mq_in_flight_rw()
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, cl@linux.com,
 nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-5-yukuai1@huaweicloud.com>
 <2f140d8b-6a2a-41af-ba73-0963713f211e@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3de1a819-050e-fc3d-f369-302b3824e9d2@huaweicloud.com>
Date: Tue, 29 Apr 2025 17:07:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2f140d8b-6a2a-41af-ba73-0963713f211e@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl_olhBoO4KgKw--.58664S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4DGry3JFWUAry7AF1xAFb_yoW8Xry8pF
	4xGa15Cr12gr1xCF1Sqa1xXFyrtw4ktry2qrnIyw1Svr13Cr17ZFy8Xr4rJFy8ur97AFsr
	Wrs8tFy7WF1UC37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/29 14:31, Hannes Reinecke 写道:
> On 4/27/25 10:29, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Also add comment for part_inflight_show() for the difference between
>> bio-based and rq-based device.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/blk-mq.c | 12 ++++++------
>>   block/blk-mq.h |  3 +--
>>   block/genhd.c  | 43 +++++++++++++++++++++++++------------------
>>   3 files changed, 32 insertions(+), 26 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 301dbd3e1743..0067e8226e05 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -89,7 +89,7 @@ struct mq_inflight {
>>       unsigned int inflight[2];
>>   };
>> -static bool blk_mq_check_inflight(struct request *rq, void *priv)
>> +static bool blk_mq_check_in_driver(struct request *rq, void *priv)
> 
> Please don't rename these functions. 'in flight' always means 'in flight
> in the driver', so renaming them just introduces churn with no real 
> advantage.

Actually, the inflight value, from /proc/diskstats from diskstats_show,
actually means IO start accounting, which may not in the rq driver. For
example, IO scheduler. The same inflight value is used in
update_io_ticks as well.

This is the main reason about this rename. Related comments are added in
part_inflight_show() in this patch, and in part_in_flight() in next
patch.

Thanks,
Kuai

> 
> Cheers,
> 
> Hannes

