From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/30] Minor fixes for priority handling
Date: Tue, 16 Jul 2013 09:13:03 +0200
Message-ID: <1373958801-103613-13-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

When no prio handler was selected we should be setting the
priority to 'PRIO_UNDEF'.
Also fixup a typo in the logging message when selecting
the default prioritizer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 1 +
 libmultipath/propsel.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index fcb8e4f..a482c53 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -957,6 +957,7 @@ get_prio (struct path * pp)
 		select_prio(pp);
 		if (!prio_selected(p)) {
 			condlog(3, "%s: no prio selected", pp->dev);
+			pp->priority = PRIO_UNDEF;
 			return 1;
 		}
 	}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 65c2c7f..cea8c1c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -447,7 +447,7 @@ select_prio (struct path * pp)
 	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	condlog(3, "%s: prio = %s (internal default)",
 		pp->dev, DEFAULT_PRIO);
-	condlog(3, "%s: prio = %s (internal default)",
+	condlog(3, "%s: prio args = %s (internal default)",
 		pp->dev, DEFAULT_PRIO_ARGS);
 	return 0;
 }
-- 
1.7.12.4
