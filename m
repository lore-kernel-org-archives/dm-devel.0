From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Wed, 15 Apr 2009 10:10:49 -0400
Message-ID: <20090415141049.GA15067@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090415043759.GA8349@redhat.com>
	<20090415.223832.71125857.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090415.223832.71125857.ryov@valinux.co.jp>
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
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, Apr 15, 2009 at 10:38:32PM +0900, Ryo Tsuruta wrote:
> Hi Vivek, 
> 
> > In the beginning of the mail, i am listing some basic test results and
> > in later part of mail I am raising some of my concerns with this patchset.
> 
> I did a similar test and got different results to yours. I'll reply
> later about the later part of your mail.
> 
> > My test setup:
> > --------------
> > I have got one SATA driver with two partitions /dev/sdd1 and /dev/sdd2 on
> > that. I have created ext3 file systems on these partitions. Created one
> > ioband device "ioband1" with weight 40 on /dev/sdd1 and another ioband
> > device "ioband2" with weight 10 on /dev/sdd2.
> >   
> > 1) I think an RT task with-in a group does not get its fair share (all
> >   the BW available as long as RT task is backlogged). 
> > 
> >   I launched one RT read task of 2G file in ioband1 group and in parallel
> >   launched more readers in ioband1 group. ioband2 group did not have any
> >   io going. Following are results with and without ioband.
> > 
> >   A) 1 RT prio 0 + 1 BE prio 4 reader
> > 
> > 	dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 39.4701 s, 54.4 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 71.8034 s, 29.9 MB/s
> > 
> > 	without-dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 35.3677 s, 60.7 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 70.8214 s, 30.3 MB/s
> > 
> >   B) 1 RT prio 0 + 2 BE prio 4 reader
> > 
> > 	dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 43.8305 s, 49.0 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 135.395 s, 15.9 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 136.545 s, 15.7 MB/s
> > 
> > 	without-dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 35.3177 s, 60.8 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 124.793 s, 17.2 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 126.267 s, 17.0 MB/s
> > 
> >   C) 1 RT prio 0 + 3 BE prio 4 reader
> > 
> > 	dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 48.8159 s, 44.0 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 185.848 s, 11.6 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 188.171 s, 11.4 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 189.537 s, 11.3 MB/s
> > 
> > 	without-dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 35.2928 s, 60.8 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 169.929 s, 12.6 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 172.486 s, 12.5 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 172.817 s, 12.4 MB/s
> > 
> >   C) 1 RT prio 0 + 3 BE prio 4 reader
> > 	dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 51.4279 s, 41.8 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 260.29 s, 8.3 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 261.824 s, 8.2 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 261.981 s, 8.2 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 262.372 s, 8.2 MB/s
> > 
> > 	without-dm-ioband
> > 	2147483648 bytes (2.1 GB) copied, 35.4213 s, 60.6 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 215.784 s, 10.0 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 218.706 s, 9.8 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 220.12 s, 9.8 MB/s
> > 	2147483648 bytes (2.1 GB) copied, 220.57 s, 9.7 MB/s
> > 
> > Notice that with dm-ioband as number of readers are increasing, finish
> > time of RT tasks is also increasing. But without dm-ioband finish time
> > of RT tasks remains more or less constat even with increase in number
> > of readers.
> > 
> > For some reason overall throughput also seems to be less with dm-ioband.
> > Because ioband2 is not doing any IO, i expected that tasks in ioband1
> > will get full disk BW and throughput will not drop.
> > 
> > I have not debugged it but I guess it might be coming from the fact that
> > there are no separate queues for RT tasks. bios from all the tasks can be
> > buffered on a single queue in a cgroup and that might be causing RT
> > request to hide behind BE tasks' request?
> 
> I followed your setup and ran the following script on my machine.
> 
>         #!/bin/sh
>         echo 1 > /proc/sys/vm/drop_caches
>         ionice -c1 -n0 dd if=/mnt1/2g.1 of=/dev/null &
>         ionice -c2 -n4 dd if=/mnt1/2g.2 of=/dev/null &
>         ionice -c2 -n4 dd if=/mnt1/2g.3 of=/dev/null &
>         ionice -c2 -n4 dd if=/mnt1/2g.4 of=/dev/null &
>         wait
> 
> I got different results and there is no siginificant difference each
> dd's throughput between w/ and w/o dm-ioband. 
> 
>     A) 1 RT prio 0 + 1 BE prio 4 reader
>         w/ dm-ioband
>         2147483648 bytes (2.1 GB) copied, 64.0764 seconds, 33.5 MB/s
>         2147483648 bytes (2.1 GB) copied, 99.0757 seconds, 21.7 MB/s
>         w/o dm-ioband
>         2147483648 bytes (2.1 GB) copied, 62.3575 seconds, 34.4 MB/s
>         2147483648 bytes (2.1 GB) copied, 98.5804 seconds, 21.8 MB/s
> 
>     B) 1 RT prio 0 + 2 BE prio 4 reader
>         w/ dm-ioband
>         2147483648 bytes (2.1 GB) copied, 64.5634 seconds, 33.3 MB/s
>         2147483648 bytes (2.1 GB) copied, 220.372 seconds, 9.7 MB/s
>         2147483648 bytes (2.1 GB) copied, 222.174 seconds, 9.7 MB/s
>         w/o dm-ioband
>         2147483648 bytes (2.1 GB) copied, 62.3036 seconds, 34.5 MB/s
>         2147483648 bytes (2.1 GB) copied, 226.315 seconds, 9.5 MB/s
>         2147483648 bytes (2.1 GB) copied, 229.064 seconds, 9.4 MB/s
> 
>     C) 1 RT prio 0 + 3 BE prio 4 reader
>         w/ dm-ioband
>         2147483648 bytes (2.1 GB) copied, 66.7155 seconds, 32.2 MB/s
>         2147483648 bytes (2.1 GB) copied, 306.524 seconds, 7.0 MB/s
>         2147483648 bytes (2.1 GB) copied, 306.627 seconds, 7.0 MB/s
>         2147483648 bytes (2.1 GB) copied, 306.971 seconds, 7.0 MB/s
>         w/o dm-ioband
>         2147483648 bytes (2.1 GB) copied, 66.1144 seconds, 32.5 MB/s
>         2147483648 bytes (2.1 GB) copied, 305.5 seconds, 7.0 MB/s
>         2147483648 bytes (2.1 GB) copied, 306.469 seconds, 7.0 MB/s
>         2147483648 bytes (2.1 GB) copied, 307.63 seconds, 7.0 MB/s
> 
> The results show that the effect of the single queue is too small and
> dm-ioband doesn't break CFQ's classification and priority.
> What do you think about my results?

Hmm..., strange. We are getting different results.  May be it is some
configuration/setup issue.

How does your ioband setup looks like. Have you created at least one more
competing ioband device? Because I think only in that case you have got
this ad-hoc logic of waiting for the group which has not finished the
tokens yet and you will end up buffering the bio in a FIFO.

If you have not already done, can you just create two partitions on your
disk, say sda1 and sda2. Create two ioband devices with weights say 95
and 5 (95% of disk for first partition and 5% for other) and then run
the above test on first ioband device.

So how does this proportional weight thing works. If I have got two ioband
devices with weight 80 and 20 and if there is no IO happening on the
second device, first devices should get all the BW?

I will re-run my tests.

Secondly from technical point of view how do you explain the fact that
FIFO release of bio does not break the notion of CFQ priority? The moment
you buffered the bios in a single queue and started doing FIFO dispatch,
you lost that notion of one bio being more important than other.

That's a different thing that in practice it might not be easily visible.

Thanks
Vivek
