From: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
Subject: [PATCH] dm-snapshot: poor copy-on-write performance due
	to I/O reordering
Date: Wed, 17 Sep 2008 17:03:19 +0900
Message-ID: <48D0B9C7.6010206@oss.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: kjamieson@bycast.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Write throughput to LVM snapshot origin volume is an order
of magnitude slower than those to LV without snapshots or
snapshot target volumes, especially in the case of sequential
writes with O_SYNC on.

The following patch originally written by Kevin Jamieson and
Jan Blunck and slightly modified for the current RCs by myself
tries to improve the performance by modifying the behaviour
of kcopyd, so that it pushes back an I/O job to the head of
the job queue instead of the tail as process_jobs() currently
does when it has to wait for free pages. This way, write
requests aren't shuffled to cause extra seeks.

I tested the patch against 2.6.27-rc5 and got the following results.
The test is a dd command writing to snapshot origin followed by fsync
to the file just created/updated.  A couple of filesystem benchmarks
gave me similar results in case of sequential writes, while random
writes didn't suffer much.

dd if=/dev/zero of=<somewhere on snapshot origin> bs=4096 count=...
   [conv=notrunc when updating]

1) linux 2.6.27-rc5 without the patch, write to snapshot origin,
average throughput (MB/s)
                     10M     100M    1000M
create,dd         511.46   610.72    11.81
create,dd+fsync     7.10     6.77     8.13
update,dd         431.63   917.41    12.75
update,dd+fsync     7.79     7.43     8.12

compared with write throughput to LV without any snapshots,
all dd+fsync and 1000 MiB writes perform very poorly.

                     10M     100M    1000M
create,dd         555.03   608.98   123.29
create,dd+fsync   114.27    72.78    76.65
update,dd         152.34  1267.27   124.04
update,dd+fsync   130.56    77.81    77.84


2) linux 2.6.27-rc5 with the patch, write to snapshot origin,
average throughput (MB/s)

                     10M     100M    1000M
create,dd         537.06   589.44    46.21
create,dd+fsync    31.63    29.19    29.23
update,dd         487.59   897.65    37.76
update,dd+fsync    34.12    30.07    26.85

Although still not on par with plain LV performance -
cannot be avoided because it's copy on write anyway -
this simple patch successfully improves throughtput
of dd+fsync while not affecting the rest.

Here's the original message:
> Date: Wed, 30 May 2007 15:56:42 -0700
> From: Kevin Jamieson <kjamieson@bycast.com>
> Subject: snapshot: kcopyd performance
>
> Hi,
>
> I've been investigating some performance issues with writes to a LVM2
> snapshot origin volume being much slower than one would expect (i.e.,
> 10-50x slower for a logical volume with a single snapshot volume).
>
> Using a simple dd test (I get similar numbers with other tools like
> bonnie) on a P4 3GHz w/SATA disks (no RAID):
>
> dd if=/dev/zero of=/vol/file bs=1M count=1000
>
> Logical volume w/o snapshot: 45.4 MB/s
> LV w/snapshot on same disk, chunksize=8K: 1.1 MB/s
> LV w/snapshot on same disk, chunksize=512K: 4.0 MB/s
> LV w/snapshot on separate disk, chunksize=8K: 1.2 MB/s
> LV w/snapshot on separate disk, chunksize=512K: 5.6 MB/s
>
> I tracked the main cause of the poor performance to the behaviour of
> process_jobs() in kcopyd. If kcopyd's page pool has no free pages, it
> moves the next job in the _pages_jobs list to the tail of the list.
> New jobs are also added to the tail of the _pages_jobs list (in
> dispatch_job()). This re-ordering of the I/Os results in a lot of extra
> seek activity for workloads consisting of sequential writes.
>
> The below patch modifies process_jobs() to push the job back to the head
> of the list instead of the tail when there are no free pages. I see
> significantly improved performance with this change:
>
> LV w/snapshot on same disk, chunksize=8K: 9.6 MB/s
> LV w/snapshot on same disk, chunksize=512K: 8.4 MB/s
> LV w/snapshot on separate disk, chunksize=8K: 17.2 MB/s
> LV w/snapshot on separate disk, chunksize=512K: 14.5 MB/s
>
> Thanks,
> Kevin
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Regards,

Kazuo Ito, NTT Open Source Software Center
Phone: +81-3-5860-5125 / FAX: +81-3-5463-5690 / E-mail: ito.kazuo@oss.ntt.co.jp

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
---
 drivers/md/dm-kcopyd.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 996802b..8f15353 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -268,6 +268,17 @@ static void push(struct list_head *jobs, struct kcopyd_job *job)
 	spin_unlock_irqrestore(&kc->job_lock, flags);
 }

+
+static void push_head(struct list_head *jobs, struct kcopyd_job *job)
+{
+	unsigned long flags;
+	struct dm_kcopyd_client *kc = job->kc;
+
+	spin_lock_irqsave(&kc->job_lock, flags);
+	list_add(&job->list, jobs);
+	spin_unlock_irqrestore(&kc->job_lock, flags);
+}
+
 /*
  * These three functions process 1 item from the corresponding
  * job list.
@@ -398,7 +409,7 @@ static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
 			 * We couldn't service this job ATM, so
 			 * push this job back onto the list.
 			 */
-			push(jobs, job);
+			push_head(jobs, job);
 			break;
 		}
