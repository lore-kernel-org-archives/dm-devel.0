From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Wed, 07 Oct 2009 23:38:05 +0900 (JST)
Message-ID: <20091007.233805.183040347.ryov@valinux.co.jp>
References: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
	<20091006.161744.189719641.ryov@valinux.co.jp>
	<20091006112201.GA27866@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091006112201.GA27866@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, righi.andrea@gmail.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, m-ikeda@ds.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >> If one would like to
> > > >> combine some physical disks into one logical device like a dm-linear,
> > > >> I think one should map the IO controller on each physical device and
> > > >> combine them into one logical device.
> > > >>
> > > >
> > > > In fact this sounds like a more complicated step where one has to setup
> > > > one dm-ioband device on top of each physical device. But I am assuming
> > > > that this will go away once you move to per reuqest queue like implementation.
> > 
> > I don't understand why the per request queue implementation makes it
> > go away. If dm-ioband is integrated into the LVM tools, it could allow
> > users to skip the complicated steps to configure dm-linear devices.
> > 
> 
> Those who are not using dm-tools will be forced to use dm-tools for
> bandwidth control features.

If once dm-ioband is integrated into the LVM tools and bandwidth can
be assigned per device by lvcreate, the use of dm-tools is no longer
required for users.

> Interesting. In all the test cases you always test with sequential
> readers. I have changed the test case a bit (I have already reported the
> results in another mail, now running the same test again with dm-version
> 1.14). I made all the readers doing direct IO and in other group I put
> a buffered writer. So setup looks as follows.
> 
> In group1, I launch 1 prio 0 reader and increasing number of prio4
> readers. In group 2 I just run a dd doing buffered writes. Weights of
> both the groups are 100 each.
> 
> Following are the results on 2.6.31 kernel.
> 
> With-dm-ioband
> ==============
> <------------prio4 readers---------------------->  <---prio0 reader------>
> nr  Max-bdwidth Min-bdwidth Agg-bdwidth Max-latency Agg-bdwidth Max-latency 
> 1   9992KiB/s   9992KiB/s   9992KiB/s   413K usec   4621KiB/s   369K usec   
> 2   4859KiB/s   4265KiB/s   9122KiB/s   344K usec   4915KiB/s   401K usec   
> 4   2238KiB/s   1381KiB/s   7703KiB/s   532K usec   3195KiB/s   546K usec   
> 8   504KiB/s    46KiB/s     1439KiB/s   399K usec   7661KiB/s   220K usec   
> 16  131KiB/s    26KiB/s     638KiB/s    492K usec   4847KiB/s   359K usec   
> 
> With vanilla CFQ
> ================
> <------------prio4 readers---------------------->  <---prio0 reader------>
> nr  Max-bdwidth Min-bdwidth Agg-bdwidth Max-latency Agg-bdwidth Max-latency 
> 1   10779KiB/s  10779KiB/s  10779KiB/s  407K usec   16094KiB/s  808K usec   
> 2   7045KiB/s   6913KiB/s   13959KiB/s  538K usec   18794KiB/s  761K usec   
> 4   7842KiB/s   4409KiB/s   20967KiB/s  876K usec   12543KiB/s  443K usec   
> 8   6198KiB/s   2426KiB/s   24219KiB/s  1469K usec  9483KiB/s   685K usec   
> 16  5041KiB/s   1358KiB/s   27022KiB/s  2417K usec  6211KiB/s   1025K usec  
> 
> 
> Above results are showing how bandwidth got distributed between prio4 and
> prio1 readers with-in group as we increased number of prio4 readers in
> the group. In another group a buffered writer is continuously going on
> as competitor.
> 
> Notice, with dm-ioband how bandwidth allocation is broken.
> 
> With 1 prio4 reader, prio4 reader got more bandwidth than prio1 reader.
> 
> With 2 prio4 readers, looks like prio4 got almost same BW as prio1.
> 
> With 8 and 16 prio4 readers, looks like prio0 readers takes over and prio4
> readers starve.
> 
> As we incresae number of prio4 readers in the group, their total aggregate
> BW share should increase. Instread it is decreasing.
> 
> So to me in the face of competition with a writer in other group, BW is
> all over the place. Some of these might be dm-ioband bugs and some of
> these might be coming from the fact that buffering takes place in higher
> layer and dispatch is FIFO?

