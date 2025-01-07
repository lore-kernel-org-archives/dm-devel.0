Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8501E3769
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 03:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736221422; cv=none; b=PRGYetoar7lAB+Jqcv+/+UCioyCDbwXM9LvBr/g/8dc+oaVUtATPl9T3hdnGwfAyIsxNkclp+dSOJVNQo3bTZwY3AXRKhJjJk29zeAeCJ4R9LyjlTgdgKSY1rPe1CyEilhD1Cg2zUG7FIg+Af61Vlp4cYHYQ5ADathGYceUbwuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736221422; c=relaxed/simple;
	bh=48qxUGEqIIPDAFplrwOiOFjsf+VO99L86P0EVuFvKFE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VcZ9vokMRuoe16WbI6gf/0nOIR0jCf5KjqcnVhiBDFYIZpyTmTeV+bDc+mDoRHYnQ+B7LhX3dIWM2/3k8t4DarmSaLpyjCw2kYB13GkWV6fhwyjoPhHM/4Yid0vbGFRcn+NQDHrLfhdkzz00bDA/enflpbEGbzXwRLyZ5pnwZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YRxhx6zw9z4f3kvm
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 11:43:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4C95E1A0CDD
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 11:43:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgAXa8Xlonxn3QoGAQ--.63759S3;
	Tue, 07 Jan 2025 11:43:35 +0800 (CST)
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
 <dbe17982-bb4f-5c86-8a91-6fe1395070b5@huaweicloud.com>
 <Z3v1ss2aMrCI5whs@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4e436ffb-ea9f-a306-e495-c56b1e09f972@huaweicloud.com>
Date: Tue, 7 Jan 2025 11:43:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z3v1ss2aMrCI5whs@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAXa8Xlonxn3QoGAQ--.63759S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKrykWry8Ar4DCFykZr45trb_yoWfGrgEg3
	42yry7Kw47Aw42vF4DWrsYvrWSqa9xta4UAFW8ZF1v9ry5WFs7JF1xA34fuw1UWa1UJrnr
	WrWDAa4vyr13ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
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

ÔÚ 2025/01/06 23:24, Christoph Hellwig Ð´µÀ:
> On Mon, Jan 06, 2025 at 07:35:33PM +0800, Yu Kuai wrote:
>> So there are total 6 existed helpers that I have to export, however,
>> these are all historical burdens, md_cluster, raid1 slow disk, ...
>> And I'm trying to get rid of them for the new md bitmap I'm working on.
>> If you really don't like *module*, I can change the config to bool. :)
> 
> FYI, I really like your previous cleanups to better encapsulate the
> bitmap code, and I'm also perfectly fine with a Kconfig options for it.

Good to know.

> 
> Also splitting existing code into modules has a tendency to break
> distro initramfs magic frequently even with request_module in place.
> So unless there is a really good reason I'd rather not do it.

Got it, I'll remove the patch 12 and change the bimtap config to bool
in the next version.

Thanks!
Kuai

> 
> .
> 

