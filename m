Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1F81D52B
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 07:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706342287; cv=none; b=FwaerXVl8hIsutrtY5brtT7g7J61CkWim/PxuSPVn/2TEX8/BYF4/6JbLOVSd+8HdKVG8ajT0ftIi4/GKtjPZFzVfoDX+91QTRUVhgJf5Wsuc0HmOFLLL+QY8rF3BMHyQcA90FFOGTaS8gLlWUjJ5cMVL0sqO/Cw1yGrYn5nh6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706342287; c=relaxed/simple;
	bh=P4jNAdBcYHPqoQV4W6EB91cNSw9pkxpKnVjgxuFSTJY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lyAs4q61ztn6WtPjh9PRVmHX+sYoxNtpQx5yvyX26Q8kDkaN20CTOXQC6RKyBMu/487nFuDQvn5SP2tqCkCRk3s2nodl1uJE/y5QJ6GiRraJvl7/jKBZ0DV/aWEurHcz9+59w653t11TWmbxprfCmRqPdqQpiA65NcnxKp4ureg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TMRkZ4jCmz4f3k63
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 15:57:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 192771A0272
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 15:58:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBGHt7RlIaeACA--.37378S3;
	Sat, 27 Jan 2024 15:58:00 +0800 (CST)
Subject: Re: [PATCH 0/7] MD fixes for the LVM2 testsuite
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e52bbc20-353d-6984-e2cb-662d4676b99a@huaweicloud.com>
Date: Sat, 27 Jan 2024 15:57:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBGHt7RlIaeACA--.37378S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4kZw1Dtr15ZFW7tw15CFg_yoWxuryrpF
	W3tFyfGr4vyryktr4SqF17CFyxXayDAa4UJr1xJw1xJF1Uua4DJ3WYyryFqFyDW34kua43
	t3Z8tr1xKr4DJaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvvb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2
	jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73Uj
	IFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Mikulas

ÔÚ 2024/01/18 2:16, Mikulas Patocka Ð´µÀ:
> Hi
> 
> Here I'm sending MD patches that fix the LVM2 testsuite for the kernels
> 6.7 and 6.8. The testsuite was broken in the 6.6 -> 6.7 window, there are
> multiple tests that deadlock.
> 
> I fixed some of the bugs. And I reverted some patches that claim to be
> fixing bugs but they break the testsuite.
> 
> I'd like to ask you - please, next time when you are going to commit
> something into the MD subsystem, download the LVM2 package from
> git://sourceware.org/git/lvm2.git and run the testsuite ("./configure &&
> make && make check") to make sure that your bugfix doesn't introduce
> another bug. You can run a specific test with the "T" parameter - for
> example "make check T=shell/integrity-caching.sh"

I tried to found broken test by myself, but I have to ask now... While
verify my fixes[1], other than the test you mentioned in this patchset:

shell/integrity-caching.sh
shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
shell/lvconvert-raid-reshape.sh

I verified in my VM that before my fixes, they do hang/fail easily and
they are indeed related to md/raid changes recently. However, I still
meet some problems that I can't make progress for now.

Is there other tests that you know are broken in the v6.6->v6.7 window?
And is there know broken test in v6.6?

Because I found some tests will fail occasionally in v6.8-rc1 with my
fixes, and they will fail in v6.6 as well. For example:

shell/lvchange-raid1-writemostly.sh
## ERROR: The test started dmeventd (2064) unexpectedly.

shell/select-report.sh
    >>> NUMBER OF ITEMS EXPECTED: 6 vol1 vol2 abc abc orig xyz
#select-report.sh:67+ echo '  >>> NUMBER OF ITEMS FOUND: 7 (  vol1 vol2 
abc abc orig snap xyz )'

And I also met a following BUG during test:

[12504.959682] BUG bio-296 (Not tainted): Object already free 

[12504.960239] 
----------------------------------------------------------------------------- 

[12504.960239] 

[12504.961209] Allocated in mempool_alloc+0xe8/0x270 age=30 cpu=1 
pid=203288
[12504.961905]  kmem_cache_alloc+0x36a/0x3b0 

[12504.962324]  mempool_alloc+0xe8/0x270 

[12504.962712]  bio_alloc_bioset+0x3b5/0x920 

[12504.963129]  bio_alloc_clone+0x3e/0x160 

[12504.963533]  alloc_io+0x3d/0x1f0 

[12504.963876]  dm_submit_bio+0x12f/0xa30 

[12504.964267]  __submit_bio+0x9c/0xe0 

[12504.964639]  submit_bio_noacct_nocheck+0x25a/0x570 

[12504.965136]  submit_bio_wait+0xc2/0x160 

[12504.965535]  blkdev_issue_zeroout+0x19b/0x2e0 

[12504.965991]  ext4_init_inode_table+0x246/0x560 

[12504.966462]  ext4_lazyinit_thread+0x750/0xbe0 

[12504.966922]  kthread+0x1b4/0x1f0

And a lockdep waring:

[ 1229.452306] ============================================ 

[ 1229.452838] WARNING: possible recursive locking detected 

[ 1229.453344] 6.8.0-rc1+ #941 Not tainted 

[ 1229.453711] -------------------------------------------- 

[ 1229.454242] lvm/18080 is trying to acquire lock: 

