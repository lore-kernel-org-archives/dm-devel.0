From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 28 Sep 2009 20:53:54 +0200
Message-ID: <1254164034.9820.81.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
	 <20090928145655.GB8192@redhat.com>
	 <4e5e476b0909280835w3410d58aod93a29d1dcda8909@mail.gmail.com>
	 <1254160274.9820.25.camel@marge.simson.net>
	 <20090928181846.GC3643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752898AbZI1SyE@vger.kernel.org>
In-Reply-To: <20090928181846.GC3643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com, jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
List-Id: dm-devel.ids

On Mon, 2009-09-28 at 14:18 -0400, Vivek Goyal wrote:
> On Mon, Sep 28, 2009 at 07:51:14PM +0200, Mike Galbraith wrote:

> I guess changing class to IDLE should have helped a bit as now this is
> equivalent to setting the quantum to 1 and after dispatching one request
> to disk, CFQ will always expire the writer once. So it might happen that
> by the the reader preempted writer, we have less number of requests in
> disk and lesser latency for this reader.

I expected SCHED_IDLE to be better than setting quantum to 1, because
max is quantum*4 if you aren't IDLE.  But that's not what happened.  I
just retested with all knobs set back to stock, fairness off, and
quantum set to 1 with everything running nice 0.  2.8 seconds avg :-/

> > I saw
> > the reference to Vivek's patch, and gave it a shot.  Makes a large
> > difference.
> >                                                            Avg
> > perf stat     12.82     7.19     8.49     5.76     9.32    8.7     anticipatory
> >               16.24   175.82   154.38   228.97   147.16  144.5     noop
> >               43.23    57.39    96.13   148.25   180.09  105.0     deadline
> >                9.15    14.51     9.39    15.06     9.90   11.6     cfq fairness=0 dd=nice 0
> >               12.22     9.85    12.55     9.88    15.06   11.9     cfq fairness=0 dd=nice 19
> >                9.77    13.19    11.78    17.40     9.51   11.9     cfq fairness=0 dd=SCHED_IDLE
> >                4.59     2.74     4.70     3.45     4.69    4.0     cfq fairness=1 dd=nice 0
> >                3.79     4.66     2.66     5.15     3.03    3.8     cfq fairness=1 dd=nice 19
> >                2.79     4.73     2.79     4.02     2.50    3.3     cfq fairness=1 dd=SCHED_IDLE
> > 
> 
> Hmm.., looks like average latency went down only in  case of fairness=1
> and not in case of fairness=0. (Looking at previous mail, average vanilla
> cfq latencies were around 12 seconds).

Yup.

> Are you running all this in root group or have you put writers and readers
> into separate cgroups?

No cgroups here.

> If everything is running in root group, then I am curious why latency went
> down in case of fairness=1. The only thing fairness=1 parameter does is
> that it lets complete all the requests from previous queue before start
> dispatching from next queue. On top of this is valid only if no preemption
> took place. In your test case, konsole should preempt the writer so
> practically fairness=1 might not make much difference.

fairness=1 very definitely makes a very large difference.  All of those
cfq numbers were logged in back to back runs.

> In fact now Jens has committed a patch which achieves the similar effect as
> fairness=1 for async queues.

Yeah, I was there yesterday.  I speculated that that would hurt my
reader, but rearranging things didn't help one bit.  Playing with merge,
I managed to give dd ~7% more throughput, and injured poor reader even
more.  (problem analysis via hammer/axe not always most effective;)

> commit 5ad531db6e0f3c3c985666e83d3c1c4d53acccf9
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Jul 3 12:57:48 2009 +0200
> 
>     cfq-iosched: drain device queue before switching to a sync queue
>     
>     To lessen the impact of async IO on sync IO, let the device drain of
>     any async IO in progress when switching to a sync cfqq that has idling
>     enabled.
> 
> 
> If everything is in separate cgroups, then we should have seen latency 
> improvements in case of fairness=0 case also. I am little perplexed here..
> 
> Thanks
> Vivek
