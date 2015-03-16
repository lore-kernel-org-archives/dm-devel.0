From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/78] Double uevent stacksize yet again
Date: Mon, 16 Mar 2015 13:35:51 +0100
Message-ID: <1426509425-15978-5-git-send-email-hare@suse.de>
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

Another report indicates that the uevent stacksize might still be
too small.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/defaults.h | 1 +
 multipathd/main.c       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index fd64a12..7831992 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -19,6 +19,7 @@
 #define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
 #define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
+#define DEFAULT_UEVENT_STACKSIZE 256
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/multipathd/main.c b/multipathd/main.c
index a160d75..9667ba1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1710,7 +1710,7 @@ child (void * param)
 	udev = udev_new();
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 1);
-	setup_thread_attr(&uevent_attr, 128 * 1024, 1);
+	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 1);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
 	if (logsink == 1) {
-- 
1.8.4.5
