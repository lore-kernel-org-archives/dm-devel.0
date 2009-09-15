From: Vivek Goyal <vgoyal@redhat.com>
Subject: dm-ioband fairness in terms of sectors seems to be
	killing disk (Was: Re: Regarding dm-ioband tests)
Date: Tue, 15 Sep 2009 17:40:32 -0400
Message-ID: <20090915214032.GB3711@redhat.com>
References: <20090901165011.GB3753@redhat.com>
	<20090901174724.GC3753@redhat.com>
	<20090903131146.GA12041@redhat.com>
	<20090904.101222.226781140.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090904.101222.226781140.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 04, 2009 at 10:12:22AM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Sep 01, 2009 at 01:47:24PM -0400, Vivek Goyal wrote:
> > > On Tue, Sep 01, 2009 at 12:50:11PM -0400, Vivek Goyal wrote:
> > > > Hi Ryo,
> > > > 
> > > > I decided to play a bit more with dm-ioband and started doing some
> > > > testing. I am doing a simple two dd threads doing reads and don't seem
> > > > to be gettting the fairness. So thought will ask you what's the issue
> > > > here. Is there an issue with my testing procedure.
> > > > 
> > > > I got one 40G SATA drive (no hardware queuing). I have created two
> > > > partitions on that disk /dev/sdd1 and /dev/sdd2 and created two ioband
> > > > devices ioband1 and ioband2 on partitions sdd1 and sdd2 respectively. The
> > > > weights of ioband1 and ioband2 devices are 200 and 100 respectively. 
> > > > 
> > > > I am assuming that this setup will create two default groups and IO
> > > > going to partition sdd1 should get double the BW of partition sdd2.
> > > > 
> > > > But it looks like I am not gettting that behavior. Following is the output
> > > > of "dmsetup table" command. This snapshot has been taken every 2 seconds
> > > > while IO was going on. Column 9 seems to be containing how many sectors
> > > > of IO has been done on a particular io band device and group. Looking at
> > > > the snapshot, it does not look like that ioband1 default group got double
> > > > the BW of ioband2 default group.  
> > > > 
> > > > Am I doing something wrong here?
> > > > 
> > > 
> > 
> > Hi Ryo,
> > 
> > Did you get a chance to look into it? Am I doing something wrong or it is
> > an issue with dm-ioband.
> 
> Sorry, I missed it. I'll look into it and report back to you.

Hi Ryo,

I am running a sequential reader in one group and few random reader and
writers in second group. Both groups are of same weight. I ran fio scripts
for 60 seconds and then looked at the output. In this case looks like we just
kill the throughput of sequential reader and disk (because random
readers/writers take over).

I ran the test "with-dm-ioband", "without-dm-ioband" and "with ioscheduler
based io controller".

First I am pasting the results and in the end I will paste my test
scripts. I have cut fio output heavily so that we does not get lost in
lots of output.

with-dm-ioband
==============

ioband1
-------
randread: (groupid=0, jobs=4): err= 0: pid=3610
  read : io=18,432KiB, bw=314KiB/s, iops=76, runt= 60076msec
    clat (usec): min=140, max=744K, avg=50866.75, stdev=61266.88

randwrite: (groupid=1, jobs=2): err= 0: pid=3614
  write: io=920KiB, bw=15KiB/s, iops=3, runt= 60098msec
    clat (usec): min=203, max=14,171K, avg=522937.86, stdev=960929.44

ioband2
-------
seqread0: (groupid=0, jobs=1): err= 0: pid=3609
  read : io=37,904KiB, bw=636KiB/s, iops=155, runt= 61026msec
    clat (usec): min=92, max=9,969K, avg=6437.89, stdev=168573.23

without dm-ioband (vanilla cfq, no grouping)
============================================
seqread0: (groupid=0, jobs=1): err= 0: pid=3969
  read : io=321MiB, bw=5,598KiB/s, iops=1,366, runt= 60104msec
    clat (usec): min=91, max=763K, avg=729.61, stdev=17402.63

randread: (groupid=0, jobs=4): err= 0: pid=3970
  read : io=15,112KiB, bw=257KiB/s, iops=62, runt= 60039msec
    clat (usec): min=124, max=1,066K, avg=63721.26, stdev=78215.17

randwrite: (groupid=1, jobs=2): err= 0: pid=3974
  write: io=680KiB, bw=11KiB/s, iops=2, runt= 60073msec
    clat (usec): min=199, max=24,646K, avg=706719.51, stdev=1774887.55

With ioscheduer based io controller patches
===========================================
cgroup 1 (weight 100)
---------------------
randread: (groupid=0, jobs=4): err= 0: pid=2995
  read : io=9,484KiB, bw=161KiB/s, iops=39, runt= 60107msec
    clat (msec): min=1, max=2,167, avg=95.47, stdev=131.60

randwrite: (groupid=1, jobs=2): err= 0: pid=2999
  write: io=2,692KiB, bw=45KiB/s, iops=11, runt= 60131msec
    clat (usec): min=199, max=30,043K, avg=178710.05, stdev=1281485.75

cgroup 2 (weight 100)
--------------------
seqread0: (groupid=0, jobs=1): err= 0: pid=2993
  read : io=547mib, bw=9,556kib/s, iops=2,333, runt= 60043msec
    clat (usec): min=92, max=224k, avg=426.74, stdev=5734.12

Note the BW of sequential reader in three cases
(636 KB/s, 5,598KiB/s, 9,556KiB/s). dm-ioband tries to provide fairness in
terms of number of sectors and it completely kills the disk throughput.

with io scheduler based io controller, we see increased throughput for
seqential reader as compared to CFQ, because now random readers are
running in a separate group and hence reader gets isolation from random
readers.

Here are my fio jobs
--------------------
First fio job file
-----------------
[global]
runtime=60

[randread]
rw=randread
size=2G
iodepth=20
directory=/mnt/sdd1/fio/
direct=1
numjobs=4
group_reporting

[randwrite]
rw=randwrite
size=1G
iodepth=20
directory=/mnt/sdd1/fio/
group_reporting
direct=1
numjobs=2

Second fio job file
-------------------
[global]
runtime=60
rw=read
size=4G
directory=/mnt/sdd2/fio/
direct=1

[seqread0]
numjobs=1
group_reporting

Thanks
Vivek
