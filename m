From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/9] multipathd: drop lock before calling
	uev_add_path
Date: Fri,  7 Apr 2017 01:16:35 -0500
Message-ID: <1491545798-22183-7-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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
Cc: Alban Browaeys <prahal@yahoo.com>
List-Id: dm-devel.ids

commit c6a18f4541d0a161e2f5fed8c67d9732bf512b37 made uev_update_path
call uev_add_path while holding the vecs lock, which is deadlocks, since
uev_add_path grabs the vecs lock itself.

Cc: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f671d58..f4ff13e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -974,6 +974,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	struct path * pp;
 	struct config *conf;
 	int disable_changed_wwids;
+	int needs_reinit = 0;
 
 	conf = get_multipath_config();
 	disable_changed_wwids = conf->disable_changed_wwids;
@@ -1009,7 +1010,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
-			retval = uev_add_path(uev, vecs, 1);
+			needs_reinit = 1;
 		else if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
@@ -1041,7 +1042,8 @@ out:
 
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 	}
-
+	if (needs_reinit)
+		retval = uev_add_path(uev, vecs, 1);
 	return retval;
 }
 
-- 
1.8.3.1
