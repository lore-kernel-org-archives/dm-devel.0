Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7AB468B
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705541728; cv=none; b=T2RlGuD3t8R+B3unuIpV3Dg0kBcFYgr6VkzJVGwl88Vag0NGdIkDarHq6ayyK3ONyAFfS9H2sn+owCJb1uJALuftyaw+BDmrNCavhHPxQla11p8s36evbp2vLNdvdPUnUTqejLYiQfbiragG9fExiIr7ZmOEDXddb+Xvkr87ips=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705541728; c=relaxed/simple;
	bh=2MN0UlIBDm7MZ9Wc3wnUkKXsVSGFjG89/DV+IREb3BU=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=KQeIkcsyXmZJxPWMMVY7gjtO6bSltC7DEk/xkSPsH+RhIaDb4f8nnvfFpCrWMQQPbYvened1Q0ASlje31f3ca/h70LNdUaIsot2V99sf+fC/gGaFICfJaz1oHqYYMEZKU+IHPK8VtDja9xtFTZBlaP43vVnhSXuRdfQXRQojvSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TFlgC2dSRz4f3jR3
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:35:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 208ED1A016E
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:35:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBFagKhlh2OsBA--.7256S3;
	Thu, 18 Jan 2024 09:35:23 +0800 (CST)
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <02ac54ff-dbd3-92c1-72ab-b742cafd93e4@huaweicloud.com>
Date: Thu, 18 Jan 2024 09:35:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBFagKhlh2OsBA--.7256S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4DKr1rJrW7tF4fWFW5GFg_yoW5GFW3pa
	4kGasayr48Ary7ZayxKa4UAr95uF42q39rJrZ3W3s3AFn5tF47AF1UuF1UZFykG34fZa18
	Aa45XFZxZr18Cw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU189N3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/18 2:19, Mikulas Patocka Ð´µÀ:
> stop_sync_thread sets MD_RECOVERY_INTR and then waits for
> MD_RECOVERY_RUNNING to be cleared. However, md_do_sync will not clear
> MD_RECOVERY_RUNNING when exiting, it will set MD_RECOVERY_DONE instead.
> 
> So, we must wait for MD_RECOVERY_DONE to be set as well.

You are missing how sync_thread() is stopped. md_do_sync() will set
MD_RECOVERY_DONE first, and md_check_recovery() is responsible for
clearing MD_RECOVERY_RUNNING.
> 
> This patch fixes a deadlock in the LVM2 test shell/integrity-caching.sh.

It's still not clear about the root cause. Any way, this patch is really
wrong, it breaks the foundation design of sync_thread.

Thanks,
Kuai

> 
> sysrq: Show Blocked State
> task:lvm             state:D stack:0     pid:11422  tgid:11422 ppid:1374   flags:0x00004002
> Call Trace:
>   <TASK>
>   __schedule+0x228/0x570
>   schedule+0x29/0xa0
>   schedule_timeout+0x6a/0xd0
>   ? timer_shutdown_sync+0x10/0x10
>   stop_sync_thread+0x141/0x180 [md_mod]
>   ? housekeeping_test_cpu+0x30/0x30
>   __md_stop_writes+0x10/0xd0 [md_mod]
>   md_stop+0x9/0x20 [md_mod]
>   raid_dtr+0x1e/0x60 [dm_raid]
>   dm_table_destroy+0x53/0x110 [dm_mod]
>   __dm_destroy+0x10b/0x1e0 [dm_mod]
>   ? table_clear+0xa0/0xa0 [dm_mod]
>   dev_remove+0xd4/0x110 [dm_mod]
>   ctl_ioctl+0x2e1/0x570 [dm_mod]
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0x85/0xa0
>   do_syscall_64+0x5d/0x1a0
>   entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v6.7
> Fixes: 130443d60b1b ("md: refactor idle/frozen_sync_thread() to fix deadlock")
> 
> ---
>   drivers/md/md.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -4881,7 +4881,8 @@ static void stop_sync_thread(struct mdde
>   	if (check_seq)
>   		sync_seq = atomic_read(&mddev->sync_seq);
>   
> -	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> +	    test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
>   		if (!locked)
>   			mddev_unlock(mddev);
>   		return;
> @@ -4901,6 +4902,7 @@ retry:
>   
>   	if (!wait_event_timeout(resync_wait,
>   		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> +		   test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
>   		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)),
>   		   HZ / 10))
>   		goto retry;
> 
> 
> .
> 

