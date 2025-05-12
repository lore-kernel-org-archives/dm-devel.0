Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF021257436
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 08:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747039461; cv=none; b=CnWZYy2SZP1Od21H3z4EYuDKJlczQZZ7IReRZMQUGsYVD4SgAKJPa4C8dCVRluPO6BXMhVztwirANyNCZ+/khMWAKcdWKatGMAowm5iyn/dUh7hH1vaSfio/EdXXHnzale3X/MVtNkvNeujKPo3fBrOPYp20LpPHV4eyFShoj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747039461; c=relaxed/simple;
	bh=VolIWPuz/u983kI8WFI2YO/i/v/5Cb6uPvsQk+u2+yc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lVyZIFyV9Gh9fFryxM+D/E4g0Frcbn4RZpdt84yy+blevZadxXRUn2U+c7fm2BYwCsQy4lbRsMlno3Q2ZMcsdlOGiR93JoWCCWiukSdAoQWnmct/BhENaI9pnfT7brbDmuETwztacmFg+DDYMsbTQsQezjxB6zfUbL0euZm6gxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zwt6J4YVwzKHLt9
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:28:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 51DC71A0A4F
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:28:23 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8msSFo5n+zMA--.59164S3;
	Mon, 12 May 2025 16:28:23 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 17/19] md/md-llbitmap: implement all bitmap
 operations
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-18-yukuai1@huaweicloud.com>
 <20250512051810.GB1667@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2cf0998f-6475-05d2-33a1-ebf3b3253b31@huaweicloud.com>
Date: Mon, 12 May 2025 16:28:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512051810.GB1667@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8msSFo5n+zMA--.59164S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw13uFyUJFW7GF13WrW5GFg_yoWfWrX_ZF
	y5GF4xKrWUGFZ8KanrX3ZxAFWUu34DG3Z8ZwsrXFWFqr17Ja95uF4kA3yqv3Z5Ja48Za1j
	gryfWrWrtry3CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbzpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 13:18, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:25AM +0800, Yu Kuai wrote:
>> And following APIs that are not needed:
>>   - llbitmap_write_all, used in old bitmap to mark all pages need
>>   writeback;
>>   - llbitmap_daemon_work, used in old bitmap, llbitmap use timer to
>>     trigger daemon;
>>   - llbitmap_cond_end_sync, use to end sync for completed sectors(TODO,
>>     don't affect functionality)
>> And following APIs that are not supported:
>>   - llbitmap_start_behind_write
>>   - llbitmap_end_behind_write
>>   - llbitmap_wait_behind_writes
>>   - llbitmap_sync_with_cluster
>>   - llbitmap_get_from_slot
>>   - llbitmap_copy_from_slot
>>   - llbitmap_set_pages
>>   - llbitmap_free
> 
> Please just make these optional instead of implementing stubs.

Ok, I'll add a patch to check if those methods are NULL before calling
them.

Thanks,
Kuai

> .
> 

