From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Thu, 16 Apr 2009 16:57:20 -0400
Message-ID: <20090416205720.GI8896@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090413.130552.226792299.ryov@valinux.co.jp>
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
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, linux-kernel@vger.kernel.org, Moyer Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, Morton Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, agk@redhat.com, Andrea Righi <righi.andrea@gmail.com>
List-Id: dm-devel.ids

On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> Hi Alasdair and all,
> 
> I did more tests on dm-ioband and I've posted the test items and
> results on my website. The results are very good.
> http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> 
> I hope someone will test dm-ioband and report back to the dm-devel
> mailing list.
> 

Ok, here are more test results. This time I am trying to see how fairness
is provided for async writes and how does it impact throughput.

I have created two partitions /dev/sda1 and /dev/sda2. Two ioband devices
ioband1 and ioband2 on /dev/sda1 and /dev/sda2 respectively with weights
40 and 40.

#dmsetup status
ioband2: 0 38025855 ioband 1 -1 150 8 186 1 0 8
ioband1: 0 40098177 ioband 1 -1 150 8 186 1 0 8

I ran following two fio jobs. One job in each partition.

************************************************************
echo cfq > /sys/block/sdd/queue/scheduler
sync
echo 3 > /proc/sys/vm/drop_caches

fio_args="--size=64m --rw=write --numjobs=50 --group_reporting"
time fio $fio_args --name=test1 --directory=/mnt/sdd1/fio/
--output=test1.log &
time fio $fio_args --name=test2 --directory=/mnt/sdd2/fio/
--output=test2.log &
wait
*****************************************************************

Following are fio job finish times with and without dm-ioband
		
			first job		second job
without dm-ioband	3m29.947s		4m1.436s 	
with dm-ioband		8m42.532s		8m43.328s

This sounds like 100% performance regression in this particular setup.

I think this regression is introduced because we are waiting for too
long for slower group to catch up to make sure proportionate numbers
look right and choke the writes even if deviec is free.

It is an hard to solve problem because the async writes traffic is 
bursty when seen at block layer and we not necessarily see higher amount of
writer traffic dispatched from higher prio process/group. So what does one
do? Wait for other groups to catch up to show right proportionate numbers
and hence let the disk be idle and kill the performance. Or just continue
and not idle too much (a small amount of idling like 8ms for sync queue 
might still be ok).

I think there might not be much benefit in providing artificial notion
of maintaining proportionate ratio and kill the performance. We should
instead try to audit async write path and see where the higher weight
application/group is stuck.

In my simple two dd test, I could see bursty traffic from high prio app and
then it would sometimes disappear for .2 to .8 seconds. In that duration if I
wait for higher priority group to catch up that I will end up keeping disk
idle for .8 seconds and kill performance. I guess better way is to not wait
that long (even if it means that to application it might give the impression
that io scheduler is not doing the job right in assiginig proportionate disk)
and over a period of time see if we can fix some things in async write path
for more smooth traffic to io scheduler.

Thoughts?

Thanks
Vivek


> Alasdair, could you please merge dm-ioband into upstream? Or could
> you please tell me why dm-ioband can't be merged?
> 
> Thanks,
> Ryo Tsuruta
> 
> To know the details of dm-ioband:
> http://people.valinux.co.jp/~ryov/dm-ioband/
> 
> RPM packages for RHEL5 and CentOS5 are available:
> http://people.valinux.co.jp/~ryov/dm-ioband/binary.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
