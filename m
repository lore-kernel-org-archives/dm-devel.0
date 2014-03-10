From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: Re: A target to just process bios background?
Date: Mon, 10 Mar 2014 17:18:07 +0900
Message-ID: <20140310171807.c477bd43cf0dfb4cd5ff880d@valinux.co.jp>
References: <20140304103037.a42991f149d749448846caab@valinux.co.jp>
	<alpine.LRH.2.02.1403061745500.928@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1403061745500.928@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, Mikulas,

> Such target doesn't exist and I wouldn't recommend to make it. If you 
> add the bio to a queue and return immediatelly from the map routine, the 
> caller sends another bio. So, in the end, you end up with extreme amount 
> of bios on the queue and very bad responsiveness.
I see. It was just a question. Don't worry, dm-writeboost doesn't contain such a code.

By the way, I want to ask you a question related to this topic.

calling dm_io() in sync mode under .map hook causes deadlock.
To avoid that, for example, dm-snap-persistent.c executes it in a different thread.

        /*
         * Issue the synchronous I/O from a different thread
         * to avoid generic_make_request recursion.
         */
        INIT_WORK_ONSTACK(&req.work, do_metadata);
        queue_work(ps->metadata_wq, &req.work);
        flush_workqueue(ps->metadata_wq);
        destroy_work_on_stack(&req.work);

If we always queue the bio and executes it in a different thread
we never be suffered from this problem and that's why I call this topic is "related".

The cause of the deadlock is that the context has only one bio_list,
the bio submitted under sync dm_io() never be executed the caller bio completes.
Thus, deadlock.

If I understand correctly, any sync I/O causes deadlock if it's called under .map hook.
And blkdev_issue_flush() seems to be sync (submitting and wait for the completion after that) but
never cause deadlock in my environment.

Is it not allowed to call blkdev_issue_flush() directly under .map?
No target uses the function in device-mapper.

--
Akira

On Thu, 6 Mar 2014 17:57:21 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 4 Mar 2014, Akira Hayakawa wrote:
> 
> > Hi,
> > 
> > Is it meaningless to submit the split and cloned bios in background
> > using workqueue?
> > 
> > device-mapper doesn't go to next split before the .map hook returns
> > (and generic_make_request() returns only in case of DM_MAPIO_REMAPPED).
> > So, quitting from .map hook and going into next split fast sounds to me
> > effective at least in terms of CPU usage (in multicore system).
> > 
> > is this discussed before?
> > 
> > A target as tiny as linear or flakey can be thought:
> > - it has work_struct in per_bio_data
> > - .map hook queue_work the work into private wq.
> > - and then return DM_MAPIO_SUBMITTED
> > 
> > is this implemented before?
> > 
> > I think this target will make people happy if they
> > want to see what if the bio submission is done background
> > without changing their code but only stacking a dm target.
> > 
> > I am sorry if I am confused.
> 
> Hi
> 
> Such target doesn't exist and I wouldn't recommend to make it. If you 
> add the bio to a queue and return immediatelly from the map routine, the 
> caller sends another bio. So, in the end, you end up with extreme amount 
> of bios on the queue and very bad responsiveness.
> 
> Suppose, for example, that you have a system with 16GB memory. 20% can be 
> marked dirty (that's the default value for /proc/sys/vm/dirty_ratio), and 
> if you use 4k bios, you may have 838860 bios on the queue. Any process 
> that tries to write anything to disk freezes until all of them are 
> written.
> 
> In fact, dm-crypt behaves this way - and we have a bug report that it 
> causes out-of-memory crashes when massive amounts of bios are added to the 
> queue.
> 
> dm-mirror also behaves this way, but only for write bios - you can load a 
> mirror target with both legs pointing to the same device if you want to 
> see how does it behave.
> 
> Mikulas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


-- 
Akira Hayakawa <hayakawa@valinux.co.jp>
