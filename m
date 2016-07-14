From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: poor thin performance, relative to thick
Date: Thu, 14 Jul 2016 16:58:48 -0400
Message-ID: <20160714205847.GA17325@redhat.com>
References: <20160711204454.GA24378@helmut> <20160712184625.GA3691@redhat.com>
	<20160714042122.GB24221@helmut>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160714042122.GB24221@helmut>
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

On Thu, Jul 14 2016 at 12:21am -0400,
Jon Bernard <jbernard@tuxion.com> wrote:

> * Mike Snitzer <snitzer@redhat.com> wrote:
> > On Mon, Jul 11 2016 at  4:44pm -0400,
> > Jon Bernard <jbernard@tuxion.com> wrote:
> > 
> > > Greetings,
> > > 
> > > I have recently noticed a large difference in performance between thick
> > > and thin LVM volumes and I'm trying to understand why that it the case.
> > > 
> > > In summary, for the same FIO test (attached), I'm seeing 560k iops on a
> > > thick volume vs. 200k iops for a thin volume and these results are
> > > pretty consistent across different runs.
> > > 
> > > I noticed that if I run two FIO tests simultaneously on 2 separate thin
> > > pools, I net nearly double the performance of a single pool.  And two
> > > tests on thin volumes within the same pool will split the maximum iops
> > > of the single pool (essentially half).  And I see similar results from
> > > linux 3.10 and 4.6.
> > > 
> > > I understand that thin must track metadata as part of its design and so
> > > some additional overhead is to be expected, but I'm wondering if we can
> > > narrow the gap a bit.
> > > 
> > > In case it helps, I also enabled LOCK_STAT and gathered locking
> > > statistics for both thick and thin runs (attached).
> > > 
> > > I'm curious to know whether this is a know issue, and if I can do
> > > anything the help improve the situation.  I wonder if the use of the
> > > primary spinlock in the pool structure could be improved - the lock
> > > statistics appear to indicate a significant amount of time contending
> > > with that one.  Or maybe it's something else entirely, and in that case
> > > please enlighten me.
> > > 
> > > If there are any specific questions or tests I can run, I'm happy to do
> > > so.  Let me know how I can help.
> > > 
> > > -- 
> > > Jon
> > 
> > I personally put a significant amount of time into thick vs thin
> > performance comparisons and improvements a few years ago.  But the focus
> > of that work was to ensure Gluster -- as deployed by Red Hat (which is
> > layered ontop of DM-thinp + XFS) -- performed comparably to thick
> > volumes for: multi-threaded sequential writes followed by reads.
> > 
> > At that time there was significant slowdown from thin when reading back
> > the writen data (due to multithreaded writes httting FIFO block
> > allocation in DM thinp).
> > 
> > Here are the related commits I worked on:
> > http://git.kernel.org/linus/c140e1c4e23b
> > http://git.kernel.org/linus/67324ea18812
> > 
> > And one that Joe later did based on the same idea (sorting):
> > http://git.kernel.org/linus/ac4c3f34a9af
> 
> Interesting, were you able to get thin to perform similarly to thick for
> your configuration at that time?

Absolutely.  thin was very competitive vs thick for the test I described
(multi-threaded sequential writes follwed by reading the written data
back).

> > > [random]
> > > direct=1 
> > > rw=randrw 
> > > zero_buffers 
> > > norandommap 
> > > randrepeat=0 
> > > ioengine=libaio
> > > group_reporting
> > > rwmixread=100 
> > > bs=4k 
> > > iodepth=32 
> > > numjobs=16 
> > > runtime=600
> > 
> > But you're focusing on multithreaded small random reads (4K).  AFAICT
> > this test will never actually allocate the block in the thin device
> > first, maybe I'm missing something but all I see is read stats.
> > 
> > But I'm also not sure what "thin-thick" means (vs "thin-thindisk1"
> > below).
> > 
> > Is the "thick" LV just a normal linear LV?
> > And "thindisk1" LV is a thin LV?
> 
> My naming choices could use improvement, I created a volume group named
> 'thin' and within that a thick volume 'thick' and also a thin pool which
> contains a single thin volume 'thindisk1'.  The device names in
> /dev/mapper are prefixed with 'thin-' and so it did get confusing.  The
> lvs output should clear this up:
> 
> # lvs -a
>   LV              VG   Attr       LSize   Pool  Origin Data%  Meta%  Move Log Cpy%Sync Convert
>   [lvol0_pmspare] thin ewi-------  16.00g                                                     
>   pool1           thin twi-aot---   1.00t              9.77   0.35                            
>   [pool1_tdata]   thin Twi-ao----   1.00t                                                     
>   [pool1_tmeta]   thin ewi-ao----  16.00g                                                     
>   pool2           thin twi-aot---   1.00t              0.00   0.03                            
>   [pool2_tdata]   thin Twi-ao----   1.00t                                                     
>   [pool2_tmeta]   thin ewi-ao----  16.00g                                                     
>   thick           thin -wi-a----- 100.00g                                                     
>   thindisk1       thin Vwi-a-t--- 100.00g pool1        100.00                                 
>   thindisk2       thin Vwi-a-t--- 100.00g pool2        0.00                                   
> 
> You raised a good point about starting with writes and Zdenek's response
> caused me to think more about provisioning.  So I've adjusted my tests
> and collected some new results.  At the moment I'm running a 4.4.13
> kernel with blk-mq enabled.  I'm first doing a sequential write test to
> ensure that all blocks are fully allocated, and I then perform a random
> write test followed by a random read test.  The results are as follows:
> 
> FIO on thick
> Write Rand: 416K
> Read Rand: 512K
> 
> FIO on thin
> Write Rand: 177K
> Read Rand: 186K
> 
> This should remove any provisioning-on-read overhead and with blk-mq
> enabled we shouldn't be hammering on q->queue_lock anymore.

Please share your exact sequence of steps/tests (command lines, fio job
files, etc).

> Do you have any intuition on where to start looking?  I've started
> reading the code and I wonder if a different locking stragegy for
> pool->lock could help.  The impact of such a change is still unclear to
> me, I'm curious if you have any thoughts about this.  I can collect new
> lockstat data, or perhaps perf could capture places where most time is
> spent, or something I don't know about yet.  I have some time to work on
> this so I'll do what I can as long as I have access to this machine.

Probably makes sense to use perf to try to get a view at where all the
time is being spent on thin vs thick.  'perf record ...' followed by
'perf report'

It would also be wise to establish a baseline for whether thick vs thin
is comparable for single thread sequential IO.  Then evaluate single
thread random IO.  Test different block sizes (both for application
block size and thinp block size).

Then once you have a handle on how things look with single threaded fio
runs elevate to multithreaded.  See what, if anything, changes in the
'perf record' + 'perf report' results.
