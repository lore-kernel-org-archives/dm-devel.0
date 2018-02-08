From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 6/7] multipathd: change spurious uevent msg
	priority
Date: Thu,  8 Feb 2018 17:56:06 -0600
Message-ID: <1518134167-15938-7-git-send-email-bmarzins@redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

The "spurious uevent, path already in pathvec" is not anything to worry
about, so it should not have the error priority.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 51e0f5e..7ac59d9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -562,7 +562,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	if (pp) {
 		int r;
 
-		condlog(0, "%s: spurious uevent, path already in pathvec",
+		condlog(2, "%s: spurious uevent, path already in pathvec",
 			uev->kernel);
 		if (!pp->mpp && !strlen(pp->wwid)) {
 			condlog(3, "%s: reinitialize path", uev->kernel);
-- 
2.7.4
