From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] multipathd: decrease log level of "spurious
	uevent" message
Date: Wed,  4 Apr 2018 18:21:57 +0200
Message-ID: <20180404162200.6518-2-mwilck@suse.com>
References: <20180404162200.6518-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404162200.6518-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We trigger such events under various conditions, there's no point
logging them at -v2.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7eeb743..7886c76 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -820,7 +820,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	if (pp) {
 		int r;
 
-		condlog(2, "%s: spurious uevent, path already in pathvec",
+		condlog(3, "%s: spurious uevent, path already in pathvec",
 			uev->kernel);
 		if (!pp->mpp && !strlen(pp->wwid)) {
 			condlog(3, "%s: reinitialize path", uev->kernel);
-- 
2.16.1