Thank you for testing. I did the same test and here are the results.

with vanilla CFQ
   <------------prio4 readers------------------>   prio0       group2
      maxbw       minbw      aggrbw     maxlat     aggrbw      bufwrite
 1 12,140KiB/s 12,140KiB/s 12,140KiB/s 30001msec 11,125KiB/s  1,923KiB/s
 2  3,967KiB/s  3,930KiB/s  7,897KiB/s 30001msec 14,213KiB/s  1,586KiB/s
 4  3,399KiB/s  3,066KiB/s 13,031KiB/s 30082msec  8,930KiB/s  1,296KiB/s
 8  2,086KiB/s  1,720KiB/s 15,266KiB/s 30003msec  7,546KiB/s    517KiB/s
16  1,156KiB/s    837KiB/s 15,377KiB/s 30033msec  4,282KiB/s    600KiB/s

with dm-ioband weight-iosize policy
   <------------prio4 readers------------------>   prio0       group2
      maxbw       minbw      aggrbw     maxlat     aggrbw      bufwrite
 1    107KiB/s    107KiB/s    107KiB/s 30007msec 12,242KiB/s 12,320KiB/s
 2  1,259KiB/s    702KiB/s  1,961KiB/s 30037msec  9,657KiB/s 11,657KiB/s
 4  2,705KiB/s     29KiB/s  5,186KiB/s 30026msec  5,927KiB/s 11,300KiB/s
 8  2,428KiB/s     27KiB/s  5,629KiB/s 30054msec  5,057KiB/s 10,704KiB/s
16  2,465KiB/s     23KiB/s  4,309KiB/s 30032msec  4,750KiB/s  9,088KiB/s

The results are somewhat different from yours. The bandwidth is
distributed to each group equally, but CFQ priority is broken as you
said. I think that the reason is not because of FIFO, but because
some IO requests are issued from dm-ioband's kernel thread on behalf of
processes which origirante the IO requests, then CFQ assumes that the
kernel thread is the originator and uses its io_context.

> > Here is my test script.
> > -------------------------------------------------------------------------
> > arg="--time_base --rw=read --runtime=30 --directory=/mnt1 --size=1024M \
> >      --group_reporting"
> > 
> > sync
> > echo 3 > /proc/sys/vm/drop_caches
> > 
> > echo $$ > /cgroup/1/tasks
> > ionice -c 2 -n 0 fio $arg --name=read1 --output=read1.log --numjobs=16 &
> > echo $$ > /cgroup/2/tasks
> > ionice -c 2 -n 0 fio $arg --name=read2 --output=read2.log --numjobs=16 &
> > ionice -c 1 -n 0 fio $arg --name=read3 --output=read3.log --numjobs=1 &
> > echo $$ > /cgroup/tasks
> > wait
> > -------------------------------------------------------------------------
> > 
> > Be that as it way, I think that if every bio can point the iocontext
> > of the process, then it makes it possible to handle IO priority in the
> > higher level controller. A patchse has already posted by Takhashi-san.
> > What do you think about this idea?
> > 
> >   Date Tue, 22 Apr 2008 22:51:31 +0900 (JST)
> >   Subject [RFC][PATCH 1/10] I/O context inheritance
> >   From Hirokazu Takahashi <>
> >   http://lkml.org/lkml/2008/4/22/195
> 
> So far you have been denying that there are issues with ioprio with-in
> group in higher level controller. Here you seems to be saying that there are
> issues with ioprio and we need to take this patch in to solve the issue? I am
> confused?

The true intention of this patch is to preserve the io-context of a
process which originate it, but I think that we could also make use of
this patch for one of the way to solve this issue.

> Anyway, if you think that above patch is needed to solve the issue of
> ioprio in higher level controller, why are you not posting it as part of
> your patch series regularly, so that we can also apply this patch along
> with other patches and test the effects?

I will post the patch, but I would like to find out and understand the
reason of above test results before posting the patch.

> Against what kernel version above patches apply. The biocgroup patches
> I tried against 2.6.31 as well as 2.6.32-rc1 and it does not apply cleanly
> against any of these?
> 
> So for the time being I am doing testing with biocgroup patches.

I created those patches against 2.6.32-rc1 and made sure the patches
can be cleanly applied to that version.

Thanks,
Ryo Tsuruta
