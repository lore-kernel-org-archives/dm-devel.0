From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Fri, 11 Sep 2009 10:30:40 -0400
Message-ID: <20090911143040.GB6758@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4AA918C1.6070907@redhat.com> <20090910205227.GB3617@redhat.com>
	<20090910205657.GD3617@redhat.com> <4AAA4DA7.8010909@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AAA4DA7.8010909@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Sep 11, 2009 at 03:16:23PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > On Thu, Sep 10, 2009 at 04:52:27PM -0400, Vivek Goyal wrote:
> >> On Thu, Sep 10, 2009 at 05:18:25PM +0200, Jerome Marchand wrote:
> >>> Vivek Goyal wrote:
> >>>> Hi All,
> >>>>
> >>>> Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
> >>>  
> >>> Hi Vivek,
> >>>
> >>> I've run some postgresql benchmarks for io-controller. Tests have been
> >>> made with 2.6.31-rc6 kernel, without io-controller patches (when
> >>> relevant) and with io-controller v8 and v9 patches.
> >>> I set up two instances of the TPC-H database, each running in their
> >>> own io-cgroup. I ran two clients to these databases and tested on each
> >>> that simple request:
> >>> $ select count(*) from LINEITEM;
> >>> where LINEITEM is the biggest table of TPC-H (6001215 entries,
> >>> 720MB). That request generates a steady stream of IOs.
> >>>
> >>> Time is measure by psql (\timing switched on). Each test is run twice
> >>> or more if there is any significant difference between the first two
> >>> runs. Before each run, the cache is flush:
> >>> $ echo 3 > /proc/sys/vm/drop_caches
> >>>
> >>>
> >>> Results with 2 groups of same io policy (BE) and same io weight (1000):
> >>>
> >>> 	w/o io-scheduler	io-scheduler v8		io-scheduler v9
> >>> 	first	second		first	second		first	second
> >>> 	DB	DB		DB	DB		DB	DB
> >>>
> >>> CFQ	48.4s	48.4s		48.2s	48.2s		48.1s	48.5s
> >>> Noop	138.0s	138.0s		48.3s	48.4s		48.5s	48.8s
> >>> AS	46.3s	47.0s		48.5s	48.7s		48.3s	48.5s
> >>> Deadl.	137.1s	137.1s		48.2s	48.3s		48.3s	48.5s
> >>>
> >>> As you can see, there is no significant difference for CFQ
> >>> scheduler.
> >> Thanks Jerome.  
> >>
> >>> There is big improvement for noop and deadline schedulers
> >>> (why is that happening?).
> >> I think because now related IO is in a single queue and it gets to run
> >> for 100ms or so (like CFQ). So previously, IO from both the instances
> >> will go into a single queue which should lead to more seeks as requests
> >> from two groups will kind of get interleaved.
> >>
> >> With io controller, both groups have separate queues so requests from
> >> both the data based instances will not get interleaved (This almost
> >> becomes like CFQ where ther are separate queues for each io context
> >> and for sequential reader, one io context gets to run nicely for certain
> >> ms based on its priority).
> >>
> >>> The performance with anticipatory scheduler
> >>> is a bit lower (~4%).
> >>>
> > 
> > Hi Jerome, 
> > 
> > Can you also run the AS test with io controller patches and both the
> > database in root group (basically don't put them in to separate group). I 
> > suspect that this regression might come from that fact that we now have
> > to switch between queues and in AS we wait for request to finish from
> > previous queue before next queue is scheduled in and probably that is
> > slowing down things a bit.., just a wild guess..
> > 
> 
> Hi Vivek,
> 
> I guess that's not the reason. I got 46.6s for both DB in root group with
> io-controller v9 patches. I also rerun the test with DB in different groups
> and found about the same result as above (48.3s and 48.6s).
> 

Hi Jerome,

Ok, so when both the DB's are in root group (with io-controller V9
patches), then you get 46.6 seconds time for both the DBs. That means there
is no regression in this case. In this case there is only one queue of 
root group and AS is running timed read/write batches on this queue.

But when both the DBs are put in separate groups then you get 48.3 and
48.6 seconds respectively and we see regression. In this case there are
two queues belonging to each group. Elevator layer takes care of queue
group queue switch and AS runs timed read/write batches on these queues.

If it is correct, then it does not exclude the possiblity that it is queue
switching overhead between groups?
 
Thanks
Vivek
