From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] multipathd: Suppress uninteresting data race
	reports
Date: Tue, 16 Aug 2016 13:00:47 -0700
Message-ID: <01747bb5-c10e-a3b6-e440-d9443837a6f7@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The global variable multipath_conf is modified through RCU. Hence
avoid that the data race detection tools Helgrind and DRD report
data races for this variable.

The global variable running_state is read without holding the mutex
that protects changes of this variable. Suppress complaints about
these reads.

The global variable uxsock_timeout is not protected by any mutex.
Suppress complaints about using this variable.

This patch introduces a new build-time requirement, namely that
the valgrind-devel package has been installed.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 multipathd/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1d73b4c..54abfef 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -23,6 +23,7 @@
 #endif
 #include <semaphore.h>
 #include <time.h>
+#include <valgrind/helgrind.h>
 
 /*
  * libcheckers
@@ -2520,6 +2521,13 @@ main (int argc, char *argv[])
 	int foreground = 0;
 	struct config *conf;
 
+	ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf, sizeof(multipath_conf),
+				   "Manipulated through RCU");
+	ANNOTATE_BENIGN_RACE_SIZED(&running_state, sizeof(running_state),
+		"Suppress complaints about unprotected running_state reads");
+	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
+		"Suppress complaints about this scalar variable");
+
 	logsink = 1;
 
 	if (getuid() != 0) {
-- 
2.9.2
