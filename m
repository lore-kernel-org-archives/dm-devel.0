From: Hannes Reinecke <hare@suse.de>
Subject: directio path-checker for multipath-tools
Date: Thu, 11 Aug 2005 16:44:23 +0200
Message-ID: <42FB6447.8000105@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070005010902010004050208"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070005010902010004050208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

I've implemented yet another path checker, based on O_DIRECT.
Rationale: On S/390 it's possible to activate multipath support for DASD
devices (called Parallel Access Volume (PAV)). As these are no SCSI
devices the readsector0 path checker wouldn't work.
And as this checker is quite generic it'll work for just about anybody.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070005010902010004050208
Content-Type: text/x-patch;
 name="multipath-tools-directio-checker.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multipath-tools-directio-checker.patch"

diff -purN multipath-tools-0.4.4.orig/libcheckers/checkers.h multipath-tools-0.4.4/libcheckers/checkers.h
--- multipath-tools-0.4.4.orig/libcheckers/checkers.h	2005-03-29 16:21:40.000000000 +0200
+++ multipath-tools-0.4.4/libcheckers/checkers.h	2005-08-04 15:20:52.000000000 +0200
@@ -9,6 +9,7 @@ enum checkers {
 	CHECKER_RESERVED,
 	TUR,
 	READSECTOR0,
+	DIRECTIO,
 	EMC_CLARIION,
	HP_SW
 };
@@ -20,6 +21,7 @@ void *get_checker_addr (int);
 int get_checker_name (char *, int);
 
 int emc_clariion (int fd, char * msg, void ** ctxt);
+int directio (int fd, char * msg, void ** ctxt);
 int readsector0 (int fd, char * msg, void ** ctxt);
 int tur (int fd, char * msg, void ** ctxt);
 
