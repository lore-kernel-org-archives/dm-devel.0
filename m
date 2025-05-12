Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37562B9B7
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 08:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747038630; cv=none; b=jqUUVGRWs6oTZ91HZUULIFhlvMijmCWWy5jcGbik9a0hOeBytkh/mc3E/elsFo8TQw4xNHh82h+8yweYTSJK/13+Y6cMrUHCefwXDkttex8T0iYriXAA8CCL4o8mrJEfczO/PDwKA/WkqVKULrQCemU7NAn53dTPbm4HyNBynw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747038630; c=relaxed/simple;
	bh=26YxyMmSrBXH6G7ipWMqOxTjuBdjOFiSopaSNVAe0Cg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NJaG2w52rWjLDpm5pwda4bb12SouqwME+MshQfx2BUGSQgcmsCLOGsUdwyRKwcwLuykvUWgQ84Bcf1FNOhbJ0s0iFcq6FiaxGuhsRxeYPJ4uFLrOnXk4wSiJ+8SIxI7ksUQsRnQI5keZ2NbCLdqsswxATm0wRYuXCw/iJMpRkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4Zwt8f5TVbzKHLyT
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:30:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 71FA01A0359
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:30:25 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl+gsSFoJKOzMA--.58196S3;
	Mon, 12 May 2025 16:30:25 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 19/19] md/md-llbitmap: add Kconfig
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-20-yukuai1@huaweicloud.com>
 <20250512051910.GC1667@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ccba7e70-b0f2-e744-2271-2d86bed364d0@huaweicloud.com>
Date: Mon, 12 May 2025 16:30:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512051910.GC1667@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl+gsSFoJKOzMA--.58196S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Wry5Wr1Duw4UCrWfWFW7urg_yoWDAFX_Ww
	45Z34IkryDCr1DtF4agF13ZrWDtayDWas7Ar4SqFySqry3AasrGrWvvry5Jw4kJayUAa98
	Zr95XF4rurnIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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

ÔÚ 2025/05/12 13:19, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:27AM +0800, Yu Kuai wrote:
>> +config MD_LLBITMAP
>> +	bool "MD RAID lockless bitmap support"
>> +	default n
> 
> n is the default default.
> 
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index 4e27f5f793b7..dd23b6fedb70 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -22,6 +22,9 @@ typedef __u16 bitmap_counter_t;
>>   enum bitmap_state {
>>   	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
>>   	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
>> +	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
>> +	BITMAP_CLEAN	   = 4, /* llbitmap is created with assume_clean */
>> +	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */
> 
> This should go into patches very early in the series, before the code
> referencing them.

Ok, I'll fold them with the new patch to move some values to md-bitmap.h
in the next version.

Thanks,
Kuai

> 
> .
> 

