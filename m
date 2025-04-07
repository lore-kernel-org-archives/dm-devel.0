Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15A2063F9
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988797; cv=none; b=BWHgi8UbyuJO8wDfsITZaw8dd/QE6pRj3ZDY0aWFva369G3+F0DCK2t27/hQIpx+qOSCUWecpEpj+82srDuxLODlk9RZJQbbomPh7lEFgjz28DYQh9VXs6y4W8VYAYssROr1YoeJKRPH5pZE1LY4StGUDL3BFhljFXdHZ6sJCEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988797; c=relaxed/simple;
	bh=/rtGmp1BKP5QH3NPTyxbJNYhJGjIem08YMhb3wvAbAY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=i3P8KOAIQFFLK91z78bgGhaF1Y1dxVDDjBMoh8gVj7fnFFiV6Nbr/5CNPSS8hI/cigkLYF4QpQuhrsoYvL7Nrdrsy02JcN4RWzWkb7sPQCmmkINJ3Z7EINRf3+aqiplhXmkRLgTAT5s7XSi36c6oKb287ApjHg81izDbv/R8v1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWBFc5DJ1z4f3jtT
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 09:19:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A24711A1125
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 09:19:50 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXe180KPNnLkvyIg--.40926S3;
	Mon, 07 Apr 2025 09:19:50 +0800 (CST)
Subject: Re: [PATCH RFC v2 02/14] md/md-bitmap: pass discard information to
 bitmap_{start, end}write
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <20250328060853.4124527-3-yukuai1@huaweicloud.com>
 <Z--mgctoFieWvuM0@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <17eebb9f-8ee9-d872-abe0-aa8351755c4d@huaweicloud.com>
Date: Mon, 7 Apr 2025 09:19:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z--mgctoFieWvuM0@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe180KPNnLkvyIg--.40926S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtry5XF1kCw1DZryxArWrZrb_yoW3CrXEg3
	4DCF1qgasxXrnaqF13Gwn8CrWDGw4rJr9rCF4DWFy0qFy8t34rCFyI9a93CryxZ3y5Ar42
	9ry2qr1fua12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRRKZX5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/04 17:29, Christoph Hellwig Ð´µÀ:
>>   	int (*startwrite)(struct mddev *mddev, sector_t offset,
>> -			  unsigned long sectors);
>> +			  unsigned long sectors, bool is_discard);
>>   	void (*endwrite)(struct mddev *mddev, sector_t offset,
>> -			 unsigned long sectors);
>> +			 unsigned long sectors, bool is_discard);
> 
> a bool discard is not a very good interface.  I'd expect an op enum or a set
> of flag to properly describe it.

Will update in the next version.

> 
> But is start/end write really the right interface for discard or should it
> have it's own set of ops?

Yes, this is historical issue. The old bitmap handle discard the same as
normal write, while new bitmap handle them differently. And I agree that
add a new ops for discard is better in the long term.

Thanks,
Kuai

> 
> .
> 

