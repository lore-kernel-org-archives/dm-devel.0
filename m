From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: [PATCH] multipathd: deferred device adding
Date: Thu, 10 Nov 2016 16:05:21 +0100
Message-ID: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
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
To: hare@suse.de, christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com, benjamin.drung@profitbricks.com, Gioh Kim <gi-oh.kim@profitbricks.com>
List-Id: dm-devel.ids

Current multipathd always receives events from udev
and add devices to topology immediately. For example,
if sdb is added, multipathd receives the event from sdb
and add sdb into the topology.
But some platform needs to defer adding new device
until user adds device manually, for instance, with "multipathd add sdb".

I tested this patch to disable ueventloop.
There was no problem on my platform.

Is there a configuration for multipath.conf or udev rule
for deferred device adding?
Or what about adding new configuration for that?

Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d6f081f..da38d02 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2372,10 +2372,12 @@ child (void * param)
 	/*
 	 * Start uevent listener early to catch events
 	 */
+	/*
 	if ((rc = pthread_create(&uevent_thr, &uevent_attr, ueventloop, udev))) {
 		condlog(0, "failed to create uevent thread: %d", rc);
 		goto failed;
 	}
+	*/
 	pthread_attr_destroy(&uevent_attr);
 	if ((rc = pthread_create(&uxlsnr_thr, &misc_attr, uxlsnrloop, vecs))) {
 		condlog(0, "failed to create cli listener: %d", rc);
@@ -2433,12 +2435,12 @@ child (void * param)
 	unlock(&vecs->lock);
 
 	pthread_cancel(check_thr);
-	pthread_cancel(uevent_thr);
+	/* pthread_cancel(uevent_thr); */
 	pthread_cancel(uxlsnr_thr);
 	pthread_cancel(uevq_thr);
 
 	pthread_join(check_thr, NULL);
-	pthread_join(uevent_thr, NULL);
+	/* pthread_join(uevent_thr, NULL); */
 	pthread_join(uxlsnr_thr, NULL);
 	pthread_join(uevq_thr, NULL);
 
-- 
2.5.0
