From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Wed, 15 Apr 2009 12:17:00 -0400
Message-ID: <20090415161700.GC15067@redhat.com>
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

Ok, one more round of testing. Little different though this time. This
time instead of progressively increasing the number of competing readers
I have run with constant number of readers multimple times.

Again, I created two partitions /dev/sdd1 and /dev/sdd2 and created two
ioband devices and assigned weight 40 and 10 respectively. All my IO
is being done only on first ioband device and there is no IO happening
on second partition.

I use following to create ioband devices.

echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 none"
"weight 0 :40" | dmsetup create ioband1
echo "0 $(blockdev --getsize /dev/sdd2) ioband /dev/sdd2 1 0 0 none"
"weight 0 :10" | dmsetup create ioband2

mount /dev/mapper/ioband1 /mnt/sdd1
mount /dev/mapper/ioband2 /mnt/sdd2

Following is dmsetup output.

# dmsetup status
ioband2: 0 38025855 ioband 1 -1 150 13 186 1 0 8
ioband1: 0 40098177 ioband 1 -1 335056 819 80342386 1 0 8

Following is my actual script to run multiple reads.

sync
echo 3 > /proc/sys/vm/drop_caches
ionice -c 1 -n 0 dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
ionice -c 2 -n 4 dd if=/mnt/sdd1/testzerofile2 of=/dev/null &
ionice -c 2 -n 4 dd if=/mnt/sdd1/testzerofile3 of=/dev/null &
ionice -c 2 -n 4 dd if=/mnt/sdd1/testzerofile4 of=/dev/null &
ionice -c 2 -n 4 dd if=/mnt/sdd1/testzerofile5 of=/dev/null &

Following is output of 4 runs of reads with and without dm-ioband

1 RT process prio 0 and 4 BE process with prio 4.

First run
----------
without dm-ioband

2147483648 bytes (2.1 GB) copied, 35.3428 s, 60.8 MB/s
2147483648 bytes (2.1 GB) copied, 215.446 s, 10.0 MB/s
2147483648 bytes (2.1 GB) copied, 218.269 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 219.433 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 220.033 s, 9.8 MB/s

with dm-ioband

2147483648 bytes (2.1 GB) copied, 48.4239 s, 44.3 MB/s
2147483648 bytes (2.1 GB) copied, 257.943 s, 8.3 MB/s
2147483648 bytes (2.1 GB) copied, 258.385 s, 8.3 MB/s
2147483648 bytes (2.1 GB) copied, 258.778 s, 8.3 MB/s
2147483648 bytes (2.1 GB) copied, 259.81 s, 8.3 MB/s

Second run
----------
without dm-ioband
2147483648 bytes (2.1 GB) copied, 35.4003 s, 60.7 MB/s
2147483648 bytes (2.1 GB) copied, 217.204 s, 9.9 MB/s
2147483648 bytes (2.1 GB) copied, 218.336 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 219.75 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 219.816 s, 9.8 MB/s

with dm-ioband
2147483648 bytes (2.1 GB) copied, 49.7719 s, 43.1 MB/s
2147483648 bytes (2.1 GB) copied, 254.118 s, 8.5 MB/s
2147483648 bytes (2.1 GB) copied, 255.7 s, 8.4 MB/s
2147483648 bytes (2.1 GB) copied, 256.512 s, 8.4 MB/s
2147483648 bytes (2.1 GB) copied, 256.581 s, 8.4 MB/s

third run
---------
without dm-ioband
2147483648 bytes (2.1 GB) copied, 35.426 s, 60.6 MB/s
2147483648 bytes (2.1 GB) copied, 218.4 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 221.074 s, 9.7 MB/s
2147483648 bytes (2.1 GB) copied, 222.421 s, 9.7 MB/s
2147483648 bytes (2.1 GB) copied, 222.489 s, 9.7 MB/s

with dm-ioband
2147483648 bytes (2.1 GB) copied, 51.5454 s, 41.7 MB/s
2147483648 bytes (2.1 GB) copied, 261.481 s, 8.2 MB/s
2147483648 bytes (2.1 GB) copied, 261.567 s, 8.2 MB/s
2147483648 bytes (2.1 GB) copied, 263.048 s, 8.2 MB/s
2147483648 bytes (2.1 GB) copied, 264.204 s, 8.1 MB/s

fourth run
----------
without dm-ioband
2147483648 bytes (2.1 GB) copied, 35.4676 s, 60.5 MB/s
2147483648 bytes (2.1 GB) copied, 217.752 s, 9.9 MB/s
2147483648 bytes (2.1 GB) copied, 219.693 s, 9.8 MB/s
2147483648 bytes (2.1 GB) copied, 221.921 s, 9.7 MB/s
2147483648 bytes (2.1 GB) copied, 222.18 s, 9.7 MB/s

with dm-ioband
2147483648 bytes (2.1 GB) copied, 46.1355 s, 46.5 MB/s
2147483648 bytes (2.1 GB) copied, 253.84 s, 8.5 MB/s
2147483648 bytes (2.1 GB) copied, 256.282 s, 8.4 MB/s
2147483648 bytes (2.1 GB) copied, 256.356 s, 8.4 MB/s
2147483648 bytes (2.1 GB) copied, 256.679 s, 8.4 MB/s


Do let me know if you think there is something wrong with my
configuration.

First of all I still notice that there is significant performance drop
here.

Secondly notice that finish time of RT task is varying so much with 
dm-ioband and it is so stable with plain cfq.

with dm-ioabnd		48.4239  49.7719   51.5454   46.1355  
without dm-ioband	35.3428  35.4003   35.426    35.4676  		

Thanks
Vivek