diff -purN multipath-tools-0.4.4.orig/libcheckers/directio.c multipath-tools-0.4.4/libcheckers/directio.c
--- multipath-tools-0.4.4.orig/libcheckers/directio.c	1970-01-01 01:00:00.000000000 +0100
+++ multipath-tools-0.4.4/libcheckers/directio.c	2005-08-04 15:19:10.000000000 +0200
@@ -0,0 +1,165 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+#include <errno.h>
+
+#include "path_state.h"
+#include "checkers.h"
+
+#define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
+#define MSG_DIRECTIO_UP		"directio checker reports path is up"
+#define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
+
+struct readsector0_checker_context {
+	void * dummy;
+};
+
+static int
+direct_read (int fd, unsigned char * buff, int size)
+{
+	long flags;
+	int reset_flags = 0;
+	int res, retval;
+
+	flags = fcntl(fd,F_GETFL);
+
+	if (flags < 0) {
+		return PATH_UNCHECKED;
+	}
+
+	if (!(flags & O_DIRECT)) {
+		flags |= O_DIRECT;
+		if (fcntl(fd,F_SETFL,flags) < 0) {
+			return PATH_UNCHECKED;
+		}
+		reset_flags = 1;
+	}
+
+	while ( (res = read(fd,buff,size)) < 0 && errno == EINTR );
+	if (res < 0) {
+		if (errno == EINVAL) {
+			/* O_DIRECT is not available */
+			retval = PATH_UNCHECKED;
+		} else if (errno == ENOMEM) {
+			retval = PATH_UP;
+		} else {
+			retval = PATH_DOWN;
+		}
+	} else {
+		retval = PATH_UP;
+	}
+	
+	if (reset_flags) {
+		flags &= ~O_DIRECT;
+		/* No point in checking for errors */
+		fcntl(fd,F_SETFL,flags);
+	}
+
+	return retval;
+}
+
+extern int
+directio (int fd, char *msg, void **context)
+{
+	unsigned char *buf, *ptr;
+	struct readsector0_checker_context * ctxt = NULL;
+	unsigned long pgsize, numsect;
+	int ret, blksize;
+
+	pgsize = getpagesize();
+	
+	/*
+	 * caller passed in a context : use its address
+	 */
+	if (context)
+		ctxt = (struct readsector0_checker_context *) (*context);
+
+	/*
+	 * passed in context is uninitialized or volatile context :
+	 * initialize it
+	 */
+	if (!ctxt) {
+		ctxt = malloc(sizeof(struct readsector0_checker_context));
+		memset(ctxt, 0, sizeof(struct readsector0_checker_context));
+
+		if (!ctxt) {
+			MSG("cannot allocate context");
+			return -1;
+		}
+		if (context)
+			*context = ctxt;
+	}
+	if (fd <= 0) {
+		MSG("no usable fd");
+		ret = -1;
+		goto out;
+	}
+	
+	if (ioctl(fd, BLKGETSIZE, &numsect) < 0) {
+		MSG("cannot get number of sectors, set default");
+		numsect = 0;
+	}
+
+	if (ioctl(fd, BLKBSZGET, &blksize) < 0) {
+		MSG("cannot get blocksize, set default");
+		blksize = 512;
+	}
+
+	if (blksize > 4096) {
+		/*
+		 * Sanity check for DASD; BSZGET is broken
+		 */
+		blksize = 4096;
+	}
+
+	if (!blksize) {
+		/*
+		 * Blocksize is 0, assume we can't write
+		 * to this device.
+		 */
+		MSG(MSG_DIRECTIO_DOWN);
+		ret = PATH_DOWN;
+		goto out;
+	}
+
+	buf = (unsigned char *)malloc(blksize + pgsize);
+	if (!buf){
+		goto out;
+	}
+	ptr = (char *)(((unsigned long)buf + pgsize - 1) &
+				(~(pgsize - 1))); 
+	ret = direct_read(fd, ptr, blksize);
+
+	switch (ret)
+	{
+	case PATH_UNCHECKED:
+		MSG(MSG_DIRECTIO_UNKNOWN);
+		break;
+	case PATH_DOWN:
+		MSG(MSG_DIRECTIO_DOWN);
+		break;
+	case PATH_UP:
+		MSG(MSG_DIRECTIO_UP);
+		break;
+	default:
+		break;
+	}
+	free(buf);
+
+out:
+	/*
+	 * caller told us he doesn't want to keep the context :
+	 * free it
+	 */
+	if (!context)
+		free(ctxt);
+
+	return ret;
+}
diff -purN multipath-tools-0.4.4.orig/libcheckers/Makefile multipath-tools-0.4.4/libcheckers/Makefile
--- multipath-tools-0.4.4.orig/libcheckers/Makefile	2005-04-04 12:09:58.000000000 +0200
+++ multipath-tools-0.4.4/libcheckers/Makefile	2005-08-04 15:19:20.000000000 +0200
@@ -6,7 +6,7 @@ BUILD = glibc
 
 include ../Makefile.inc
 
-OBJS = readsector0.o tur.o selector.o emc_clariion.o hp_sw.o
+OBJS = readsector0.o tur.o selector.o directio.o emc_clariion.o hp_sw.o
 
 all: $(BUILD)
 
diff -purN multipath-tools-0.4.4.orig/libcheckers/selector.c multipath-tools-0.4.4/libcheckers/selector.c
--- multipath-tools-0.4.4.orig/libcheckers/selector.c	2005-03-29 16:27:46.000000000 +0200
+++ multipath-tools-0.4.4/libcheckers/selector.c	2005-08-04 15:20:27.000000000 +0200
@@ -10,6 +10,8 @@ get_checker_id (char * str)
 		return TUR;
 	if (0 == strncmp(str, "readsector0", 11))
 		return READSECTOR0;
+ 	if (0 == strncmp(str, "directio", 8))
+		return DIRECTIO;
  	if (0 == strncmp(str, "emc_clariion", 12))
 		return EMC_CLARIION;
 	return -1;
@@ -27,6 +29,9 @@ get_checker_addr (int id)
 	case READSECTOR0:
 		checker = &readsector0;
 		break;
+	case DIRECTIO:
+		checker = &directio;
+		break;
 	case EMC_CLARIION:
 		checker = &emc_clariion;
 		break;
@@ -49,6 +54,9 @@ get_checker_name (char * str, int id)
 	case READSECTOR0:
 		s = "readsector0";
 		break;
+	case DIRECTIO:
+		s = "directio";
+		break;
 	case EMC_CLARIION:
 		s = "emc_clariion";
 		break;

--------------070005010902010004050208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070005010902010004050208--
