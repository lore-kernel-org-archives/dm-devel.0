From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: bug: using smp_processor_id() in preemptible code in
 rr_select_path()
Date: Fri, 5 Aug 2016 11:27:06 -0400
Message-ID: <20160805152705.GA17480@redhat.com>
References: <20160803153545.GE20370@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160803153545.GE20370@bblock-ThinkPad-W530>
Sender: linux-block-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, hch@lst.de, axboe@kernel.dk, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 03 2016 at 11:35am -0400,
Benjamin Block <bblock@linux.vnet.ibm.com> wrote:

> Hej Mike,
> 
> when running a debug-kernel today with several multipath-devices using
> the round-robin path selector I noticed that the kernel throws these
> warnings here:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: kdmwork-252:0/881
> caller is rr_select_path+0x36/0x108 [dm_round_robin]
> CPU: 1 PID: 881 Comm: kdmwork-252:0 Not tainted 4.7.0-debug #4
>        00000000617679b8 0000000061767a48 0000000000000002 0000000000000000
>        0000000061767ae8 0000000061767a60 0000000061767a60 00000000001145d0
>        0000000000000000 0000000000b962ae 0000000000bb291e 000000000000000b
>        0000000061767aa8 0000000061767a48 0000000000000000 0000000000000000
>        0700000000b962ae 00000000001145d0 0000000061767a48 0000000061767aa8
> Call Trace:
> ([<00000000001144a2>] show_trace+0x8a/0xe0)
> ([<0000000000114586>] show_stack+0x8e/0xf0)
> ([<00000000006c7fdc>] dump_stack+0x9c/0xe0)
> ([<00000000006fbbc0>] check_preemption_disabled+0x108/0x130)
> ([<000003ff80268646>] rr_select_path+0x36/0x108 [dm_round_robin])
> ([<000003ff80259a42>] choose_path_in_pg+0x42/0xc8 [dm_multipath])
> ([<000003ff80259b62>] choose_pgpath+0x9a/0x1a0 [dm_multipath])
> ([<000003ff8025b51a>] __multipath_map.isra.5+0x72/0x228 [dm_multipath])
> ([<000003ff8025b75e>] multipath_map+0x3e/0x50 [dm_multipath])
> ([<000003ff80225eb6>] map_request+0x66/0x458 [dm_mod])
> ([<000003ff802262ec>] map_tio_request+0x44/0x70 [dm_mod])
> ([<000000000016835a>] kthread_worker_fn+0xf2/0x1d8)
> ([<00000000001681da>] kthread+0x112/0x120)
> ([<000000000098378a>] kernel_thread_starter+0x6/0xc)
> ([<0000000000983784>] kernel_thread_starter+0x0/0xc)
> no locks held by kdmwork-252:0/881.
> 
> 
> There are several more of these warnings, but all have the same
> stack-trace (this is on s390x, but this looks like its only common code)
> - sometimes the process-context is multipath.
> 
> Looking at the changes in this function, it rather looks like this is
> caused by changes made in commit
> b0b477c7e0dd93f8916d106018ded1331b81bf61 (dm round robin: use percpu
> 'repeat_count' and 'current_path').
> 
> The kernel is a stock v4.7 with some debug options enabled (prominently
> DEBUG_PREEMPT). Need any more info?

As you can see from commit b0b477c7e0dd9 the round-robin path selector
is now using percpu data (pointer) and a percpu_counter.

I'm really not sure how else to access this percpu data.

Cc'ing LKML, linux-block, Jens and hch to cast a wider net in the hopes
of getting an answer to how to fix this.
