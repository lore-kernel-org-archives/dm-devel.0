Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D1187862
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 06:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100160; cv=none; b=FKXvyGtgprZZAHcxImpqqfkNMxkUqgwJ0IuGKgf6K4LnBcQX1Pwc5qJOyI3OYHCwr+9c55GqHoOH/O1ItTtVQb7ylcICQ0I6Qx+6A84rz55XKnZrQfkXbL0oJfV0Q5ZX8LXuiMSaeWozN2Rw1cHRT7ylRFzNl+oHC5pxfK0kjBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100160; c=relaxed/simple;
	bh=tjDMntZf2PwVuVuRzSUddtzVkqPn6lcPYqhksmxb0cE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=e1bJkb6p2GifL5Pb6xbDF63XWWPee3EQTeuHfbDNgHIIOWWSmYbv+G9Dx1vZi2V02s4VX9XAUD1Nqp0xHtpjIAdjl0ckaJsifTTuNL82xmyMQIRt/q8r8pJ0XrtOzXqspG08F3/bPR5Q9mWGYtsW+Qk+/USZfAUgfM2+EOuaB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wfd973SYSz4f3jMf
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 14:55:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D8C291A07BA
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 14:55:52 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIL1a7Rm9pdiBA--.26423S3;
	Thu, 08 Aug 2024 14:55:51 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, John Stoffel <john@stoffel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
Date: Thu, 8 Aug 2024 14:55:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIL1a7Rm9pdiBA--.26423S3
X-Coremail-Antispam: 1UD129KBjvAXoWDWrW5Wr13Zw47Zr1DZF45trb_yoWrtFWxKo
	W3W3ySkF48Gr15W3W8K3Z8K345Ca1IyFyfCry0kw4UCF42k3WUAFn8AFy5GayfJrs8JFyx
	CrnIqry2y3srZws5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYh7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
	bIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/08 14:02, Christian Theune 写道:
> Hi,
> 
>> On 7. Aug 2024, at 23:05, John Stoffel <john@stoffel.org> wrote:
>>
>>>>>>> "Christian" == Christian Theune <ct@flyingcircus.io> writes:
>>
>>
>>
>>> i had some more time at hand and managent to compile 5.15.164. The
>>> issue is the same. After around 1h30m of work it hangs.  I’ll try to
>>> reproduce this on a newer supported kernel if I can.
>>
>> Supported by who?   NixOS?  Why don't you just install linux kernel
>> 6.6.x and see of the problem is still there?  5.15.x is ancient and
>> un-supported upstream now.
> 
> I did just that. However, 5.15 “un-supported” by upstream is confusing me. It’s an official LTS kernel with an EOL of December 2026.
> 
> Also, I’d like to note that NixOS kernels tend to be very close to upstream. The only patches that I can see are involved here are those that patch out some hard coded references to user space paths:
> 
> https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/linux-kernels.nix#L173
> https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/request-key-helper.patch
> https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/bridge-stp-helper.patch
> 
> Kernel is now:
> 
> Linux barbrady08 6.10.3 #1-NixOS SMP PREEMPT_DYNAMIC Sat Aug  3 07:01:09 UTC 2024 x86_64 GNU/Linux
> 
> The issue is still there on 6.10.3 and now looks like shown below.
> 
> I’m aware that this is output that shows symptoms and not (necessarily) the cause. I’m currently a bit out of ideas where to look for more information and would appreciate any pointers. My suspicion is an interaction problem triggered by the use of NVMe in combination with other systems (xfs, dm-crypt and raid are the ones I’m aware of playign a role).
> 
> The use of NVMe itself likely isn’t the issue (we’ve been using NVMe on similar hosts and also in combination with dm-crypt with this kernel for a while now) and I could imagine that it triggers a race condition due to the higher performance - although the specific performance parameters aren't *that* high. Right before the lockup I see ~700 IOPS reading and ~2.5k IOPS writing. So we have seen NVMe with dm-crypt but not with raid before.
> 
> I can perform debugging on that machine as needed, but googling for any combination of hung tasks related to nvme/xfs/crypt/raid only ends up showing me generic performance concerns from forum, an unrelated xfs issue mentioned by redhat and the list archive entry from this post.

Since 6.10 is the same, I take a closer look at this.

At first is this a new problem or a new scenario?
> 
> [ 7497.019235] INFO: task .backy-wrapped:2706 blocked for more than 122 seconds.
> [ 7497.027265]       Not tainted 6.10.3 #1-NixOS
> [ 7497.032173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.040974] task:.backy-wrapped  state:D stack:0     pid:2706  tgid:2706  ppid:1      flags:0x00000002
> [ 7497.040979] Call Trace:
> [ 7497.040981]  <TASK>
> [ 7497.040987]  __schedule+0x3fa/0x1550
> [ 7497.040996]  ? xfs_iextents_copy+0xec/0x1b0 [xfs]
> [ 7497.041085]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.041089]  ? xlog_copy_iovec+0x30/0x90 [xfs]
> [ 7497.041168]  schedule+0x27/0xf0
> [ 7497.041171]  io_schedule+0x46/0x70
> [ 7497.041173]  folio_wait_bit_common+0x13f/0x340
> [ 7497.041180]  ? __pfx_wake_page_function+0x10/0x10
> [ 7497.041187]  folio_wait_writeback+0x2b/0x80
> [ 7497.041191]  truncate_inode_partial_folio+0x5b/0x190
> [ 7497.041194]  truncate_inode_pages_range+0x1de/0x400
> [ 7497.041207]  evict+0x1b0/0x1d0
> [ 7497.041212]  __dentry_kill+0x6e/0x170
> [ 7497.041216]  dput+0xe5/0x1b0
> [ 7497.041218]  do_renameat2+0x386/0x600
> [ 7497.041226]  __x64_sys_rename+0x43/0x50
> [ 7497.041229]  do_syscall_64+0xb7/0x200
> [ 7497.041234]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 7497.041236] RIP: 0033:0x7f4be586f75b
> [ 7497.041265] RSP: 002b:00007fffd2706538 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> [ 7497.041267] RAX: ffffffffffffffda RBX: 00007fffd27065d0 RCX: 00007f4be586f75b
> [ 7497.041269] RDX: 0000000000000000 RSI: 00007f4bd6f73e50 RDI: 00007f4bd6f732d0
> [ 7497.041270] RBP: 00007fffd2706580 R08: 00000000ffffffff R09: 0000000000000000
> [ 7497.041271] R10: 00007fffd27067b0 R11: 0000000000000246 R12: 00000000ffffff9c
> [ 7497.041273] R13: 00000000ffffff9c R14: 0000000037fb4ab0 R15: 00007f4be5814810
> [ 7497.041277]  </TASK>
> [ 7497.041281] INFO: task kworker/u131:1:12780 blocked for more than 122 seconds.
> [ 7497.049410]       Not tainted 6.10.3 #1-NixOS
> [ 7497.054317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.063124] task:kworker/u131:1  state:D stack:0     pid:12780 tgid:12780 ppid:2      flags:0x00004000
> [ 7497.063131] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.063140] Call Trace:
> [ 7497.063141]  <TASK>
> [ 7497.063145]  __schedule+0x3fa/0x1550
> [ 7497.063154]  schedule+0x27/0xf0
> [ 7497.063156]  md_bitmap_startwrite+0x14f/0x1c0

 From code review, the counter for the bit reaches COUNTER_MAX, means
