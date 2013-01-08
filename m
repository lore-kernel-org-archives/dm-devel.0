From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/42] prio: fix merging of prioritizers with
	different args
Date: Tue,  8 Jan 2013 14:53:43 +0100
Message-ID: <1357653259-62650-6-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Petr Uzel <petr.uzel@suse.cz>
List-Id: dm-devel.ids

From: Petr Uzel <petr.uzel@suse.cz>

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 libmultipath/discovery.c                 |   12 ++++---
 libmultipath/prio.c                      |   49 +++++++++++++++++++++++++++++-
 libmultipath/prio.h                      |    9 +++++-
 libmultipath/prioritizers/alua.c         |    1 +
 libmultipath/prioritizers/datacore.c     |    1 +
 libmultipath/prioritizers/emc.c          |    1 +
 libmultipath/prioritizers/hds.c          |    1 +
 libmultipath/prioritizers/hp_sw.c        |    1 +
 libmultipath/prioritizers/ontap.c        |    1 +
 libmultipath/prioritizers/rdac.c         |    1 +
 libmultipath/prioritizers/weightedpath.c |    6 +++-
 libmultipath/propsel.c                   |   15 ++++-----
 libmultipath/structs.c                   |    3 ++
 libmultipath/structs.h                   |    6 +++-
 libmultipath/structs_vec.c               |    2 +-
 15 files changed, 90 insertions(+), 19 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 33e44b6..6f5470f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -777,21 +777,23 @@ get_prio (struct path * pp)
 	if (!pp)
 		return 0;
 
-	if (!pp->prio) {
+	struct prio * p = &pp->prio;
+
+	if (!prio_selected(p)) {
 		select_prio(pp);
-		if (!pp->prio) {
+		if (!prio_selected(p)) {
 			condlog(3, "%s: no prio selected", pp->dev);
 			return 1;
 		}
 	}
-	pp->priority = prio_getprio(pp->prio, pp);
+	pp->priority = prio_getprio(p, pp);
 	if (pp->priority < 0) {
-		condlog(3, "%s: %s prio error", pp->dev, prio_name(pp->prio));
+		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
 		pp->priority = PRIO_UNDEF;
 		return 1;
 	}
 	condlog(3, "%s: %s prio = %u",
-		pp->dev, prio_name(pp->prio), pp->priority);
+		pp->dev, prio_name(p), pp->priority);
 	return 0;
 }
 
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 61c19b7..cf97fad 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -22,13 +22,23 @@ static struct prio * alloc_prio (void)
 	struct prio *p;
 
 	p = MALLOC(sizeof(struct prio));
-	if (p)
+	if (p) {
 		INIT_LIST_HEAD(&p->node);
+		p->refcount = 1;
+	}
 	return p;
 }
 
 void free_prio (struct prio * p)
 {
+	if (!p)
+		return;
+	p->refcount--;
+	if (p->refcount) {
+		condlog(3, "%s prioritizer refcount %d",
+			p->name, p->refcount);
+		return;
+	}
 	condlog(3, "unloading %s prioritizer", p->name);
 	list_del(&p->node);
 	if (p->handle) {
@@ -110,6 +120,13 @@ int prio_getprio (struct prio * p, struct path * pp)
 	return p->getprio(pp, p->args);
 }
 
+int prio_selected (struct prio * p)
+{
+	if (!p || !p->getprio)
+		return 0;
+	return (p->getprio) ? 1 : 0;
+}
+
 char * prio_name (struct prio * p)
 {
 	return p->name;
@@ -119,3 +136,33 @@ char * prio_args (struct prio * p)
 {
 	return p->args;
 }
+
+void prio_get (struct prio * dst, char * name, char * args)
+{
+	struct prio * src = prio_lookup(name);
+
+	if (!src) {
+		dst->getprio = NULL;
+		return;
+	}
+
+	strncpy(dst->name, src->name, PRIO_NAME_LEN);
+	if (args)
+		strncpy(dst->args, args, PRIO_ARGS_LEN);
+	dst->getprio = src->getprio;
+	dst->handle = NULL;
+
+	src->refcount++;
+}
+
+void prio_put (struct prio * dst)
+{
+	struct prio * src;
+
+	if (!dst)
+		return;
+
+	src = prio_lookup(dst->name);
+	memset(dst, 0x0, sizeof(struct prio));
+	free_prio(src);
+}
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 36929fb..4eeb216 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -6,7 +6,10 @@
  */
 #include "checkers.h"
 #include "vector.h"
-#include "structs.h"
+
+/* forward declaration to avoid circular dependency */
+struct path;
+
 #include "list.h"
 #include "memory.h"
 
@@ -41,6 +44,7 @@
 
 struct prio {
 	void *handle;
+	int refcount;
 	struct list_head node;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
@@ -52,6 +56,9 @@ void cleanup_prio (void);
 struct prio * add_prio (char *);
 struct prio * prio_lookup (char *);
 int prio_getprio (struct prio *, struct path *);
+void prio_get (struct prio *, char *, char *);
+void prio_put (struct prio *);
+int prio_selected (struct prio *);
 char * prio_name (struct prio *);
 char * prio_args (struct prio *);
 int prio_set_args (struct prio *, char *);
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 4da3ee7..b9493a4 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -16,6 +16,7 @@
 
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #include "alua.h"
 
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 2c16c6c..e3e6a51 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -24,6 +24,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 20d727e..87e9a8d 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -5,6 +5,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 4789340..b22e1df 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -75,6 +75,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 2de460f..c24baad 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -15,6 +15,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define TUR_CMD_LEN		6
 #define SCSI_CHECK_CONDITION	0x2
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 6e6e3d3..0d34092 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -22,6 +22,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define INQUIRY_CMD	0x12
 #define INQUIRY_CMDLEN	6
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index 41ea887..8667790 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -5,6 +5,7 @@
 #include <sg_include.h>
 #include <debug.h>
 #include <prio.h>
+#include <structs.h>
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index d6c81f0..54c9039 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -60,6 +60,10 @@ int prio_path_weight(struct path *pp, char *prio_args)
 
 	regex = get_next_string(&temp, split_char);
 
+	/* Return default priority if the argument is not parseable */
+	if (!regex)
+		return priority;
+
 	if (!strcmp(regex, HBTL)) {
 		sprintf(path, "%d:%d:%d:%d", pp->sg_id.host_no,
 			pp->sg_id.channel, pp->sg_id.scsi_id, pp->sg_id.lun);
@@ -67,7 +71,7 @@ int prio_path_weight(struct path *pp, char *prio_args)
 		strcpy(path, pp->dev);
 	} else {
 		condlog(0, "%s: %s - Invalid arguments", pp->dev,
-			pp->prio->name);
+			pp->prio.name);
 		return priority;
 	}
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 6ac4caa..17bd893 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -383,20 +383,19 @@ extern int
 select_prio (struct path * pp)
 {
 	struct mpentry * mpe;
+	struct prio * p = &pp->prio;
 
 	if ((mpe = find_mpe(pp->wwid))) {
 		if (mpe->prio_name) {
-			pp->prio = prio_lookup(mpe->prio_name);
-			prio_set_args(pp->prio, mpe->prio_args);
+			prio_get(p, mpe->prio_name, mpe->prio_args);
 			condlog(3, "%s: prio = %s (LUN setting)",
-				pp->dev, pp->prio->name);
+				pp->dev, prio_name(p));
 			return 0;
 		}
 	}
 
 	if (pp->hwe && pp->hwe->prio_name) {
-		pp->prio = prio_lookup(pp->hwe->prio_name);
-		prio_set_args(pp->prio, pp->hwe->prio_args);
+		prio_get(p, pp->hwe->prio_name, pp->hwe->prio_name);
 		condlog(3, "%s: prio = %s (controller setting)",
 			pp->dev, pp->hwe->prio_name);
 		condlog(3, "%s: prio args = %s (controller setting)",
@@ -404,16 +403,14 @@ select_prio (struct path * pp)
 		return 0;
 	}
 	if (conf->prio_name) {
-		pp->prio = prio_lookup(conf->prio_name);
-		prio_set_args(pp->prio, conf->prio_args);
+		prio_get(p, conf->prio_name, conf->prio_args);
 		condlog(3, "%s: prio = %s (config file default)",
 			pp->dev, conf->prio_name);
 		condlog(3, "%s: prio args = %s (config file default)",
 			pp->dev, conf->prio_args);
 		return 0;
 	}
-	pp->prio = prio_lookup(DEFAULT_PRIO);
-	prio_set_args(pp->prio, DEFAULT_PRIO_ARGS);
+	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	condlog(3, "%s: prio = %s (internal default)",
 		pp->dev, DEFAULT_PRIO);
 	condlog(3, "%s: prio = %s (internal default)",
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 3c0fe90..ab57559 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -45,6 +45,9 @@ free_path (struct path * pp)
 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
 
+	if (prio_selected(&pp->prio))
+		prio_put(&pp->prio);
+
 	if (pp->fd >= 0)
 		close(pp->fd);
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 991ea6e..312014b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -3,6 +3,8 @@
 
 #include <sys/types.h>
 
+#include "prio.h"
+
 #define WWID_SIZE		128
 #define SERIAL_SIZE		65
 #define NODE_NAME_SIZE		224
@@ -132,6 +134,7 @@ struct hd_geometry {
       unsigned long start;
 };
 #endif
+
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
@@ -157,7 +160,8 @@ struct path {
 	int priority;
 	int pgindex;
 	char * uid_attribute;
-	struct prio * prio;
+	struct prio prio;
+	char * prio_args;
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f998708..d914435 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -82,7 +82,7 @@ orphan_path (struct path * pp)
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
-	pp->prio = NULL;
+	prio_put(&pp->prio);
 	checker_put(&pp->checker);
 	if (pp->fd >= 0)
 		close(pp->fd);
-- 
1.7.4.2
