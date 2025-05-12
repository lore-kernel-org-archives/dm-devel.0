Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3A0265632
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057016; cv=none; b=tIEzWnZl9EmyZFlgpBvPL/Jt7l6o+8RQS9eEYcjQeD0sbosv183kKXUGBoEfergG8vJLlTaRGi2HwKgphOdozhdg9xh+ZfXJkIqu66d5WAx+ve8Uj82nE/QCt0/t2bFwC91XqhHOqhShahgcUgcMp/XPriVZaUm35812MTDMd9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057016; c=relaxed/simple;
	bh=VAP55gU+lkNmr97U9CJuE0YIVMJc0Q0lYNAgXRswrPo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZHbviCsRFF8qlkTR6FfyFl55QfEm36IRnNhtA+CDtSd/gxuxUKJ51wGTpgmoygCw1em+chGx2LNYNLaWn25roa46agNHgTLD0Ray89PhhNm2xJ6O/9Cmd2tdzWHfkoqF3MsZ8xTfd1TWOGpVX4T/XKfjM0FhQwd1e1CCPiSerRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zx0xc2r7Bz4f3jMw
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 21:36:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1B96C1A18C3
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 21:36:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2Br+SFo0IbIMA--.59542S3;
	Mon, 12 May 2025 21:36:44 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com>
Date: Mon, 12 May 2025 21:36:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512133048.GA32562@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2Br+SFo0IbIMA--.59542S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr43Cr13ZrW5ZFyrtw1fWFg_yoWxtrc_ur
	9Iyr47Cr4UZa4ktwn8KrZI9r4vkr43JFy5XrZ5Ja1vq34DJFy8GanrGrWFqFn5tw4ftrnx
	Ww4Yqas3Xr15KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
	0267AKxVWxJr0_GcJvcSsGvfC2KfnxnUUI43ZEXa7VUb8hL5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 21:30, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 03:26:41PM +0200, Christoph Hellwig wrote:
>>> 1) bitmap bio must be done before this bio can be issued;
>>> 2) bitmap bio will be added to current->bio_list, and wait for this bio
>>> to be issued;
>>>
>>> Do you have a better sulution to this problem?
>>
>> A bew block layer API that bypasses bio_list maybe?  I.e. export
>> __submit_bio with a better name and a kerneldoc detailing the narrow
>> use case.
> 
> That won't work as we'd miss a lot of checks, cgroup handling, etc.
> 
> But maybe a flag to skip the recursion avoidance?

I think this can work, and this can also improve performance. I'll look
into this.

Thanks,
Kuai

> 
> .
> 

