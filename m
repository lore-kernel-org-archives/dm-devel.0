Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4441192B74
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736163340; cv=none; b=BGbGuf9MvoqX5UJjhm5t6KAl4V4RxR9YGEs9n2z/XqlxBVWQ88ATDJ4UBh51R+TquUDUV5mMzkpVxCWq4YkJTT5RIeuGTwT79te7Qg8bD51aKRiPb5azlDzFvmpjGN4CQpmDySGXm0tvWR1k9zDH2fxDhE+00SebwlOiAxko8PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736163340; c=relaxed/simple;
	bh=nehGsFzRAFryYGek8YFcX2TkEbtlurJJErxqt3RuSC8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D2dwjApjZxRQ4bobNa2tDGxTeeYf73QkA5XyKzxiCqc2cgjb0OeKtdRdiXcUNXIUtvAJ+fpuKpek0IZxbB41cN/4ZAzgubCDcWaiOSOrPV4OY68nmHWRNJzinIIqTw05t91j9V/22P5Y6PNr0yQ8P4sTGZdL8B9OGDET0Tj7LQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YRXD15xbVz4f3lfX
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 19:35:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 214FE1A139A
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 19:35:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgCH2sQFwHtn85fHAA--.65023S3;
	Mon, 06 Jan 2025 19:35:34 +0800 (CST)
Subject: Re: [PATCH md-6.14 13/13] md/md-bitmap: support to build md-bitmap as
 kernel module
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
 <20241225111546.1833250-14-yukuai1@huaweicloud.com>
 <Z3u7quGlqJ8fP6R7@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dbe17982-bb4f-5c86-8a91-6fe1395070b5@huaweicloud.com>
Date: Mon, 6 Jan 2025 19:35:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z3u7quGlqJ8fP6R7@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCH2sQFwHtn85fHAA--.65023S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZry3GF4UKw4DJrW3ur4xCrg_yoWxCrgEyF
	92kryUGw13Ja4xAF4UGF40vrZ29a15GFWkZFWjyFW2qry8XF9rJF97K3s5Zw42gF4Dtryx
	WF4DAr17Zw15JjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/01/06 19:16, Christoph Hellwig Ð´µÀ:
> On Wed, Dec 25, 2024 at 07:15:46PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Now that all implementations are internal, it's sensible to build it as
>> kernel module now.
> 
> Why is it sensible?  You need tons of exports for a small piece of
> code that doesn't really feel like it is a sensible module.
> 

So there are total 6 existed helpers that I have to export, however,
these are all historical burdens, md_cluster, raid1 slow disk, ...
And I'm trying to get rid of them for the new md bitmap I'm working on.
If you really don't like *module*, I can change the config to bool. :)

Thanks,
Kuai

> .
> 

