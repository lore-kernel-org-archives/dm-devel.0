From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH v2] dm kcopyd: Increase default sub-job size to
	512KB
Date: Wed, 17 Jul 2019 14:24:10 +0300
Message-ID: <20190717112410.3017-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: ntsironis@arrikto.com
List-Id: dm-devel.ids

Currently, kcopyd has a sub-job size of 64KB and a maximum number of 8
sub-jobs. As a result, for any kcopyd job, we have a maximum of 512KB of
I/O in flight.

This upper limit to the amount of in-flight I/O under-utilizes fast
devices and results in decreased throughput, e.g., when writing to a
snapshotted thin LV with I/O size less than the pool's block size (so
COW is performed using kcopyd).

Increase kcopyd's default sub-job size to 512KB, so we have a maximum of
4MB of I/O in flight for each kcopyd job. This results in an up to 96%
improvement of bandwidth when writing to a snapshotted thin LV, with I/O
sizes less than the pool's block size.

Also, add dm_mod.kcopyd_subjob_size_kb module parameter to allow users
to fine tune the sub-job size of kcopyd. The default value of this
parameter is 512KB and the maximum allowed value is 1024KB.

We evaluate the performance impact of the change by running the
snap_breaking_throughput benchmark, from the device mapper test suite
[1].

The benchmark:

  1. Creates a 1G thin LV
  2. Provisions the thin LV
  3. Takes a snapshot of the thin LV
  4. Writes to the thin LV with:

      dd if=/dev/zero of=/dev/vg/thin_lv oflag=direct bs=<I/O size>

Running this benchmark with various thin pool block sizes and dd I/O
sizes (all combinations triggering the use of kcopyd) we get the
following results:

+-----------------+-------------+------------------+-----------------+
| Pool block size | dd I/O size | BW before (MB/s) | BW after (MB/s) |
+-----------------+-------------+------------------+-----------------+
|       1 MB      |      256 KB |       242        |       280       |
|       1 MB      |      512 KB |       238        |       295       |
|                 |             |                  |                 |
|       2 MB      |      256 KB |       238        |       354       |
|       2 MB      |      512 KB |       241        |       380       |
|       2 MB      |        1 MB |       245        |       394       |
|                 |             |                  |                 |
|       4 MB      |      256 KB |       248        |       412       |
|       4 MB      |      512 KB |       234        |       432       |
|       4 MB      |        1 MB |       251        |       474       |
|       4 MB      |        2 MB |       257        |       504       |
|                 |             |                  |                 |
|       8 MB      |      256 KB |       239        |       420       |
|       8 MB      |      512 KB |       256        |       431       |
|       8 MB      |        1 MB |       264        |       467       |
|       8 MB      |        2 MB |       264        |       502       |
|       8 MB      |        4 MB |       281        |       537       |
+-----------------+-------------+------------------+-----------------+

[1] https://github.com/jthornber/device-mapper-test-suite

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-kcopyd.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

Changes in v2:
  - Add dm_mod.kcopyd_subjob_size_kb module parameter

v1: https://www.redhat.com/archives/dm-devel/2019-June/msg00003.html

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 671c24332802..df2011de7be2 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -28,10 +28,27 @@
 
 #include "dm-core.h"
 
-#define SUB_JOB_SIZE	128
 #define SPLIT_COUNT	8
 #define MIN_JOBS	8
-#define RESERVE_PAGES	(DIV_ROUND_UP(SUB_JOB_SIZE << SECTOR_SHIFT, PAGE_SIZE))
+
+#define DEFAULT_SUB_JOB_SIZE_KB 512
+#define MAX_SUB_JOB_SIZE_KB     1024
+
+static unsigned kcopyd_subjob_size_kb = DEFAULT_SUB_JOB_SIZE_KB;
+
+module_param(kcopyd_subjob_size_kb, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(kcopyd_subjob_size_kb, "Sub-job size for dm-kcopyd clients");
+
+static unsigned dm_get_kcopyd_subjob_size(void)
+{
+	unsigned sub_job_size_kb;
+
+	sub_job_size_kb = __dm_get_module_param(&kcopyd_subjob_size_kb,
+						DEFAULT_SUB_JOB_SIZE_KB,
+						MAX_SUB_JOB_SIZE_KB);
+
+	return sub_job_size_kb << 1;
+}
 
 /*-----------------------------------------------------------------
  * Each kcopyd client has its own little pool of preallocated
@@ -41,6 +58,7 @@ struct dm_kcopyd_client {
 	struct page_list *pages;
 	unsigned nr_reserved_pages;
 	unsigned nr_free_pages;
+	unsigned sub_job_size;
 
 	struct dm_io_client *io_client;
 
@@ -693,8 +711,8 @@ static void segment_complete(int read_err, unsigned long write_err,
 		progress = job->progress;
 		count = job->source.count - progress;
 		if (count) {
-			if (count > SUB_JOB_SIZE)
-				count = SUB_JOB_SIZE;
+			if (count > kc->sub_job_size)
+				count = kc->sub_job_size;
 
 			job->progress += count;
 		}
@@ -821,7 +839,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	job->master_job = job;
 	job->write_offset = 0;
 
-	if (job->source.count <= SUB_JOB_SIZE)
+	if (job->source.count <= kc->sub_job_size)
 		dispatch_job(job);
 	else {
 		job->progress = 0;
@@ -888,6 +906,7 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
 struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
 	int r;
+	unsigned reserve_pages;
 	struct dm_kcopyd_client *kc;
 
 	kc = kzalloc(sizeof(*kc), GFP_KERNEL);
@@ -912,9 +931,12 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 		goto bad_workqueue;
 	}
 
+	kc->sub_job_size = dm_get_kcopyd_subjob_size();
+	reserve_pages = DIV_ROUND_UP(kc->sub_job_size << SECTOR_SHIFT, PAGE_SIZE);
+
 	kc->pages = NULL;
 	kc->nr_reserved_pages = kc->nr_free_pages = 0;
-	r = client_reserve_pages(kc, RESERVE_PAGES);
+	r = client_reserve_pages(kc, reserve_pages);
 	if (r)
 		goto bad_client_pages;
 
-- 
2.11.0
