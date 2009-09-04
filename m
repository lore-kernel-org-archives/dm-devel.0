From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Fri, 4 Sep 2009 19:11:29 -0400
Message-ID: <20090904231129.GA3689@redhat.com>
References: <20090901165011.GB3753@redhat.com>
	<20090904.130228.104054439.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090904.130228.104054439.ryov@valinux.co.jp>
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
Cc: Rik Van Riel <riel@redhat.com>, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Moyer Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, Morton Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On Fri, Sep 04, 2009 at 01:02:28PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 

> Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Ryo,
> > 
> > I decided to play a bit more with dm-ioband and started doing some
> > testing. I am doing a simple two dd threads doing reads and don't seem
> > to be gettting the fairness. So thought will ask you what's the issue
> > here. Is there an issue with my testing procedure.

[ CCing relevant folks on thread as what does fairness mean is becoming
  interesting]

> 
> Thank you for testing dm-ioband. dm-ioband is designed to start
> throttling bandwidth when multiple IO requests are issued to devices
> simultaneously, IOW, to start throttling when IO load exceeds a
> certain level.
> 

What is that certain level? Secondly what's the advantage of this?

I can see disadvantages though. So unless a group is really busy "up to
that certain level" it will not get fairness? I breaks the isolation
between groups.

> Here is my test script that runs multiple dd threads on each
> directory. Each directory stores 20 files of 2GB.
> 
>     #!/bin/sh
>     tmout=60
> 
>     for nr_threads in 1 4 8 12 16 20; do
>             sync; echo 3 > /proc/sys/vm/drop_caches
> 
>             for i in $(seq $nr_threads); do
>                     dd if=/mnt1/ioband1.${i}.0 of=/dev/null &
>                     dd if=/mnt2/ioband2.${i}.0 of=/dev/null &
>             done
>             iostat -k 1 $tmout > ${nr_threads}.log
>             killall -ws TERM dd
>     done
>     exit 0
> 
> Here is the result. The average throughputs of each device are
> according to the proportion of the weight settings when the number of
> thread is over four.
> 
>               Average thoughput in 60 seconds [KB/s]
> 
>               ioband1           ioband2
>   threads    weight 200        weight 100       total
>         1   26642 (54.9%)     21925 (45.1%)     48568
>         4   33974 (67.7%)     16181 (32.3%)     50156
>         8   31952 (66.2%)     16297 (33.8%)     48249
>        12   32062 (67.8%)     15236 (32.2%)     47299
>        16   31780 (67.7%)     15165 (32.3%)     46946
>        20   29955 (66.3%)     15239 (33.7%)     45195
> 
> Please try to run the above script on your envirionment and I would be
> glad if you let me know the result.

I ran my simple dd test again with two ioband deviecs of weight 200
(ioband1) and 100 (ioband2)respectively. I launched four sequential dd
readers on ioband2 and and one sequential reader in ioband1.

Now if we are providing isolation between groups then ioband1 should get
double the bandwidth of ioband1. But that does not happen. Following is
the output of "dmsetup table" command.

Fri Sep  4 18:02:01 EDT 2009
ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0

Fri Sep  4 18:02:08 EDT 2009
ioband2: 0 40355280 ioband 1 -1 2031 32 250280 0 0 0
ioband1: 0 37768752 ioband 1 -1 1484 0 186544 0 0 0

Fri Sep  4 18:02:12 EDT 2009
ioband2: 0 40355280 ioband 1 -1 3541 64 437192 0 0 0
ioband1: 0 37768752 ioband 1 -1 2802 0 352728 0 0 0

Fri Sep  4 18:02:16 EDT 2009
ioband2: 0 40355280 ioband 1 -1 5200 87 644144 0 0 0
ioband1: 0 37768752 ioband 1 -1 4003 0 504296 0 0 0

Fri Sep  4 18:02:20 EDT 2009
ioband2: 0 40355280 ioband 1 -1 7632 111 948232 0 0 0
ioband1: 0 37768752 ioband 1 -1 4494 0 566080 0 0 0

This seems to be breaking the isolation between two groups. Now if there
is one bad group with lots of readers and writers of lower weight, it will
overwhelm a group of higher weight with 1-2 readers running or some random
readers running etc.

If there are lots of readers running in a group and then a small file
reader comes in a different group of higher prio, it will not get any
fairness and latency of file read will be very high. But one would expect
that groups will provide isolation and latency of small file reader will
not increase with number of readers in a low prio group.

I also ran your test of doing heavy IO in two groups. This time I am
running 4 dd threads in both the ioband devices. Following is the snapshot
of "dmsetup table" output.

Fri Sep  4 17:45:27 EDT 2009
ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0

Fri Sep  4 17:45:29 EDT 2009
ioband2: 0 40355280 ioband 1 -1 41 0 4184 0 0 0
ioband1: 0 37768752 ioband 1 -1 173 0 20096 0 0 0

Fri Sep  4 17:45:37 EDT 2009
ioband2: 0 40355280 ioband 1 -1 1605 23 197976 0 0 0
ioband1: 0 37768752 ioband 1 -1 4640 1 583168 0 0 0

Fri Sep  4 17:45:45 EDT 2009
ioband2: 0 40355280 ioband 1 -1 3650 47 453488 0 0 0
ioband1: 0 37768752 ioband 1 -1 8572 1 1079144 0 0 0

Fri Sep  4 17:45:51 EDT 2009
ioband2: 0 40355280 ioband 1 -1 5111 68 635696 0 0 0
ioband1: 0 37768752 ioband 1 -1 11587 1 1459544 0 0 0

Fri Sep  4 17:45:53 EDT 2009
ioband2: 0 40355280 ioband 1 -1 5698 73 709272 0 0 0
ioband1: 0 37768752 ioband 1 -1 12503 1 1575112 0 0 0

Fri Sep  4 17:45:57 EDT 2009
ioband2: 0 40355280 ioband 1 -1 6790 87 845808 0 0 0
ioband1: 0 37768752 ioband 1 -1 14395 2 1813680 0 0 0

Note, it took me more than 20 seconds (since I started the threds) to
reach close to desired fairness level. That's too long a duration. Again
random readers or small file readers are compeltely out of picture for
any kind of fairness or are not protected at all with dm-ioband
controller.

I think there are serious issues with the notion of fairness and what kind of
isolation dm-ioband provide between groups and it should be looked into.

Thanks
Vivek
