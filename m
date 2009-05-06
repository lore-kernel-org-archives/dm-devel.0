From: Fabio Checconi <fchecconi@gmail.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 6 May 2009 12:20:30 +0200
Message-ID: <20090506102030.GB20544@gandalf.sssup.it>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <1241562049.11059.921.camel@twins> <20090506034254.GD4416@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757379AbZEFKOW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090506034254.GD4416@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

Hi,

> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> Date: Wed, May 06, 2009 09:12:54AM +0530
>
> * Peter Zijlstra <peterz@infradead.org> [2009-05-06 00:20:49]:
> 
> > On Tue, 2009-05-05 at 13:24 -0700, Andrew Morton wrote:
> > > On Tue,  5 May 2009 15:58:27 -0400
> > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > 
> > > > Hi All,
> > > > 
> > > > Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> > > > ...
> > > > Currently primarily two other IO controller proposals are out there.
> > > > 
> > > > dm-ioband
> > > > ---------
> > > > This patch set is from Ryo Tsuruta from valinux.
> > > > ...
> > > > IO-throttling
> > > > -------------
> > > > This patch set is from Andrea Righi provides max bandwidth controller.
> > > 
> > > I'm thinking we need to lock you guys in a room and come back in 15 minutes.
> > > 
> > > Seriously, how are we to resolve this?  We could lock me in a room and
> > > cmoe back in 15 days, but there's no reason to believe that I'd emerge
> > > with the best answer.
> > > 
> > > I tend to think that a cgroup-based controller is the way to go. 
> > > Anything else will need to be wired up to cgroups _anyway_, and that
> > > might end up messy.
> > 
> > FWIW I subscribe to the io-scheduler faith as opposed to the
> > device-mapper cult ;-)
> > 
> > Also, I don't think a simple throttle will be very useful, a more mature
> > solution should cater to more use cases.
> >
> 
> I tend to agree, unless Andrea can prove us wrong. I don't think
> throttling a task (not letting it consume CPU, memory when its IO
> quota is exceeded) is a good idea. I've asked that question to Andrea
> a few times, but got no response.
>  

  from what I can see, the principle used by io-throttling is not too
different to what happens when bandwidth differentiation with synchronous
access patterns is achieved using idling at the io scheduler level.

When an io scheduler anticipates requests from a task/cgroup, all the
other tasks with pending (synchronous) requests are in fact blocked, and
the fact that the task being anticipated is allowed to submit additional
io while they remain blocked is what creates the bandwidth differentiation
among them.

Of course there are many differences, in particular related to the
latencies introduced by the two mechanisms, the granularity they use to
allocate disk service, and to what throttling and proportional share io
scheduling can or cannot guarantee, but FWIK both of them rely on
blocking tasks to create bandwidth differentiation.
