From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: performance considerations with IO schedulers and
	DMmultipathing
Date: Wed, 05 Dec 2007 20:42:19 -0500 (EST)
Message-ID: <20071205.204219.28783441.k-ueda@ct.jp.nec.com>
References: <5201e28f0711271342s25dedae6j617f89c1d229b6c7@mail.gmail.com>
	<1D80D4F6D179BD4D869FE807A5BF8336012DCA51@EXCNYSM0A1AN.nysemail.nyenet>
	<5201e28f0711300502k7f51ff55vd9f557a6a05fcdc@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0711300502k7f51ff55vd9f557a6a05fcdc@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

On Fri, 30 Nov 2007 14:02:31 +0100, Stefan Bader wrote:
> 2007/11/30, Romanowski, John (OFT) <John.Romanowski@oft.state.ny.us>:
> >
> > Here's some links:
> >
> > Google cache of this article:
> > "The basis for my test was to determine the best possible performance
> > combination of elevator tuning AND /etc/multipath.conf rr_min_io setting."
> >
> > http://72.14.209.104/search?q=cache:q2p5HOwGxHwJ:www.techyblog.com/content/view/45/28/+Multipath+rr_min_io+Oracle+Elevator+Benchmarks&hl=en&ct=clnk&cd=1&gl=us
> 
> 
> The thing is, that there are two settings that affect different drivers. The
> I/O scheduler setting will affect the disks that are part of the multipath
> volume (and only them), while the rr_min_io affects the multipath volume.
> The higher the value of rr_min_io, the more requests are sent down one path
> before switching to the next in the same path group. While this is good for
> sequential I/O (because the elevator/scheduler on the underlying device can
> merge more efficiently), this reduces the amount of I/O that is sent in
> parallel. With very high rr_min_io settings you will end up using mostly one
> path at a time, while the others are idle.
> Using small values for rr_min_io, the chances of spreading the requests over
> all paths are higher, but so is the chance of separating a long sequence
> into smaller parts that are not sequential for the disk devices that make
> the paths. Here a scheduler setting that copes with that pattern can help.
> Another approach, that is not in the mainline kernel yet, is to introduce a
> queue to the multipath target, merge sequential request there and send each
> I/O down another path (like rr_min_io=1 would do). Kiyoshi Ueda from NEC had
> a presentation about this on last years OLS (
> https://ols2006.108.redhat.com/2007/Reprints/ueda-Reprint.pdf ). From their
> evaluation of the current kernel, smaller rr_min_io values improved
> performance but the best value was different for reads and writes.

Although I can't say what combination is the best on the current
bio-based dm-multipath, I wrote down my experiences and understanding
below.  I hope that helps.


I used 2.6.19.1 and single dd on block device and ext3 filesystem
to evaluate sequential I/O performance.
I remenber that cfq/as were the best for READ and there was no big
difference for WRITE.

Generally speaking, READ has synchronous behavior and underlying
devices don't become so busy.  So I/O schedulers which dispatch READ
request quickly like cfq are good for READ rather than keeping for
long time to merge.
As for WRITE, there is no big difference between I/O schedulers,
because underlying devices are almost busy, so merging as much as
possible is good for WRITE and all I/O schedulers do that.
I haven't tested random I/O using different I/O schedulers.
It may depend on workload which I/O scheduler is the best.


As for the rr_min_io, it's very complex, because it depends on
page size (and read-ahead code as for READ).
For exsample, on systems with 4k page size:
  - For READ
    * On block device: 8 or 16 is good for 2 paths environment because:
      block device doesn't have readpages() operation, so each page
      is submitted as 1 bio.
      READ is based on read-ahead and read-ahead window size is 128k
      (not configurable on bio-based dm device).
      So dispatching half size of the window to a same path is good for
      minimum number of requests on each path in 2 paths environment.
    * On filesystem : 1 is good because:
      Almost all filesystems including ext3 have readpages() operation,
      so filesystems make a read-ahead-window-size (128k) bio.
      Since up to 2 windows (so 2 bios) can be submitted in 2.6.19.1,
      dispaching them to each paths is good.
    (NOTE: Since read-ahead code has been changed in 2.6.22 or so very
           much, the values above may differ now.)

  - for WRITE
    * 64 or 128 is good because:
      Each page is submitted as 1 bio for WRITE, regardless block device
      or filesystem.
      And default q->max_sectors is 512k.
      So dispatching 128 bios to a same path is good for maxmum merge
      on 4k page size system.

So it is very difficult to find the best rr_min_io on real workload.

If request-based dm-multipath is used, the best rr_min_io should be
always 1 :-)

Thanks,
Kiyoshi Ueda
