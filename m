From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 9/21] [libcheckers] use async I/O for directio
	checker
Date: Mon, 21 May 2007 11:23:49 +0200
Message-ID: <20070521092349.26C4AD44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


The directio checker will block until the request is returned.
We should rather use async I/O to guarantee that the checker
will return after a certain time so as not to stall the entire
daemon.

Signed-off-by: Stefan Bader <bader@de.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libcheckers/directio.c |  119 ++++++++++++++++++--------
 libcheckers/libaio.h   |  222 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 303 insertions(+), 38 deletions(-)

diff --git a/libcheckers/directio.c b/libcheckers/directio.c
index b53c1c3..2251515 100644
--- a/libcheckers/directio.c
+++ b/libcheckers/directio.c
@@ -12,28 +12,44 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <errno.h>
+#include <linux/kdev_t.h>
+#include <asm/unistd.h>
 
+#include "libaio.h"
 #include "checkers.h"
+#include "../libmultipath/debug.h"
 
 #define MSG_DIRECTIO_UNKNOWN	"directio checker is not available"
 #define MSG_DIRECTIO_UP		"directio checker reports path is up"
 #define MSG_DIRECTIO_DOWN	"directio checker reports path is down"
 
 struct directio_context {
-	int blksize; 
-	unsigned char *buf;
-	unsigned char *ptr;
+	int		running;
+	int		reset_flags;
+	int		blksize;
+	unsigned char *	buf;
+	unsigned char * ptr;
+	io_context_t	ioctx;
+	struct iocb	io;
 };
 
