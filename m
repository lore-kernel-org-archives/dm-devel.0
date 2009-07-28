From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 03/24] io-controller: bfq support of in-class
	preemption
Date: Tue, 28 Jul 2009 11:03:10 -0400
Message-ID: <20090728150310.GA3870@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com>
	<1248467274-32073-4-git-send-email-vgoyal@redhat.com>
	<4A6DDBDE.8020608@redhat.com> <20090727224138.GA3702@redhat.com>
	<4A6EE4A0.6080700@redhat.com> <20090728135212.GC6133@redhat.com>
	<4A6F0B32.7060801@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A6F0B32.7060801@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jerome Marchand <jmarchan@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Tue, Jul 28, 2009 at 04:29:06PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > On Tue, Jul 28, 2009 at 01:44:32PM +0200, Jerome Marchand wrote:
> >> Vivek Goyal wrote:
> >>> Hi Jerome,
> >>>
> >>> Thanks for testing it out. I could also reproduce the issue.
> >>>
> >>> I had assumed that RT queue will always preempt non-RT queue and hence if
> >>> there is an RT ioq/request pending, the sd->next_entity will point to
> >>> itself and any queue which is preempting it has to be on same service
> >>> tree.
> >>>
> >>> But in your test case it looks like that RT async queue is pending and 
> >>> there is some sync BE class IO going on. It looks like that CFQ allows
> >>> sync queue preempting async queue irrespective of class, so in this case
> >>> sync BE class reader will preempt async RT queue and that's where my
> >>> assumption is broken and we see BUG_ON() hitting.
> >>>
> >>> Can you please tryout following patch. It is a quick patch and requires
> >>> more testing. It solves the crash but still does not solve the issue of
> >>> sync queue always preempting async queues irrespective of class. In
> >>> current scheduler we always schedule the RT queue first (whether it be
> >>> sync or async). This problem requires little more thought.
> >> I've tried it: I can't reproduce the issue anymore and I haven't seen any
> >> other problem so far.
> >> By the way, what is the expected result regarding fairness among different
> >> groups when IO from different classes are run on each group? For instance,
> >> if we have RT IO going on on one group, BE IO on an other and Idle IO on a
> >> third group, what is the expected result: should the IO time been shared
> >> fairly between the groups or should RT IO have priority? As it is now, the
> >> time is shared fairly between BE and RT groups and the last group running
> >> Idle IO hardly get any time.
> >>
> > 
> > Hi Jerome,
> > 
> > If there are two groups RT and BE, I would expect RT group to get all the
> > bandwidth as long as it is backlogged and starve the BE group.
> 
> I wasn't clear enough. I meant the class of the process as set by ionice, not
> the class of the cgroup. That is, of course, only an issue when using CFQ.
> 
> > 
> > I ran quick test of two dd readers. One reader is in RT group and other is
> > in BE group. I do see that RT group runs away with almost all the BW.
> > 
> > group1 time=8:16 2479 group1 sectors=8:16 457848
> > group2 time=8:16 103  group2 sectors=8:16 18936
> > 
> > Note that when group1 (RT) finished it had got 2479 ms of disk time while
> > group2 (BE) got only 103 ms.
> > 
> > Can you send details of your test. It should not be fair sharing between
> > RT and BE group.
> 
> Setup:
> 
> $ mount -t cgroup -o io,blkio none /cgroup
> $ mkdir /cgroup/test1 /cgroup/test2 /cgroup/test3
> $ echo 1000 > /cgroup/test1/io.weight
> $ echo 1000 > /cgroup/test2/io.weight
> $ echo 1000 > /cgroup/test3/io.weight
> 
> Test:
> $ echo 3 > /proc/sys/vm/drop_caches
> 
> $ ionice -c 1 dd if=/tmp/io-controller-test3 of=/dev/null &
> $ echo $! > /cgroup/test1/tasks
> 
> $ ionice -c 2 dd if=/tmp/io-controller-test1 of=/dev/null &
> $ echo $! > /cgroup/test2/tasks
> 
> $ ionice -c 3 dd if=/tmp/io-controller-test2 of=/dev/null &
> $ echo $! > /cgroup/test3/tasks
> 

Ok, got it. So you have created three BE class groups and with-in those
groups you are running job of RT, BE and IDLE type.

From group scheduling point of view, because the tree groups have got same
class and same weight, they should get equal access to disk and with-in
group how bandwidth is divided is left to CFQ.

Because in this case, only one task is present in each group, it should
get all the BW available to the group. Hence, in above test case, all the
three dd processes should get equal amount of disk time.

You mentioned that RT and BE task are getting fair share but not IDLE
task. This is a bug and probably I know where the bug is. I will debug it
and fix it soon.

Thanks
Vivek
