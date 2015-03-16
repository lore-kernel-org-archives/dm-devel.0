From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/78] multipath: check for running daemon when
	called with '-u'
Date: Mon, 16 Mar 2015 13:36:18 +0100
Message-ID: <1426509425-15978-32-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When multipath is called to check for a valid device it really
should check if the daemon is running. Otherwise it'll blindly
assume the device to be eligible for multipathing even though
the daemon isn't running.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index 08ba66c..ce8fb5b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -56,6 +56,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <wwids.h>
+#include <uxsock.h>
 #include "dev_t.h"
 
 int logsink;
@@ -622,6 +623,18 @@ main (int argc, char *argv[])
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
+	if (conf->cmd == CMD_VALID_PATH &&
+	    conf->dev_type == DEV_UEVENT) {
+		int fd;
+
+		fd = ux_socket_connect(DEFAULT_SOCKET);
+		if (fd == -1) {
+			printf("%s is not a valid multipath device path\n",
+				conf->dev);
+			goto out;
+		}
+		close(fd);
+	}
 	if (conf->cmd == CMD_REMOVE_WWID && !conf->dev) {
 		condlog(0, "the -w option requires a device");
 		goto out;
-- 
1.8.4.5
