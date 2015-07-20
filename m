From: Tejaswini Poluri <tpoluri@mvista.com>
Subject: [PATCH 2/2] multipathd: Disabled code that is not being
	used.
Date: Mon, 20 Jul 2015 14:59:32 +0530
Message-ID: <1437384572-23106-2-git-send-email-tpoluri@mvista.com>
References: <1437384572-23106-1-git-send-email-tpoluri@mvista.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1437384572-23106-1-git-send-email-tpoluri@mvista.com>
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
Cc: Tejaswini Poluri <tpoluri@mvista.com>
List-Id: dm-devel.ids

This part of the code is moved to cli_add_map and
disabled here as it is not used by any function call
here.

Signed-off-by: Tejaswini Poluri <tpoluri@mvista.com>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index f876258..e40b968 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -329,6 +329,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 			return 1;
 		}
 	}
+#if 0 /*Disabled as the code is not used by any function*/
 	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
@@ -344,6 +345,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 		condlog(0, "%s: uev_add_map %s failed", alias, dev);
 
 	FREE(refwwid);
+#endif
 	return r;
 }
 
-- 
1.9.1
