From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/39] kpartx/lopart.c: use fstat() when reading
	device nodes
Date: Thu, 16 Jun 2016 11:47:37 +0200
Message-ID: <1466070465-1021-32-git-send-email-hare@suse.de>
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

Coverity pointed out that we shouldn't be using stat()/open(),
as the file might have vanished or changed in between those
two calls. So modify it to open()/fstat() instead.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/lopart.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index d4a2ab4..f29cfc1 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -169,19 +169,18 @@ find_unused_loop_device (void)
 
 		sprintf(dev, "/dev/loop%d", next_loop);
 
-		if (stat (dev, &statbuf) == 0 && S_ISBLK(statbuf.st_mode)) {
-			somedev++;
-			fd = open (dev, O_RDONLY);
-
-			if (fd >= 0) {
-
+		fd = open (dev, O_RDONLY);
+		if (fd >= 0) {
+			if (fstat (fd, &statbuf) == 0 &&
+			    S_ISBLK(statbuf.st_mode)) {
+				somedev++;
 				if(ioctl (fd, LOOP_GET_STATUS, &loopinfo) == 0)
 					someloop++;		/* in use */
 				else if (errno == ENXIO)
 					next_loop_dev = xstrdup(dev);
 
-				close (fd);
 			}
+			close (fd);
 
 			/* continue trying as long as devices exist */
 			continue;
-- 
2.6.6
