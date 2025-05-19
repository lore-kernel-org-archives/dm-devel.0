Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E661E5B7B
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 11:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747653556; cv=none; b=DPQ6SkHMydPEOJaDEV183YoRKWfqwt+dqOtUk/tIgDbUR0LyW+uWBFBUS1tN+uWV9jkcel2XNOkLD7LioV/UYuywF94UfGuBGDptStM5b/bWMOdY5zfVOT8edh7bS5pZFzygzkcdwzxfqkWCQkqiuAGS5QapRQlf2vZXrIVPQn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747653556; c=relaxed/simple;
	bh=Mgztn8weWDCQc6aZ82YyO9N9Cw6NUYsNGD6n0v/TkMI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mvrnaNxKzZk3EkXSq1BTiKQyAuFl4oHRBKw3t5lYN0R8FnjK9dL3T4wJ9jpXt4F49jVWkfpr+litQngiaQuKPx9FuKEzVtpL7/TWXD8jyF1Vp+cGweeR6hbIdJK4XMTUUnczzJYCXkjPFM4SfamvVRQniaSGVIqXzM1OoA1rN7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b1FYj2CWDz4f3jqq
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 19:18:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 17C4F1A07FA
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 19:19:09 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl+rEytoy39+Mw--.36139S3;
	Mon, 19 May 2025 19:19:08 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
To: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, zkabelac@redhat.com,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
 <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
Date: Mon, 19 May 2025 19:19:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl+rEytoy39+Mw--.36139S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF17ZryxCw43tr4rCF4xXrb_yoW5Xr4kpa
	yDJF93ArWUJ3yUZr1DXa1UuayFkF4DGry2kry8C34fAw15ZFWkAa1kGrWYgr1DWrW5Cw17
	JF4UJr4DGF45tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/19 18:09, Mikulas Patocka Ð´µÀ:
> The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") breaks
> the lvm2 test shell/lvcreate-large-raid.sh. The commit changes raid1 and
> raid10 to pass down all the flags from the incoming bio. The problem is
> when we pass down the REQ_RAHEAD flag - bios with this flag may fail
> anytime and md-raid is not prepared to handle this failure.

Can dm-raid handle this falg? At least from md-raid array, for read
ahead IO, it doesn't make sense to kill that flag.

If we want to fall back to old behavior, can we kill that flag from
dm-raid?

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 127138c61be5..ca7fb1713117 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3353,6 +3353,11 @@ static int raid_map(struct dm_target *ti, struct 
bio *bio)
         if (unlikely(bio_has_data(bio) && bio_end_sector(bio) > 
mddev->array_sectors))
                 return DM_MAPIO_REQUEUE;

+       /*
+        * bios with this flag may fail anytime, dm-raid is not prepared to
+        * handle failure.
+        */
+       bio->bi_opf &= ~REQ_RAHEAD;
         if (unlikely(!md_handle_request(mddev, bio)))
                 return DM_MAPIO_REQUEUE;

Thanks,
Kuai

> 
> This commit fixes the code, so that the REQ_RAHEAD flag is not passed
> down.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
> 
> ---
>   drivers/md/raid1.c  |    1 +
>   drivers/md/raid10.c |    1 +
>   2 files changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/md/raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid1.c
> +++ linux-2.6/drivers/md/raid1.c
> @@ -1404,6 +1404,7 @@ static void raid1_read_request(struct md
>   	read_bio->bi_iter.bi_sector = r1_bio->sector +
>   		mirror->rdev->data_offset;
>   	read_bio->bi_end_io = raid1_end_read_request;
> +	read_bio->bi_opf &= ~REQ_RAHEAD;
>   	if (test_bit(FailFast, &mirror->rdev->flags) &&
>   	    test_bit(R1BIO_FailFast, &r1_bio->state))
>   	        read_bio->bi_opf |= MD_FAILFAST;
> Index: linux-2.6/drivers/md/raid10.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid10.c
> +++ linux-2.6/drivers/md/raid10.c
> @@ -1263,6 +1263,7 @@ static void raid10_write_one_disk(struct
>   	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
>   				   choose_data_offset(r10_bio, rdev));
>   	mbio->bi_end_io	= raid10_end_write_request;
> +	mbio->bi_opf &= ~REQ_RAHEAD;
>   	if (!replacement && test_bit(FailFast,
>   				     &conf->mirrors[devnum].rdev->flags)
>   			 && enough(conf, devnum))
> 
> 
> .
> 

