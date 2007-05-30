From: Kevin Jamieson <kjamieson@bycast.com>
Subject: kcopyd performance
Date: Wed, 30 May 2007 15:56:42 -0700
Message-ID: <465E012A.5080905@bycast.com>
Reply-To: kjamieson@bycast.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
List-Id: dm-devel.ids

Hi,

I've been investigating some performance issues with writes to a LVM2
snapshot origin volume being much slower than one would expect (i.e.,
10-50x slower for a logical volume with a single snapshot volume).

Using a simple dd test (I get similar numbers with other tools like
bonnie) on a P4 3GHz w/SATA disks (no RAID):

dd if=/dev/zero of=/vol/file bs=1M count=1000

Logical volume w/o snapshot: 45.4 MB/s
LV w/snapshot on same disk, chunksize=8K: 1.1 MB/s
LV w/snapshot on same disk, chunksize=512K: 4.0 MB/s
LV w/snapshot on separate disk, chunksize=8K: 1.2 MB/s
LV w/snapshot on separate disk, chunksize=512K: 5.6 MB/s

I tracked the main cause of the poor performance to the behaviour of
process_jobs() in kcopyd. If kcopyd's page pool has no free pages, it
moves the next job in the _pages_jobs list to the tail of the list.
New jobs are also added to the tail of the _pages_jobs list (in
dispatch_job()). This re-ordering of the I/Os results in a lot of extra
seek activity for workloads consisting of sequential writes.

The below patch modifies process_jobs() to push the job back to the head
of the list instead of the tail when there are no free pages. I see
significantly improved performance with this change:

LV w/snapshot on same disk, chunksize=8K: 9.6 MB/s
LV w/snapshot on same disk, chunksize=512K: 8.4 MB/s
LV w/snapshot on separate disk, chunksize=8K: 17.2 MB/s
LV w/snapshot on separate disk, chunksize=512K: 14.5 MB/s

Thanks,
Kevin


--- linux/drivers/md/kcopyd.c.bak	2007-05-30 14:18:36.000000000 -0700
+++ linux/drivers/md/kcopyd.c	2007-05-30 15:54:33.000000000 -0700
@@ -280,6 +280,15 @@
 	spin_unlock_irqrestore(&_job_lock, flags);
 }
 
+static inline void push_head(struct list_head *jobs, struct kcopyd_job *job)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&_job_lock, flags);
+	list_add(&job->list, jobs);
+	spin_unlock_irqrestore(&_job_lock, flags);
+}
+
 /*
  * These three functions process 1 item from the corresponding
  * job list.
@@ -404,7 +413,7 @@
 			 * We couldn't service this job ATM, so
 			 * push this job back onto the list.
 			 */
-			push(jobs, job);
+			push_head(jobs, job);
 			break;
 		}
 

 
