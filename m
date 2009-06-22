From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Mon, 22 Jun 2009 11:30:31 -0400
Message-ID: <20090622153030.GA15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<20090621152116.GC3728@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090621152116.GC3728@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
> 
> > 
> > Hi All,
> > 
> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
> [snip]
> 
> > Testing
> > =======
> >
> 
> [snip]
> 
> I've not been reading through the discussions in complete detail, but
> I see no reference to async reads or aio. In the case of aio, aio
> presumes the context of the user space process. Could you elaborate on
> any testing you've done with these cases? 
> 

Hi Balbir,

So far I had not done any testing with AIO. I have done some just now.
Here are the results.

Test1 (AIO reads)
================
Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
respectively. I am using cfq scheduler. Following are some lines from my test
script.

===================================================================
fio_args="--ioengine=libaio --rw=read --size=512M"

echo 1 > /sys/block/$BLOCKDEV/queue/iosched/fairness

fio $fio_args --name=test1 --directory=/mnt/$BLOCKDEV/fio1/ --output=/mnt/$BLOCKDEV/fio1/test1.log --exec_postrun="../read-and-display-group-stats.sh $maj_dev $minor_dev" &

fio $fio_args --name=test2 --directory=/mnt/$BLOCKDEV/fio2/ --output=/mnt/$BLOCKDEV/fio2/test2.log &
===================================================================

test1 and test2 are two groups with weight 1000 and 500 respectively.
"read-and-display-group-stats.sh" is one small script which reads the
test1 and test2 cgroup files to determine how much disk time each group
got till first fio job finished.

Following are the results.

test1 statistics: time=8 16 5598   sectors=8 16 1049648 
test2 statistics: time=8 16 2908   sectors=8 16 508560

Above shows that by the time first fio (higher weight), finished, group
test1 got 5598 ms of disk time and group test2 got 2908 ms of disk time.
similarly the statistics for number of sectors transferred are also shown.

Note that disk time given to group test1 is almost double of group2 disk
time.


Test2 (AIO Wries (direct))
==========================
Set up two fio, AIO direct write jobs in two cgroup with weight 1000 and 500
respectively. I am using cfq scheduler. Following are some lines from my test
script.

===================================================================
fio_args="--ioengine=libaio --rw=write --size=512M --direct=1"

echo 1 > /sys/block/$BLOCKDEV/queue/iosched/fairness

fio $fio_args --name=test1 --directory=/mnt/$BLOCKDEV/fio1/ --output=/mnt/$BLOCKDEV/fio1/test1.log --exec_postrun="../read-and-display-group-stats.sh $maj_dev $minor_dev" &

fio $fio_args --name=test2 --directory=/mnt/$BLOCKDEV/fio2/ --output=/mnt/$BLOCKDEV/fio2/test2.log &
===================================================================

test1 and test2 are two groups with weight 1000 and 500 respectively.
"read-and-display-group-stats.sh" is one small script which reads the
test1 and test2 cgroup files to determine how much disk time each group
got till first fio job finished.

Following are the results.

test1 statistics: time=8 16 28029   sectors=8 16 1049656
test2 statistics: time=8 16 14093   sectors=8 16 512600

Above shows that by the time first fio (higher weight), finished, group
test1 got 28029 ms of disk time and group test2 got 14093 ms of disk time.
similarly the statistics for number of sectors transferred are also shown.

Note that disk time given to group test1 is almost double of group2 disk
time.

Thanks
Vivek
