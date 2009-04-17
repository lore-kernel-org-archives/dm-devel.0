From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Thu, 16 Apr 2009 22:11:39 -0400
Message-ID: <20090417021139.GB23152@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090416205720.GI8896@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090416205720.GI8896@redhat.com>
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

On Thu, Apr 16, 2009 at 04:57:20PM -0400, Vivek Goyal wrote:
> On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> > Hi Alasdair and all,
> > 
> > I did more tests on dm-ioband and I've posted the test items and
> > results on my website. The results are very good.
> > http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> > 
> > I hope someone will test dm-ioband and report back to the dm-devel
> > mailing list.
> > 
> 

Ok, one more test. This time to show that with single queue and FIFO
dispatch a writer can easily starve the reader.

I have created two partitions /dev/sda1 and /dev/sda2. Two ioband devices
ioband1 and ioband2 on /dev/sda1 and /dev/sda2 respectively with weights
40 and 20.

I am launching an aggressive writer dd with prio 7 (Best effort) and a
reader with prio 0 (Best effort).

Following is my script.

****************************************************************
rm /mnt/sdd1/aggressivewriter

sync
echo 3 > /proc/sys/vm/drop_caches

#launch an hostile writer
ionice -c2 -n7 dd if=/dev/zero of=/mnt/sdd1/aggressivewriter bs=4K count=524288 conv=fdatasync &

# Reader
ionice -c 2 -n 0 dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
wait $!
echo "reader finished"
**********************************************************************

Following are the results without and with dm-ioband

Without dm-ioband
-----------------
First run
2147483648 bytes (2.1 GB) copied, 46.4747 s, 46.2 MB/s (Reader)
reader finished
2147483648 bytes (2.1 GB) copied, 87.9293 s, 24.4 MB/s (Writer)

Second run
2147483648 bytes (2.1 GB) copied, 47.6461 s, 45.1 MB/s (Reader)
reader finished
2147483648 bytes (2.1 GB) copied, 89.0781 s, 24.1 MB/s (Writer)

Third run
2147483648 bytes (2.1 GB) copied, 51.0624 s, 42.1 MB/s (Reader)
reader finished
2147483648 bytes (2.1 GB) copied, 91.9507 s, 23.4 MB/s (Writer)

With dm-ioband
--------------
2147483648 bytes (2.1 GB) copied, 54.895 s, 39.1 MB/s (Writer)
2147483648 bytes (2.1 GB) copied, 88.6323 s, 24.2 MB/s (Reader)
reader finished

2147483648 bytes (2.1 GB) copied, 62.6102 s, 34.3 MB/s (Writer)
2147483648 bytes (2.1 GB) copied, 91.6662 s, 23.4 MB/s (Reader)
reader finished

2147483648 bytes (2.1 GB) copied, 58.9928 s, 36.4 MB/s (Writer)
2147483648 bytes (2.1 GB) copied, 90.6707 s, 23.7 MB/s (Reader)
reader finished

I have marked which dd finished first. I determine it with the help of
wait command and also monitor the "iostat -d 5 sdd1" to see how IO rates
are varying.

Notice with dm-ioband its complete reversal of fortunes. A reader is
completely starved by the aggressive writer. I think this one you should
be able to reproduce easily with script.

I don't understand how single queue and FIFO dispatch does not break
the notion of cfq classes and priorities?

Thanks
Vivek

> Ok, here are more test results. This time I am trying to see how fairness
> is provided for async writes and how does it impact throughput.
> 
> I have created two partitions /dev/sda1 and /dev/sda2. Two ioband devices
> ioband1 and ioband2 on /dev/sda1 and /dev/sda2 respectively with weights
> 40 and 40.
> 
> #dmsetup status
> ioband2: 0 38025855 ioband 1 -1 150 8 186 1 0 8
> ioband1: 0 40098177 ioband 1 -1 150 8 186 1 0 8
> 
> I ran following two fio jobs. One job in each partition.
> 
> ************************************************************
> echo cfq > /sys/block/sdd/queue/scheduler
> sync
> echo 3 > /proc/sys/vm/drop_caches
> 
> fio_args="--size=64m --rw=write --numjobs=50 --group_reporting"
> time fio $fio_args --name=test1 --directory=/mnt/sdd1/fio/
> --output=test1.log &
> time fio $fio_args --name=test2 --directory=/mnt/sdd2/fio/
> --output=test2.log &
> wait
> *****************************************************************
> 
> Following are fio job finish times with and without dm-ioband
> 		
> 			first job		second job
> without dm-ioband	3m29.947s		4m1.436s 	
> with dm-ioband		8m42.532s		8m43.328s
> 
> This sounds like 100% performance regression in this particular setup.
> 
> I think this regression is introduced because we are waiting for too
> long for slower group to catch up to make sure proportionate numbers
> look right and choke the writes even if deviec is free.
> 
> It is an hard to solve problem because the async writes traffic is 
> bursty when seen at block layer and we not necessarily see higher amount of
> writer traffic dispatched from higher prio process/group. So what does one
> do? Wait for other groups to catch up to show right proportionate numbers
> and hence let the disk be idle and kill the performance. Or just continue
> and not idle too much (a small amount of idling like 8ms for sync queue 
> might still be ok).
> 
> I think there might not be much benefit in providing artificial notion
> of maintaining proportionate ratio and kill the performance. We should
> instead try to audit async write path and see where the higher weight
> application/group is stuck.
> 
> In my simple two dd test, I could see bursty traffic from high prio app and
> then it would sometimes disappear for .2 to .8 seconds. In that duration if I
> wait for higher priority group to catch up that I will end up keeping disk
> idle for .8 seconds and kill performance. I guess better way is to not wait
> that long (even if it means that to application it might give the impression
> that io scheduler is not doing the job right in assiginig proportionate disk)
> and over a period of time see if we can fix some things in async write path
> for more smooth traffic to io scheduler.
> 
> Thoughts?
> 
> Thanks
> Vivek
> 
> 
> > Alasdair, could you please merge dm-ioband into upstream? Or could
> > you please tell me why dm-ioband can't be merged?
> > 
> > Thanks,
> > Ryo Tsuruta
> > 
> > To know the details of dm-ioband:
> > http://people.valinux.co.jp/~ryov/dm-ioband/
> > 
> > RPM packages for RHEL5 and CentOS5 are available:
> > http://people.valinux.co.jp/~ryov/dm-ioband/binary.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
