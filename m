From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 55/78] uxlsnr: use typedef for trigger function
Date: Mon, 16 Mar 2015 13:36:42 +0100
Message-ID: <1426509425-15978-56-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/uxlsnr.c | 3 +--
 multipathd/uxlsnr.h | 8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 7b13190..550dcc4 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -119,8 +119,7 @@ void uxsock_cleanup(void *arg)
 /*
  * entry point
  */
-void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
-			void * trigger_data)
+void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 {
 	int ux_sock;
 	size_t len;
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 8b5a525..d274b04 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -1,11 +1,13 @@
 #ifndef _UXLSNR_H
 #define _UXLSNR_H
 
-void * uxsock_listen(int (*uxsock_trigger)
-			(char *, char **, int *, void *),
-			void * trigger_data);
+typedef int (uxsock_trigger_fn)(char *, char **, int *, void *);
+
+void * uxsock_listen(uxsock_trigger_fn uxsock_trigger,
+		     void * trigger_data);
 
 extern volatile sig_atomic_t reconfig_sig;
 extern volatile sig_atomic_t log_reset_sig;
+
 #endif
 
-- 
1.8.4.5
