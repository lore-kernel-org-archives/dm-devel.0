From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 15/19] multipathd: minor fixes
Date: Fri, 21 Sep 2018 18:05:23 -0500
Message-ID: <1537571127-10143-16-git-send-email-bmarzins@redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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

In update_multipath(), conf is set again in a couple of lines, and
nothing uses it before then, so there's no point in setting it twice.
Also, in ev_remove_path(), strncpy() could end up unterminated, so
use strlcpy() instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index cc493c1..125a805 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -429,7 +429,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 				continue;
 
 			if (pp->state != PATH_DOWN) {
-				struct config *conf = get_multipath_config();
+				struct config *conf;
 				int oldstate = pp->state;
 				int checkint;
 
@@ -1096,7 +1096,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			/*
 			 * flush_map will fail if the device is open
 			 */
-			strncpy(alias, mpp->alias, WWID_SIZE);
+			strlcpy(alias, mpp->alias, WWID_SIZE);
 			if (mpp->flush_on_last_del == FLUSH_ENABLED) {
 				condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
 				mpp->retry_tick = 0;
-- 
2.7.4
