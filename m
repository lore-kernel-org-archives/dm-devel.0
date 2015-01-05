From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Mon, 5 Jan 2015 10:50:43 -0500
Message-ID: <20150105155043.GA2260@redhat.com>
References: <CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
	<20141107183321.GA31022@redhat.com>
	<alpine.LRH.2.02.1501021741470.23294@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1501021741470.23294@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 02 2015 at  5:56pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi, I'm back.
> 
> I looked at current internal suspend code in 3.19.
> 
> One thing that seems strange is this:
> 
> static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
> {
>         struct dm_table *map = NULL;
> 
>         if (dm_suspended_internally_md(md))
>                 return; /* nested internal suspend */
> ....
> static void __dm_internal_resume(struct mapped_device *md)
> {
>         if (!dm_suspended_internally_md(md))
>                 return; /* resume from nested internal suspend */
> 
> - the comments imply that the code supports nested internal suspend, while 
> in fact it doesn't. If the caller calls:
> * dm_internal_suspend_noflush
> * dm_internal_suspend_noflush
> * dm_internal_resume
> the device is not suspended while it should be.

Yes, very true, it should.  But IIRC in practice it doesn't hurt us to
not be bothered about being so precise given the current caller.

> The "if" branch in __dm_internal_resume has nothing to do with nested 
> suspend, it's called if the caller calls dm_internal_resume without 
> dm_internal_suspend_noflush - that shouldn't happen, so there should be 
> WARN or BUG.

The first internal resume would've cleared the DM_INTERNAL_SUSPEND_FLAG,
etc.  So AFAICT the code in question does also cover multiple internal
suspends/resumes (albeit without the counter you've suggested).

But I did narrowly define "nested suspend" as an internal suspend that
arrives _after_ a normal suspend.

From the header of commit ffcc39364 ("dm: enhance internal suspend and
resume interface"):

    Both DM_SUSPEND_FLAG and DM_INTERNAL_SUSPEND_FLAG may be set if a device
    was already suspended when dm_internal_suspend_noflush() was called --
    this can be thought of as a "nested suspend".  A "nested suspend" can
    occur with legacy userspace dm-thin code that might suspend all active
    thin volumes before suspending the pool for resize.

Could be the reality is "nested suspend" is also supporting the case of
multiple internal suspends.

> If you want to support multiple internal suspends (which is needed if one 
> table can have multiple dm-thin targets), you need a counter that counts 
> how many times the device was suspended - the counter doesn't have to be 
> atomic because the code already holds md->suspend_lock. If you don't want 
> to support multiple internal suspends, there should be at least WARN when 
> the caller attempts to do it.

I'll have a look.  Will need some time to revisit this line of work.

FYI, the device-mapper-test-suite has fairly comprehensive test coverage
for all supported scenarios, e.g.:

# dmtest run --suite thin-provisioning -t /SuspendTests/
Loaded suite thin-provisioning
Started
SuspendTests
  nested_internal_suspend_using_inactive_table...PASS
  suspend_pool_active_thins_no_io...PASS
  suspend_pool_after_suspend_thin...PASS
  suspend_pool_concurrent_suspend...PASS
  suspend_pool_no_active_thins...PASS
  suspend_pool_no_thins...PASS
  suspend_pool_resume_thin...PASS
  suspend_pool_suspended_thin...PASS
  wait_on_bit_during_resume...PASS
  wait_on_bit_during_suspend...PASS

# dmtest run --suite thin-provisioning -n activate_thin_while_pool_suspended_fails
Loaded suite thin-provisioning
Started
CreationTests
  activate_thin_while_pool_suspended_fails...PASS

So any changes in this area need to be verified using dmts.
