From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: bug: using smp_processor_id() in preemptible code in
 rr_select_path()
Date: Sun, 7 Aug 2016 17:49:30 +0200
Message-ID: <20160807154930.GA31352@bblock-ThinkPad-W530>
References: <20160803153545.GE20370@bblock-ThinkPad-W530>
 <20160805152705.GA17480@redhat.com>
 <497f02e5-4f3d-8590-3096-fb5e2422bff4@kernel.dk>
 <20160805154223.GA2340@redhat.com>
 <107dc81f-675d-8ae4-0ac2-99c248a23c60@kernel.dk>
 <20160805160638.GA17651@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805160638.GA17651@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 12:06 Fri 05 Aug     , Mike Snitzer wrote:
> On Fri, Aug 05 2016 at 11:54am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 08/05/2016 09:42 AM, Mike Snitzer wrote:
> > >On Fri, Aug 05 2016 at 11:33P -0400,
> > >Jens Axboe <axboe@kernel.dk> wrote:
> > >
> > >>On 08/05/2016 09:27 AM, Mike Snitzer wrote:
> > >>>On Wed, Aug 03 2016 at 11:35am -0400,
> > >>>Benjamin Block <bblock@linux.vnet.ibm.com> wrote:
> > >>>
> > >>>>Hej Mike,
> > >>>>
> > >>>>when running a debug-kernel today with several multipath-devices using
> > >>>>the round-robin path selector I noticed that the kernel throws these
> > >>>>warnings here:
> > >>>>
> > >>>>BUG: using smp_processor_id() in preemptible [00000000] code: kdmwork-252:0/881
> > >>>>caller is rr_select_path+0x36/0x108 [dm_round_robin]
> > >>>>CPU: 1 PID: 881 Comm: kdmwork-252:0 Not tainted 4.7.0-debug #4
> > >>>>      00000000617679b8 0000000061767a48 0000000000000002 0000000000000000
> > >>>>      0000000061767ae8 0000000061767a60 0000000061767a60 00000000001145d0
> > >>>>      0000000000000000 0000000000b962ae 0000000000bb291e 000000000000000b
> > >>>>      0000000061767aa8 0000000061767a48 0000000000000000 0000000000000000
> > >>>>      0700000000b962ae 00000000001145d0 0000000061767a48 0000000061767aa8
> > >>>>Call Trace:
> > >>>>([<00000000001144a2>] show_trace+0x8a/0xe0)
> > >>>>([<0000000000114586>] show_stack+0x8e/0xf0)
> > >>>>([<00000000006c7fdc>] dump_stack+0x9c/0xe0)
> > >>>>([<00000000006fbbc0>] check_preemption_disabled+0x108/0x130)
> > >>>>([<000003ff80268646>] rr_select_path+0x36/0x108 [dm_round_robin])
> > >>>>([<000003ff80259a42>] choose_path_in_pg+0x42/0xc8 [dm_multipath])
> > >>>>([<000003ff80259b62>] choose_pgpath+0x9a/0x1a0 [dm_multipath])
> > >>>>([<000003ff8025b51a>] __multipath_map.isra.5+0x72/0x228 [dm_multipath])
> > >>>>([<000003ff8025b75e>] multipath_map+0x3e/0x50 [dm_multipath])
> > >>>>([<000003ff80225eb6>] map_request+0x66/0x458 [dm_mod])
> > >>>>([<000003ff802262ec>] map_tio_request+0x44/0x70 [dm_mod])
> > >>>>([<000000000016835a>] kthread_worker_fn+0xf2/0x1d8)
> > >>>>([<00000000001681da>] kthread+0x112/0x120)
> > >>>>([<000000000098378a>] kernel_thread_starter+0x6/0xc)
> > >>>>([<0000000000983784>] kernel_thread_starter+0x0/0xc)
> > >>>>no locks held by kdmwork-252:0/881.
> > >>>>
> > >>>>
> > >>>>There are several more of these warnings, but all have the same
> > >>>>stack-trace (this is on s390x, but this looks like its only common code)
> > >>>>- sometimes the process-context is multipath.
> > >>>>
> > >>>>Looking at the changes in this function, it rather looks like this is
> > >>>>caused by changes made in commit
> > >>>>b0b477c7e0dd93f8916d106018ded1331b81bf61 (dm round robin: use percpu
> > >>>>'repeat_count' and 'current_path').
> > >>>>
> > >>>>The kernel is a stock v4.7 with some debug options enabled (prominently
> > >>>>DEBUG_PREEMPT). Need any more info?
> > >>>
> > >>>As you can see from commit b0b477c7e0dd9 the round-robin path selector
> > >>>is now using percpu data (pointer) and a percpu_counter.
> > >>>
> > >>>I'm really not sure how else to access this percpu data.
> > >>>
> > >>>Cc'ing LKML, linux-block, Jens and hch to cast a wider net in the hopes
> > >>>of getting an answer to how to fix this.
> > >>
> > >>From a quick look, looks like you are using this_cpu_ptr() without
> > >>having preemption disabled.
> > >
> > >Right, that is what it looked like to me too.
> > >
> > >I'm just not sure on what the proper pattern is to fix this.
> > >
> > >I'll look closer though.
> > 
> > I always forget the details (if this confuses lockdep or not), but you
> > could potentially turn it into:
> > 
> > local_irq_save(flags);
> > x = this_cpu_ptr();
> > [...]
> > 
> > spin_lock(&s->lock);
> > [...]
> > 
> > instead.
> 
> Cool, I've coded up the patch (compile tested only).
> 
> Benjamin, any chance you could test this against your v4.7 kernel and
> report back?
> 

I will give it a go on Monday. Thx for the quick fix.


- Benjamin

> 
> diff --git a/drivers/md/dm-round-robin.c b/drivers/md/dm-round-robin.c
> index 4ace1da..ed446f8 100644
> --- a/drivers/md/dm-round-robin.c
> +++ b/drivers/md/dm-round-robin.c
> @@ -210,14 +210,17 @@ static struct dm_path *rr_select_path(struct path_selector *ps, size_t nr_bytes)
>  	struct path_info *pi = NULL;
>  	struct dm_path *current_path = NULL;
> 
> +	local_irq_save(flags);
>  	current_path = *this_cpu_ptr(s->current_path);
>  	if (current_path) {
>  		percpu_counter_dec(&s->repeat_count);
> -		if (percpu_counter_read_positive(&s->repeat_count) > 0)
> +		if (percpu_counter_read_positive(&s->repeat_count) > 0) {
> +			local_irq_restore(flags);
>  			return current_path;
> +		}
>  	}
> 
> -	spin_lock_irqsave(&s->lock, flags);
> +	spin_lock(&s->lock);
>  	if (!list_empty(&s->valid_paths)) {
>  		pi = list_entry(s->valid_paths.next, struct path_info, list);
>  		list_move_tail(&pi->list, &s->valid_paths);
> @@ -225,7 +228,8 @@ static struct dm_path *rr_select_path(struct path_selector *ps, size_t nr_bytes)
>  		set_percpu_current_path(s, pi->path);
>  		current_path = pi->path;
>  	}
> -	spin_unlock_irqrestore(&s->lock, flags);
> +	spin_unlock(&s->lock);
> +	local_irq_restore(flags);
> 
>  	return current_path;
>  }
> 

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
