From: Vivek Goyal <vgoyal@redhat.com>
Subject: ioband: Limited fairness and weak isolation between
	groups (Was: Re: Regarding dm-ioband tests)
Date: Wed, 16 Sep 2009 00:45:01 -0400
Message-ID: <20090916044501.GB3736@redhat.com>
References: <20090901165011.GB3753@redhat.com>
	<20090904.130228.104054439.ryov@valinux.co.jp>
	<20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090907.200222.193693062.ryov@valinux.co.jp>
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
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Mon, Sep 07, 2009 at 08:02:22PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > > Thank you for testing dm-ioband. dm-ioband is designed to start
> > > throttling bandwidth when multiple IO requests are issued to devices
> > > simultaneously, IOW, to start throttling when IO load exceeds a
> > > certain level.
> > > 
> > 
> > What is that certain level? Secondly what's the advantage of this?
> > 
> > I can see disadvantages though. So unless a group is really busy "up to
> > that certain level" it will not get fairness? I breaks the isolation
> > between groups.
> 
> In your test case, at least more than one dd thread have to run
> simultaneously in the higher weight group. The reason is that
> if there is an IO group which does not issue a certain number of IO
> requests, dm-ioband assumes the IO group is inactive and assign its
> spare bandwidth to active IO groups. Then whole bandwidth of the
> device can be efficiently used. Please run two dd threads in the
> higher group, it will work as you expect.
> 
> However, if you want to get fairness in a case like this, a new
> bandwidth control policy which controls accurately according to
> assigned weights can be added to dm-ioband.
> 
> > I also ran your test of doing heavy IO in two groups. This time I am
> > running 4 dd threads in both the ioband devices. Following is the snapshot
> > of "dmsetup table" output.
> >
> > Fri Sep  4 17:45:27 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 0 0 0 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 0 0 0 0 0 0
> > 
> > Fri Sep  4 17:45:29 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 41 0 4184 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 173 0 20096 0 0 0
> > 
> > Fri Sep  4 17:45:37 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 1605 23 197976 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 4640 1 583168 0 0 0
> > 
> > Fri Sep  4 17:45:45 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 3650 47 453488 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 8572 1 1079144 0 0 0
> > 
> > Fri Sep  4 17:45:51 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 5111 68 635696 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 11587 1 1459544 0 0 0
> > 
> > Fri Sep  4 17:45:53 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 5698 73 709272 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 12503 1 1575112 0 0 0
> > 
> > Fri Sep  4 17:45:57 EDT 2009
> > ioband2: 0 40355280 ioband 1 -1 6790 87 845808 0 0 0
> > ioband1: 0 37768752 ioband 1 -1 14395 2 1813680 0 0 0
> > 
> > Note, it took me more than 20 seconds (since I started the threds) to
> > reach close to desired fairness level. That's too long a duration.
> 
> We regarded reducing throughput loss rather than reducing duration
> as the design of dm-ioband. Of course, it is possible to make a new
> policy which reduces duration.

Not anticipating on rotation media and letting other group do the dispatch
is not only bad for fairness of random readers but it seems to be bad for
overall throughput also. So letting other group dispatching thinking it
will boost throughput is not necessarily right on rotational media.

I ran following test. Created two groups of weight 100 each and put a 
sequential dd reader in first group and put buffered writers in second
group and let it run for 20 seconds and observed at the end of 20 seconds
which group got how much work done. I ran this test multiple time, while
increasing the number of writers by one each time. Did test this with
dm-ioband and with io scheduler based io controller patches.

With dm-ioband
==============
launched reader 3176
launched 1 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 159 0 1272 0 0 0
ioband1: 0 37768752 ioband 1 -1 13282 23 1673656 0 0 0
Total sectors transferred: 1674928

launched reader 3194
launched 2 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 138 0 1104 54538 54081 436304
ioband1: 0 37768752 ioband 1 -1 4247 1 535056 0 0 0
Total sectors transferred: 972464

launched reader 3203
launched 3 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 189 0 1512 44956 44572 359648
ioband1: 0 37768752 ioband 1 -1 3546 0 447128 0 0 0
Total sectors transferred: 808288

launched reader 3213
launched 4 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 83 0 664 55937 55810 447496
ioband1: 0 37768752 ioband 1 -1 2243 0 282624 0 0 0
Total sectors transferred: 730784