there are already lots of write IO issued in the range represented by
this bit. And md_bitmap_startwrite() is waiting for such IO to be done
to issue new IO. Hence either IO is handered too slow or deadlock is
triggered.

So for the next step, can you do the following test for problem
identificatioin?

1) With the hangtaks, are the underlying disks idle?(By iostat). And can
you please collect /sys/block/[disk]/inflight for both raid and
underlying disks.
2) Can you still reporduce the problem with raid1/raid10?
3) Can you still reporduce the problem with bitmap disabled? By adding
md-bitmap=none while creating the array.

Thanks,
Kuai

> [ 7497.063160]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.063168]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.063175]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.063182]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.063184]  ? bio_split_rw+0x193/0x260
> [ 7497.063190]  md_handle_request+0x153/0x270
> [ 7497.063194]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.063198]  __submit_bio+0x190/0x240
> [ 7497.063203]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.063205]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.063207]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.063210]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.063214]  process_one_work+0x18f/0x3b0
> [ 7497.063219]  worker_thread+0x233/0x340
> [ 7497.063222]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.063225]  kthread+0xcd/0x100
> [ 7497.063228]  ? __pfx_kthread+0x10/0x10
> [ 7497.063230]  ret_from_fork+0x31/0x50
> [ 7497.063234]  ? __pfx_kthread+0x10/0x10
> [ 7497.063236]  ret_from_fork_asm+0x1a/0x30
> [ 7497.063243]  </TASK>
> [ 7497.063246] INFO: task kworker/u131:0:17487 blocked for more than 122 seconds.
> [ 7497.071367]       Not tainted 6.10.3 #1-NixOS
> [ 7497.076269] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.085073] task:kworker/u131:0  state:D stack:0     pid:17487 tgid:17487 ppid:2      flags:0x00004000
> [ 7497.085081] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.085086] Call Trace:
> [ 7497.085087]  <TASK>
> [ 7497.085089]  __schedule+0x3fa/0x1550
> [ 7497.085094]  schedule+0x27/0xf0
> [ 7497.085096]  md_bitmap_startwrite+0x14f/0x1c0
> [ 7497.085098]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.085102]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.085108]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.085114]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.085116]  ? bio_split_rw+0x193/0x260
> [ 7497.085120]  md_handle_request+0x153/0x270
> [ 7497.085122]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.085125]  __submit_bio+0x190/0x240
> [ 7497.085128]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.085131]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.085133]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.085135]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.085138]  process_one_work+0x18f/0x3b0
> [ 7497.085142]  worker_thread+0x233/0x340
> [ 7497.085145]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.085148]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.085150]  kthread+0xcd/0x100
> [ 7497.085152]  ? __pfx_kthread+0x10/0x10
> [ 7497.085155]  ret_from_fork+0x31/0x50
> [ 7497.085157]  ? __pfx_kthread+0x10/0x10
> [ 7497.085159]  ret_from_fork_asm+0x1a/0x30
> [ 7497.085164]  </TASK>
> [ 7497.085165] INFO: task kworker/u131:2:18973 blocked for more than 122 seconds.
> [ 7497.093282]       Not tainted 6.10.3 #1-NixOS
> [ 7497.098185] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.106988] task:kworker/u131:2  state:D stack:0     pid:18973 tgid:18973 ppid:2      flags:0x00004000
> [ 7497.106993] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.106998] Call Trace:
> [ 7497.106999]  <TASK>
> [ 7497.107001]  __schedule+0x3fa/0x1550
> [ 7497.107006]  schedule+0x27/0xf0
> [ 7497.107009]  md_bitmap_startwrite+0x14f/0x1c0
> [ 7497.107012]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.107016]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.107021]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.107026]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.107028]  ? bio_split_rw+0x193/0x260
> [ 7497.107033]  md_handle_request+0x153/0x270
> [ 7497.107036]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.107039]  __submit_bio+0x190/0x240
> [ 7497.107042]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.107044]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.107046]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.107049]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.107052]  process_one_work+0x18f/0x3b0
> [ 7497.107055]  worker_thread+0x233/0x340
> [ 7497.107058]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.107060]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.107063]  kthread+0xcd/0x100
> [ 7497.107065]  ? __pfx_kthread+0x10/0x10
> [ 7497.107067]  ret_from_fork+0x31/0x50
> [ 7497.107069]  ? __pfx_kthread+0x10/0x10
> [ 7497.107071]  ret_from_fork_asm+0x1a/0x30
> [ 7497.107081]  </TASK>
> [ 7497.107086] INFO: task rsync:23530 blocked for more than 122 seconds.
> [ 7497.114327]       Not tainted 6.10.3 #1-NixOS
> [ 7497.119226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.128020] task:rsync           state:D stack:0     pid:23530 tgid:23530 ppid:23520  flags:0x00000000
> [ 7497.128024] Call Trace:
> [ 7497.128025]  <TASK>
> [ 7497.128027]  __schedule+0x3fa/0x1550
> [ 7497.128030]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.128034]  schedule+0x27/0xf0
> [ 7497.128036]  schedule_timeout+0x15d/0x170
> [ 7497.128040]  __down_common+0x119/0x220
> [ 7497.128045]  down+0x47/0x60
> [ 7497.128048]  xfs_buf_lock+0x31/0xe0 [xfs]
> [ 7497.128131]  xfs_buf_find_lock+0x55/0x100 [xfs]
> [ 7497.128185]  xfs_buf_get_map+0x1ea/0xa80 [xfs]
> [ 7497.128236]  xfs_buf_read_map+0x62/0x2a0 [xfs]
> [ 7497.128287]  ? xfs_read_agf+0x97/0x150 [xfs]
> [ 7497.128357]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
> [ 7497.128429]  ? xfs_read_agf+0x97/0x150 [xfs]
> [ 7497.128489]  xfs_read_agf+0x97/0x150 [xfs]
> [ 7497.128540]  xfs_alloc_read_agf+0x5a/0x200 [xfs]
> [ 7497.128589]  xfs_alloc_fix_freelist+0x345/0x660 [xfs]
> [ 7497.128641]  xfs_alloc_vextent_prepare_ag+0x2d/0x120 [xfs]
> [ 7497.128690]  xfs_alloc_vextent_exact_bno+0xd1/0x100 [xfs]
> [ 7497.128740]  xfs_ialloc_ag_alloc+0x177/0x610 [xfs]
> [ 7497.128812]  xfs_dialloc+0x219/0x7b0 [xfs]
> [ 7497.128864]  ? xfs_trans_alloc_icreate+0x93/0x120 [xfs]
> [ 7497.128935]  xfs_create+0x2c7/0x640 [xfs]
> [ 7497.128998]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.129001]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.129003]  ? get_cached_acl+0x4c/0x90
> [ 7497.129008]  xfs_generic_create+0x321/0x3a0 [xfs]
> [ 7497.129061]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.129065]  path_openat+0xf82/0x1240
> [ 7497.129072]  do_filp_open+0xc4/0x170
> [ 7497.129084]  do_sys_openat2+0xab/0xe0
> [ 7497.129090]  __x64_sys_openat+0x57/0xa0
> [ 7497.129093]  do_syscall_64+0xb7/0x200
> [ 7497.129096]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [ 7497.129099] RIP: 0033:0x7f6809d2be2f
> [ 7497.129121] RSP: 002b:00007ffe3d410cf0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> [ 7497.129123] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6809d2be2f
> [ 7497.129124] RDX: 00000000000000c2 RSI: 00007ffe3d412fc0 RDI: 00000000ffffff9c
> [ 7497.129126] RBP: 000000000003a2f8 R08: 001f1108db8eff56 R09: 00007ffe3d410f2c
> [ 7497.129128] R10: 0000000000000180 R11: 0000000000000246 R12: 00007ffe3d41300b
> [ 7497.129129] R13: 00007ffe3d412fc0 R14: 8421084210842109 R15: 00007f6809dc6a80
> [ 7497.129133]  </TASK>
> [ 7497.129146] INFO: task kworker/u131:3:23611 blocked for more than 122 seconds.
> [ 7497.137277]       Not tainted 6.10.3 #1-NixOS
> [ 7497.142187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.150980] task:kworker/u131:3  state:D stack:0     pid:23611 tgid:23611 ppid:2      flags:0x00004000
> [ 7497.150986] Workqueue: writeback wb_workfn (flush-253:4)
> [ 7497.150993] Call Trace:
> [ 7497.150995]  <TASK>
> [ 7497.150998]  __schedule+0x3fa/0x1550
> [ 7497.151007]  schedule+0x27/0xf0
> [ 7497.151009]  schedule_timeout+0x15d/0x170
> [ 7497.151013]  __wait_for_common+0x90/0x1c0
> [ 7497.151015]  ? __pfx_schedule_timeout+0x10/0x10
> [ 7497.151020]  xfs_buf_iowait+0x1c/0xc0 [xfs]
> [ 7497.151094]  __xfs_buf_submit+0x132/0x1e0 [xfs]
> [ 7497.151146]  xfs_buf_read_map+0x129/0x2a0 [xfs]
> [ 7497.151197]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
> [ 7497.151267]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
> [ 7497.151336]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
> [ 7497.151396]  xfs_btree_read_buf_block+0xa7/0x120 [xfs]
> [ 7497.151446]  xfs_btree_lookup_get_block+0xa6/0x1f0 [xfs]
> [ 7497.151497]  xfs_btree_lookup+0xea/0x500 [xfs]
> [ 7497.151546]  ? xfs_btree_increment+0x44/0x310 [xfs]
> [ 7497.151596]  xfs_alloc_fixup_trees+0x66/0x4c0 [xfs]
> [ 7497.151661]  xfs_alloc_cur_finish+0x2b/0xa0 [xfs]
> [ 7497.151710]  xfs_alloc_ag_vextent_near+0x437/0x540 [xfs]
> [ 7497.151764]  xfs_alloc_vextent_iterate_ags.constprop.0+0xc8/0x200 [xfs]
> [ 7497.151813]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.151817]  ? xfs_buf_item_format+0x1b8/0x450 [xfs]
> [ 7497.151884]  xfs_alloc_vextent_start_ag+0xc0/0x190 [xfs]
> [ 7497.151938]  xfs_bmap_btalloc+0x4dd/0x640 [xfs]
> [ 7497.151999]  xfs_bmapi_allocate+0xac/0x2c0 [xfs]
> [ 7497.152048]  xfs_bmapi_convert_one_delalloc+0x1f6/0x430 [xfs]
> [ 7497.152105]  xfs_bmapi_convert_delalloc+0x43/0x60 [xfs]
> [ 7497.152155]  xfs_map_blocks+0x257/0x420 [xfs]
> [ 7497.152228]  iomap_writepages+0x271/0x9b0
> [ 7497.152235]  xfs_vm_writepages+0x67/0x90 [xfs]
> [ 7497.152287]  do_writepages+0x76/0x260
> [ 7497.152294]  ? uas_submit_urbs+0x8c/0x4c0 [uas]
> [ 7497.152297]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.152300]  ? psi_group_change+0x213/0x3c0
> [ 7497.152305]  __writeback_single_inode+0x3d/0x350
> [ 7497.152307]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.152309]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.152312]  writeback_sb_inodes+0x21c/0x4e0
> [ 7497.152323]  __writeback_inodes_wb+0x4c/0xf0
> [ 7497.152325]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.152328]  wb_writeback+0x193/0x310
> [ 7497.152332]  wb_workfn+0x357/0x450
> [ 7497.152337]  process_one_work+0x18f/0x3b0
> [ 7497.152342]  worker_thread+0x233/0x340
> [ 7497.152345]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.152348]  kthread+0xcd/0x100
> [ 7497.152352]  ? __pfx_kthread+0x10/0x10
> [ 7497.152354]  ret_from_fork+0x31/0x50
> [ 7497.152358]  ? __pfx_kthread+0x10/0x10
> [ 7497.152360]  ret_from_fork_asm+0x1a/0x30
> [ 7497.152366]  </TASK>
> [ 7497.152368] INFO: task kworker/u131:4:23612 blocked for more than 123 seconds.
> [ 7497.160489]       Not tainted 6.10.3 #1-NixOS
> [ 7497.165390] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.174190] task:kworker/u131:4  state:D stack:0     pid:23612 tgid:23612 ppid:2      flags:0x00004000
> [ 7497.174194] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.174200] Call Trace:
> [ 7497.174201]  <TASK>
> [ 7497.174203]  __schedule+0x3fa/0x1550
> [ 7497.174208]  schedule+0x27/0xf0
> [ 7497.174210]  md_bitmap_startwrite+0x14f/0x1c0
> [ 7497.174214]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.174219]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.174227]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.174233]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.174235]  ? bio_split_rw+0x193/0x260
> [ 7497.174242]  md_handle_request+0x153/0x270
> [ 7497.174245]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.174248]  __submit_bio+0x190/0x240
> [ 7497.174252]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.174255]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.174257]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.174259]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.174263]  process_one_work+0x18f/0x3b0
> [ 7497.174266]  worker_thread+0x233/0x340
> [ 7497.174269]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.174271]  kthread+0xcd/0x100
> [ 7497.174273]  ? __pfx_kthread+0x10/0x10
> [ 7497.174276]  ret_from_fork+0x31/0x50
> [ 7497.174277]  ? __pfx_kthread+0x10/0x10
> [ 7497.174279]  ret_from_fork_asm+0x1a/0x30
> [ 7497.174285]  </TASK>
> [ 7497.174292] INFO: task kworker/u130:33:23645 blocked for more than 123 seconds.
> [ 7497.182499]       Not tainted 6.10.3 #1-NixOS
> [ 7497.187400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.196203] task:kworker/u130:33 state:D stack:0     pid:23645 tgid:23645 ppid:2      flags:0x00004000
> [ 7497.196209] Workqueue: xfs-cil/dm-4 xlog_cil_push_work [xfs]
> [ 7497.196281] Call Trace:
> [ 7497.196282]  <TASK>
> [ 7497.196285]  __schedule+0x3fa/0x1550
> [ 7497.196289]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.196293]  schedule+0x27/0xf0
> [ 7497.196295]  xlog_state_get_iclog_space+0x102/0x2b0 [xfs]
> [ 7497.196346]  ? __pfx_default_wake_function+0x10/0x10
> [ 7497.196351]  xlog_write_get_more_iclog_space+0xd0/0x100 [xfs]
> [ 7497.196400]  xlog_write+0x310/0x470 [xfs]
> [ 7497.196451]  xlog_cil_push_work+0x6a5/0x880 [xfs]
> [ 7497.196503]  process_one_work+0x18f/0x3b0
> [ 7497.196507]  worker_thread+0x233/0x340
> [ 7497.196510]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.196512]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.196515]  kthread+0xcd/0x100
> [ 7497.196517]  ? __pfx_kthread+0x10/0x10
> [ 7497.196519]  ret_from_fork+0x31/0x50
> [ 7497.196522]  ? __pfx_kthread+0x10/0x10
> [ 7497.196524]  ret_from_fork_asm+0x1a/0x30
> [ 7497.196529]  </TASK>
> [ 7497.196531] INFO: task kworker/u131:6:23863 blocked for more than 123 seconds.
> [ 7497.204648]       Not tainted 6.10.3 #1-NixOS
> [ 7497.209539] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.218347] task:kworker/u131:6  state:D stack:0     pid:23863 tgid:23863 ppid:2      flags:0x00004000
> [ 7497.218353] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.218359] Call Trace:
> [ 7497.218360]  <TASK>
> [ 7497.218363]  __schedule+0x3fa/0x1550
> [ 7497.218369]  schedule+0x27/0xf0
> [ 7497.218371]  md_bitmap_startwrite+0x14f/0x1c0
> [ 7497.218375]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.218379]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.218384]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.218390]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.218392]  ? bio_split_rw+0x193/0x260
> [ 7497.218398]  md_handle_request+0x153/0x270
> [ 7497.218401]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.218405]  __submit_bio+0x190/0x240
> [ 7497.218408]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.218410]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.218413]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.218415]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.218419]  process_one_work+0x18f/0x3b0
> [ 7497.218423]  worker_thread+0x233/0x340
> [ 7497.218426]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.218428]  kthread+0xcd/0x100
> [ 7497.218430]  ? __pfx_kthread+0x10/0x10
> [ 7497.218433]  ret_from_fork+0x31/0x50
> [ 7497.218435]  ? __pfx_kthread+0x10/0x10
> [ 7497.218437]  ret_from_fork_asm+0x1a/0x30
> [ 7497.218442]  </TASK>
> [ 7497.218444] INFO: task kworker/u131:7:23864 blocked for more than 123 seconds.
> [ 7497.226572]       Not tainted 6.10.3 #1-NixOS
> [ 7497.231475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7497.240277] task:kworker/u131:7  state:D stack:0     pid:23864 tgid:23864 ppid:2      flags:0x00004000
> [ 7497.240282] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
> [ 7497.240287] Call Trace:
> [ 7497.240288]  <TASK>
> [ 7497.240290]  __schedule+0x3fa/0x1550
> [ 7497.240298]  schedule+0x27/0xf0
> [ 7497.240301]  md_bitmap_startwrite+0x14f/0x1c0
> [ 7497.240304]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 7497.240310]  __add_stripe_bio+0x1f4/0x240 [raid456]
> [ 7497.240314]  raid5_make_request+0x34d/0x1280 [raid456]
> [ 7497.240320]  ? __pfx_woken_wake_function+0x10/0x10
> [ 7497.240322]  ? bio_split_rw+0x193/0x260
> [ 7497.240328]  md_handle_request+0x153/0x270
> [ 7497.240330]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.240334]  __submit_bio+0x190/0x240
> [ 7497.240338]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [ 7497.240340]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 7497.240342]  ? submit_bio_noacct+0x46/0x5a0
> [ 7497.240345]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
> [ 7497.240348]  process_one_work+0x18f/0x3b0
> [ 7497.240353]  worker_thread+0x233/0x340
> [ 7497.240356]  ? __pfx_worker_thread+0x10/0x10
> [ 7497.240358]  kthread+0xcd/0x100
> [ 7497.240361]  ? __pfx_kthread+0x10/0x10
> [ 7497.240364]  ret_from_fork+0x31/0x50
> [ 7497.240366]  ? __pfx_kthread+0x10/0x10
> [ 7497.240368]  ret_from_fork_asm+0x1a/0x30
> [ 7497.240375]  </TASK>
> [ 7497.240376] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
> 
>>
>>
>>
>>> Kernel:
>>
>>> Linux version 5.15.164 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU ld (GNU Binutils) 2.40) #1-NixOS SMP Sat Jul 27 08:46:18 UTC 2024
>>
>>> The config is unchanged except from the deprecated NFSD_V2_ACL and NFSD_V3 options which I had to remove. NFS is not in use on this server, though.
>>
>>> Output:
>>
>>> [ 4549.838672] INFO: task kworker/u64:7:432 blocked for more than 122 seconds.
>>> [ 4549.846507]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.851616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.860421] task:kworker/u64:7   state:D stack:    0 pid:  432 ppid:     2 flags:0x00004000
>>> [ 4549.860426] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4549.860435] Call Trace:
>>> [ 4549.860437]  <TASK>
>>> [ 4549.860440]  __schedule+0x373/0x1580
>>> [ 4549.860446]  ? sysvec_call_function_single+0xa/0x90
>>> [ 4549.860449]  ? asm_sysvec_call_function_single+0x16/0x20
>>> [ 4549.860453]  schedule+0x5b/0xe0
>>> [ 4549.860455]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4549.860459]  ? finish_wait+0x90/0x90
>>> [ 4549.860465]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4549.860472]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4549.860476]  ? kmem_cache_alloc_node_trace+0x341/0x3e0
>>> [ 4549.860480]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.860484]  ? linear_map+0x44/0x90 [dm_mod]
>>> [ 4549.860490]  ? finish_wait+0x90/0x90
>>> [ 4549.860492]  ? __blk_queue_split+0x516/0x580
>>> [ 4549.860495]  md_handle_request+0x11f/0x1b0
>>> [ 4549.860500]  md_submit_bio+0x6e/0xb0
>>> [ 4549.860502]  __submit_bio+0x18c/0x220
>>> [ 4549.860505]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.860507]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4549.860510]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4549.860512]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4549.860517]  process_one_work+0x1d3/0x360
>>> [ 4549.860521]  worker_thread+0x4d/0x3b0
>>> [ 4549.860523]  ? process_one_work+0x360/0x360
>>> [ 4549.860525]  kthread+0x115/0x140
>>> [ 4549.860528]  ? set_kthread_struct+0x50/0x50
>>> [ 4549.860530]  ret_from_fork+0x1f/0x30
>>> [ 4549.860535]  </TASK>
>>> [ 4549.860536] INFO: task kworker/u64:23:448 blocked for more than 122 seconds.
>>> [ 4549.868461]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.873555] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.882358] task:kworker/u64:23  state:D stack:    0 pid:  448 ppid:     2 flags:0x00004000
>>> [ 4549.882364] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4549.882368] Call Trace:
>>> [ 4549.882369]  <TASK>
>>> [ 4549.882370]  __schedule+0x373/0x1580
>>> [ 4549.882373]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4549.882375]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4549.882379]  schedule+0x5b/0xe0
>>> [ 4549.882382]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4549.882384]  ? finish_wait+0x90/0x90
>>> [ 4549.882387]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4549.882393]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4549.882397]  ? __bio_clone_fast+0xa5/0xe0
>>> [ 4549.882401]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.882403]  ? finish_wait+0x90/0x90
>>> [ 4549.882406]  md_handle_request+0x11f/0x1b0
>>> [ 4549.882410]  ? blk_throtl_charge_bio_split+0x23/0x60
>>> [ 4549.882413]  md_submit_bio+0x6e/0xb0
>>> [ 4549.882415]  __submit_bio+0x18c/0x220
>>> [ 4549.882417]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.882419]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4549.882421]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4549.882424]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4549.882428]  process_one_work+0x1d3/0x360
>>> [ 4549.882431]  worker_thread+0x4d/0x3b0
>>> [ 4549.882433]  ? process_one_work+0x360/0x360
>>> [ 4549.882435]  kthread+0x115/0x140
>>> [ 4549.882436]  ? set_kthread_struct+0x50/0x50
>>> [ 4549.882438]  ret_from_fork+0x1f/0x30
>>> [ 4549.882442]  </TASK>
>>> [ 4549.882497] INFO: task .backy-wrapped:2578 blocked for more than 122 seconds.
>>> [ 4549.890517]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.895611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.904406] task:.backy-wrapped  state:D stack:    0 pid: 2578 ppid:     1 flags:0x00000002
>>> [ 4549.904411] Call Trace:
>>> [ 4549.904412]  <TASK>
>>> [ 4549.904414]  __schedule+0x373/0x1580
>>> [ 4549.904419]  ? xlog_cil_commit+0x556/0x880 [xfs]
>>> [ 4549.904465]  ? __xfs_trans_commit+0xac/0x2f0 [xfs]
>>> [ 4549.904498]  schedule+0x5b/0xe0
>>> [ 4549.904500]  io_schedule+0x42/0x70
>>> [ 4549.904503]  wait_on_page_bit_common+0x119/0x380
>>> [ 4549.904507]  ? __page_cache_alloc+0x80/0x80
>>> [ 4549.904510]  wait_on_page_writeback+0x22/0x70
>>> [ 4549.904513]  truncate_inode_pages_range+0x26f/0x6d0
>>> [ 4549.904520]  evict+0x15f/0x180
>>> [ 4549.904524]  __dentry_kill+0xde/0x170
>>> [ 4549.904527]  dput+0x139/0x320
>>> [ 4549.904529]  do_renameat2+0x375/0x5f0
>>> [ 4549.904536]  __x64_sys_rename+0x3f/0x50
>>> [ 4549.904538]  do_syscall_64+0x34/0x80
>>> [ 4549.904541]  entry_SYSCALL_64_after_hwframe+0x6c/0xd6
>>> [ 4549.904544] RIP: 0033:0x7fbf3e61a75b
>>> [ 4549.904545] RSP: 002b:00007ffc61e25988 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
>>> [ 4549.904548] RAX: ffffffffffffffda RBX: 00007ffc61e25a20 RCX: 00007fbf3e61a75b
>>> [ 4549.904549] RDX: 0000000000000000 RSI: 00007fbf2f7ff150 RDI: 00007fbf2f7fc190
>>> [ 4549.904550] RBP: 00007ffc61e259d0 R08: 00000000ffffffff R09: 0000000000000000
>>> [ 4549.904551] R10: 00007ffc61e25c00 R11: 0000000000000246 R12: 00000000ffffff9c
>>> [ 4549.904552] R13: 00000000ffffff9c R14: 00000000016afab0 R15: 00007fbf30ef0810
>>> [ 4549.904555]  </TASK>
>>> [ 4549.904556] INFO: task kworker/u64:0:4372 blocked for more than 122 seconds.
>>> [ 4549.912477]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.917573] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.926373] task:kworker/u64:0   state:D stack:    0 pid: 4372 ppid:     2 flags:0x00004000
>>> [ 4549.926376] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4549.926380] Call Trace:
>>> [ 4549.926381]  <TASK>
>>> [ 4549.926383]  __schedule+0x373/0x1580
>>> [ 4549.926386]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4549.926389]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4549.926392]  schedule+0x5b/0xe0
>>> [ 4549.926394]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4549.926397]  ? finish_wait+0x90/0x90
>>> [ 4549.926401]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4549.926406]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4549.926410]  ? __bio_clone_fast+0xa5/0xe0
>>> [ 4549.926413]  ? finish_wait+0x90/0x90
>>> [ 4549.926415]  ? __blk_queue_split+0x2d0/0x580
>>> [ 4549.926418]  md_handle_request+0x11f/0x1b0
>>> [ 4549.926422]  md_submit_bio+0x6e/0xb0
>>> [ 4549.926424]  __submit_bio+0x18c/0x220
>>> [ 4549.926426]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.926428]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4549.926431]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4549.926434]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4549.926437]  process_one_work+0x1d3/0x360
>>> [ 4549.926441]  worker_thread+0x4d/0x3b0
>>> [ 4549.926442]  ? process_one_work+0x360/0x360
>>> [ 4549.926444]  kthread+0x115/0x140
>>> [ 4549.926447]  ? set_kthread_struct+0x50/0x50
>>> [ 4549.926448]  ret_from_fork+0x1f/0x30
>>> [ 4549.926454]  </TASK>
>>> [ 4549.926459] INFO: task rsync:4929 blocked for more than 122 seconds.
>>> [ 4549.933603]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.938702] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.947501] task:rsync           state:D stack:    0 pid: 4929 ppid:  4925 flags:0x00000000
>>> [ 4549.947503] Call Trace:
>>> [ 4549.947505]  <TASK>
>>> [ 4549.947505]  ? usleep_range_state+0x90/0x90
>>> [ 4549.947510]  __schedule+0x373/0x1580
>>> [ 4549.947513]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.947515]  ? blk_mq_sched_insert_requests+0x97/0xe0
>>> [ 4549.947519]  ? usleep_range_state+0x90/0x90
>>> [ 4549.947521]  schedule+0x5b/0xe0
>>> [ 4549.947523]  schedule_timeout+0xff/0x130
>>> [ 4549.947526]  __wait_for_common+0xaf/0x160
>>> [ 4549.947530]  xfs_buf_iowait+0x1c/0xa0 [xfs]
>>> [ 4549.947573]  __xfs_buf_submit+0x109/0x1b0 [xfs]
>>> [ 4549.947604]  xfs_buf_read_map+0x120/0x280 [xfs]
>>> [ 4549.947635]  ? xfs_btree_read_buf_block.constprop.0+0xae/0xf0 [xfs]
>>> [ 4549.947670]  xfs_trans_read_buf_map+0x156/0x2c0 [xfs]
>>> [ 4549.947705]  ? xfs_btree_read_buf_block.constprop.0+0xae/0xf0 [xfs]
>>> [ 4549.947735]  xfs_btree_read_buf_block.constprop.0+0xae/0xf0 [xfs]
>>> [ 4549.947764]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.947766]  xfs_btree_lookup_get_block+0xa2/0x180 [xfs]
>>> [ 4549.947798]  xfs_btree_lookup+0xe9/0x540 [xfs]
>>> [ 4549.947830]  xfs_alloc_lookup_eq+0x1d/0x30 [xfs]
>>> [ 4549.947863]  xfs_alloc_fixup_trees+0xe7/0x3b0 [xfs]
>>> [ 4549.947893]  xfs_alloc_cur_finish+0x2b/0xa0 [xfs]
>>> [ 4549.947923]  xfs_alloc_ag_vextent_near.constprop.0+0x3f2/0x4a0 [xfs]
>>> [ 4549.947954]  xfs_alloc_ag_vextent+0x13f/0x150 [xfs]
>>> [ 4549.947983]  xfs_alloc_vextent+0x327/0x450 [xfs]
>>> [ 4549.948013]  xfs_bmap_btalloc+0x44e/0x830 [xfs]
>>> [ 4549.948047]  xfs_bmapi_allocate+0xda/0x300 [xfs]
>>> [ 4549.948076]  xfs_bmapi_write+0x4ab/0x570 [xfs]
>>> [ 4549.948109]  xfs_da_grow_inode_int+0xd8/0x320 [xfs]
>>> [ 4549.948141]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.948142]  ? xfs_da_read_buf+0xf7/0x150 [xfs]
>>> [ 4549.948171]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.948174]  xfs_dir2_grow_inode+0x68/0x120 [xfs]
>>> [ 4549.948204]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.948206]  xfs_dir2_node_addname+0x5ea/0x9e0 [xfs]
>>> [ 4549.948241]  xfs_dir_createname+0x1cf/0x1e0 [xfs]
>>> [ 4549.948271]  xfs_rename+0x87e/0xcd0 [xfs]
>>> [ 4549.948308]  xfs_vn_rename+0xfa/0x170 [xfs]
>>> [ 4549.948340]  vfs_rename+0x818/0x10d0
>>> [ 4549.948345]  ? lookup_dcache+0x17/0x60
>>> [ 4549.948348]  ? do_renameat2+0x57f/0x5f0
>>> [ 4549.948350]  do_renameat2+0x57f/0x5f0
>>> [ 4549.948355]  __x64_sys_rename+0x3f/0x50
>>> [ 4549.948357]  do_syscall_64+0x34/0x80
>>> [ 4549.948360]  entry_SYSCALL_64_after_hwframe+0x6c/0xd6
>>> [ 4549.948362] RIP: 0033:0x7fcc5520c1d7
>>> [ 4549.948364] RSP: 002b:00007ffe3909c748 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
>>> [ 4549.948366] RAX: ffffffffffffffda RBX: 00007ffe3909c8f0 RCX: 00007fcc5520c1d7
>>> [ 4549.948367] RDX: 0000000000000000 RSI: 00007ffe3909c8f0 RDI: 00007ffe3909e8f0
>>> [ 4549.948368] RBP: 00007ffe3909e8f0 R08: 0000000000000000 R09: 00007ffe3909c2f8
>>> [ 4549.948369] R10: 00007ffe3909c2f7 R11: 0000000000000246 R12: 0000000000000000
>>> [ 4549.948370] R13: 00000000023c9c30 R14: 00000000000081a4 R15: 0000000000000004
>>> [ 4549.948373]  </TASK>
>>> [ 4549.948374] INFO: task kworker/u64:1:4930 blocked for more than 122 seconds.
>>> [ 4549.956299]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.961396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.970198] task:kworker/u64:1   state:D stack:    0 pid: 4930 ppid:     2 flags:0x00004000
>>> [ 4549.970202] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4549.970205] Call Trace:
>>> [ 4549.970206]  <TASK>
>>> [ 4549.970209]  __schedule+0x373/0x1580
>>> [ 4549.970211]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.970215]  schedule+0x5b/0xe0
>>> [ 4549.970217]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4549.970219]  ? finish_wait+0x90/0x90
>>> [ 4549.970223]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4549.970229]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4549.970232]  ? kmem_cache_alloc_node_trace+0x341/0x3e0
>>> [ 4549.970236]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.970238]  ? linear_map+0x44/0x90 [dm_mod]
>>> [ 4549.970244]  ? finish_wait+0x90/0x90
>>> [ 4549.970245]  ? __blk_queue_split+0x516/0x580
>>> [ 4549.970248]  md_handle_request+0x11f/0x1b0
>>> [ 4549.970251]  md_submit_bio+0x6e/0xb0
>>> [ 4549.970254]  __submit_bio+0x18c/0x220
>>> [ 4549.970256]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.970258]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4549.970260]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4549.970263]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4549.970267]  process_one_work+0x1d3/0x360
>>> [ 4549.970270]  worker_thread+0x4d/0x3b0
>>> [ 4549.970272]  ? process_one_work+0x360/0x360
>>> [ 4549.970274]  kthread+0x115/0x140
>>> [ 4549.970276]  ? set_kthread_struct+0x50/0x50
>>> [ 4549.970278]  ret_from_fork+0x1f/0x30
>>> [ 4549.970282]  </TASK>
>>> [ 4549.970284] INFO: task kworker/u64:2:4949 blocked for more than 123 seconds.
>>> [ 4549.978205]       Not tainted 5.15.164 #1-NixOS
>>> [ 4549.983290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4549.992088] task:kworker/u64:2   state:D stack:    0 pid: 4949 ppid:     2 flags:0x00004000
>>> [ 4549.992093] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4549.992097] Call Trace:
>>> [ 4549.992098]  <TASK>
>>> [ 4549.992100]  __schedule+0x373/0x1580
>>> [ 4549.992103]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4549.992106]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4549.992109]  schedule+0x5b/0xe0
>>> [ 4549.992111]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4549.992114]  ? finish_wait+0x90/0x90
>>> [ 4549.992117]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4549.992122]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4549.992125]  ? kmem_cache_alloc+0x261/0x3b0
>>> [ 4549.992129]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.992131]  ? linear_map+0x44/0x90 [dm_mod]
>>> [ 4549.992135]  ? finish_wait+0x90/0x90
>>> [ 4549.992137]  ? __blk_queue_split+0x516/0x580
>>> [ 4549.992139]  md_handle_request+0x11f/0x1b0
>>> [ 4549.992142]  md_submit_bio+0x6e/0xb0
>>> [ 4549.992144]  __submit_bio+0x18c/0x220
>>> [ 4549.992146]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4549.992148]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4549.992150]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4549.992153]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4549.992157]  process_one_work+0x1d3/0x360
>>> [ 4549.992160]  worker_thread+0x4d/0x3b0
>>> [ 4549.992162]  ? process_one_work+0x360/0x360
>>> [ 4549.992163]  kthread+0x115/0x140
>>> [ 4549.992166]  ? set_kthread_struct+0x50/0x50
>>> [ 4549.992168]  ret_from_fork+0x1f/0x30
>>> [ 4549.992172]  </TASK>
>>> [ 4549.992174] INFO: task kworker/u64:5:4952 blocked for more than 123 seconds.
>>> [ 4550.000095]       Not tainted 5.15.164 #1-NixOS
>>> [ 4550.005187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4550.013985] task:kworker/u64:5   state:D stack:    0 pid: 4952 ppid:     2 flags:0x00004000
>>> [ 4550.013988] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4550.013992] Call Trace:
>>> [ 4550.013993]  <TASK>
>>> [ 4550.013995]  __schedule+0x373/0x1580
>>> [ 4550.013997]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4550.014000]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4550.014003]  schedule+0x5b/0xe0
>>> [ 4550.014005]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4550.014008]  ? finish_wait+0x90/0x90
>>> [ 4550.014010]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4550.014015]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4550.014018]  ? __bio_clone_fast+0xa5/0xe0
>>> [ 4550.014022]  ? finish_wait+0x90/0x90
>>> [ 4550.014024]  ? __blk_queue_split+0x2d0/0x580
>>> [ 4550.014027]  md_handle_request+0x11f/0x1b0
>>> [ 4550.014030]  md_submit_bio+0x6e/0xb0
>>> [ 4550.014032]  __submit_bio+0x18c/0x220
>>> [ 4550.014034]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4550.014036]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4550.014038]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4550.014041]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4550.014044]  process_one_work+0x1d3/0x360
>>> [ 4550.014047]  worker_thread+0x4d/0x3b0
>>> [ 4550.014049]  ? process_one_work+0x360/0x360
>>> [ 4550.014050]  kthread+0x115/0x140
>>> [ 4550.014052]  ? set_kthread_struct+0x50/0x50
>>> [ 4550.014054]  ret_from_fork+0x1f/0x30
>>> [ 4550.014058]  </TASK>
>>> [ 4550.014059] INFO: task kworker/u64:8:4954 blocked for more than 123 seconds.
>>> [ 4550.021982]       Not tainted 5.15.164 #1-NixOS
>>> [ 4550.027078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4550.035881] task:kworker/u64:8   state:D stack:    0 pid: 4954 ppid:     2 flags:0x00004000
>>> [ 4550.035884] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4550.035887] Call Trace:
>>> [ 4550.035888]  <TASK>
>>> [ 4550.035890]  __schedule+0x373/0x1580
>>> [ 4550.035893]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4550.035896]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4550.035899]  schedule+0x5b/0xe0
>>> [ 4550.035901]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4550.035904]  ? finish_wait+0x90/0x90
>>> [ 4550.035907]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4550.035912]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4550.035916]  ? __bio_clone_fast+0xa5/0xe0
>>> [ 4550.035919]  ? finish_wait+0x90/0x90
>>> [ 4550.035921]  ? __blk_queue_split+0x2d0/0x580
>>> [ 4550.035924]  md_handle_request+0x11f/0x1b0
>>> [ 4550.035927]  md_submit_bio+0x6e/0xb0
>>> [ 4550.035929]  __submit_bio+0x18c/0x220
>>> [ 4550.035931]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4550.035933]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4550.035936]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4550.035939]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4550.035942]  process_one_work+0x1d3/0x360
>>> [ 4550.035946]  worker_thread+0x4d/0x3b0
>>> [ 4550.035948]  ? process_one_work+0x360/0x360
>>> [ 4550.035949]  kthread+0x115/0x140
>>> [ 4550.035951]  ? set_kthread_struct+0x50/0x50
>>> [ 4550.035953]  ret_from_fork+0x1f/0x30
>>> [ 4550.035957]  </TASK>
>>> [ 4550.035958] INFO: task kworker/u64:9:4955 blocked for more than 123 seconds.
>>> [ 4550.043881]       Not tainted 5.15.164 #1-NixOS
>>> [ 4550.048979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 4550.057786] task:kworker/u64:9   state:D stack:    0 pid: 4955 ppid:     2 flags:0x00004000
>>> [ 4550.057790] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>> [ 4550.057794] Call Trace:
>>> [ 4550.057796]  <TASK>
>>> [ 4550.057798]  __schedule+0x373/0x1580
>>> [ 4550.057801]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>> [ 4550.057803]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [ 4550.057806]  schedule+0x5b/0xe0
>>> [ 4550.057808]  md_bitmap_startwrite+0x177/0x1e0
>>> [ 4550.057810]  ? finish_wait+0x90/0x90
>>> [ 4550.057813]  add_stripe_bio+0x449/0x770 [raid456]
>>> [ 4550.057818]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>> [ 4550.057821]  ? __bio_clone_fast+0xa5/0xe0
>>> [ 4550.057824]  ? finish_wait+0x90/0x90
>>> [ 4550.057826]  ? __blk_queue_split+0x2d0/0x580
>>> [ 4550.057828]  md_handle_request+0x11f/0x1b0
>>> [ 4550.057831]  md_submit_bio+0x6e/0xb0
>>> [ 4550.057834]  __submit_bio+0x18c/0x220
>>> [ 4550.057835]  ? srso_alias_return_thunk+0x5/0x7f
>>> [ 4550.057837]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>> [ 4550.057839]  submit_bio_noacct+0xbe/0x2d0
>>> [ 4550.057842]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>> [ 4550.057846]  process_one_work+0x1d3/0x360
>>> [ 4550.057848]  worker_thread+0x4d/0x3b0
>>> [ 4550.057850]  ? process_one_work+0x360/0x360
>>> [ 4550.057852]  kthread+0x115/0x140
>>> [ 4550.057854]  ? set_kthread_struct+0x50/0x50
>>> [ 4550.057856]  ret_from_fork+0x1f/0x30
>>> [ 4550.057860]  </TASK>
>>
>>
>>>> On 7. Aug 2024, at 08:46, Christian Theune <ct@flyingcircus.io> wrote:
>>>>
>>>> I tried updating to 5.15.164, but have to struggle against our config management as some options have been shifted that I need to filter out: NFSD_V3 and NFSD2_ACL are now fixed and cause config errors if set - I guess that’s a valid thing to happen within an LTS release. I’ll try again on Friday
>>>>
>>>>> On 7. Aug 2024, at 07:31, Christian Theune <ct@flyingcircus.io> wrote:
>>>>>
>>>>> Sure,
>>>>>
>>>>> would you prefer me testing on 5.15.x or something else?
>>>>>
>>>>>> On 7. Aug 2024, at 04:55, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> 在 2024/08/06 22:10, Christian Theune 写道:
>>>>>>> we are seeing an issue that can be triggered with relative ease on a server that has been working fine for a few weeks. The regular workload is a backup utility that copies off data from virtual disk images in 4MiB (compressed) chunks from Ceph onto a local NVME-based RAID-6 array that is encrypted using LUKS.
>>>>>>> Today I started a larger rsync job from another server (that has a couple of million files with around 200-300 gib in total) to migrate data and we’ve seen the server suddenly lock up twice. Any IO that interacts with the mountpoint (/srv/backy) will hang indefinitely. A reset is required to get out of this as the machine will hang trying to unmount the affected filesystem. No other messages than the hung tasks are being presented - I have no indicator for hardware faults at the moment.
>>>>>>> I’m messaging both dm-devel and linux-raid as I’m suspecting either one or both (or an interaction) might be the cause.
>>>>>>> Kernel:
>>>>>>> Linux version 5.15.138 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU ld (GNU Binutils) 2.40) #1-NixOS SMP Wed Nov 8 16:26:52 UTC 2023
>>>>>>
>>>>>> Since you can trigger this easily, I'll suggest you to try the latest
>>>>>> kernel release first.
>>>>>>
>>>>>> Thanks,
>>>>>> Kuai
>>>>>>
>>>>>>> See the kernel config attached.
>>>>>
>>>>>
>>>>> Liebe Grüße,
>>>>> Christian Theune
>>>>>
>>>>> -- 
>>>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>>>>
>>>>>
>>>>
>>>> Liebe Grüße,
>>>> Christian Theune
>>>>
>>>> -- 
>>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>>>
>>
>>> Liebe Grüße,
>>> Christian Theune
>>
>>> -- 
>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>
>>
> 
> Liebe Grüße,
> Christian Theune
> 

