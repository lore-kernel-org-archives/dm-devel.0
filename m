From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/42] Print out multipath alias for
	flush_on_last_del messages
Date: Tue,  8 Jan 2013 14:53:52 +0100
Message-ID: <1357653259-62650-15-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

Added for consistency.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/propsel.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 756aced..a02a644 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -606,24 +606,25 @@ select_flush_on_last_del(struct multipath *mp)
 		return 0;
 	if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
 		mp->flush_on_last_del = mp->mpe->flush_on_last_del;
-		condlog(3, "flush_on_last_del = %i (multipath setting)",
-				mp->flush_on_last_del);
+		condlog(3, "%s: flush_on_last_del = %i (multipath setting)",
+			mp->alias, mp->flush_on_last_del);
 		return 0;
 	}
 	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
 		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
-		condlog(3, "flush_on_last_del = %i (controler setting)",
-				mp->flush_on_last_del);
+		condlog(3, "%s: flush_on_last_del = %i (controler setting)",
+			mp->alias, mp->flush_on_last_del);
 		return 0;
 	}
 	if (conf->flush_on_last_del != FLUSH_UNDEF) {
 		mp->flush_on_last_del = conf->flush_on_last_del;
-		condlog(3, "flush_on_last_del = %i (config file default)",
-				mp->flush_on_last_del);
+		condlog(3, "%s: flush_on_last_del = %i (config file default)",
+			mp->alias, mp->flush_on_last_del);
 		return 0;
 	}
 	mp->flush_on_last_del = FLUSH_UNDEF;
-	condlog(3, "flush_on_last_del = DISABLED (internal default)");
+	condlog(3, "%s: flush_on_last_del = DISABLED (internal default)",
+		mp->alias);
 	return 0;
 }
 
-- 
1.7.4.2
