From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 02/22] Revert "multipathd: imply -n if
	find_multipaths is set"
Date: Fri, 13 Apr 2018 23:59:55 +0200
Message-ID: <20180413220015.7032-3-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This reverts commit 64e27ec066a001012f44550f095c93443e91d845.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4d65f1d0..17175a85 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2403,10 +2403,6 @@ reconfigure (struct vectors * vecs)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	if (conf->find_multipaths) {
-		condlog(2, "find_multipaths is set: -n is implied");
-		ignore_new_devs = 1;
-	}
 	if (ignore_new_devs)
 		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
-- 
2.16.1
