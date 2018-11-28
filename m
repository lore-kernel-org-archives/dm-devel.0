From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] libmultipath: cleanup pthread_cleanup_pop
	call
Date: Wed, 28 Nov 2018 00:13:23 -0600
Message-ID: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

pthread_cleanup_push() and pthread_cleanup_pop() must be called in the
same lexical scope.  In uevent_listen(), the pthread_cleanup_pop() call
to cleanup the udev monitor is called in a nested 'if' block, within
the block where pthread_cleanup_push() is called.  Since this is a
single-statement if block, it doesn't actually cause any problems, but
it should be fixed anyways.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 5f910e6..f73de8c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -806,7 +806,7 @@ int uevent_listen(struct udev *udev)
 	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
 		condlog(2, "failed to create udev monitor");
-		goto out;
+		goto failback;
 	}
 	pthread_cleanup_push(monitor_cleanup, monitor);
 #ifdef LIBUDEV_API_RECVBUF
@@ -893,8 +893,8 @@ int uevent_listen(struct udev *udev)
 	}
 	need_failback = 0;
 out:
-	if (monitor)
-		pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
+failback:
 	if (need_failback)
 		err = failback_listen();
 	pthread_cleanup_pop(1);
-- 
2.7.4
