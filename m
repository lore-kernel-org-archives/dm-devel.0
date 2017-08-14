From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] libmultipath: cli_add_map: Use CMD_NONE
Date: Mon, 14 Aug 2017 22:40:42 +0200
Message-ID: <20170814204043.17640-3-mwilck@suse.com>
References: <20170814204043.17640-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170814204043.17640-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Commands issued from the daemon itself should always pass
CMD_NONE to coalesce_paths. Otherwise, the daemon mistakenly
tries to talk to itself via the socket, causing deadlock.

Reproduce simply by calling "multipathd add map $X".

Fixes: d19936f4 "libmultipath: Do not access 'conf->cmd' in domap()"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b4a95e37..f5ba4cfb 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -782,7 +782,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 					 vecs->pathvec, &refwwid);
 			if (refwwid) {
 				if (coalesce_paths(vecs, NULL, refwwid,
-						   FORCE_RELOAD_NONE, 1))
+						   FORCE_RELOAD_NONE, CMD_NONE))
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
-- 
2.14.0
