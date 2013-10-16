From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: A review of dm-writeboost
Date: Wed, 16 Oct 2013 19:34:38 +0900
Message-ID: <525E6BBE.40004@gmail.com>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
 <52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
 <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
 <20131016060750.GE4446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20131016060750.GE4446@dastard>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: david@fromorbit.com
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com
List-Id: dm-devel.ids

Dave

> Akira, can you please post the entire set of messages you are
> getting when XFS showing problems? That way I can try to confirm
> whether it's a regression in XFS or something else.

Environment:
- The kernel version is 3.12-rc1
- The debuggee is a KVM virtual machine equipped with 8 vcpus.
- writeboost version is commit 236732eb84684e8473353812acb3302232e1eab0
  You can clone it from https://github.com/akiradeveloper/dm-writeboost

Test:
1. Make a writeboost device with 3MB cache device and 3GB backing store
   with default option (segment size order is 7 and RAM buffer is 2MB allocated).
2. start testing/1 script (compiling Ruby and make test after it)
3. set blockup variable to 1 via message interface few seconds later.
   The writeboost device starts to return -EIO on all incoming requests.
   I guess this behavior causes the problem.

In some case, XFS doesn't collapse after setting blockup to 1.
When I set the variable to 1 about 10 or 20 seconds later,
it didn't collapse but neatly stops the compile and
after again I set it to 0, it restarts the compile.
XFS does collapse (badly shutting down the filesystem as seen below) in some case
but doesn't collapse in another case sounds to me that
the former case runs into a very corner case bug.

The entire set of messages via virsh console is shown below.
Some lines related to writeboost are all benign.
The daemons are just stopping because blockup variable is 1.

[  146.284626] XFS (dm-3): metadata I/O error: block 0x300d91 ("xlog_iodone") error 5 numblks 64
[  146.285825] XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
[  146.286699] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
[  146.560036] device-mapper: writeboost: err@modulator_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[  147.244036] device-mapper: writeboost: err@migrate_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[  172.052006] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
[  172.436003] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]
[  180.560040] device-mapper: writeboost: err@recorder_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[  180.561179] device-mapper: writeboost: err@sync_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[  200.052005] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
[  200.436005] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]
[  206.484005] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies g=1797 c=1796 q=3022)
[  232.052007] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
[  232.436003] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]
[  260.052006] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
[  260.436004] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]
[  288.052006] BUG: soft lockup - CPU#0 stuck for 23s! [script:3170]
[  288.436004] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:1:57]

Akira
