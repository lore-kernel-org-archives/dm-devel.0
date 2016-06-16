From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/39] multipathd: correctly free refwwid in
	cli_add_map()
Date: Thu, 16 Jun 2016 11:47:07 +0200
Message-ID: <1466070465-1021-2-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

We need to free the refwwid only when present.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/cli_handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a1b7052..52bcdaa 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -715,6 +715,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
+				FREE(refwwid);
 			}
 		} /*we attempt to create device only once*/
 		count++;
@@ -726,7 +727,6 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	}
 	rc = ev_add_map(dev_path, alias, vecs);
 	FREE(alias);
-	FREE(refwwid);
 	return rc;
 }
 
-- 
2.6.6
