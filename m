From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: corruption causing crash in __queue_work
Date: Thu, 17 Dec 2015 17:43:12 +0200
Message-ID: <5672D810.2010404@kyup.com>
References: <20151209162744.GN30240@mtj.duckdns.org>
 <566945A2.1050208@kyup.com> <20151210152901.GR30240@mtj.duckdns.org>
 <566AF262.8050009@kyup.com> <20151211170805.GT30240@mtj.duckdns.org>
 <566E80AE.7020502@kyup.com> <20151214153147.GA14957@redhat.com>
 <CAJFSNy6qc-m_=FNuzrFJnvKJR2zSE12m8sQ3CCBRaBtyf=6AFg@mail.gmail.com>
 <20151214203138.GA2871@redhat.com> <56729272.2010803@kyup.com>
 <20151217153327.GI4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151217153327.GI4026@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 12/17/2015 05:33 PM, Tejun Heo wrote:
> Hello, Nikolay.
> 
> On Thu, Dec 17, 2015 at 12:46:10PM +0200, Nikolay Borisov wrote:
>> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
>> index 493c38e08bd2..ccbbf7823cf3 100644
>> --- a/drivers/md/dm-thin.c
>> +++ b/drivers/md/dm-thin.c
>> @@ -3506,8 +3506,8 @@ static void pool_postsuspend(struct dm_target *ti)
>>         struct pool_c *pt = ti->private;
>>         struct pool *pool = pt->pool;
>>
>> -       cancel_delayed_work(&pool->waker);
>> -       cancel_delayed_work(&pool->no_space_timeout);
>> +       cancel_delayed_work_sync(&pool->waker);
>> +       cancel_delayed_work_sync(&pool->no_space_timeout);
>>         flush_workqueue(pool->wq);
>>         (void) commit(pool);
>>  }
>>
>> And this seems to have resolved the crashes. For the past 24 hours I
>> haven't seen a single server crash whereas before at least 3-5 servers
>> would crash.
> 
> So, that's an obvious bug on dm-thin side.


Mike if you are ok with this I will submit a proper patch ?
> 
>> Given that, it seems like a race condition between destroying the
>> workqueue from dm-thin and cancelling all the delayed work.
>>
>> Tejun, I've looked at cancel_delayed_work/cancel_delayed_work_sync and
>> they both call try_to_grab_pending and then their function diverges. Is
>> it possible that there is a latent race condition between canceling the
>> delayed work and the subsequent re-scheduling of the work item?
> 
> It's just the wrong variant being used.  cancel_delayed_work() doesn't
> guarantee that the work item isn't running on return.  If the work
> item was running and the workqueue is destroyed afterwards, it may end
> up trying to requeue itself on a destroyed workqueue.

Right, but my initial understanding was that when canceling the delayed
work and then issuing flush_workqueue would act the same way as if
cancel_delayed_work_sync is called wrt to this particular delayed item, no?



> 
> Thanks.
> 
