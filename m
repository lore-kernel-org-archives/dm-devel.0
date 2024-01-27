Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37588443D
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 01:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706318395; cv=none; b=nEGiJuhLBcW/1VACIkL2HATsEFXSzcKLRwLgrAvzCh513iEZq58I/wUCwAWUuxqheG6BDBkfqB81tBd7unw0rEM4dW/okmectgU7oXC4G/xuawaBnbZffGHalSrtnK5L7w3AW5BNwhhXoRmLHsJ83NUy4q5kfy9KG+FwL9Qs0XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706318395; c=relaxed/simple;
	bh=+j3Kt8OzmJvqq707AeYnQZtsKaG7YprJwUmuBavexLU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pu+weUsSnIcTPLaC03OmBh3FJuosV9kofpIiIa9S+vtswDBIiu6OcOewjU5hDgRB/+1REJ3OzsFEbVwIuENg0EXLWfQ/kZB835VWOGWaZP+Q2jJGjEHSxuI+0bQ2a7vEvFfAtK2ey7li23BfLUr8gHXrLamUqtjB9N7ntzTRqug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TMGv55t6pz4f3jMX
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 09:19:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CD7491A017A
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 09:19:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBE1WrRlDHdjCA--.15547S3;
	Sat, 27 Jan 2024 09:19:49 +0800 (CST)
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
To: Yu Kuai <yukuai1@huaweicloud.com>, Zdenek Kabelac <zkabelac@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>,
 Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com>
 <CAPhsuW483DSEvgoT0c-Mo1gdpVKRRLkTxu+kuxYG6k-zew+FFA@mail.gmail.com>
 <82e9b11f-e28-683-782d-aa5b8c62ff1a@redhat.com>
 <CAPhsuW4YLVLhv2ii0UjiQOmiqR3mk6u8r94-SVZjMs6LVp+WaQ@mail.gmail.com>
 <56ff3ba-9a60-1930-a2a1-c2562ece1ec1@redhat.com>
 <Za8k8GityCXjSVJ-@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <08748e1b-e947-44d3-34dc-7dc0f9db1c04@huaweicloud.com>
 <166bea43-1d1e-3938-3af1-491e61d5bcf6@huaweicloud.com>
 <86a989b0-53ee-4915-8ff4-aafa3ad18d16@redhat.com>
 <82218127-8778-9fda-bbfd-30178760dc53@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cafb906e-dac5-0048-7582-35076ff1b779@huaweicloud.com>
Date: Sat, 27 Jan 2024 09:19:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <82218127-8778-9fda-bbfd-30178760dc53@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBE1WrRlDHdjCA--.15547S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF9a9DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/01/27 9:13, Yu Kuai 写道:
> Hi,
> 
> 在 2024/01/26 18:29, Zdenek Kabelac 写道:
>> make check_local T=raid
>>
I just tried that, however, this just fond 65 tests. And look like it's
just find test file name with 'raid'.

Thanks,
Kuai

>>
>> will do the same thing.  With S=   you could even select list of tests 
>> you want to skip.
> 
> Thanks for the notice!
> 
> Kuai
> 
>>
>> Regards
> 
> .
> 

