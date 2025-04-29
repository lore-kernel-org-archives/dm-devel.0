Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5AF2FB2
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890830; cv=none; b=icy9u/yBQEp4oKjlk2lIeSTwj4TDRdQ9wrc8yn8bJDHh1/ACjnG8V+Y5W3CSzqBQPoZfKxaxJ3rQinRok6gZNLniWxG8f/rstYyxlBuUfxIGmMAu0wcJBEXTfXUV9vqj0V1bnOrdiLaTN3f03eMzLeY1TKBxLbbgjQQ8WjvE+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890830; c=relaxed/simple;
	bh=12cEaqd+nPFPiuGXls/Wex6cbqwVkBYaSc6LG/ur2uM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ncOUcIpC3X1wR3vKWLzhezDrrIv+RZHHr+2duU83lmAhyjXeYduf33fWLwVh06kiHMGKUORW0X40mri6lPHJ/QFzLBgJMNDbRQWCE5bJArjvZu1+sv/8Q0UjQOfT3fNJuVjpQvHBa4IkZp0EQu5223xsZ+61P//FcEk++q+rET0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zmjg3352vz4f3l7d
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:39:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9ADB81A07BB
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:40:23 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH618GLhBoB_2AKw--.51220S3;
	Tue, 29 Apr 2025 09:40:23 +0800 (CST)
Subject: Re: [PATCH v2 1/9] blk-mq: remove blk_mq_in_flight()
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, cl@linux.com,
 nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-2-yukuai1@huaweicloud.com>
 <0296cc37-d56c-405a-84c7-4b814496e4df@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <02558808-78e9-d7c2-1826-8c9551f4f3e5@huaweicloud.com>
Date: Tue, 29 Apr 2025 09:40:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0296cc37-d56c-405a-84c7-4b814496e4df@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH618GLhBoB_2AKw--.51220S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6r
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	F0eHDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/28 21:45, John Garry 写道:
> On 27/04/2025 09:29, Yu Kuai wrote:
>> From: Yu Kuai<yukuai3@huawei.com>
>>
>> It's not used and can be removed.
>>
> 
> it's nice to mention when it stopped being used.

Ok
> 
>> Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> 
> Regardless, FWIW:
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks,
Kuai

> 
> .
> 

