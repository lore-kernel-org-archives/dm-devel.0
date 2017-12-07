From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/12] multipath: fix hwhandler check in
	select_action
Date: Thu,  7 Dec 2017 12:48:57 -0600
Message-ID: <1512672546-12785-4-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If the existing multipath table does not have a hardware handler set,
then even if retain_hwhandler is enabled on the new table, it may still
be possible to set the hardware handler on reload. So, adding a
hardware handler to the table should trigger a reload in this case.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 09cbe3c..0dfa250 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -563,7 +563,8 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
-	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_ON &&
+	if ((mpp->retain_hwhandler != RETAIN_HWHANDLER_ON ||
+	     strcmp(cmpp->hwhandler, "0") == 0) &&
 	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
 	     strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler)))) {
-- 
2.7.4
