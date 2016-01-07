From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: [RFC] disk doesn't spin down with thin pool + dmeventd
Date: Thu, 7 Jan 2016 19:31:20 +0000
Message-ID: <568EBD08.70800@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000501010704090107000502"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000501010704090107000502
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I tried using Docker on my Fedora NAS box.  It created a thin pool LV, 
which caused hard drive activity every ~10 seconds.

dmeventd queries the thin pool every 10 seconds, and it causes a 
transaction commit in order to make sure the statistics are up to date. 
But transactions are already supposed to be committed after 1 second.  
(See Documentation/device-mapper/thin-provisioning.txt, "Updating 
on-disk metadata").

It seems like a simple case of "don't do that".  The kernel already lets 
us avoid the commit.  How about it (patch below)?  If it seems 
reasonable, I can whip up a commit message for it.

Thanks
Alan

diff --git a/daemons/dmeventd/dmeventd.c b/daemons/dmeventd/dmeventd.c
index c093d91..5948f15 100644
--- a/daemons/dmeventd/dmeventd.c
+++ b/daemons/dmeventd/dmeventd.c
@@ -412,6 +412,15 @@ static struct thread_status *_alloc_thread_status(const struct message_data *dat
  	if (!(thread->device.name = dm_strdup(data->device_uuid)))
  		goto_out;
  
+	/*
+	 * Avoid repeatedly forcing a flush.
+	 * Allow the disks to sleep, and accept "out-of-date" statistics.
+	 * E.g. affects thin pools.  Commits will occur every second already,
+	 * if the pool state is changing.
+	 */
+	if (!dm_task_no_flush(thread->wait_task))
+		goto_out;
+
  	/* runs ioctl and may register lvm2 pluging */
  	thread->processing = 1;
  	thread->status = DM_THREAD_REGISTERING;



--------------000501010704090107000502
Content-Type: text/x-patch;
 name="dmevent-noflush.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmevent-noflush.patch"

diff --git a/daemons/dmeventd/dmeventd.c b/daemons/dmeventd/dmeventd.c
index c093d91..5948f15 100644
--- a/daemons/dmeventd/dmeventd.c
+++ b/daemons/dmeventd/dmeventd.c
@@ -412,6 +412,15 @@ static struct thread_status *_alloc_thread_status(const struct message_data *dat
 	if (!(thread->device.name = dm_strdup(data->device_uuid)))
 		goto_out;
 
+	/*
+	 * Avoid repeatedly forcing a flush.
+	 * Allow the disks to sleep, and accept "out-of-date" statistics.
+	 * E.g. affects thin pools.  Commits will occur every second already,
+	 * if the pool state is changing.
+	 */
+	if (!dm_task_no_flush(thread->wait_task))
+		goto_out;
+
 	/* runs ioctl and may register lvm2 pluging */
 	thread->processing = 1;
 	thread->status = DM_THREAD_REGISTERING;

--------------000501010704090107000502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000501010704090107000502--
