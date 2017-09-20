From: Michael Lass <bevan@bi-co.net>
Subject: [PATCH] multipathd: fix build without systemd
Date: Wed, 20 Sep 2017 22:47:55 +0200
Message-ID: <20170920204755.27047-1-bevan@bi-co.net>
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
To: dm-devel@redhat.com
Cc: Michael Lass <bevan@bi-co.net>
List-Id: dm-devel.ids

do_sd_notify contains a call to sd_notify which is unknown if USE_SYSTEMD is
undefined. In this case, do_sd_notify is never called anyway, so embed the
entire function into an #ifdef USE_SYSTEMD.

This fixes a regression introduced in 88ddca5.

Signed-off-by: Michael Lass <bevan@bi-co.net>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8049da22..bbe14771 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -169,6 +169,7 @@ sd_notify_status(void)
 	return NULL;
 }
 
+#ifdef USE_SYSTEMD
 static void do_sd_notify(enum daemon_status old_state)
 {
 	/*
@@ -181,6 +182,7 @@ static void do_sd_notify(enum daemon_status old_state)
 		return;
 	sd_notify(0, sd_notify_status());
 }
+#endif
 
 static void config_cleanup(void *arg)
 {
-- 
2.14.1
