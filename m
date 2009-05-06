From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 6 May 2009 22:40:47 +0530
Message-ID: <20090506171047.GV4416@balbir.in.ibm.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	<20090505132441.1705bfad.akpm@linux-foundation.org>
	<20090506102030.GB20544@gandalf.sssup.it>
Reply-To: balbir@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090506102030.GB20544@gandalf.sssup.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fabio Checconi <fchecconi@gmail.com>
Cc: paolo.valente@unimore.it, dhaval@linux.vnet.ibm.com, snitzer@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>, containers@lists.linux-foundation.org, agk@redhat.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

* Fabio Checconi <fchecconi@gmail.com> [2009-05-06 12:20:30]:

> Hi,
> 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Date: Wed, May 06, 2009 09:12:54AM +0530
> >
> > * Peter Zijlstra <peterz@infradead.org> [2009-05-06 00:20:49]:
> > 
> > > On Tue, 2009-05-05 at 13:24 -0700, Andrew Morton wrote:
> > > > On Tue,  5 May 2009 15:58:27 -0400
> > > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > 
> > > > > 
> > > > > Hi All,
> > > > > 
> > > > > Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> > > > > ...
> > > > > Currently primarily two other IO controller proposals are out there.
> > > > > 
> > > > > dm-ioband
> > > > > ---------
> > > > > This patch set is from Ryo Tsuruta from valinux.
> > > > > ...
> > > > > IO-throttling
> > > > > -------------
> > > > > This patch set is from Andrea Righi provides max bandwidth controller.
> > > > 
> > > > I'm thinking we need to lock you guys in a room and come back in 15 minutes.
> > > > 
> > > > Seriously, how are we to resolve this?  We could lock me in a room and
> > > > cmoe back in 15 days, but there's no reason to believe that I'd emerge
> > > > with the best answer.
> > > > 
> > > > I tend to think that a cgroup-based controller is the way to go. 
> > > > Anything else will need to be wired up to cgroups _anyway_, and that
> > > > might end up messy.
> > > 
> > > FWIW I subscribe to the io-scheduler faith as opposed to the
> > > device-mapper cult ;-)
> > > 
> > > Also, I don't think a simple throttle will be very useful, a more mature
> > > solution should cater to more use cases.
> > >
> > 
> > I tend to agree, unless Andrea can prove us wrong. I don't think
> > throttling a task (not letting it consume CPU, memory when its IO
> > quota is exceeded) is a good idea. I've asked that question to Andrea
> > a few times, but got no response.
> >  
> 
>   from what I can see, the principle used by io-throttling is not too
> different to what happens when bandwidth differentiation with synchronous
> access patterns is achieved using idling at the io scheduler level.
> 
> When an io scheduler anticipates requests from a task/cgroup, all the
> other tasks with pending (synchronous) requests are in fact blocked, and
> the fact that the task being anticipated is allowed to submit additional
> io while they remain blocked is what creates the bandwidth differentiation
> among them.
> 
> Of course there are many differences, in particular related to the
> latencies introduced by the two mechanisms, the granularity they use to
> allocate disk service, and to what throttling and proportional share io
> scheduling can or cannot guarantee, but FWIK both of them rely on
> blocking tasks to create bandwidth differentiation.

My concern stems from the fact that in the case in this case we might
throttle all the tasks in the group.. no? I'll take a closer look.


-- 
	Balbir
