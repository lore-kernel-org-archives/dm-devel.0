Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB213FEE
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 07:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120454; cv=none; b=GEhq/PJgrK7IYf0DZNjX7NkIx6jcgxAANM9cpozzQuBDcO3PpUEcQP+t4dDwOXiTMgY5HmdG/6+7VC7Unnolf+3aicj7K8Ly9DPlr7twrO2lSwdAEhO1grWun7NWHVp2Ak8aaWzg1B3osMIUUkuyACCGJ6LhmQy6IdTlmot5MLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120454; c=relaxed/simple;
	bh=K3drLE2Oi+IvVbndZqChwht2avF2P5gnpQVpowPrJUE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DBGH+2zq03Hhqc71N7rvFLTHd2UHyMj7xUPinUT0lcoBhBzrOmxFln1yKLvg0X1BpAvLBk5oXZF7A+7Tu39uOw/Ni3NWm4p3qppvTn303ZzymoQPxn34omFGgYOlqav/Dd5CA+rjWqr6JPaYh4dIuPlC+kBCHvlhsQzlcrD+khI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZxSPj4lPrz4f3jt8
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 15:13:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2E8601A12C2
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 15:14:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXe1878SJofX8SMQ--.8827S3;
	Tue, 13 May 2025 15:14:05 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-16-yukuai1@huaweicloud.com>
 <20250512051722.GA1667@lst.de>
 <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com>
 <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de>
 <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com>
 <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com>
 <20250513064803.GA1508@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com>
Date: Tue, 13 May 2025 15:14:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250513064803.GA1508@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe1878SJofX8SMQ--.8827S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr48Ww4xJryDGrWDZry7Jrb_yoW8WF45pr
	WrKan7Grs8GrsFqF1xZa43WFyrKFWvvrZ8JayrW3WrGw4jvrn5XF4rKFySy3ZrAr1kG3Wv
	qr1ftrn8Ca1UZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/13 14:48, Christoph Hellwig Ð´µÀ:
> On Tue, May 13, 2025 at 02:32:04PM +0800, Yu Kuai wrote:
>> However, for bitmap file case, bio is issued from submit_bh(), I'll have
>> to change buffer_head code and I'm not sure if we want to do that.
> 
> Don't bother with the old code, I'm still hoping we can replace it with
> your new code ASAP.

Agreed :)
> 
>> +       BIO_STACKED_META,       /* bio is metadata from stacked device */
> 
> I don't think that is the right name and description.  The whole point
> of the recursion avoidance is to to supported stacked devices by
> reducing the stack depth.  So we clearly need to document why that
> is not desirable for some very specific cases like reading in metadata
> needed to process a write I/O.  We should also ensure it doesn't
> propagate to lover stacked devices.
> 
> In fact I wonder if a better interfaces would be one to stash away
> current->bio_list and then restore it after the call, as that would
> enforce all that.

Yes, following change can work as well.

Just wonder, if the array is created by another array, and which is
created by another array ...  In this case, the stack depth can be
huge. :(  This is super weird case, however, should we keep the old code
in this case?

Thanks,
Kuai

  static void bitmap_unplug(struct mddev *mddev, bool sync)
  {
         struct bitmap *bitmap = mddev->bitmap;
+       struct bio_list *bio_list = NULL;

         if (!bitmap)
                 return;

-       if (sync)
-               __bitmap_unplug(bitmap);
-       else
-               bitmap_unplug_async(bitmap);
+       if (current->bio_list) {
+               bio_list = current->bio_list;
+               current->bio_list = NULL;
+       }
+
+       __bitmap_unplug(bitmap);
+
+       current->bio_list = bio_list;
  }

> .
> 

