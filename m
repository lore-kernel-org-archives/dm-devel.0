From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 1 Sep 2009 13:47:24 -0400
Message-ID: <20090901174724.GC3753@redhat.com>
References: <20090901165011.GB3753@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090901165011.GB3753@redhat.com>
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
Cc: dm-devel@redhat.com, linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Sep 01, 2009 at 12:50:11PM -0400, Vivek Goyal wrote:
> Hi Ryo,
> 
> I decided to play a bit more with dm-ioband and started doing some
> testing. I am doing a simple two dd threads doing reads and don't seem
> to be gettting the fairness. So thought will ask you what's the issue
> here. Is there an issue with my testing procedure.
> 
> I got one 40G SATA drive (no hardware queuing). I have created two
> partitions on that disk /dev/sdd1 and /dev/sdd2 and created two ioband
> devices ioband1 and ioband2 on partitions sdd1 and sdd2 respectively. The
> weights of ioband1 and ioband2 devices are 200 and 100 respectively. 
> 
> I am assuming that this setup will create two default groups and IO
> going to partition sdd1 should get double the BW of partition sdd2.
> 
> But it looks like I am not gettting that behavior. Following is the output
> of "dmsetup table" command. This snapshot has been taken every 2 seconds
> while IO was going on. Column 9 seems to be containing how many sectors
> of IO has been done on a particular io band device and group. Looking at
> the snapshot, it does not look like that ioband1 default group got double
> the BW of ioband2 default group.  
> 
> Am I doing something wrong here?
> 

I tried another variant of test. This time I also created two additional
groups on ioband1 devices and linked these to cgroups test1 and test2 and
launched two dd threads in two cgroups on device ioband1. There also I
don't seem to be getting the right fairness numbers for cgroup test1 and
test2.

Script to create ioband devices and additional groups
-----------------------------------------------------
echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 none"
"weight 0 :200" | dmsetup create ioband1
echo "0 $(blockdev --getsize /dev/sdd2) ioband /dev/sdd2 1 0 0 none"
"weight 0 :100" | dmsetup create ioband2

# Some code to mount and create cgroups.
# Read group id
test1_id=`cat /cgroup/ioband/test1/blkio.id`
test2_id=`cat /cgroup/ioband/test2/blkio.id`

test1_weight=200
test2_weight=100

dmsetup message ioband1 0 type cgroup 
dmsetup message ioband1 0 attach $test1_id
dmsetup message ioband1 0 attach $test2_id
dmsetup message ioband1 0 weight $test1_id:$test1_weight
dmsetup message ioband1 0 weight $test2_id:$test2_weight

mount /dev/mapper/ioband1 /mnt/sdd1
mount /dev/mapper/ioband2 /mnt/sdd2
-----------------------------------------------------------------

Following are two dd jobs
-------------------------
dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
echo $! > /cgroup/ioband/test1/tasks

dd if=/mnt/sdd1/testzerofile2 of=/dev/null &
echo $! > /cgroup/ioband/test2/tasks


Following are "dmsetup status" results every 2 seconds
======================================================

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 0 0 0 0 0 0 3 0 0 0 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 0 0 0 0 0 0 3 0 0 0 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 689 0 86336 0 0 0 3 650 3
81472 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 1725 0 217024 0 0 0 3 1270
11 158912 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 2690 0 338744 0 0 0 3 1978
15 247856 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 3762 0 474040 0 0 0 3 2583
21 323736 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 4745 0 598064 0 0 0 3 3275
27 410392 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 5737 0 723120 0 0 0 3 3985
31 499592 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 6815 0 859184 0 0 0 3 4594
37 575864 0 0 0

ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0 2 7823 0 986288 0 0 0 3 5276
43 661360 0 0 0

"dmsetup table" output
======================
ioband2: 0 40355280 ioband 8:50 1 4 192 none weight 768 :100
ioband1: 0 37768752 ioband 8:49 1 4 192 cgroup weight 768 :200 2:200 3:100

Because I am using "weight" policy, I thought that test1 cgroup with id
"2" will issue double the number of requests of cgroup test2 with id "3".
But that does not seem to be happening here. Is there an issue with my
testing method.

Thanks
Vivek
 
> ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
> ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 96 0 11528 0 0 0
> ioband1: 0 37768752 ioband 1 -1 82 0 9736 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 748 2 93032 0 0 0
> ioband1: 0 37768752 ioband 1 -1 896 0 112232 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 1326 5 165816 0 0 0
> ioband1: 0 37768752 ioband 1 -1 1816 0 228312 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 1943 6 243712 0 0 0
> ioband1: 0 37768752 ioband 1 -1 2692 0 338760 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 2461 10 308576 0 0 0
> ioband1: 0 37768752 ioband 1 -1 3618 0 455608 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 3118 11 391352 0 0 0
> ioband1: 0 37768752 ioband 1 -1 4406 0 555032 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 3734 15 468760 0 0 0
> ioband1: 0 37768752 ioband 1 -1 5273 0 664328 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 4307 17 540784 0 0 0
> ioband1: 0 37768752 ioband 1 -1 6181 0 778992 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 4930 19 619208 0 0 0
> ioband1: 0 37768752 ioband 1 -1 7028 0 885728 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 5599 22 703280 0 0 0
> ioband1: 0 37768752 ioband 1 -1 7815 0 985024 0 0 0
> 
> ioband2: 0 40355280 ioband 1 -1 6586 27 827456 0 0 0
> ioband1: 0 37768752 ioband 1 -1 8327 0 1049624 0 0 0
> 
> Following are details of my test setup.
> ---------------------------------------
> I took dm-ioband patch version 1.12.3 and applied on 2.6.31-rc6.
> 
> Created ioband devices using following command.
> ----------------------------------------------
> echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 none"
> "weight 0 :200" | dmsetup create ioband1
> echo "0 $(blockdev --getsize /dev/sdd2) ioband /dev/sdd2 1 0 0 none"
> "weight 0 :100" | dmsetup create ioband2
> 
> mount /dev/mapper/ioband1 /mnt/sdd1
> mount /dev/mapper/ioband2 /mnt/sdd2
> 
> Started two dd threads
> ======================
> dd if=/mnt/sdd1/testzerofile1 of=/dev/null &
> dd if=/mnt/sdd2/testzerofile1 of=/dev/null &
> 
> Output of dmsetup table command
> ================================
> ioband2: 0 40355280 ioband 8:50 1 4 192 none weight 768 :100
> ioband1: 0 37768752 ioband 8:49 1 4 192 none weight 768 :200
> 
> Thanks
> Vivek
