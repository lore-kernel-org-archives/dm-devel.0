From: Fabio Checconi <fchecconi@gmail.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 21:01:42 +0200
Message-ID: <20090909190142.GI17468@gandalf.sssup.it>
References: <20090904231129.GA3689@redhat.com> <20090907.200222.193693062.ryov@valinux.co.jp> <4AA51065.6050000@redhat.com> <20090908.120119.71095369.ryov@valinux.co.jp> <4AA6AF58.3050501@redhat.com> <20090909000900.GK17468@gandalf.sssup.it> <20090909020620.GC3594@redhat.com> <20090909154126.GG17468@gandalf.sssup.it> <20090909173003.GE8256@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752815AbZIIS60@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090909173003.GE8256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Wed, Sep 09, 2009 01:30:03PM -0400
>
> On Wed, Sep 09, 2009 at 05:41:26PM +0200, Fabio Checconi wrote:
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Date: Tue, Sep 08, 2009 10:06:20PM -0400
> > >
...
> > This is good, however tuning will not be an easy task (at least, in my
> > experience with BFQ it has been a problem): while for throughput usually
> > there are tradeoffs, as soon as a queue/group idles and then timeouts,
> > from the fairness perspective the results soon become almost random
> > (i.e., depending on the rate of successful anticipations, but in the
> > common case they are unpredictable)...
> 
> I am lost in last few lines. I guess you are suggesting that static tuning
> is hard and dynamically adjusting idling has limitations that it might not
> be accurate all the time?
> 

Yes, this was the problem, at least for me.  As soon as there were
unsuccessful anticipations there was no graceful degradation of
fairness, and bandwidth distribution became almost random.  In
this situation all the complexity of CFQ/BFQ/io-controller seems
overkill; NCQ+SSD is or will be quite a common usage scenario
triggering it.


> I will explain how things are working in current set of io scheduler
> patches.
> 
> Currently on top of queue idling, I have implemented group idling also.
> Queue idling is dynamic and io scheduler like CFQ keeps track of
> traffic pattern on the queue and disables/enables idling dynamically. So
> in this case fairness depends on rate of successful anticipations by the
> io scheduler.
> 
> Group idling currently is static in nature and purely implemented in
> elevator fair queuing layer. Group idling kicks in only when a group is
> empty at the time of queue expiration and underlying ioscheduler has not
> chosen to enable idling on the queue. This provides us the gurantee that
> group will keep on getting its fair share of disk as long as a new request
> comes in the group with-in that idling period.
> 
> Implementing group idling ensures that it does not bog down the io scheduler
> and with-in group queue switching can still be very fast (no idling on many of
> the queues by cfq).
> 
> Now in case of SSD if group idling is really hurting somebody, I would
> expect him to set it to either 1 or 0. You might get better throughput
> but then expect fairness for the group only if the group is continuously
> backlogged. (Something what dm-ioband guys seem to be doing).
> 
> So do you think that adjusting this "group_idling" tunable is too
> complicated and there are better ways to handle it in case of SSD+NCQ?
> 

Unfortunately I am not aware of any reasonable and working method to
properly handle this issue; anyway adjusting the tunable is something
that needs a lot of care.
