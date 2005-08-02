From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: mirror patches - device failure detection/race
	fix/deadlock fix
Date: Tue, 2 Aug 2005 13:02:02 -0500
Message-ID: <c387ba5e1b8301718a021f96e04c70e5@redhat.com>
References: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
	<20050802173543.GA5224@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050802173543.GA5224@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Aug 2, 2005, at 12:35 PM, Alasdair G Kergon wrote:

> On Tue, Aug 02, 2005 at 11:00:05AM -0500, Jon Brassow wrote:
>> The 'race.patch' fixes a couple race conditions that were a result of
>> the __rh_alloc() function releasing and regrabbing a lock when called.
>
> -       read_unlock(&rh->hash_lock);
> -       nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
> +       nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
>         nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
>
> So mempool_alloc is now called while holding a spinlock.
> With GFP_ATOMIC, what happens if it returns NULL?

That's what the mempool is all about.  :)  I suppose, if you were under 
memory pressure long enough and the kernel never successfully reclaimed 
memory, it *might* return NULL -- in which case, the kernel oops's.  I 
think this is so unlikely, that I would be willing to put in a BUG() 
call if nreg is found to be NULL.  BTW, the scenario is exactly the 
same as if the gfp_flag was GFP_NOIO -- if the kernel can't get us 
memory, it can't get us memory.

> Doesn't it need to be able to sleep to get the benefit of the mempool?

No.  mempool will try to allocate memory honoring the flags you have 
set (in this case GFP_ATOMIC).  If unsuccessful, it will tap into the 
memory reserve you have created when you did a mempool_create.  So, 
when there is no memory left to give us, we have 64 _regions_ left in 
our repository.

Am I wrong?

>
>> The 'deadlock.patch' switches all spin_lock calls on the region_lock 
>> to
>> spin_lock_irqsave.  Without this patch you machine will hang.
>
> I'd prefer it if race.patch used the correct versions (with or without 
> _irq).
>

Are you asking me to "combine" the patches?  I can do that.

  brassow