+
 int directio_init (struct checker * c)
 {
 	unsigned long pgsize = getpagesize();
 	struct directio_context * ct;
+	long flags;
 
 	ct = malloc(sizeof(struct directio_context));
 	if (!ct)
 		return 1;
-	c->context = (void *)ct;
+	memset(ct, 0, sizeof(struct directio_context));
+
+	if (syscall(__NR_io_setup, 1, &ct->ioctx) != 0) {
+		condlog(1, "io_setup failed");
+		free(ct);
+		return 1;
+	}
 
 	if (ioctl(c->fd, BLKBSZGET, &ct->blksize) < 0) {
 		MSG(c, "cannot get blocksize, set default");
@@ -50,11 +66,28 @@ int directio_init (struct checker * c)
 	ct->buf = (unsigned char *)malloc(ct->blksize + pgsize);
 	if (!ct->buf)
 		goto out;
-	ct->ptr = (unsigned char *)(((unsigned long)ct->buf + pgsize - 1) &
-		  (~(pgsize - 1))); 
 
+	flags = fcntl(c->fd, F_GETFL);
+	if (flags < 0)
+		goto out;
+	if (!(flags & O_DIRECT)) {
+		flags |= O_DIRECT;
+		if (fcntl(c->fd, F_SETFL, flags) < 0)
+			goto out;
+		ct->reset_flags = 1;
+	}
+
+	ct->ptr = (unsigned char *) (((unsigned long)ct->buf + pgsize - 1) &
+		  (~(pgsize - 1)));
+
+	/* Sucessfully initialized, return the context. */
+	c->context = (void *) ct;
 	return 0;
+
 out:
+	if (ct->buf)
+		free(ct->buf);
+	syscall(__NR_io_destroy, ct->ioctx);
 	free(ct);
 	return 1;
 }
@@ -62,56 +95,63 @@ out:
 void directio_free (struct checker * c)
 {
 	struct directio_context * ct = (struct directio_context *)c->context;
+	long flags;
 
 	if (!ct)
 		return;
+
+	if (ct->reset_flags) {
+		if ((flags = fcntl(c->fd, F_GETFL)) >= 0) {
+			flags &= ~O_DIRECT;
+			/* No point in checking for errors */
+			fcntl(c->fd, F_SETFL, flags);
+		}
+	}
+
 	if (ct->buf)
 		free(ct->buf);
+	syscall(__NR_io_destroy, ct->ioctx);
 	free(ct);
 }
 
 static int
-direct_read (int fd, unsigned char * buff, int size)
+check_state(int fd, struct directio_context *ct)
 {
-	long flags;
-	int reset_flags = 0;
-	int res, retval;
-
-	flags = fcntl(fd,F_GETFL);
-
-	if (flags < 0) {
-		return PATH_UNCHECKED;
+	struct timespec	timeout = { .tv_sec = 2 };
+	struct io_event event;
+	struct stat	sb;
+	int		rc = PATH_UNCHECKED;
+	long		r;
+
+	if (fstat(fd, &sb) == 0) {
+		condlog(4, "directio: called for %x", (unsigned) sb.st_rdev);
 	}
 
-	if (!(flags & O_DIRECT)) {
-		flags |= O_DIRECT;
-		if (fcntl(fd,F_SETFL,flags) < 0) {
+	if (!ct->running) {
+		struct iocb *ios[1] = { &ct->io };
+
+		condlog(3, "directio: starting new request");
+		memset(&ct->io, 0, sizeof(struct iocb));
+		io_prep_pread(&ct->io, fd, ct->ptr, ct->blksize, 0);
+		if (syscall(__NR_io_submit, ct->ioctx, 1, ios) != 1) {
+			condlog(3, "directio: io_submit error %i", errno);
 			return PATH_UNCHECKED;
 		}
-		reset_flags = 1;
 	}
+	ct->running = 1;
 
-	while ( (res = read(fd,buff,size)) < 0 && errno == EINTR );
-	if (res < 0) {
-		if (errno == EINVAL) {
-			/* O_DIRECT is not available */
-			retval = PATH_UNCHECKED;
-		} else if (errno == ENOMEM) {
-			retval = PATH_UP;
-		} else {
-			retval = PATH_DOWN;
-		}
+	r = syscall(__NR_io_getevents, ct->ioctx, 1L, 1L, &event, &timeout);
+	if (r < 1L) {
+		condlog(3, "directio: timeout r=%li errno=%i", r, errno);
+		rc = PATH_DOWN;
 	} else {
-		retval = PATH_UP;
-	}
-	
-	if (reset_flags) {
-		flags &= ~O_DIRECT;
-		/* No point in checking for errors */
-		fcntl(fd,F_SETFL,flags);
+		condlog(3, "directio: io finished %lu/%lu", event.res,
+			event.res2);
+		ct->running = 0;
+		rc = (event.res == ct->blksize) ? PATH_UP : PATH_DOWN;
 	}
 
-	return retval;
+	return rc;
 }
 
 int directio (struct checker * c)
@@ -119,7 +159,10 @@ int directio (struct checker * c)
 	int ret;
 	struct directio_context * ct = (struct directio_context *)c->context;
 
-	ret = direct_read(c->fd, ct->ptr, ct->blksize);
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	ret = check_state(c->fd, ct);
 
 	switch (ret)
 	{
diff --git a/libcheckers/libaio.h b/libcheckers/libaio.h
new file mode 100644
index 0000000..6574601
--- /dev/null
+++ b/libcheckers/libaio.h
@@ -0,0 +1,222 @@
+/* /usr/include/libaio.h
+ *
+ * Copyright 2000,2001,2002 Red Hat, Inc.
+ *
+ * Written by Benjamin LaHaise <bcrl@redhat.com>
+ *
+ * libaio Linux async I/O interface
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
+ */
+#ifndef __LIBAIO_H
+#define __LIBAIO_H
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#include <sys/types.h>
+#include <string.h>
+
+struct timespec;
+struct sockaddr;
+struct iovec;
+struct iocb;
+
+typedef struct io_context *io_context_t;
+
+typedef enum io_iocb_cmd {
+	IO_CMD_PREAD = 0,
+	IO_CMD_PWRITE = 1,
+
+	IO_CMD_FSYNC = 2,
+	IO_CMD_FDSYNC = 3,
+
+	IO_CMD_POLL = 5,
+	IO_CMD_NOOP = 6,
+} io_iocb_cmd_t;
+
+#if defined(__i386__) /* little endian, 32 bits */
+#define PADDED(x, y)	x; unsigned y
+#define PADDEDptr(x, y)	x; unsigned y
+#define PADDEDul(x, y)	unsigned long x; unsigned y
+#elif defined(__ia64__) || defined(__x86_64__) || defined(__alpha__)
+#define PADDED(x, y)	x, y
+#define PADDEDptr(x, y)	x
+#define PADDEDul(x, y)	unsigned long x
+#elif defined(__powerpc64__) /* big endian, 64 bits */
+#define PADDED(x, y)	unsigned y; x
+#define PADDEDptr(x,y)	x
+#define PADDEDul(x, y)	unsigned long x
+#elif defined(__PPC__)  /* big endian, 32 bits */
+#define PADDED(x, y)	unsigned y; x
+#define PADDEDptr(x, y)	unsigned y; x
+#define PADDEDul(x, y)	unsigned y; unsigned long x
+#elif defined(__s390x__) /* big endian, 64 bits */
+#define PADDED(x, y)	unsigned y; x
+#define PADDEDptr(x,y)	x
+#define PADDEDul(x, y)	unsigned long x
+#elif defined(__s390__) /* big endian, 32 bits */
+#define PADDED(x, y)	unsigned y; x
+#define PADDEDptr(x, y) unsigned y; x
+#define PADDEDul(x, y)	unsigned y; unsigned long x
+#else
+#error	endian?
+#endif
+
+struct io_iocb_poll {
+	PADDED(int events, __pad1);
+};	/* result code is the set of result flags or -'ve errno */
+
+struct io_iocb_sockaddr {
+	struct sockaddr *addr;
+	int		len;
+};	/* result code is the length of the sockaddr, or -'ve errno */
+
+struct io_iocb_common {
+	PADDEDptr(void	*buf, __pad1);
+	PADDEDul(nbytes, __pad2);
+	long long	offset;
+	long long	__pad3, __pad4;
+};	/* result code is the amount read or -'ve errno */
+
+struct io_iocb_vector {
+	const struct iovec	*vec;
+	int			nr;
+	long long		offset;
+};	/* result code is the amount read or -'ve errno */
+
+struct iocb {
+	PADDEDptr(void *data, __pad1);	/* Return in the io completion event */
+	PADDED(unsigned key, __pad2);	/* For use in identifying io requests */
+
+	short		aio_lio_opcode;	
+	short		aio_reqprio;
+	int		aio_fildes;
+
+	union {
+		struct io_iocb_common		c;
+		struct io_iocb_vector		v;
+		struct io_iocb_poll		poll;
+		struct io_iocb_sockaddr	saddr;
+	} u;
+};
+
+struct io_event {
+	PADDEDptr(void *data, __pad1);
+	PADDEDptr(struct iocb *obj,  __pad2);
+	PADDEDul(res,  __pad3);
+	PADDEDul(res2, __pad4);
+};
+
+#undef PADDED
+#undef PADDEDptr
+#undef PADDEDul
+
+typedef void (*io_callback_t)(io_context_t ctx, struct iocb *iocb, long res, long res2);
+
+/* library wrappers */
+extern int io_queue_init(int maxevents, io_context_t *ctxp);
+/*extern int io_queue_grow(io_context_t ctx, int new_maxevents);*/
+extern int io_queue_release(io_context_t ctx);
+/*extern int io_queue_wait(io_context_t ctx, struct timespec *timeout);*/
+extern int io_queue_run(io_context_t ctx);
+
+/* Actual syscalls */
+extern int io_setup(int maxevents, io_context_t *ctxp);
+extern int io_destroy(io_context_t ctx);
+extern int io_submit(io_context_t ctx, long nr, struct iocb *ios[]);
+extern int io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt);
+extern int io_getevents(io_context_t ctx_id, long min_nr, long nr, struct io_event *events, struct timespec *timeout);
+
+
+static inline void io_set_callback(struct iocb *iocb, io_callback_t cb)
+{
+	iocb->data = (void *)cb;
+}
+
+static inline void io_prep_pread(struct iocb *iocb, int fd, void *buf, size_t count, long long offset)
+{
+	memset(iocb, 0, sizeof(*iocb));
+	iocb->aio_fildes = fd;
+	iocb->aio_lio_opcode = IO_CMD_PREAD;
+	iocb->aio_reqprio = 0;
+	iocb->u.c.buf = buf;
+	iocb->u.c.nbytes = count;
+	iocb->u.c.offset = offset;
+}
+
+static inline void io_prep_pwrite(struct iocb *iocb, int fd, void *buf, size_t count, long long offset)
+{
+	memset(iocb, 0, sizeof(*iocb));
+	iocb->aio_fildes = fd;
+	iocb->aio_lio_opcode = IO_CMD_PWRITE;
+	iocb->aio_reqprio = 0;
+	iocb->u.c.buf = buf;
+	iocb->u.c.nbytes = count;
+	iocb->u.c.offset = offset;
+}
+
+static inline void io_prep_poll(struct iocb *iocb, int fd, int events)
+{
+	memset(iocb, 0, sizeof(*iocb));
+	iocb->aio_fildes = fd;
+	iocb->aio_lio_opcode = IO_CMD_POLL;
+	iocb->aio_reqprio = 0;
+	iocb->u.poll.events = events;
+}
+
+static inline int io_poll(io_context_t ctx, struct iocb *iocb, io_callback_t cb, int fd, int events)
+{
+	io_prep_poll(iocb, fd, events);
+	io_set_callback(iocb, cb);
+	return io_submit(ctx, 1, &iocb);
+}
+
+static inline void io_prep_fsync(struct iocb *iocb, int fd)
+{
+	memset(iocb, 0, sizeof(*iocb));
+	iocb->aio_fildes = fd;
+	iocb->aio_lio_opcode = IO_CMD_FSYNC;
+	iocb->aio_reqprio = 0;
+}
+
+static inline int io_fsync(io_context_t ctx, struct iocb *iocb, io_callback_t cb, int fd)
+{
+	io_prep_fsync(iocb, fd);
+	io_set_callback(iocb, cb);
+	return io_submit(ctx, 1, &iocb);
+}
+
+static inline void io_prep_fdsync(struct iocb *iocb, int fd)
+{
+	memset(iocb, 0, sizeof(*iocb));
+	iocb->aio_fildes = fd;
+	iocb->aio_lio_opcode = IO_CMD_FDSYNC;
+	iocb->aio_reqprio = 0;
+}
+
+static inline int io_fdsync(io_context_t ctx, struct iocb *iocb, io_callback_t cb, int fd)
+{
+	io_prep_fdsync(iocb, fd);
+	io_set_callback(iocb, cb);
+	return io_submit(ctx, 1, &iocb);
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __LIBAIO_H */
-- 
1.4.3.4
