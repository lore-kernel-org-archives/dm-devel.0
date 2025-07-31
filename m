Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E777D176AC8
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 01:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753926574; cv=none; b=gFCRaDFYg07Q35ihSKryejmHfEU30ueTZddZR4TbJ0qqOB4Kbcin0aQXYbuPy2PKwS5dVL1lrI85nD5VphvDAf1wlapWnCS0R5xNkHqQNwJ4rEZUotyc+aHNoQKyGPz1g4yZ88OD8ijbs6MhnVybQ1Kn4RmG8fM5urO+OhQiLTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753926574; c=relaxed/simple;
	bh=NnMgq53QVCwA/CighbaGjo9jhrRKNRuqjx0ity8ATSE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oW3m4LoZNf8gMcurP2NaRk7HzJZ2XtvmIAKRz9bbgpp8WiYoPqFzHotsySjWa7dn+g/sJM2m1TneD+eNg1CZtFRF40x/8k763Lcp2YZ6fDd+HRFh8yJH1lkPk9rn02h4TnHpYSd7vpGaO/8TwHbTOw/bj+t1omRIBwdyx/nUjsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bssT63sFXzYQtxn
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 09:49:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 37DF91A06D7
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 09:49:29 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxSny4poelM2CA--.34795S3;
	Thu, 31 Jul 2025 09:49:29 +0800 (CST)
Subject: Re: [bug report] dm: 'tried to init an initialized object' error
 triggered during device creation
To: Hou Tao <houtao@huaweicloud.com>, Li Lingfeng <lilingfeng3@huawei.com>,
 agk@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-block@vger.kernel.org
Cc: zhengqixing@huawei.com, yangerkun <yangerkun@huawei.com>,
 "zhangyi (F)" <yi.zhang@huawei.com>,
 "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
 Li Lingfeng <lilingfeng@huaweicloud.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <83591d0b-2467-433c-bce0-5581298eb161@huawei.com>
 <f9c385b3-2426-13a1-bc4b-54c3fb402704@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <09e676c5-8407-a0a6-313c-22fcfee4e488@huaweicloud.com>
Date: Thu, 31 Jul 2025 09:49:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f9c385b3-2426-13a1-bc4b-54c3fb402704@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxSny4poelM2CA--.34795S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr1xur1DGF47Gw1UJw43Jrb_yoW3GrX_JF
	ZxKa4rWrs8Gr4Y9w10kw4fAFZ5G343JwsxJrZ8XF98Gr15Xw45J3yDuw4rCr4UJ3y7GF9F
	kr48W348ZrW7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/31 9:28, Hou Tao 写道:
> cc +linux-block
> 
> The disk->queue_kobj is initialized in add_disk() and is uninitialized
> in del_disk(). And it seems that blk_unregister_queue() in del_disk()
> doesn't uninitialize the queue_kobj completely, because it doesn't
> expect the queue_kobj will be added again. I think the right place to
> fix the problem is blk_unregister_queue(). How about just memset the
> queue_kobj as zero after deleting the queue_kobj in blk_unregister_queue() ?

I think it's better to move kobject_init to allocate disk:

1) alloc disk, kobject_init
2) register q, kobject_add
3) unregister q, kobject_del
4) free disk, kobject_put

With this, it's safe to add the kobject again.

Thanks,
Kuai

