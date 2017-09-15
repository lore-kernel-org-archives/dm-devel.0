From: Hannes Reinecke <hare@suse.de>
Subject: libmultipath: add pthread_cleanup hook for udev monitor
Date: Fri, 15 Sep 2017 08:14:30 +0200
Message-ID: <1505456070-116960-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

The udev monitor from uevent_listen() needs to be cleaned up from
a pthread cleanup hook.
Valgrind complained here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/uevent.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index eb44da56..8b511eb2 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -361,6 +361,14 @@ static void uevent_cleanup(void *arg)
 	udev_unref(udev);
 }
 
+static void monitor_cleanup(void *arg)
+{
+	struct udev_monitor *monitor = arg;
+
+	condlog(3, "Releasing uevent_monitor() resources");
+	udev_monitor_unref(monitor);
+}
+
 /*
  * Service the uevent queue.
  */
@@ -749,6 +757,7 @@ int uevent_listen(struct udev *udev)
 		condlog(2, "failed to create udev monitor");
 		goto out;
 	}
+	pthread_cleanup_push(monitor_cleanup, monitor);
 #ifdef LIBUDEV_API_RECVBUF
 	if (udev_monitor_set_receive_buffer_size(monitor, 128 * 1024 * 1024))
 		condlog(2, "failed to increase buffer size");
@@ -834,7 +843,7 @@ int uevent_listen(struct udev *udev)
 	need_failback = 0;
 out:
 	if (monitor)
-		udev_monitor_unref(monitor);
+		pthread_cleanup_pop(1);
 	if (need_failback)
 		err = failback_listen();
 	pthread_cleanup_pop(1);
-- 
2.12.0
