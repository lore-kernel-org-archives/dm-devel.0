From: Edward Goggin <egoggin@emc.com>
Subject: patch for handling CLARiiON I/O to inactive snapshot
	logical units
Date: Fri, 10 Nov 2006 14:58:15 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D152B@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe,

Here is my 2nd attempt at a patch which attempts to prevent an I/O hang
which can occur with host I/O to an inactive CLARiiON snapshot logical
unit.  While the inactive snapshot LU is presented to a host, inquiry,
TUR, and read capacity commands succeed, but read and write commands are
failed.  Complicating the matter is the fact that read/write to the
active paths fails with a particular sense code/asc/ascq combination
while read/write to the passive paths does not.

Unlike the previous patch, I've tried to make this one CLARiiON
specific.  Two exceptions though.  First, I did keep the change to
libcheckers/readsector0.c to allow other checkers than readsector0 to
use sg_read().  Second, I changed libmultipath/discovery.c to allow
pathinfo() to invoke the path priority callout function of a path with a
path state of PATH_DOWN since some paths (e.g., paths to inactive
snapshot LU on CLARiiON) may have their state set to PATH_DOWN for
reasons other than transport connectivity failure.  Without the latter
change, it is possible to create a situation whereby there are paths of
different priorities in the same path group even though the path group
policy is priority based grouping.  This is certainly the case for paths
to a multipath mapped device for an inactive snapshot CLARiiON LUs when
the paths change to a healthy state as soon as the snapshot is
activated.

Thanks,

Ed Goggin


diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
index a883e3d..1539921 100644
--- a/libcheckers/emc_clariion.c
+++ b/libcheckers/emc_clariion.c
@@ -10,10 +10,13 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <errno.h>
+#include <pthread.h>
=20
 #include "checkers.h"
=20
 #include "../libmultipath/sg_include.h"
+#include "../libmultipath/vector.h"
+#include "../libmultipath/debug.h"
=20
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -22,31 +25,285 @@
 struct emc_clariion_checker_context {
 	char wwn[16];
 	unsigned wwn_set;
+	dev_t rdev;
 };
=20
+/*
+ * Mechanism to track active and passive CLARiiON paths to inactive
+ * CLARiiON snapshot LUs.  This is done so that we can fail passive
paths
+ * to an inactive snapshot LU even though the read test contained
herein
+ * will return 02/04/03 instead of 05/25/01 sense code/ASC/ASCQ data.
+ */
+int sg_read (int sg_fd, unsigned char * buff, unsigned char *
senseBuff);
+
+/*
+ * Entry in fwwn_vec for each inactive snapshot LU.  path_vec vector
contains
+ * dev_t entries for each path to the LU.
+ */
+typedef struct fwwne {
+	char wwn[16];		/* WWN of inactive snapshot LU */
+	vector path_vec;	/* array of paths to this LU */
+} fwwne;
+vector fwwn_vec =3D NULL;		/* vector of inactive snapshot
LUs */
+pthread_mutex_t fwwn_mutex =3D PTHREAD_MUTEX_INITIALIZER;
+
+#define WWN_SIZE			16
+#define INIT_WWN(dwwn, swwn)		memcpy(dwwn, swwn, WWN_SIZE)
+#define	MATCH_WWNS(wwn1, wwn2)		(memcmp(wwn1, wwn2,
WWN_SIZE) =3D=3D 0)
+
+#define INIT_PATH(dpath, spath)		memcpy(dpath, spath,
sizeof(dev_t))
+#define MATCH_PATHS(rdev1, rdev2)	(memcmp(rdev1, rdev2, \
+					        sizeof(dev_t)) =3D=3D 0)
+
+/*
+ * Setup LU and path associated with this path checker to be known as
an
+ * inactive snapshot LU and path to same.
+ */
+void failwwn(struct checker *c)
+{
+	struct emc_clariion_checker_context * ct =3D
+		(struct emc_clariion_checker_context *)c->context;
+	char *wwn =3D ct->wwn;
+	vector path_vec;
+	fwwne *fp;
+	dev_t *pp;
+	int i, j;
+
+	pthread_mutex_lock(&fwwn_mutex);
+	if (fwwn_vec) {
+		vector_foreach_slot(fwwn_vec, fp, i) {
+			/*
+			 * Check for already known inactive snapshot LU.
+			 */
+			if (MATCH_WWNS(fp->wwn, wwn)) {
+				path_vec =3D fp->path_vec;
+				vector_foreach_slot(path_vec, pp, j) {
+					/*
+					 * Check for already known path
+					 * to already known inactive
+					 * snapshot LU.
+					 */
+					if (MATCH_PATHS(pp, &ct->rdev))
{
+						pthread_mutex_unlock(
+							&fwwn_mutex);
+						return;
+					}
+				}
+				/*
+				 * Identify new path to already known
+				 * inactive snapshot LU.
+				 */
+				if (vector_alloc_slot(path_vec)) {
+					vector_set_slot(path_vec,
&ct->rdev);
+					condlog(4, "failwwn %s count is
%d.\n",
+						wwn,
VECTOR_SIZE(path_vec));
+				}
+				pthread_mutex_unlock(&fwwn_mutex);
+				return;
+			}
+		}
+	} else {
+		/*
+	   	 * Allocate the inactive snapshot LU vector.
+		 */
+		fwwn_vec =3D vector_alloc();
+		if (fwwn_vec =3D=3D 0) {
+			pthread_mutex_unlock(&fwwn_mutex);
+			return;
+		}
+	}
+
+	/*
+	 * Allocate the path vector for this inactive snapshot LU.
+	 */
+	path_vec =3D vector_alloc();
+	if (path_vec =3D=3D 0) {
+		pthread_mutex_unlock(&fwwn_mutex);
+		return;
+	}
+	if (!vector_alloc_slot(path_vec)) {
+		vector_free(path_vec);
+		pthread_mutex_unlock(&fwwn_mutex);
+		return;
+	}
+	vector_set_slot(path_vec, &ct->rdev);
+
+	/*
+	 * Allocate the inactive snapshot vector entry itself.
+	 */
+	fp =3D malloc(sizeof(fwwne));
+	if (fp =3D=3D 0) {
+		vector_free(path_vec);
+		pthread_mutex_unlock(&fwwn_mutex);
+		return;
+	}
+	if (!vector_alloc_slot(fwwn_vec)) {
+		free(fp);
+		vector_free(path_vec);
+		pthread_mutex_unlock(&fwwn_mutex);
+		return;
+	}
+
+	/*
+	 * Initialize fields and link to the vector.
+	 */
+	INIT_WWN(fp->wwn, wwn);
+	fp->path_vec =3D path_vec;
+	vector_set_slot(fwwn_vec, fp);
+
+	condlog(4, "failwwn %s count is %d.\n", wwn,
VECTOR_SIZE(fp->path_vec));
+	pthread_mutex_unlock(&fwwn_mutex);
+	return;
+}
+
+/*
+ * Determine if the LU and path associated with this path checker are
already
+ * associated with an-active snapshot LU.
+ */
+int findwwn(struct checker *c)
+{
+	struct emc_clariion_checker_context * ct =3D
+		(struct emc_clariion_checker_context *)c->context;
+	char *wwn =3D ct->wwn;
+	vector path_vec;
+	fwwne *fp;
+	dev_t *pp;
+	int i, j;
+
+	pthread_mutex_lock(&fwwn_mutex);
+	if (fwwn_vec) {
+		vector_foreach_slot(fwwn_vec, fp, i) {
+			/*
+			 * Check for already known inactive snapshot LU.
+			 */
+			if (MATCH_WWNS(fp->wwn, wwn)) {
+				path_vec =3D fp->path_vec;
+				vector_foreach_slot(path_vec, pp, j) {
+					/*
+					 * Check for already known path
+					 * to already known inactive
+					 * snapshot LU.
+					 */
+					if (MATCH_PATHS(pp, &ct->rdev))
{
+						pthread_mutex_unlock(
+							&fwwn_mutex);
+						return 1;
+					}
+				}
+				/*
+				 * Identify new path to already known
+				 * inactive snapshot LU.
+				 */
+				if (vector_alloc_slot(path_vec)) {
+					vector_set_slot(path_vec,
&ct->rdev);
+					condlog(4, "failwwn %s count is
%d.\n",
+						wwn,
VECTOR_SIZE(path_vec));
+				}
+				pthread_mutex_unlock(&fwwn_mutex);
+				return 1;
+			}
+		}
+	}
+	pthread_mutex_unlock(&fwwn_mutex);
+	return 0;
+}
+
+#define UNFAILWWN(c) unfailwwnpath(c, 0)
+#define UNFAILWWNPATH(c) unfailwwnpath(c, 1)
+
+/*
+ * Remove LU and path associated with this path checker as
+ * inactive snapshot LU and path to same.
+ */
+void unfailwwnpath(struct checker *c, int match_paths)
+{
+	struct emc_clariion_checker_context * ct =3D
+		(struct emc_clariion_checker_context *)c->context;
+	char *wwn =3D ct->wwn;
+	vector path_vec;
+	fwwne *fp;
+	dev_t *pp;
+	int i, j;
+
+	pthread_mutex_lock(&fwwn_mutex);
+	if (fwwn_vec) {
+		vector_foreach_slot(fwwn_vec, fp, i) {
+			/*
+			 * Check for already known inactive snapshot LU.
+			 */
+			if (MATCH_WWNS(fp->wwn, wwn)) {
+				path_vec =3D fp->path_vec;
+				vector_foreach_slot(path_vec, pp, j) {
+					/*
+					 * Check for already known path
+					 * to already known inactive
+					 * snapshot LU.
+					 */
+					if (!match_paths ||
+					    MATCH_PATHS(pp, &ct->rdev))
{
+
vector_del_slot(path_vec, j);
+						condlog(4, "unfailwwn %s
"
+							"count is
%d.\n",
+							wwn,
+
VECTOR_SIZE(path_vec));
+						if (match_paths)
+							break;
+					}
+				}
+				if (VECTOR_SIZE(path_vec) =3D=3D 0) {
+					vector_del_slot(fwwn_vec, i);
+					free(fp);
+					vector_free(path_vec);
+
pthread_mutex_unlock(&fwwn_mutex);
+					condlog(4, "unfailwwn de-alloc "
+						"%s.\n", wwn);
+				}
+				pthread_mutex_unlock(&fwwn_mutex);
+				return;
+			}
+		}
+	}
+	pthread_mutex_unlock(&fwwn_mutex);
+	return;
+}
+
 int emc_clariion_init (struct checker * c)
 {
+	struct stat stat;
+	int err;
+
 	c->context =3D malloc(sizeof(struct
emc_clariion_checker_context));
 	if (!c->context)
 		return 1;
 	((struct emc_clariion_checker_context *)c->context)->wwn_set =3D
0;
+
+	err =3D fstat(c->fd, &stat);
+	if (err =3D=3D 0) {
+		INIT_PATH(&((struct emc_clariion_checker_context *)
+			   c->context)->rdev, &stat.st_rdev);
+	}
+
 	return 0;
 }
=20
 void emc_clariion_free (struct checker * c)
 {
+	UNFAILWWNPATH(c);
 	free(c->context);
 }
=20
 int emc_clariion(struct checker * c)
 {
-	unsigned char sense_buffer[256] =3D { 0, };
+	unsigned char sense_buffer[256] =3D { 0, }, *sbb;
 	unsigned char sb[128] =3D { 0, };
+	unsigned char buf[512];
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] =3D {INQUIRY_CMD, 1, 0xC0,
0,
 						sizeof(sb), 0};
 	struct sg_io_hdr io_hdr;
 	struct emc_clariion_checker_context * ct =3D
 		(struct emc_clariion_checker_context *)c->context;
+	int ret;
+	int retry_count=3D3;
=20
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	io_hdr.interface_id =3D 'S';
@@ -69,7 +326,8 @@ int emc_clariion(struct checker * c)
 	}
 	if (/* Verify the code page - right page & revision */
 	    sense_buffer[1] !=3D 0xc0 || sense_buffer[9] !=3D 0x00) {
-		MSG(c, "emc_clariion_checker: Path unit report page in
unknown format");
+		MSG(c, "emc_clariion_checker: Path unit report page in "
+		    "unknown format");
 		return PATH_DOWN;
 	}
=20
@@ -79,13 +337,15 @@ int emc_clariion(struct checker * c)
 		|| (sense_buffer[28] & 0x07) !=3D 0x04
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) !=3D 0x04) {
-		MSG(c, "emc_clariion_checker: Path not correctly
configured for failover");
+		MSG(c, "emc_clariion_checker: Path not correctly "
+		    "configured for failover");
 		return PATH_DOWN;
 	}
=20
 	if ( /* LUN operations should indicate normal operations */
 		sense_buffer[48] !=3D 0x00) {
-		MSG(c, "emc_clariion_checker: Path not available for
normal operations");
+		MSG(c, "emc_clariion_checker: Path not available for "
+		    "normal operations");
 		return PATH_SHAKY;
 	}
=20
@@ -102,15 +362,76 @@ int emc_clariion(struct checker * c)
 	 */
 	if (ct->wwn_set) {
 		if (memcmp(ct->wwn, &sense_buffer[10], 16) !=3D 0) {
-			MSG(c, "emc_clariion_checker: Logical Unit WWN
has changed!");
+			MSG(c, "emc_clariion_checker: Logical Unit WWN "
+			    "has changed!");
 			return PATH_DOWN;
 		}
 	} else {
 		memcpy(ct->wwn, &sense_buffer[10], 16);
 		ct->wwn_set =3D 1;
 	}
-=09
-=09
-	MSG(c, "emc_clariion_checker: Path healthy");
-        return PATH_UP;
+
+retry:=09
+	memset(sense_buffer, 0, sizeof(sense_buffer));
+	ret =3D sg_read(c->fd, &buf[0], sbb =3D &sense_buffer[0]);
+	if (ret =3D=3D PATH_DOWN) {
+		char str[256];
+
+		condlog(4, "emc_clariion_checker: Read error for "
+			"(0x%llx), sense data are 0x%x/0x%x/0x%x",
+			ct->rdev, sbb[2]&0xf, sbb[12], sbb[13]);
+
+		/*
+		 * Check for inactive snapshot lu this way.  Must fail
these.
+	 	 */
+		if (((sbb[2]&0xf) =3D=3D 5) && (sbb[12] =3D=3D 0x25) &&
(sbb[13]=3D=3D1)) {
+			/*
+			 * Do this so that we can fail even the passive
paths
+			 * which will return 02/04/03 not 05/25/01.
+			 */
+			failwwn(c);
+			sprintf(str, "emc_clariion_checker: Active path
"
+				"(0x%llx) to inactive snapshot.",
ct->rdev);
+			MSG(c, str);
+		}
+		/*
+	  	 * Check for passive/standby path this way.  Must OK
these
+		 * as long as not path to inactive snapshot LU.
+		 */
+		else if (((sbb[2]&0xf)=3D=3D2) && (sbb[12]=3D=3D4) &&
(sbb[13]=3D=3D3)) {
+			if (findwwn(c)) {
+				MSG(c, "emc_clariion_checker: Passive
path "
+				    "to inactive snapshot.");
+			} else {
+				MSG(c,
+			    "emc_clariion_checker: Passive path is
healthy.");
+				ret =3D PATH_UP;	/* not ghost */
+			}
+		} else {
+			sprintf(str, "emc_clariion_checker: Read error
for "
+				"(0x%llx), sense data are
0x%x/0x%x/0x%x",
+				ct->rdev, sbb[2]&0xf, sbb[12], sbb[13]);
+			MSG(c, str);
+			/*
+			 * Retry if UNIT_ATTENTION check condition since
+			 * this likely indicates a path group
re-assignment
+			 * operation (trespass) took place.
+			 */
+			if (((sbb[2]&0xf) =3D=3D 6) && (sbb[12] =3D=3D 0x29) &&
+			    (sbb[13]=3D=3D0)) {
+				if (--retry_count)
+					goto retry;
+			}
+		}
+	} else {
+		MSG(c, "emc_clariion_checker: Active path is healthy.");
+		/*
+		 * Remove the path from the set of paths to inactive
+		 * snapshot LUs if it was in this list since the
snapshot
+		 * is no longer inactive.
+		 */
+		UNFAILWWN(c);
+	}
+
+	return ret;
 }
diff --git a/libcheckers/readsector0.c b/libcheckers/readsector0.c
index b0acec9..dd18528 100644
--- a/libcheckers/readsector0.c
+++ b/libcheckers/readsector0.c
@@ -34,8 +34,8 @@ void readsector0_free (struct checker *=20
 	return;
 }
=20
-static int
-sg_read (int sg_fd, unsigned char * buff)
+int
+sg_read (int sg_fd, unsigned char * buff, unsigned char * senseBuff)
 {
 	/* defaults */
 	int blocks =3D 1;
@@ -45,7 +45,6 @@ sg_read (int sg_fd, unsigned char * buff
 	int * diop =3D NULL;
=20
 	unsigned char rdCmd[cdbsz];
-	unsigned char senseBuff[SENSE_BUFF_LEN];
 	struct sg_io_hdr io_hdr;
 	int res;
 	int rd_opcode[] =3D {0x8, 0x28, 0xa8, 0x88};
@@ -97,9 +96,10 @@ extern int
 readsector0 (struct checker * c)
 {
 	unsigned char buf[512];
+	unsigned char sbuf[SENSE_BUFF_LEN];
 	int ret;
=20
-	ret =3D sg_read(c->fd, &buf[0]);
+	ret =3D sg_read(c->fd, &buf[0], &sbuf[0]);
=20
 	switch (ret)
 	{
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index efc2016..15fe89b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -701,7 +701,14 @@ pathinfo (struct path *pp, vector hwtabl
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 =09
-	if (mask & DI_PRIO && pp->state !=3D PATH_DOWN)
+
+	/*
+	 * Path state of PATH_DOWN does not necessarily prevent
+	 * path priority callout (or getuid callouot) from
+	 * succeeding since the path may be being considered
+	 * failed for reasons other than transport connectivity.
+	 */
+	if (mask & DI_PRIO /*&& pp->state !=3D PATH_DOWN*/)
 		get_prio(pp);
=20
 	if (mask & DI_WWID && !strlen(pp->wwid))
