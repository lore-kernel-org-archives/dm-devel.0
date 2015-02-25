From: Mike Snitzer <snitzer@redhat.com>
Subject: FIXED! [was: awful request merge results while
 simulating high IOPS] multipath
Date: Tue, 24 Feb 2015 23:38:08 -0500
Message-ID: <20150225043808.GA14060@redhat.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
	<54ECAC08.7040603@kernel.dk> <20150224172259.GA39226@redhat.com>
	<54ECBA78.6020204@kernel.dk> <20150224181257.GA11444@redhat.com>
	<54ECC000.40604@kernel.dk> <20150224183256.GA11566@redhat.com>
	<20150225005608.GA13348@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150225005608.GA13348@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, jmoyer@redhat.com, shivakrishna.merla@netapp.com, dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

New multipath results using these 2 additional DM patches:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d379ecbac533d3ac45c7f155b1fc1b760abace6e
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d379ecbac533d3ac45c7f155b1fc1b760abace6e

(the important one being the last patch, thanks to Jens for the suggestion!)

Both deadline and noop schedulers work really well this fio test now
(cfq is slightly slower):

[64_seq_write]
#filename=/dev/mapper/skd_mpath
filename=/dev/dm-7
rw=write
rwmixread=0
blocksize=4k
iodepth=16
direct=1
numjobs=64
runtime=100
ioengine=libaio
time_based

deadline:
---------
Run status group 0 (all jobs):
  WRITE: io=64402MB, aggrb=659426KB/s, minb=8960KB/s, maxb=10348KB/s, mint=100001msec, maxt=100007msec

Disk stats (read/write):
    dm-7: ios=78/951571, merge=0/14721874, ticks=1/6766375, in_queue=6868921, util=100.00%, aggrios=257/951897, aggrmerge=0/0, aggrticks=3/3467932, aggrin_queue=3467835, aggrutil=99.09%
  skd0: ios=257/951897, merge=0/0, ticks=3/3467932, in_queue=3467835, util=99.09%

(deadline is _really_ fast with this test now, noop is fast too, see below)

cfq:
----
rotational=0
------------
Run status group 0 (all jobs):
  WRITE: io=18719MB, aggrb=191652KB/s, minb=2639KB/s, maxb=4210KB/s, mint=100001msec, maxt=100018msec

Disk stats (read/write):
    dm-7: ios=91/368755, merge=0/4407385, ticks=2/6783504, in_queue=6815287, util=100.00%, aggrios=273/368851, aggrmerge=0/0, aggrticks=5/2962495, aggrin_queue=2962487, aggrutil=95.40%
  skd0: ios=273/368851, merge=0/0, ticks=5/2962495, in_queue=2962487, util=95.40%

rotational=1
------------
Run status group 0 (all jobs):
  WRITE: io=19660MB, aggrb=200940KB/s, minb=2304KB/s, maxb=6441KB/s, mint=100001msec, maxt=100188msec

Disk stats (read/write):
    dm-7: ios=91/786111, merge=0/4179472, ticks=2/5820606, in_queue=5834058, util=99.98%, aggrios=182/786507, aggrmerge=0/0, aggrticks=4/131800, aggrin_queue=131758, aggrutil=70.55%
  skd0: ios=182/786507, merge=0/0, ticks=4/131800, in_queue=131758, util=70.55%

noop:
-----
Run status group 0 (all jobs):
  WRITE: io=58264MB, aggrb=596517KB/s, minb=9301KB/s, maxb=9354KB/s, mint=100001msec, maxt=100018msec

Disk stats (read/write):
    dm-7: ios=116/998937, merge=0/13874486, ticks=4/6853397, in_queue=6934793, util=100.00%, aggrios=295/999061, aggrmerge=0/0, aggrticks=8/3776141, aggrin_queue=3776117, aggrutil=98.81%
  skd0: ios=295/999061, merge=0/0, ticks=8/3776141, in_queue=3776117, util=98.81%
