From: Fabio Checconi <fchecconi@gmail.com>
Subject: Re: [PATCH 25/23] io-controller: fix queue vs group fairness
Date: Wed, 9 Sep 2009 04:03:45 +0200
Message-ID: <20090909020345.GL17468@gandalf.sssup.it>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <20090908222827.GC3558@redhat.com> <20090908231334.GJ17468@gandalf.sssup.it> <20090909013205.GB3594@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752452AbZIICAb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090909013205.GB3594@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Tue, Sep 08, 2009 09:32:05PM -0400
>
> On Wed, Sep 09, 2009 at 01:13:34AM +0200, Fabio Checconi wrote:
> > Hi,
> > 
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Date: Tue, Sep 08, 2009 06:28:27PM -0400
> > >
> > > 
> > > o I found an issue during test and that is if there is a mix of queue and group
> > ...
> > >  So we need to keep track of process io queue's vdisktime, even it after got
> > >  deleted from io scheduler's service tree and use that same vdisktime if that
> > >  queue gets backlogged again. But trusting a ioq's vdisktime is bad because
> > >  it can lead to issues if a service tree min_vtime wrap around takes place 
> > >  between two requests of the queue. (Agreed that it can be not that easy to
> > >  hit but it is possible).
> > > 
> > >  Hence, keep a cache of io queues serviced recently and when a queue gets
> > >  backlogged, if it is found in cache, use that vdisktime otherwise assign
> > >  a new vdisktime. This cache of io queues (idle tree), is basically the idea
> > >  implemented by BFQ guys. I had gotten rid of idle trees in V9 and now I am
> > >  bringing it back. (Now I understand it better. :-)).
> > > 
> > >  There is one good side affect of keeping the cache of recently service io
> > >  queues. Now CFQ can differentiate between streaming readers and new processes
> > >  doing IO. Now for a new queue (which is not in the cache), we can assign a
> > >  lower vdisktime and for a streaming reader, we assign vdisktime based on disk
> > >  time used. This way small file readers or the processes doing small amount
> > >  of IO will have reduced latencies at the cost of little reduced throughput of
> > >  streaming readers.
> > > 
> > 
> >   just a little note: this patch seems to introduce a special case for
> > vdisktime = 0, assigning it the meaning of "bad timestamp," but the virtual
> > time space wraps, so 0 is a perfectly legal value, which can be reached by
> > service.  I have no idea if it can produce visible effects, but it doesn't
> > seem to be correct.
> > 
> > 
> 
> Hi Fabio,
> 
> You are right that technically during wrap arounds one can hit value 0 as
> legal value. But I think it is hard to hit at the same time, the only side
> affect of it will be that a queue will be either placed favorably (in case of
> sync queues) or at the end of tree (if it is async queue).
> 
> Async queues anyway go at the end after every dispatch round. So only side
> affect is that once during wrap around cycle a sync queue will be placed
> favorably and can gain share once in a dispatch round.
> 
> I think it is not a big issue at this point of time. But if it becomes
> significant, I can introduce a new variable or start passing function
> parameter to denote whether we found the queue in cache or not.
> 
> But if you think that it is absolutely no no, let me know....
> 

I don't think it's an issue at all, just wanted to make sure it gets
noticed, because timestamping bugs may be hard to hit but often are
hard to debug.  Maybe it deserves a line of comment...