launched reader 3224
launched 5 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 179 0 1432 46544 46146 372352
ioband1: 0 37768752 ioband 1 -1 3348 0 422744 0 0 0
Total sectors transferred: 796528

launched reader 3236
launched 6 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 176 0 1408 44499 44115 355992
ioband1: 0 37768752 ioband 1 -1 3998 0 504504 0 0 0
Total sectors transferred: 861904

launched reader 3250
launched 7 writers
waiting for 20 seconds
ioband2: 0 40355280 ioband 1 -1 451 0 3608 42267 42115 338136
ioband1: 0 37768752 ioband 1 -1 2682 0 337976 0 0 0
Total sectors transferred: 679720

With io scheduler based io controller
=====================================
launched reader 3026
launched 1 writers
waiting for 20 seconds
test1 statistics: time=8:48 8657   sectors=8:48 886112 dq=8:48 0
test2 statistics: time=8:48 7685   sectors=8:48 473384 dq=8:48 4
Total sectors transferred: 1359496

launched reader 3064
launched 2 writers
waiting for 20 seconds
test1 statistics: time=8:48 7429   sectors=8:48 856664 dq=8:48 0
test2 statistics: time=8:48 7431   sectors=8:48 376528 dq=8:48 0
Total sectors transferred: 1233192

launched reader 3094
launched 3 writers
waiting for 20 seconds
test1 statistics: time=8:48 7279   sectors=8:48 832840 dq=8:48 0
test2 statistics: time=8:48 7302   sectors=8:48 372120 dq=8:48 0
Total sectors transferred: 1204960

launched reader 3122
launched 4 writers
waiting for 20 seconds
test1 statistics: time=8:48 7291   sectors=8:48 846024 dq=8:48 0
test2 statistics: time=8:48 7314   sectors=8:48 361280 dq=8:48 0
Total sectors transferred: 1207304

launched reader 3151
launched 5 writers
waiting for 20 seconds
test1 statistics: time=8:48 7077   sectors=8:48 815184 dq=8:48 0
test2 statistics: time=8:48 7090   sectors=8:48 398472 dq=8:48 0
Total sectors transferred: 1213656

launched reader 3179
launched 6 writers
waiting for 20 seconds
test1 statistics: time=8:48 7494   sectors=8:48 873304 dq=8:48 1
test2 statistics: time=8:48 7034   sectors=8:48 316312 dq=8:48 2
Total sectors transferred: 1189616

launched reader 3209
launched 7 writers
waiting for 20 seconds
test1 statistics: time=8:48 6809   sectors=8:48 795528 dq=8:48 0
test2 statistics: time=8:48 6850   sectors=8:48 380008 dq=8:48 1
Total sectors transferred: 1175536

Few things stand out.
====================
- With dm-ioband, as number of writers increased, in group 2, it gave
  BW to those writes over reads running in group 1. It had two bad
  effects. First of all read throughput went down secondly overall disk
  throughput also went down.

  So reader did not get fairness at the same time overall throughput went
  down. Hence probably it is not a very good idea to not anticipate and
  always let other groups dispatch on rotational media.

  In contrast, io scheduler based controller seems to be steady and reader
  doest not suffer as number of writers increase in the second group and
  overall disk throughput also remains stable.

Follwoing is the sample script I used for above test.

*******************************************************************
launch_writers() {
        nr_writers=$1
        for ((j=1;j<=$nr_writers;j++)); do
                dd if=/dev/zero of=/mnt/sdd2/writefile$j bs=4K &
        #       echo "launched writer $!"
        done
}

do_test () {
        nr_writers=$1
        sync
        echo 3 > /proc/sys/vm/drop_caches

        echo noop > /sys/block/sdd/queue/scheduler
        echo cfq > /sys/block/sdd/queue/scheduler

        dmsetup message ioband1 0 reset
        dmsetup message ioband2 0 reset

        #launch a sequential reader in sdd1
        dd if=/mnt/sdd1/4G-file of=/dev/null &
        echo "launched reader $!"

        launch_writers $nr_writers
        echo "launched $nr_writers writers"
        echo "waiting for 20 seconds"
        sleep 20
        dmsetup status
        killall dd > /dev/null 2>&1
}

for ((i=1;i<8;i++)); do
        do_test $i
        echo
done

*********************************************************************
