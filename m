From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/21] multipathd: check_path: improve logging
	for "unusable path" case
Date: Fri, 12 Oct 2018 00:27:04 +0200
Message-ID: <20181011222707.3631-19-mwilck@suse.com>
References: <20181011222707.3631-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181011222707.3631-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1bd1518a..8ce72fce 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1894,7 +1894,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-		condlog(2, "%s: unusable path", pp->dev);
+		condlog(2, "%s: unusable path - checker failed", pp->dev);
+		LOG_MSG(2, verbosity, pp);
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		pathinfo(pp, conf, 0);
-- 
2.19.0
