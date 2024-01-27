Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0644680
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 01:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706317994; cv=none; b=ikwq8RPf2+PTBOQ12sslXsonocOPndNhAoxqDxJKRBrrmd2omQUXZIKFq3vi81MMmoIJcf2CTzJkeGzrweUKqg0J//Fp3cO9plxoshx5llbJBthujP7fHX4urfvsH1zRmJAEgUsv2Sw5HPfqq/fITYzV/fWx7QWLLl5GaTChIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706317994; c=relaxed/simple;
	bh=y6MGOzUlhXI8KNq60ec+52HQGuEK+uqHoi+fFyKF9Mk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KhPDMPRVC1WmULxYQwjwqatOp558WGS3JqXSt1QjON9Ym0qwR5zAvR6N/BPXrKruFHKVasqe4COpngVHpuP5Y7fn4WWBqu7PCd7lKV5Bh55iG0HBFFR/88nWaAXXQuRIpRJ3xfJfce+8k3Ylt3NC9IeNvQaO1chf13pLO7GGw5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TMGlK5pYPz4f3lVP
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 09:13:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2ECC01A016E
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 09:13:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g6iWLRlhvliCA--.4573S3;
	Sat, 27 Jan 2024 09:13:08 +0800 (CST)
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
To: Zdenek Kabelac <zkabelac@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <82218127-8778-9fda-bbfd-30178760dc53@huaweicloud.com>
Date: Sat, 27 Jan 2024 09:13:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86a989b0-53ee-4915-8ff4-aafa3ad18d16@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g6iWLRlhvliCA--.4573S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYy7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/01/26 18:29, Zdenek Kabelac 写道:
> make check_local T=raid
> 
> 
> will do the same thing.  With S=   you could even select list of tests 
> you want to skip.

Thanks for the notice!

Kuai

> 
> Regards

