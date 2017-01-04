From: Anthony Ryan <anthonyryan1@gmail.com>
Subject: [PATCH] Include sys/sysmacros.h
Date: Tue, 3 Jan 2017 23:34:53 -0500
Message-ID: <CACqULmPQdDPnHkM701=XJ1qSc8y87-6Fb=kbvEGGeHyrrBXvEg@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The major, minor & makedev macros are not supposed to be included
with sys/types.h but glibc has done this against POSIX standards.

Alternative libcs aren't able to be used because of this and glibc
has expressed interest in correcting this behaviour in a future
release.
---
 kpartx/dasd.c               | 1 +
 kpartx/kpartx.c             | 1 +
 libmultipath/checkers/tur.c | 1 +
 libmultipath/devmapper.c    | 1 +
 libmultipath/util.c         | 1 +
 5 files changed, 5 insertions(+)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 1206e45..f50c1bd 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -28,6 +28,7 @@
 #include <inttypes.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <sys/ioctl.h>
 #include <linux/hdreg.h>
 #include <errno.h>
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index d31fea8..3452787 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -28,6 +28,7 @@
 #include <stdint.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <sys/types.h>
 #include <ctype.h>
 #include <libdevmapper.h>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 4d6c3c2..d9a9e67 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -11,6 +11,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
+#include <sys/sysmacros.h>
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4f8ef13..9c0b240 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -12,6 +12,7 @@
 #include <ctype.h>
 #include <unistd.h>
 #include <errno.h>
+#include <sys/sysmacros.h>

 #include "checkers.h"
 #include "vector.h"
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 03a5738..1841f35 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -4,6 +4,7 @@
 #include <pthread.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <sys/types.h>
 #include <unistd.h>

-- 
2.11.0
