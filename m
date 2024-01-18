Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4B26124
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705543005; cv=none; b=r6Y80dKrSiUJO6ntkZJMXGNXt8TmGrgrF8cdvJ9/dYOZzsUW/y/OL0/I0DtPgdWucVhMkyXMp1HfNyT0ASW5MSVj3jcnc3rlJ1jvZKcZUeEtIG+L8Ave1g+h/fmIyp7qOpXITbr0MbZj+/uHw9hF4vCdAPk+dtfRyGoJAy8W5vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705543005; c=relaxed/simple;
	bh=F8cVZXu1p1igx8NIwwzoapTI0+v+eWG5jCdGP34rM6o=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=hSKKW/ssqYWZgy6ADnQxYsML6b/XLx5MFlajufrUEJJmYsOOlwNMv9c7ZGSjhNdVclzlsW60ZIzTusO5Tr14ODwAox9wI3dJ78vaZ+f038bnYSHxHNZZkMWJQTb5vZUHHIOpN7DGoITH2/tQbLNfYdEy+0mX5FNyHJrHFzBlxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TFm7p0PWYz4f3k5n
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:56:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3A09F1A016E
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:56:40 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ5XhahlCPKtBA--.42624S3;
	Thu, 18 Jan 2024 09:56:40 +0800 (CST)
Subject: Re: [PATCH 7/7] md: fix a suspicious RCU usage warning
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <51539879-e1ca-fde3-b8b4-8934ddedcbc@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <322e1306-6507-9707-7985-f460e2536cf0@huaweicloud.com>
Date: Thu, 18 Jan 2024 09:56:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <51539879-e1ca-fde3-b8b4-8934ddedcbc@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ5XhahlCPKtBA--.42624S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr13tw1ruF1kAFWrtw48tFb_yoW8KF18pa
	n3Aa4xJr4UJryjyF4jyayUKFyruFy5JFW7Jr93Jw1xZas7A39xAa45KFyrWryDCr90y34U
	X3W5KFs8Gwn8tFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
	67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
	uYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/01/18 2:22, Mikulas Patocka Ð´µÀ:
> RCU protection was removed in the commit 2d32777d60de ("raid1: remove rcu
> protection to access rdev from conf").
> 
> However, the code in fix_read_error does rcu_dereference outside
> rcu_read_lock - this triggers the following warning. The warning is
> triggered by a LVM2 test shell/integrity-caching.sh.
> 
> This commit removes rcu_dereference.
> 
> =============================
> WARNING: suspicious RCU usage
> 6.7.0 #2 Not tainted
> -----------------------------
> drivers/md/raid1.c:2265 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> no locks held by mdX_raid1/1859.
> 
> stack backtrace:
> CPU: 2 PID: 1859 Comm: mdX_raid1 Not tainted 6.7.0 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x60/0x70
>   lockdep_rcu_suspicious+0x153/0x1b0
>   raid1d+0x1732/0x1750 [raid1]
>   ? lock_acquire+0x9f/0x270
>   ? finish_wait+0x3d/0x80
>   ? md_thread+0xf7/0x130 [md_mod]
>   ? lock_release+0xaa/0x230
>   ? md_register_thread+0xd0/0xd0 [md_mod]
>   md_thread+0xa0/0x130 [md_mod]
>   ? housekeeping_test_cpu+0x30/0x30
>   kthread+0xdc/0x110
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x28/0x40
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: ca294b34aaf3 ("md/raid1: support read error check")

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> 
> ---
>   drivers/md/raid1.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid1.c
> +++ linux-2.6/drivers/md/raid1.c
> @@ -2262,7 +2262,7 @@ static void fix_read_error(struct r1conf
>   	int sectors = r1_bio->sectors;
>   	int read_disk = r1_bio->read_disk;
>   	struct mddev *mddev = conf->mddev;
> -	struct md_rdev *rdev = rcu_dereference(conf->mirrors[read_disk].rdev);
> +	struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
>   
>   	if (exceed_read_errors(mddev, rdev)) {
>   		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
> 
> .
> 

