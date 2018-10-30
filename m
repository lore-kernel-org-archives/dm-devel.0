From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/7] libmultipath: set pp->checkint in
	store_pathinfo()
Date: Tue, 30 Oct 2018 22:22:43 +0100
Message-ID: <20181030212249.31127-2-mwilck@suse.com>
References: <20181030212249.31127-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030212249.31127-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

store_pathinfo is called with valid conf pointer anyway, so
checkint is available. pp->checkint is now valid for every
path after path_discovery().

This fixes a bad conf access in cli_add_path().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c  | 1 +
 multipathd/cli_handlers.c | 1 -
 multipathd/main.c         | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0bcd3c39..def5d6b2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -103,6 +103,7 @@ store_pathinfo (vector pathvec, struct config *conf,
 	err = store_path(pathvec, pp);
 	if (err)
 		goto out;
+	pp->checkint = conf->checkint;
 
 out:
 	if (err)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 75000807..4aea4ce7 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -736,7 +736,6 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 			condlog(0, "%s: failed to store path info", param);
 			return 1;
 		}
-		pp->checkint = conf->checkint;
 	}
 	return ev_add_path(pp, vecs, 1);
 blacklisted:
diff --git a/multipathd/main.c b/multipathd/main.c
index fcf0d2db..c24b2b99 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2321,8 +2321,6 @@ configure (struct vectors * vecs)
 			free_path(pp);
 			i--;
 		}
-		else
-			pp->checkint = conf->checkint;
 		pthread_cleanup_pop(1);
 	}
 	if (map_discovery(vecs)) {
-- 
2.19.1
