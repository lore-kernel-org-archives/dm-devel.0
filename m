From: bmarzins@sourceware.org
Subject: multipath-tools/libcheckers directio.c
Date: 26 Jul 2007 19:27:15 -0000
Message-ID: <20070726192715.27202.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-07-26 19:27:14

Modified files:
	libcheckers    : directio.c 

Log message:
	Fix for #235081. Now using async directio callout.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/directio.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1

--- multipath-tools/libcheckers/directio.c	2005/11/16 20:24:57	1.2
+++ multipath-tools/libcheckers/directio.c	2007/07/26 19:27:13	1.2.2.1
@@ -12,90 +12,149 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <errno.h>
+#include <linux/kdev_t.h>
+#include <asm/unistd.h>
 
+#include "libaio.h"
 #include "path_state.h"
 #include "checkers.h"
+#include "../libmultipath/debug.h"
 
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
 #define MSG_DIRECTIO_UP		"directio checker reports path is up"
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
 
-struct readsector0_checker_context {
-	void * dummy;
+struct directio_context {
+	int             running;
+	int             blksize;
+	unsigned char * buf;
+	unsigned char * ptr;
+	io_context_t    ioctx;
+	struct iocb     io;
 };
 
 static int
-direct_read (int fd, unsigned char * buff, int size)
+check_state(int fd, struct directio_context *ct)
 {
 	long flags;
 	int reset_flags = 0;
-	int res, retval;
+	struct timespec timeout = { .tv_sec = 2 };
+	struct io_event event;
+	struct stat     sb;
+	int             rc = PATH_UNCHECKED;
+	long            r;
 
-	flags = fcntl(fd,F_GETFL);
-
-	if (flags < 0) {
-		return PATH_UNCHECKED;
-	}
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		goto out;
 
 	if (!(flags & O_DIRECT)) {
 		flags |= O_DIRECT;
-		if (fcntl(fd,F_SETFL,flags) < 0) {
-			return PATH_UNCHECKED;
-		}
+		if (fcntl(fd, F_SETFL, flags) < 0)
+			goto out;
 		reset_flags = 1;
 	}
 
-	while ( (res = read(fd,buff,size)) < 0 && errno == EINTR );
-	if (res < 0) {
-		if (errno == EINVAL) {
-			/* O_DIRECT is not available */
-			retval = PATH_UNCHECKED;
-		} else if (errno == ENOMEM) {
-			retval = PATH_UP;
-		} else {
-			retval = PATH_DOWN;
+	if (fstat(fd, &sb) == 0) {
+		condlog(4, "directio: called for %x", (unsigned) sb.st_rdev);
+	}
+
+	if (!ct->running) {
+		struct iocb *ios[1] = { &ct->io };
+
+		condlog(3, "directio: starting new request");
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
+		if (syscall(__NR_io_submit, ct->ioctx, 1, ios) != 1) {
+			condlog(3, "directio: io_submit error %i", errno);
+			rc = PATH_UNCHECKED;
+			goto out;
 		}
+	}
+	ct->running = 1;
+
+	r = syscall(__NR_io_getevents, ct->ioctx, 1L, 1L, &event, &timeout);
+	if (r < 1L) {
+		condlog(3, "directio: timeout r=%li errno=%i", r, errno);
+		rc = PATH_DOWN;
 	} else {
-		retval = PATH_UP;
+		condlog(3, "directio: io finished %lu/%lu", event.res,
+				event.res2);
+		ct->running = 0;
+		rc = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
 	}
-	
+
+out:
 	if (reset_flags) {
 		flags &= ~O_DIRECT;
 		/* No point in checking for errors */
-		fcntl(fd,F_SETFL,flags);
+		fcntl(fd, F_SETFL, flags);
 	}
+	return rc;
+}
 
-	return retval;
+void
+cleanup_context (struct directio_context *ctxt)
+{
+	if (ctxt->buf)
+		free(ctxt->buf);
+	syscall(__NR_io_destroy, ctxt->ioctx);
+	free(ctxt);
 }
 
 extern int
 directio (int fd, char *msg, void **context)
 {
-	unsigned char *buf, *ptr;
-	struct readsector0_checker_context * ctxt = NULL;
-	unsigned long pgsize, numsect;
-	int ret, blksize;
-
-	pgsize = getpagesize();
+	struct directio_context * ctxt = NULL;
+	int ret;
 	
 	/*
 	 * caller passed in a context : use its address
 	 */
 	if (context)
-		ctxt = (struct readsector0_checker_context *) (*context);
+		ctxt = (struct directio_context *) (*context);
 
 	/*
 	 * passed in context is uninitialized or volatile context :
 	 * initialize it
 	 */
 	if (!ctxt) {
-		ctxt = malloc(sizeof(struct readsector0_checker_context));
-		memset(ctxt, 0, sizeof(struct readsector0_checker_context));
-
+		unsigned long pgsize = getpagesize();
+	
+		ctxt = malloc(sizeof(struct directio_context));
 		if (!ctxt) {
-			MSG("cannot allocate context");
-			return -1;
+			condlog(0, "cannot allocate context");
+			goto fail;
+		}
+		memset(ctxt, 0, sizeof(struct directio_context));
+		if (syscall(__NR_io_setup, 1, &ctxt->ioctx) != 0) {
+			condlog(0, "io_setup failed");
+			goto fail;
+		}
+		if (ioctl(fd, BLKBSZGET, &ctxt->blksize) < 0) {
+			condlog(3, "cannot get blocksize, set default");
+			ctxt->blksize = 512;
 		}
+		if (ctxt->blksize > 4096) {
+			/*
+			 * Sanity check for DASD; BSZGET is broken
+			 */
+			ctxt->blksize = 4096;
+		}
+		if (!ctxt->blksize){
+			condlog(3, "blocksize is zero? Assuming path down\n");
+			MSG(MSG_DIRECTIO_DOWN);
+			ret = PATH_DOWN;
+			goto out;
+		}
+		ctxt->buf = (unsigned char *)malloc(ctxt->blksize + pgsize);
+		if (!ctxt->buf){
+			condlog(0, "cannot allocate context buffer\n");
+			goto fail;
+		}
+
+		ctxt->ptr = (unsigned char *) (((unsigned long)ctxt->buf + pgsize - 1) & (~(pgsize - 1)));
+
 		if (context)
 			*context = ctxt;
 	}
@@ -104,41 +163,7 @@
 		ret = -1;
 		goto out;
 	}
-	
-	if (ioctl(fd, BLKGETSIZE, &numsect) < 0) {
-		MSG("cannot get number of sectors, set default");
-		numsect = 0;
-	}
-
-	if (ioctl(fd, BLKBSZGET, &blksize) < 0) {
-		MSG("cannot get blocksize, set default");
-		blksize = 512;
-	}
-
-	if (blksize > 4096) {
-		/*
-		 * Sanity check for DASD; BSZGET is broken
-		 */
-		blksize = 4096;
-	}
-
-	if (!blksize) {
-		/*
-		 * Blocksize is 0, assume we can't write
-		 * to this device.
-		 */
-		MSG(MSG_DIRECTIO_DOWN);
-		ret = PATH_DOWN;
-		goto out;
-	}
-
-	buf = (unsigned char *)malloc(blksize + pgsize);
-	if (!buf){
-		goto out;
-	}
-	ptr = (unsigned char *)(((unsigned long)buf + pgsize - 1) &
-				(~(pgsize - 1))); 
-	ret = direct_read(fd, ptr, blksize);
+	ret = check_state(fd, ctxt);
 
 	switch (ret)
 	{
@@ -154,7 +179,6 @@
 	default:
 		break;
 	}
-	free(buf);
 
 out:
 	/*
@@ -162,7 +186,13 @@
 	 * free it
 	 */
 	if (!context)
-		free(ctxt);
+		cleanup_context(ctxt);
 
 	return ret;
+fail:
+	if (context)
+		*context = NULL;
+	if (ctxt)
+		cleanup_context(ctxt);
+	return -1;
 }
