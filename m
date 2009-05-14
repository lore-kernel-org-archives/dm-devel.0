From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] IO Controller: Add per-device weight and ioprio_class
 handling
Date: Thu, 14 May 2009 09:24:02 +0800
Message-ID: <4A0B72B2.3020305@cn.fujitsu.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A0A29B5.7030109@cn.fujitsu.com> <20090513171734.GA18371@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762258AbZENBZQ@vger.kernel.org>
In-Reply-To: <20090513171734.GA18371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
>> +	}
>> +	spin_unlock_irq(&iocg->lock);
>>  
> 
> I think we need to use spin_lock_irqsave() and spin_lock_irqrestore()
> version above because it can be called with request queue lock held and we
> don't want to enable the interrupts unconditionally here.

  Will change.

> 
> I hit following lock validator warning.
> 
>  
> [   81.521242] =================================
> [   81.522127] [ INFO: inconsistent lock state ]
> [   81.522127] 2.6.30-rc4-ioc #47
> [   81.522127] ---------------------------------
> [   81.522127] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> [   81.522127] io-group-bw-tes/4138 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [   81.522127]  (&q->__queue_lock){+.?...}, at: [<ffffffff811d7b2e>] __make_request+0x35/0x396
> [   81.522127] {IN-SOFTIRQ-W} state was registered at:
> [   81.522127]   [<ffffffffffffffff>] 0xffffffffffffffff
> [   81.522127] irq event stamp: 1006
> [   81.522127] hardirqs last  enabled at (1005): [<ffffffff810c1198>] kmem_cache_alloc+0x9d/0x105
> [   81.522127] hardirqs last disabled at (1006): [<ffffffff8150343f>] _spin_lock_irq+0x12/0x3e
> [   81.522127] softirqs last  enabled at (286): [<ffffffff81042039>] __do_softirq+0x17a/0x187
> [   81.522127] softirqs last disabled at (271): [<ffffffff8100ccfc>] call_softirq+0x1c/0x34
> [   81.522127] 
> [   81.522127] other info that might help us debug this:
> [   81.522127] 3 locks held by io-group-bw-tes/4138:
> [   81.522127]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<ffffffff810cfd2c>] do_lookup+0x82/0x15f
> [   81.522127]  #1:  (&q->__queue_lock){+.?...}, at: [<ffffffff811d7b2e>] __make_request+0x35/0x396
> [   81.522127]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e55bb>] __rcu_read_lock+0x0/0x30
> [   81.522127] 
> [   81.522127] stack backtrace:
> [   81.522127] Pid: 4138, comm: io-group-bw-tes Not tainted 2.6.30-rc4-ioc #47
> [   81.522127] Call Trace:
> [   81.522127]  [<ffffffff8105edad>] valid_state+0x17c/0x18f
> [   81.522127]  [<ffffffff8105eb8a>] ? check_usage_backwards+0x0/0x52
> [   81.522127]  [<ffffffff8105ee9b>] mark_lock+0xdb/0x1ff
> [   81.522127]  [<ffffffff8105f00c>] mark_held_locks+0x4d/0x6b
> [   81.522127]  [<ffffffff8150331a>] ? _spin_unlock_irq+0x2b/0x31
> [   81.522127]  [<ffffffff8105f13e>] trace_hardirqs_on_caller+0x114/0x138
> [   81.522127]  [<ffffffff8105f16f>] trace_hardirqs_on+0xd/0xf
> [   81.522127]  [<ffffffff8150331a>] _spin_unlock_irq+0x2b/0x31
> [   81.522127]  [<ffffffff811e5534>] ? io_group_init_entity+0x2a/0xb1
> [   81.522127]  [<ffffffff811e5597>] io_group_init_entity+0x8d/0xb1
> [   81.522127]  [<ffffffff811e688e>] ? io_group_chain_alloc+0x49/0x167
> [   81.522127]  [<ffffffff811e68fe>] io_group_chain_alloc+0xb9/0x167
> [   81.522127]  [<ffffffff811e6a04>] io_find_alloc_group+0x58/0x85
> [   81.522127]  [<ffffffff811e6aec>] io_get_io_group+0x6e/0x94
> [   81.522127]  [<ffffffff811e6d8c>] io_group_get_request_list+0x10/0x21
> [   81.522127]  [<ffffffff811d7021>] blk_get_request_list+0x9/0xb
> [   81.522127]  [<ffffffff811d7ab0>] get_request_wait+0x132/0x17b
> [   81.522127]  [<ffffffff811d7dc1>] __make_request+0x2c8/0x396
> [   81.522127]  [<ffffffff811d6806>] generic_make_request+0x1f2/0x28c
> [   81.522127]  [<ffffffff810e9ee7>] ? bio_init+0x18/0x32
> [   81.522127]  [<ffffffff811d8019>] submit_bio+0xb1/0xbc
> [   81.522127]  [<ffffffff810e61c1>] submit_bh+0xfb/0x11e
> [   81.522127]  [<ffffffff8111f554>] __ext3_get_inode_loc+0x263/0x2c2
> [   81.522127]  [<ffffffff81122286>] ext3_iget+0x69/0x399
> [   81.522127]  [<ffffffff81125b92>] ext3_lookup+0x81/0xd0
> [   81.522127]  [<ffffffff810cfd81>] do_lookup+0xd7/0x15f
> [   81.522127]  [<ffffffff810d15c2>] __link_path_walk+0x319/0x67f
> [   81.522127]  [<ffffffff810d1976>] path_walk+0x4e/0x97
> [   81.522127]  [<ffffffff810d1b48>] do_path_lookup+0x115/0x15a
> [   81.522127]  [<ffffffff810d0fec>] ? getname+0x19d/0x1bf
> [   81.522127]  [<ffffffff810d252a>] user_path_at+0x52/0x8c
> [   81.522127]  [<ffffffff811ee668>] ? __up_read+0x1c/0x8c
> [   81.522127]  [<ffffffff8150379b>] ? _spin_unlock_irqrestore+0x3f/0x47
> [   81.522127]  [<ffffffff8105f13e>] ? trace_hardirqs_on_caller+0x114/0x138
> [   81.522127]  [<ffffffff810cb6c1>] vfs_fstatat+0x35/0x62
> [   81.522127]  [<ffffffff811ee6d0>] ? __up_read+0x84/0x8c
> [   81.522127]  [<ffffffff810cb7bb>] vfs_stat+0x16/0x18
> [   81.522127]  [<ffffffff810cb7d7>] sys_newstat+0x1a/0x34
> [   81.522127]  [<ffffffff8100c5e9>] ? retint_swapgs+0xe/0x13
> [   81.522127]  [<ffffffff8105f13e>] ? trace_hardirqs_on_caller+0x114/0x138
> [   81.522127]  [<ffffffff8107f771>] ? audit_syscall_entry+0xfe/0x12a
> [   81.522127]  [<ffffffff8100bb2b>] system_call_fastpath+0x16/0x1b
> 
> Thanks
> Vivek
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng
