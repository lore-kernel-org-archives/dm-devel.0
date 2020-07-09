From: mwilck@suse.com
Subject: [PATCH 55/74] libmultipath: add uninitialize_path()
Date: Thu,  9 Jul 2020 12:51:26 +0200
Message-ID: <20200709105145.9211-3-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

This helper clears all fields of struct path (except pp->udev) that must be
re-ininitialized if the path ever is to be used again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c     | 19 +++++++++++++++++--
 libmultipath/structs.h     |  1 +
 libmultipath/structs_vec.c |  9 +--------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 9407462..056a205 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -114,19 +114,34 @@ alloc_path (void)
 }
 
 void
-free_path (struct path * pp)
+uninitialize_path(struct path *pp)
 {
 	if (!pp)
 		return;
 
+	pp->dmstate = PSTATE_UNDEF;
+	pp->uid_attribute = NULL;
+	pp->getuid = NULL;
+
 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
 
 	if (prio_selected(&pp->prio))
 		prio_put(&pp->prio);
 
-	if (pp->fd >= 0)
+	if (pp->fd >= 0) {
 		close(pp->fd);
+		pp->fd = -1;
+	}
+}
+
+void
+free_path (struct path * pp)
+{
+	if (!pp)
+		return;
+
+	uninitialize_path(pp);
 
 	if (pp->udev) {
 		udev_device_unref(pp->udev);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d69bc2e..894099d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -416,6 +416,7 @@ struct host_group {
 struct path * alloc_path (void);
 struct pathgroup * alloc_pathgroup (void);
 struct multipath * alloc_multipath (void);
+void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
 void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0b8c548..05c8626 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -98,14 +98,7 @@ void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
 	pp->mpp = NULL;
-	pp->dmstate = PSTATE_UNDEF;
-	pp->uid_attribute = NULL;
-	pp->getuid = NULL;
-	prio_put(&pp->prio);
-	checker_put(&pp->checker);
-	if (pp->fd >= 0)
-		close(pp->fd);
-	pp->fd = -1;
+	uninitialize_path(pp);
 }
 
 void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
-- 
2.26.2
