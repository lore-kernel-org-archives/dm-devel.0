From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH] libmultipath: Add prioritizer context data
Date: Thu, 16 Apr 2015 23:12:33 -0500
Message-ID: <1429243953-24332-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Currently, running the alua prioritizer on a path causes 5 ioctls on many
devices.  get_target_port_group_support() returns whether alua is
supported. get_target_port_group() gets the TPG id. This often takes two
ioctls because 128 bytes is not a large enough buffer size on many
devices. Finally, get_asymmetric_access_state() also often takes two
ioctls because of the buffer size. This can get to be problematic when
there are thousands of paths.  The goal of this patch to to cut this down
to one call in the usual case.

In order to do this, I've added a context pointer to the prio structure,
similar to what exists for the checker structure, and initprio() and
freeprio() functions to the prioritizers. The only one that currently uses
these is the alua prioritizer. It caches the type of alua support, the TPG
id, and the necessary buffer size.  The only thing I'm worried about with
this patch is whether the first two values could change.  In order to deal
with that possibility, whenever a path gets a change event, or becomes
valid again after a failure, it resets the context structure values, which
forces all of them to get checked the next time the prioritizer is called.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.c                      | 34 ++++++++++++++++++-
 libmultipath/prio.h                      |  7 ++++
 libmultipath/prioritizers/alua.c         | 58 +++++++++++++++++++++++++-------
 libmultipath/prioritizers/alua_rtpg.c    | 22 +++++++++---
 libmultipath/prioritizers/alua_rtpg.h    |  4 +--
 libmultipath/prioritizers/const.c        |  4 +++
 libmultipath/prioritizers/datacore.c     |  3 ++
 libmultipath/prioritizers/def_func.h     | 11 ++++++
 libmultipath/prioritizers/emc.c          |  4 +++
 libmultipath/prioritizers/hds.c          |  4 +++
 libmultipath/prioritizers/hp_sw.c        |  4 +++
 libmultipath/prioritizers/iet.c          |  4 +++
 libmultipath/prioritizers/ontap.c        |  4 +++
 libmultipath/prioritizers/random.c       |  4 +++
 libmultipath/prioritizers/rdac.c         |  4 +++
 libmultipath/prioritizers/weightedpath.c |  3 ++
 libmultipath/propsel.c                   |  4 +--
 multipathd/main.c                        | 24 ++++++++-----
 18 files changed, 171 insertions(+), 31 deletions(-)
 create mode 100644 libmultipath/prioritizers/def_func.h

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index ab8eca9..c8fe252 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -115,9 +115,24 @@ struct prio * add_prio (char * name)
 	p->getprio = (int (*)(struct path *, char *)) dlsym(p->handle, "getprio");
 	errstr = dlerror();
 	if (errstr != NULL)
-		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
+		condlog(0, "A dynamic linking error occurred with getprio: (%s)", errstr);
 	if (!p->getprio)
 		goto out;
+
+	p->initprio = (int (*)(struct prio *)) dlsym(p->handle, "initprio");
+	errstr = dlerror();
+	if (errstr != NULL)
+		condlog(0, "A dynamic linking error occurred with initprio: (%s)", errstr);
+	if (!p->initprio)
+		goto out;
+
+	p->freeprio = (int (*)(struct prio *)) dlsym(p->handle, "freeprio");
+	errstr = dlerror();
+	if (errstr != NULL)
+		condlog(0, "A dynamic linking error occurred with freeprio: (%s)", errstr);
+	if (!p->freeprio)
+		goto out;
+
 	list_add(&p->node, &prioritizers);
 	return p;
 out:
@@ -125,6 +140,13 @@ out:
 	return NULL;
 }
 
+int prio_init (struct prio * p)
+{
+	if (!p || !p->initprio)
+		return 1;
+	return p->initprio(p);
+}
+
 int prio_getprio (struct prio * p, struct path * pp)
 {
 	return p->getprio(pp, p->args);
@@ -159,8 +181,16 @@ void prio_get (struct prio * dst, char * name, char * args)
 	strncpy(dst->name, src->name, PRIO_NAME_LEN);
 	if (args)
 		strncpy(dst->args, args, PRIO_ARGS_LEN);
+	dst->initprio = src->initprio;
 	dst->getprio = src->getprio;
+	dst->freeprio = src->freeprio;
 	dst->handle = NULL;
+	dst->context = NULL;
+
+	if (dst->initprio(dst) != 0){
+		memset(dst, 0x0, sizeof(struct prio));
+		return;
+	}
 
 	src->refcount++;
 }
@@ -173,6 +203,8 @@ void prio_put (struct prio * dst)
 		return;
 
 	src = prio_lookup(dst->name);
+	if (dst->freeprio)
+		dst->freeprio(dst);
 	memset(dst, 0x0, sizeof(struct prio));
 	free_prio(src);
 }
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 495688f..6d57ecd 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -46,9 +46,15 @@ struct prio {
 	void *handle;
 	int refcount;
 	struct list_head node;
+	void * context;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
+	int (*initprio)(struct prio * p);
+	/* You are allowed to call initprio multiple times without calling
+	 * freeprio. Doing so will reinitialize it (possibly skipping
+	 * allocations) */
 	int (*getprio)(struct path *, char *);
+	int (*freeprio)(struct prio * p);
 };
 
 unsigned int get_prio_timeout(unsigned int default_timeout);
@@ -57,6 +63,7 @@ void cleanup_prio (void);
 struct prio * add_prio (char *);
 struct prio * prio_lookup (char *);
 int prio_getprio (struct prio *, struct path *);
+int prio_init (struct prio *);
 void prio_get (struct prio *, char *, char *);
 void prio_put (struct prio *);
 int prio_selected (struct prio *);
diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 39ed1c8..7691156 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -37,6 +37,12 @@ static const char * aas_string[] = {
 	[AAS_TRANSITIONING]	= "transitioning between states",
 };
 
+struct alua_context {
+	int tpg_support;
+	int tpg;
+	int buflen;
+};
+
 static const char *aas_print_string(int rc)
 {
 	rc &= 0x7f;
@@ -51,24 +57,25 @@ static const char *aas_print_string(int rc)
 }
 
 int
-get_alua_info(int fd)
+get_alua_info(int fd, struct alua_context *ct)
 {
 	int	rc;
-	int	tpg;
 
-	rc = get_target_port_group_support(fd);
-	if (rc < 0)
-		return -ALUA_PRIO_TPGS_FAILED;
+	if (ct->tpg_support <= 0 || ct->tpg < 0) {
+		ct->tpg_support = get_target_port_group_support(fd);
+		if (ct->tpg_support < 0)
+			return -ALUA_PRIO_TPGS_FAILED;
 
-	if (rc == TPGS_NONE)
-		return -ALUA_PRIO_NOT_SUPPORTED;
+		if (ct->tpg_support == TPGS_NONE)
+			return -ALUA_PRIO_NOT_SUPPORTED;
 
-	tpg = get_target_port_group(fd);
-	if (tpg < 0)
-		return -ALUA_PRIO_RTPG_FAILED;
+		ct->tpg = get_target_port_group(fd, &ct->buflen);
+		if (ct->tpg < 0)
+			return -ALUA_PRIO_RTPG_FAILED;
+	}
 
-	condlog(3, "reported target port group is %i", tpg);
-	rc = get_asymmetric_access_state(fd, tpg);
+	condlog(3, "reported target port group is %i", ct->tpg);
+	rc = get_asymmetric_access_state(fd, ct->tpg, &ct->buflen);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
 
@@ -86,7 +93,7 @@ int getprio (struct path * pp, char * args)
 	if (pp->fd < 0)
 		return -ALUA_PRIO_NO_INFORMATION;
 
-	rc = get_alua_info(pp->fd);
+	rc = get_alua_info(pp->fd, pp->prio.context);
 	if (rc >= 0) {
 		aas = (rc & 0x0f);
 		priopath = (rc & 0x80);
@@ -126,3 +133,28 @@ int getprio (struct path * pp, char * args)
 	}
 	return rc;
 }
+
+int initprio(struct prio *p)
+{
+	if (!p->context) {
+		struct alua_context *ct;
+
+		ct = malloc(sizeof(struct alua_context));
+		if (!ct)
+			return 1;
+		p->context = ct;
+	}
+	memset(p->context, 0, sizeof(struct alua_context));
+	return 0;
+}
+
+
+int freeprio(struct prio *p)
+{
+	if (p->context) {
+		free(p->context);
+		p->context = NULL;
+	}
+	return 0;
+}
+
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 6d04fc1..7ef2ef5 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -171,7 +171,7 @@ get_target_port_group_support(int fd)
 }
 
 int
-get_target_port_group(int fd)
+get_target_port_group(int fd, int *buflen_ptr)
 {
 	unsigned char		*buf;
 	struct vpd83_data *	vpd83;
@@ -179,7 +179,12 @@ get_target_port_group(int fd)
 	int			rc;
 	int			buflen, scsi_buflen;
 
-	buflen = 128; /* Lets start from 128 */
+	if (!buflen_ptr || *buflen_ptr == 0) {
+		buflen = 128; /* Lets start from 128 */
+		if (buflen_ptr)
+			*buflen_ptr = 128;
+	} else
+		buflen = *buflen_ptr;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG("malloc failed: could not allocate"
@@ -202,6 +207,8 @@ get_target_port_group(int fd)
 			return -RTPG_RTPG_FAILED;
 		}
 		buflen = scsi_buflen;
+		if (buflen_ptr)
+			*buflen_ptr = buflen;
 		memset(buf, 0, buflen);
 		rc = do_inquiry(fd, 1, 0x83, buf, buflen);
 		if (rc < 0)
@@ -269,7 +276,7 @@ do_rtpg(int fd, void* resp, long resplen)
 }
 
 int
-get_asymmetric_access_state(int fd, unsigned int tpg)
+get_asymmetric_access_state(int fd, unsigned int tpg, int *buflen_ptr)
 {
 	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
@@ -278,7 +285,12 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 	int			buflen;
 	uint32_t		scsi_buflen;
 
-	buflen = 128; /* Initial value from old code */
+	if (!buflen_ptr || *buflen_ptr == 0) {
+		buflen = 128; /* Initial value from old code */
+		if (buflen_ptr)
+			*buflen_ptr = 128;
+	} else
+		buflen = *buflen_ptr;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG ("malloc failed: could not allocate"
@@ -299,6 +311,8 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 			return -RTPG_RTPG_FAILED;
 		}
 		buflen = scsi_buflen;
+		if (buflen_ptr)
+			*buflen_ptr = buflen;
 		memset(buf, 0, buflen);
 		rc = do_rtpg(fd, buf, buflen);
 		if (rc < 0)
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index c43e0a9..cade64d 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -23,8 +23,8 @@
 #define RTPG_TPG_NOT_FOUND			4
 
 int get_target_port_group_support(int fd);
-int get_target_port_group(int fd);
-int get_asymmetric_access_state(int fd, unsigned int tpg);
+int get_target_port_group(int fd, int *buflen_ptr);
+int get_asymmetric_access_state(int fd, unsigned int tpg, int *buflen_ptr);
 
 #endif /* __RTPG_H__ */
 
diff --git a/libmultipath/prioritizers/const.c b/libmultipath/prioritizers/const.c
index bf689cd..362d4e1 100644
--- a/libmultipath/prioritizers/const.c
+++ b/libmultipath/prioritizers/const.c
@@ -1,8 +1,12 @@
 #include <stdio.h>
 
 #include <prio.h>
+#include "def_func.h"
 
 int getprio (struct path * pp, char * args)
 {
 	return 1;
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index e3e6a51..c2f0d0b 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -25,6 +25,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
@@ -111,3 +112,5 @@ int getprio (struct path * pp, char * args)
         return datacore_prio(pp->dev, pp->fd, args);
 }
 
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/def_func.h b/libmultipath/prioritizers/def_func.h
new file mode 100644
index 0000000..8976b3f
--- /dev/null
+++ b/libmultipath/prioritizers/def_func.h
@@ -0,0 +1,11 @@
+#ifndef _DEF_FUNC_H
+#define _DEF_FUNC_H
+
+#include "prio.h"
+
+#define declare_nop_prio(name)						\
+int name (struct prio *p)						\
+{									\
+	return 0;							\
+}
+#endif /* _DEF_FUNC_H */
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index e49809c..448528f 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -6,6 +6,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -85,3 +86,6 @@ int getprio (struct path * pp, char * args)
 {
 	return emc_clariion_prio(pp->dev, pp->fd);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 8043b5b..292fe1c 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -76,6 +76,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define INQ_REPLY_LEN 255
 #define INQ_CMD_CODE 0x12
@@ -170,3 +171,6 @@ int getprio (struct path * pp, char * args)
 {
 	return hds_modular_prio(pp->dev, pp->fd);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 4950cf7..371d766 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -16,6 +16,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define TUR_CMD_LEN		6
 #define SCSI_CHECK_CONDITION	0x2
@@ -99,3 +100,6 @@ int getprio (struct path * pp, char * args)
 {
 	return hp_sw_prio(pp->dev, pp->fd);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 0bcc48b..a6b73d5 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -9,6 +9,7 @@
 #include <debug.h>
 #include <unistd.h>
 #include <structs.h>
+#include "def_func.h"
 
 //
 // This prioritizer suits iSCSI needs, makes it possible to prefer one path.
@@ -141,3 +142,6 @@ int getprio(struct path * pp, char * args)
 {
 	return iet_prio(pp->dev, args);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 5e82a17..c556e3b 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -23,6 +23,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define INQUIRY_CMD	0x12
 #define INQUIRY_CMDLEN	6
@@ -245,3 +246,6 @@ int getprio (struct path * pp, char * args)
 {
 	return ontap_prio(pp->dev, pp->fd);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/random.c b/libmultipath/prioritizers/random.c
index 281a0d1..c38b0f6 100644
--- a/libmultipath/prioritizers/random.c
+++ b/libmultipath/prioritizers/random.c
@@ -4,6 +4,7 @@
 #include <time.h>
 
 #include <prio.h>
+#include "def_func.h"
 
 int getprio (struct path * pp, char * args)
 {
@@ -13,3 +14,6 @@ int getprio (struct path * pp, char * args)
 	srand((unsigned int)tv.tv_usec);
 	return 1+(int) (10.0*rand()/(RAND_MAX+1.0));
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index a210055..1fc302f 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -6,6 +6,7 @@
 #include <debug.h>
 #include <prio.h>
 #include <structs.h>
+#include "def_func.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -95,3 +96,6 @@ int getprio (struct path * pp, char * args)
 {
 	return rdac_prio(pp->dev, pp->fd);
 }
+
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 13bc52f..1c3f821 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -32,6 +32,7 @@
 #include <memory.h>
 #include <debug.h>
 #include <regex.h>
+#include "def_func.h"
 
 char *get_next_string(char **temp, char *split_char)
 {
@@ -104,3 +105,5 @@ int getprio(struct path *pp, char *args)
 	return prio_path_weight(pp, args);
 }
 
+declare_nop_prio(initprio)
+declare_nop_prio(freeprio)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f64d5e4..347cc66 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -376,10 +376,10 @@ detect_prio(struct path * pp)
 
 	if (get_target_port_group_support(pp->fd) <= 0)
 		return;
-	ret = get_target_port_group(pp->fd);
+	ret = get_target_port_group(pp->fd, NULL);
 	if (ret < 0)
 		return;
-	if (get_asymmetric_access_state(pp->fd, ret) < 0)
+	if (get_asymmetric_access_state(pp->fd, ret, NULL) < 0)
 		return;
 	prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index f876258..360a584 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -721,20 +721,23 @@ static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int ro, retval = 0;
+	struct path * pp;
+
+	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+	if (!pp) {
+		condlog(0, "%s: spurious uevent, path not found",
+			uev->kernel);
+		return 1;
+	}
+	/* reinit the prio values on change event, in case something is
+	 * different */
+	prio_init(&pp->prio);
 
 	ro = uevent_get_disk_ro(uev);
 
 	if (ro >= 0) {
-		struct path * pp;
-
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
 			uev->kernel, ro);
-		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-		if (!pp) {
-			condlog(0, "%s: spurious uevent, path not found",
-				uev->kernel);
-			return 1;
-		}
 		if (pp->mpp) {
 			retval = reload_map(vecs, pp->mpp, 0);
 
@@ -1272,6 +1275,7 @@ check_path (struct vectors * vecs, struct path * pp)
 		}
 
 		if(newstate == PATH_UP || newstate == PATH_GHOST){
+			prio_init(&pp->prio);
 			if ( pp->mpp && pp->mpp->prflag ){
 				/*
 				 * Check Persistent Reservation.
@@ -1308,7 +1312,9 @@ check_path (struct vectors * vecs, struct path * pp)
 
 		/*
 		 * if at least one path is up in a group, and
-		 * the group is disabled, re-enable it
+		 * the group is disabled, re-enable it.
+		 * Reinitialize the prioritizer, in case something
+		 * changed.
 		 */
 		if (newstate == PATH_UP)
 			enable_group(pp);
-- 
1.8.3.1
