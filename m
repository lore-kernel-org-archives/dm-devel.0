Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0079457
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 02:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716173724; cv=none; b=TJr1Q6JOdQdCMBrAfEQ0qcwX4pdFvqifqOenLa2bUE26UTO0WM4MT3fapeEsFzmcXWKmz7VmiDBwqw/z2y5FD4Fm/LEERadlx1toSyqOhHLzssaz6p1F4OLh/D/dguhCqQgZzJnr8+MI/6/5IaZvghjRA35aizjITxPv5PFngw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716173724; c=relaxed/simple;
	bh=jmYjkYbXz7ZLDmA5iRmEULkEjQfbSiiaZLp/d0SHWQE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aifFVjaoDZhSLY71P9X9R+I/WWcTsmdXNMOXhN0MwzYtAjKnL2xFqfttP1BU3QjG3r5K6qNPt4d6Itz1oHaJ1tjNMHT+xl319FPXeg/iEaOIoDjK7q+xJTdPvR5VSHy8b/4gS9HQtKFpdfNv5r8Ev8q2PXBJlNFsT2XDeBrSc+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VjMcV5K3jz4f3jYr
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 10:55:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 73A0B1A01B9
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 10:55:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RGNu0pmqAKbNA--.6490S3;
	Mon, 20 May 2024 10:55:10 +0800 (CST)
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Changhui Zhong <czhong@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora>
 <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
 <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
Date: Mon, 20 May 2024 10:55:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RGNu0pmqAKbNA--.6490S3
X-Coremail-Antispam: 1UD129KBjvJXoW7XFWUur43tF1rZF13uryxGrg_yoW8JF4rpa
	93W3WakFWDur1293Z7Gw13uFyFka95Xr18Xr45tw1fA3ZrJFySkws29w43WFnrXr4Sg34a
	vF1a9395tF1UAFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Changhui

在 2024/05/20 8:39, Changhui Zhong 写道:
> [czhong@vm linux-block]$ git bisect bad
> 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
> commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
> Author: Yu Kuai<yukuai3@huawei.com>
> Date:   Thu May 9 20:38:25 2024 +0800
> 
>      block: add plug while submitting IO
> 
>      So that if caller didn't use plug, for example, __blkdev_direct_IO_simple()
>      and __blkdev_direct_IO_async(), block layer can still benefit from caching
>      nsec time in the plug.
> 
>      Signed-off-by: Yu Kuai<yukuai3@huawei.com>
>      Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@huaweicloud.com
>      Signed-off-by: Jens Axboe<axboe@kernel.dk>
> 
>   block/blk-core.c | 6 ++++++
>   1 file changed, 6 insertions(+)

Thanks for the test!

I was surprised to see this blamed commit, and after taking a look at
raid1 barrier code, I found that there are some known problems, fixed in
raid10, while raid1 still unfixed. So I wonder this patch maybe just
making the exist problem easier to reporduce.

I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
can you change your script to test raid10 as well, if raid10 is fine,
I'll give you these patches later to test raid1.

Thanks,
Kuai

