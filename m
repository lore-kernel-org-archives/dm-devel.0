Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0ED19F127
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 08:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747038243; cv=none; b=mhZpxmb+SDunuzHDm6jiaYAHHsoVyE/9YR1gZrPkaGOymDxz/gXTxxoPNiCTgkC5PDHo8fCRuPpKtR+IcVYpqLp0xzuOnIqEnr/qEsRZZ+eEvaqIfLMK+w+/cEqKfDH9BcKkC7i0nlcW8V057FdXVvQtvfaWbW1vY28fKWFK0Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747038243; c=relaxed/simple;
	bh=PGSpOJuLwDKFHcB99ZBz3OtHAgOA9XGAMJZz+sOTY48=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=G2qeho2Ka2bfDdjXF6HWheSvAlOSQ/V8pKe7x1sbnODRs8zhNWF/JxwJPa54duxu2zPYJq0HF8xDUlHV/7OSh+KBsQaHVy/WayjDXgkL/WqkW2i3585y4fA3c3XEOwrMaLtyDj0iyQdPT1CBbFtIKmY4lw1kimX5RKxBgNI8ybw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zwt0p3PmVz4f3jtJ
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:23:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED91B1A19CB
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:23:57 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHq18csCFoXjOzMA--.56018S3;
	Mon, 12 May 2025 16:23:57 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com>
Date: Mon, 12 May 2025 16:23:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512051722.GA1667@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHq18csCFoXjOzMA--.56018S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW3Ar1kGF47urWkJrW3GFg_yoWDKFX_Xa
	s0yrnrC34UJrs0qw1UW3WDZrZ7Cw4rJ3Z5Xay3WFykJ3sxWayDAFsY93yktry3t34xAw13
	Kr97ta48XFWagjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbHa0JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 13:17, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:23AM +0800, Yu Kuai wrote:
>> +static void llbitmap_unplug(struct mddev *mddev, bool sync)
>> +{
>> +	DECLARE_COMPLETION_ONSTACK(done);
>> +	struct llbitmap *llbitmap = mddev->bitmap;
>> +	struct llbitmap_unplug_work unplug_work = {
>> +		.llbitmap = llbitmap,
>> +		.done = &done,
>> +	};
>> +
>> +	if (!llbitmap_dirty(llbitmap))
>> +		return;
>> +
>> +	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
>> +	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
>> +	wait_for_completion(&done);
>> +	destroy_work_on_stack(&unplug_work.work);
> 
> Why is this deferring the work to a workqueue, but then synchronously
> waits on it?

This is the same as old bitmap, by the fact that issue new IO and wait
for such IO to be done from submit_bio() context will deadlock.

1) bitmap bio must be done before this bio can be issued;
2) bitmap bio will be added to current->bio_list, and wait for this bio
to be issued;

Do you have a better sulution to this problem?

Thanks,
Kuai

> 
> .
> 

