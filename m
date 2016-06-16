From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/39] kpartx: fixup fd leakage in lopart.c
Date: Thu, 16 Jun 2016 11:47:30 +0200
Message-ID: <1466070465-1021-25-git-send-email-hare@suse.de>
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

We're leaking filedescriptors when trying to figure out the loop
device.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/lopart.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 39add44..e7f6090 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -154,13 +154,15 @@ find_unused_loop_device (void)
 	while (next_loop_dev == NULL) {
 		if (stat("/dev/loop-control", &statbuf) == 0 &&
 		    S_ISCHR(statbuf.st_mode)) {
-			fd = open("/dev/loop-control", O_RDWR);
-			if (fd < 0)
+			int next_loop_fd;
+
+			next_loop_fd = open("/dev/loop-control", O_RDWR);
+			if (next_loop_fd < 0)
 				return NULL;
-			next_loop = ioctl(fd, LOOP_CTL_GET_FREE);
+			next_loop = ioctl(next_loop_fd, LOOP_CTL_GET_FREE);
+			close(next_loop_fd);
 			if (next_loop < 0)
 				return NULL;
-			close(fd);
 		}
 
 		sprintf(dev, "/dev/loop%d", next_loop);
@@ -173,11 +175,8 @@ find_unused_loop_device (void)
 
 				if(ioctl (fd, LOOP_GET_STATUS, &loopinfo) == 0)
 					someloop++;		/* in use */
-
-				else if (errno == ENXIO) {
-					close (fd);
+				else if (errno == ENXIO)
 					next_loop_dev = xstrdup(dev);
-				}
 
 				close (fd);
 			}
-- 
2.6.6
