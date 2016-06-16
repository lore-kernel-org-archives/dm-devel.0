From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/39] libmultipath: remove stale references to
	fd_ep in uevent_listen()
Date: Thu, 16 Jun 2016 11:47:14 +0200
Message-ID: <1466070465-1021-9-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/uevent.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 454b819..fb8b4a7 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -474,7 +474,7 @@ int uevent_listen(struct udev *udev)
 {
 	int err = 2;
 	struct udev_monitor *monitor = NULL;
-	int fd, fd_ep = -1, socket_flags, events;
+	int fd, socket_flags, events;
 	int need_failback = 1;
 	int timeout = 30;
 	LIST_HEAD(uevlisten_tmp);
@@ -579,8 +579,6 @@ int uevent_listen(struct udev *udev)
 	}
 	need_failback = 0;
 out:
-	if (fd_ep >= 0)
-		close(fd_ep);
 	if (monitor)
 		udev_monitor_unref(monitor);
 	if (need_failback)
-- 
2.6.6
