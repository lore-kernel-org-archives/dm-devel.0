From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 02/16] Revert "multipathd: imply -n if
	find_multipaths is set"
Date: Fri, 19 Jan 2018 01:29:02 +0100
Message-ID: <20180119002916.10323-3-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This reverts commit 64e27ec066a001012f44550f095c93443e91d845.
---
 multipathd/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 26632291657f..255d1d860b2a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2131,10 +2131,6 @@ reconfigure (struct vectors * vecs)
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
2.15.1
