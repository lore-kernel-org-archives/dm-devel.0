From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5/5] libmultipath: cleanup old issues with
	directio checker
Date: Wed, 19 Feb 2020 00:54:33 -0600
Message-ID: <1582095273-10279-6-git-send-email-bmarzins@redhat.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

The directio checker manually aligns its directio buffer, instead of
using posix_memalign(). It also defaults the block size for the read to
512, which may be too small for 4k devices, and it only waits for 5 ns
for IO completion before giving up and setting the path to pending,
which means that in will virtually always set the path to pending on the
check when the IO is issued.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/directio.c | 13 ++++---------
 tests/directio.c                 |  1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 649961a4..503519e2 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -38,7 +38,6 @@ struct async_req {
 	struct iocb io;
 	unsigned int blksize;
 	unsigned char *	buf;
-	unsigned char * ptr;
 	struct list_head node;
 	int state; /* PATH_REMOVED means this is an orphan */
 };
@@ -174,7 +173,7 @@ int libcheck_init (struct checker * c)
 
 	if (ioctl(c->fd, BLKBSZGET, &req->blksize) < 0) {
 		c->msgid = MSG_DIRECTIO_BLOCKSIZE;
-		req->blksize = 512;
+		req->blksize = 4096;
 	}
 	if (req->blksize > 4096) {
 		/*
@@ -185,8 +184,7 @@ int libcheck_init (struct checker * c)
 	if (!req->blksize)
 		goto out;
 
-	req->buf = (unsigned char *)malloc(req->blksize + pgsize);
-	if (!req->buf)
+	if (posix_memalign((void **)&req->buf, pgsize, req->blksize) != 0)
 		goto out;
 
 	flags = fcntl(c->fd, F_GETFL);
@@ -199,9 +197,6 @@ int libcheck_init (struct checker * c)
 		ct->reset_flags = 1;
 	}
 
-	req->ptr = (unsigned char *) (((unsigned long)req->buf + pgsize - 1) &
-		  (~(pgsize - 1)));
-
 	/* Successfully initialized, return the context. */
 	ct->req = req;
 	c->context = (void *) ct;
@@ -298,7 +293,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 static int
 check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 {
-	struct timespec	timeout = { .tv_nsec = 5 };
+	struct timespec	timeout = { .tv_nsec = 1000 };
 	struct stat	sb;
 	int		rc;
 	long		r;
@@ -323,7 +318,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 
 		LOG(3, "starting new request");
 		memset(&ct->req->io, 0, sizeof(struct iocb));
-		io_prep_pread(&ct->req->io, fd, ct->req->ptr,
+		io_prep_pread(&ct->req->io, fd, ct->req->buf,
 			      ct->req->blksize, 0);
 		ct->req->state = PATH_PENDING;
 		if (io_submit(ct->aio_grp->ioctx, 1, ios) != 1) {
diff --git a/tests/directio.c b/tests/directio.c
index 23fd2da9..3cd7a520 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -23,7 +23,6 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#define UNIT_TESTING /* enable memory testing in directio.c */
 #include <cmocka.h>
 #include "globals.c"
 #include "../libmultipath/checkers/directio.c"
-- 
2.17.2
