From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Performance testing of related dm-crypt patches
Date: Fri, 20 Feb 2015 09:43:56 -0500
Message-ID: <20150220144355.GA15472@redhat.com>
References: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
	<54E7007E.5000702@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54E7007E.5000702@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 20 2015 at  4:38am -0500,
Ondrej Kozina <okozina@redhat.com> wrote:

> Hi,
> 
> the mail will be quite a big one so for better navigation I'm adding
> contents:
> 
> [1] Short resume of performance results
> [2] Descriptions of test systems
> [3] Detailed tests description
> [4] Description of dm-crypt modules involved in testing
> [5] dm-zero based test results
> [6] spin drive based results
> [7] spin drive based results (heavy load)
> --------------------------------------------------------------------
> 
> [1] Short resume of performance results
> ---------------------------------------
> 
> Results for dm-crypt target mapped over dm-zero one (testing pure
> performance of dm-crypt only) show that unbounding the workqueue
> is vastly beneficial for very fast devices. Offloading the requests
> to separate thread (before sorting the requests) has some cost (~10%
> compared to after the unbound workqueue patch applied) but it's not
> anything that would kill the performance seriously. Also results
> show that (CPU) price for sorting the requests before submitting to
> lower layer is negligible. Note that with dm-zero backend no I/O
> scheduler steps in.
> 
> With spin drives it's not so straightforward, but in summary
> there're still nice performance gains visible. Especially with
> larger block sizes (and deeper queues) the sorting patch improves
> the performance significantly and sometimes matches the performance
> of raw block device!
> 
> Unfortunately there are examples of workloads where even unbounding
> the queue or subsequent offloading of requests to separate thread
> can hurt performance so this is why we decided to introduce 2
> switches in dm-crypt target constructor. More detailed explanation
> in [6] and [7].

Overall the good definitely outweighs any bad though.  Thanks a lot for
all your work on this testing.
 
> [6] spin drive based results
> ----------------------------
> 
> "disk" test single socket system with cfq scheduler:
> http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk/numa_1/stats
> full test results including fio job files and logs:
> http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk/numa_1/test_disk_aio.tar.xz
> 
> Usually, there's noticeable performance improvement starting with
> patch E in iodepth=8 and reasonably set bsize (4KiB and larger), but
> as you can seen there're few examples where offloading (and sorting)
> hurts the performance (iodepth=32, various block sizes).
> 
> With iodepth=256 there're some examples where unbounding the
> workqueue without offloading to single thread can hurt the
> performance (bsize=16KiB and 32KiB)
> 
> But in most cases we can say dm-crypt performance is pretty close to
> raw block device now.

Yes, though there definitely seems something pathologically wrong with
the cases you pointed out.  But in 99% of all cases the end result of
the new changes is better than existing dm-crypt (G vs A).

> [7] spin drive based results (heavy load)
> -----------------------------------------
> 
> These tests were most complex. Tested both cfq and deadline
> schedulers, setting different nr_request parameter for device's
> scheduler queue.
> 
> Tests were spawning 1, 5 or 8 fio processes per CPU socket (8, 40 or
> 64 processes in case of numa_8) in a system and performed i/o on
> same count of non-overlapping disk regions.
> 
> subdir /numj_1/ means: single process per cpu socket, /numj_5/: 5
> processes...
> 
> Unfortunately, there're workloads where unbounding the workqueue
> shows performance drop and subsequent offloading to single thread
> makes it even worse. (see 8 socket system, cfq, numj_1: http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_8/cfq/nr_req_128/numj_1/stats).
> 
> Similar observations in 2 socket system, cfq, numj_1 :http://okozina.fedorapeople.org/dm-crypt-for-3.20/disk_heavy_load/numa_2/cfq/nr_req_128/numj_1/stats.
> 
> On both 2 socket and 8 socket system this observation fades away
> with adding more fio processes per socket.
> 
> Only 4 socket system (not so up to date AMD CPUs w/o HT) didn't show
> such pattern.
> 
> Generally with higher load, deeper ioqueues and larger block sizes,
> the sorting which takes place in offload thread proves to do it's
> job good.

It is interesting to note that deadline pretty consistently outperforms
CFQ.  Not too surprising considering all the extra logic that CFQ has.
But it is nice to see that with CFQ the new changes, targeting helping
CFQ, seem to be helping (to overcome CFQ's IO context constraints).

In the end I'm inclined to "ship it!".  I'll prep the pull for Linus
now.

Again, thanks for all your testing!

Mike
