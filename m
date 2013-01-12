From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 15/18] multipath: Fix kpartx and udevd race
Date: Sat, 12 Jan 2013 00:04:52 -0600
Message-ID: <1357970695-3396-15-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Sometimes when kpartx is used to view partition data on disk image files,
udev still has the loop device open when kpartx is trying to tear it down.
This causes the LOOP_CLR_FD ioctl to fail with EBUSY.  kpartx now retries
in this case.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/lopart.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 79d8328..b1007e1 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -286,6 +286,7 @@ set_loop (const char *device, const char *file, int offset, int *loopro)
 extern int 
 del_loop (const char *device)
 {
+	int retries = 3;
 	int fd;
 
 	if ((fd = open (device, O_RDONLY)) < 0) {
@@ -295,10 +296,17 @@ del_loop (const char *device)
 		return 1;
 	}
 
-	if (ioctl (fd, LOOP_CLR_FD, 0) < 0) {
-		perror ("ioctl: LOOP_CLR_FD");
-		close (fd);
-		return 1;
+	while (ioctl (fd, LOOP_CLR_FD, 0) < 0) {
+		if (errno != EBUSY || retries-- <= 0) {
+			perror ("ioctl: LOOP_CLR_FD");
+			close (fd);
+			return 1;
+		}
+		fprintf(stderr,
+			"loop: device %s still in use, retrying delete\n",
+			device);
+		sleep(1);
+		continue;
 	}
 
 	close (fd);
-- 
1.8.0
