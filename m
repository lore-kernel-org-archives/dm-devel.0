From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/39] libmpathpersist: memory leak in
	mpath_persistent_reserve_(in, out)()
Date: Thu, 16 Jun 2016 11:47:26 +0200
Message-ID: <1466070465-1021-21-git-send-email-hare@suse.de>
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

When either curmp or pathvec couldn't be allocated we never
free up the other one, too.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index c4b8521..cfc2f0f 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -195,6 +195,10 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 	if (!curmp || !pathvec){
 		condlog (0, "%s: vector allocation failed.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
+		if (curmp)
+			vector_free(curmp);
+		if (pathvec)
+			vector_free(pathvec);
 		goto out;
 	}
 
@@ -285,6 +289,10 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	if (!curmp || !pathvec){
 		condlog (0, "%s: vector allocation failed.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
+		if (curmp)
+			vector_free(curmp);
+		if (pathvec)
+			vector_free(pathvec);
 		goto out;
 	}
 
-- 
2.6.6
