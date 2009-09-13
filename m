From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Sun, 13 Sep 2009 14:54:47 -0400
Message-ID: <20090913185447.GA11003@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4AA918C1.6070907@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AA918C1.6070907@redhat.com>
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

On Thu, Sep 10, 2009 at 05:18:25PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
>  
> Hi Vivek,
> 
> I've run some postgresql benchmarks for io-controller. Tests have been
> made with 2.6.31-rc6 kernel, without io-controller patches (when
> relevant) and with io-controller v8 and v9 patches.
> I set up two instances of the TPC-H database, each running in their
> own io-cgroup. I ran two clients to these databases and tested on each
> that simple request:
> $ select count(*) from LINEITEM;
> where LINEITEM is the biggest table of TPC-H (6001215 entries,
> 720MB). That request generates a steady stream of IOs.
> 
> Time is measure by psql (\timing switched on). Each test is run twice
> or more if there is any significant difference between the first two
> runs. Before each run, the cache is flush:
> $ echo 3 > /proc/sys/vm/drop_caches
> 
> 
> Results with 2 groups of same io policy (BE) and same io weight (1000):
> 
> 	w/o io-scheduler	io-scheduler v8		io-scheduler v9
> 	first	second		first	second		first	second
> 	DB	DB		DB	DB		DB	DB
> 
> CFQ	48.4s	48.4s		48.2s	48.2s		48.1s	48.5s
> Noop	138.0s	138.0s		48.3s	48.4s		48.5s	48.8s
> AS	46.3s	47.0s		48.5s	48.7s		48.3s	48.5s
> Deadl.	137.1s	137.1s		48.2s	48.3s		48.3s	48.5s
> 
> As you can see, there is no significant difference for CFQ
> scheduler. There is big improvement for noop and deadline schedulers
> (why is that happening?). The performance with anticipatory scheduler
> is a bit lower (~4%).
> 

Ok, I think what's happening here is that by default slice lenght for
a queue is 100ms. When you put two instances of DB in two different
groups, one streaming reader can run at max for 100ms at a go and then 
we switch to next reader.

But when both the readers are in root group, then AS lets run one reader
to run at max 250ms (sometimes 125ms and sometimes 250ms based on at what
time as_fifo_expired() was invoked).

So because a reader gets to run longer at one stretch in root group, it
reduces number of seeks and leads to little enhanced throughput.

If you change the /sys/block/<disk>/queue/iosched/slice_sync to 250 ms, then
one group queue can run at max for 250ms before we switch the queue. In
this case you should be able to get same performance as in root group.

Thanks
Vivek
