Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CF22550B0
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747031111; cv=none; b=S5dtXx8QmNGjfIb1OmSzcUx6QOTXRUr9bHAz9dFf4u0mtXIgr5V/pfzfwdqnQXJe8QXPQm7e6cdN7NuapoSWOztE2oScKS8EQmsCN7dB/CAHc/spHfE4hycjXQv5hHRHi56I14403KDi76WMVLkWG4catrEjSkzubuPMFk1SbyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747031111; c=relaxed/simple;
	bh=JZX16uF+c4cpMaU32JGD3vlA89b8Pzqo/TruBDVOzVo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=upvobU4dAfe0xJNe6I6xNMtFzBwXoi7JbFUQoH1d7xoV0I4qIfIohKXvGbXptNRAMoRkf4uacmE5bNVpH671lfZgYKtqKhf2bZgxdm/XZZGyM/UPrPOAZQdgodxKzCe5Wo7rj55VXjH5RHkHTXZN9080cl0lswjbptDTACi7YbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZwqMf01Z9z4f3jtJ
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:24:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 77CF41A07BB
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:25:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni19AlCFoHgKrMA--.11379S3;
	Mon, 12 May 2025 14:25:05 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 05/19] md: delay registration of bitmap_ops
 until creating bitmap
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-6-yukuai1@huaweicloud.com>
 <20250512045306.GE868@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f921797d-3876-f5d6-8a5b-019cdd9d8a03@huaweicloud.com>
Date: Mon, 12 May 2025 14:25:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512045306.GE868@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni19AlCFoHgKrMA--.11379S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYN7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	W8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7V
	UbE_M3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 12:53, Christoph Hellwig Ð´µÀ:
>> +	head = xa_load(&md_submodule, mddev->bitmap_id);
>>   	xa_unlock(&md_submodule);
>> -	if (!mddev->bitmap_ops)
>> -		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
>> +
>> +	if (WARN_ON_ONCE(!head || head->type != MD_BITMAP)) {
>> +		pr_err("md: can't find bitmap id %d\n", mddev->bitmap_id);
>> +		return;
>> +	}
> 
> This needs a real error return, doesn't it?

The caller check and return -ENOENT if mddev->bitmap_ops is NULL, I
can change the code here by checking return value instead.

Thanks,
Kuai

> 
> 
> 
> .
> 