[ 1229.454687] ffff888112abc1d0 (&pmd->root_lock){++++}-{3:3}, at: 
dm_thin_find_block+0x9f/0x0
[ 1229.455543] 

[ 1229.455543] but task is already holding lock: 

[ 1229.456122] ffff8881058bf1d0 (&pmd->root_lock){++++}-{3:3}, at: 
dm_pool_commit_metadata+0x0
[ 1229.456992] 

[ 1229.456992] other info that might help us debug this: 

[ 1229.457628]  Possible unsafe locking scenario: 

[ 1229.457628] 

[ 1229.458218]        CPU0 

[ 1229.458469]        ---- 

[ 1229.458726]   lock(&pmd->root_lock); 

[ 1229.459093]   lock(&pmd->root_lock); 

[ 1229.459455] 

[ 1229.459455]  *** DEADLOCK *** 

[ 1229.459455] 

[ 1229.460045]  May be due to missing lock nesting notation 

[ 1229.460045] 

[ 1229.460697] 3 locks held by lvm/18080: 

[ 1229.461074]  #0: ffff888153306870 (&md->suspend_lock/1){+.+.}-{3:3}, 
at: dm_resume+0x24/0x0
[ 1229.461935]  #1: ffff8881058bf1d0 (&pmd->root_lock){++++}-{3:3}, at: 
dm_pool_commit_metada0
[ 1229.462857]  #2: ffff88810f3abf10 (&md->io_barrier){.+.+}-{0:0}, at: 
dm_get_live_table+0x50
[ 1229.463731] 

[ 1229.463731] 

[ 1229.463731] stack backtrace: 

[ 1229.464165] CPU: 3 PID: 18080 Comm: lvm Not tainted 6.8.0-rc1+ #941 

[ 1229.464780] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.16.1-2.fc37 04/04
[ 1229.465618] Call Trace: 

[ 1229.465884]  <TASK> 

[ 1229.466110]  dump_stack_lvl+0x4a/0x80 

[ 1229.466491]  __lock_acquire+0x1ad4/0x3540 

[ 1229.467369]  lock_acquire+0x16a/0x400 

[ 1229.470276]  down_read+0xa3/0x380 

[ 1229.471877]  dm_thin_find_block+0x9f/0x1e0 

[ 1229.474901]  thin_map+0x28b/0x5f0 

[ 1229.476116]  __map_bio+0x237/0x260 

[ 1229.476469]  dm_submit_bio+0x321/0xa30 

[ 1229.478546]  __submit_bio+0x9c/0xe0 

[ 1229.478913]  submit_bio_noacct_nocheck+0x25a/0x570 

[ 1229.480807]  __flush_write_list+0x115/0x1a0 

[ 1229.481725]  dm_bufio_write_dirty_buffers+0xb9/0x600 

[ 1229.483642]  __commit_transaction+0x2f3/0x4e0 

[ 1229.486185]  dm_pool_commit_metadata+0x3c/0x70 

[ 1229.486636]  commit+0x8c/0x1b0 

[ 1229.487757]  pool_preresume+0x235/0x550 

[ 1229.489010]  dm_table_resume_targets+0xa6/0x1b0 

[ 1229.489467]  dm_resume+0x120/0x210 

[ 1229.489820]  dev_suspend+0x269/0x3e0 

[ 1229.490187]  ctl_ioctl+0x447/0x740 

[ 1229.492539]  dm_ctl_ioctl+0xe/0x20 

[ 1229.492895]  __x64_sys_ioctl+0xc9/0x100 

[ 1229.493284]  do_syscall_64+0x7d/0x1a0 

[ 1229.493667]  entry_SYSCALL_64_after_hwframe+0x6e/0x76 

[ 1229.494171] RIP: 0033:0x7f86667400ab 

[ 1229.494537] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 
89 e0 41 5c c3 66 0f 8
[ 1229.496340] RSP: 002b:00007fff312bc1f8 EFLAGS: 00000206 ORIG_RAX: 
0000000000000010
[ 1229.497084] RAX: ffffffffffffffda RBX: 0000561323f78320 RCX: 
00007f86667400ab
[ 1229.497796] RDX: 000056132506a8e0 RSI: 00000000c138fd06 RDI: 
0000000000000004
[ 1229.498494] RBP: 000056132402614e R08: 0000000000000000 R09: 
00000000000f4240
[ 1229.499195] R10: 0000000000000001 R11: 0000000000000206 R12: 
000056132506a990
[ 1229.499901] R13: 0000000000000001 R14: 0000561325060460 R15: 
000056132506a8e0
[ 1229.500615]  </TASK> 

[ 1230.525934] device-mapper: thin: Data device (dm-8) discard 
unsupported: Disabling discard.

Currently, I'm not sure if there are still new regressions related to
md/raid changes. Do you have any suggestions? Please let me know what
you think, I really need some help here. :(

BTW, as Xiao Ni replied in the other thread[2], he also tests my fixes
and reported that there are 72 failed tests in total, which is
unbelievable for me. And we must dig deeper for root cause...

[1] 
https://lore.kernel.org/all/20240127074754.2380890-1-yukuai1@huaweicloud.com/
[2] 
https://lore.kernel.org/all/CALTww2_f_orkTXPDtA4AJsbX-UmwhAb-AF_tujH4Gw3cX3ObWg@mail.gmail.com/
Thanks,
Kuai

> 
> Mikulas
> 
> .
> 

