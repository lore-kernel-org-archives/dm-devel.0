From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Wed, 30 Sep 2009 17:43:19 +0900 (JST)
Message-ID: <20090930.174319.183036386.ryov@valinux.co.jp>
References: <20090929032255.GA10664@redhat.com>
	<20090929.185653.183056711.ryov@valinux.co.jp>
	<20090929141049.GA12141@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753265AbZI3InR@vger.kernel.org>
In-Reply-To: <20090929141049.GA12141@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: nauman@google.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com, yoshikawa.takuya@oss.ntt.co.jp
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> I was thinking that elevator layer will do the merge of bios. So IO
> scheduler/elevator can time stamp the first bio in the request as it goes
> into the disk and again timestamp with finish time once request finishes.
> 
> This way higher layer can get an idea how much disk time a group of bios
> used. But on multi queue, if we dispatch say 4 requests from same queue,
> then time accounting becomes an issue.
> 
> Consider following where four requests rq1, rq2, rq3 and rq4 are
> dispatched to disk at time t0, t1, t2 and t3 respectively and these
> requests finish at time t4, t5, t6 and t7. For sake of simlicity assume
> time elapsed between each of milestones is t. Also assume that all these
> requests are from same queue/group.
> 
>         t0   t1   t2   t3  t4   t5   t6   t7
>         rq1  rq2  rq3 rq4  rq1  rq2  rq3 rq4
> 
> Now higher layer will think that time consumed by group is:
> 
> (t4-t0) + (t5-t1) + (t6-t2) + (t7-t3) = 16t
> 
> But the time elapsed is only 7t.

IO controller can know how many requests are issued and still in
progress. Is it not enough to accumulate the time while in-flight IOs
exist?

> Secondly if a different group is running only single sequential reader,
> there CFQ will be driving queue depth of 1 and time will not be running
> faster and this inaccuracy in accounting will lead to unfair share between
> groups.
>
> So we need something better to get a sense which group used how much of
> disk time.

It could be solved by implementing the way to pass on such information
from IO scheduler to higher layer controller.

> > How about making throttling policy be user selectable like the IO
> > scheduler and putting it in the higher layer? So we could support
> > all of policies (time-based, size-based and rate limiting). There
> > seems not to only one solution which satisfies all users. But I agree
> > with starting with proportional bandwidth control first. 
> > 
> 
> What are the cases where time based policy does not work and size based
> policy works better and user would choose size based policy and not timed
> based one?

I think that disk time is not simply proportional to IO size. If there
are two groups whose wights are equally assigned and they issue
different sized IOs repsectively, the bandwidth of each group would
not distributed equally as expected. 

> I am not against implementing things in higher layer as long as we can
> ensure tight control on latencies, strong isolation between groups and
> not break CFQ's class and ioprio model with-in group.
> 
> > BTW, I will start to reimplement dm-ioband into block layer.
> 
> Can you elaborate little bit on this?

bio is grabbed in generic_make_request() and throttled as well as
dm-ioband's mechanism. dmsetup command is not necessary any longer.

> > > Fairness for higher level logical devices
> > > =========================================
> > > Do we want good fairness numbers for higher level logical devices also
> > > or it is sufficient to provide fairness at leaf nodes. Providing fairness
> > > at leaf nodes can help us use the resources optimally and in the process
> > > we can get fairness at higher level also in many of the cases.
> > 
> > We should also take care of block devices which provide their own
> > make_request_fn() and not use a IO scheduler. We can't use the leaf
> > nodes approach to such devices.
> > 
> 
> I am not sure how big an issue is this. This can be easily solved by
> making use of NOOP scheduler by these devices. What are the reasons for
> these devices to not use even noop? 

I'm not sure why the developers of the device driver choose their own
way, and the driver is provided in binary form, so we can't modify it.

> > > Fairness with-in group
> > > ======================
> > > One of the issues with higher level controller is that how to do fair
> > > throttling so that fairness with-in group is not impacted. Especially
> > > the case of making sure that we don't break the notion of ioprio of the
> > > processes with-in group.
> > 
> > I ran your test script to confirm that the notion of ioprio was not
> > broken by dm-ioband. Here is the results of the test.
> > https://lists.linux-foundation.org/pipermail/containers/2009-May/017834.html
> > 
> > I think that the time period during which dm-ioband holds IO requests
> > for throttling would be too short to break the notion of ioprio.
> 
> Ok, I re-ran that test. Previously default io_limit value was 192 and now

The default value of io_limit on the previous test was 128 (not 192)
which is equall to the default value of nr_request.

> I set it up to 256 as you suggested. I still see writer starving reader. I
> have removed "conv=fdatasync" from writer so that a writer is pure buffered
> writes.

O.K. You removed "conv=fdatasync", the new dm-ioband handles
sync/async requests separately, and it solves this
buffered-write-starves-read problem. I would like to post it soon
after doing some more test.

> On top of that can you please give some details how increasing the
> buffered queue length reduces the impact of writers?

When the number of in-flight IOs exceeds io_limit, processes which are
going to issue IOs are made sleep by dm-ioband until all the in-flight
IOs are finished. But IO scheduler layer can accept IO requests more
than the value of io_limit, so it was a bottleneck of the throughput.

> IO Prio issue
> --------------
> I ran another test where two ioband devices were created of weight 100 
> each on two partitions. In first group 4 readers were launched. Three
> readers are of class BE and prio 7, fourth one is of class BE prio 0. In
> group2, I launched a buffered writer.
> 
> One would expect that prio0 reader gets more bandwidth as compared to
> prio 4 readers and prio 7 readers will get more or less same bw. Looks like
> that is not happening. Look how vanilla CFQ provides much more bandwidth
> to prio0 reader as compared to prio7 reader and how putting them in the
> group reduces the difference betweej prio0 and prio7 readers.
> 
> Following are the results.

O.K. I'll try to do more test with dm-ioband according to your
comments especially working with CFQ. Thanks for pointing out.

Thanks,
Ryo Tsuruta
