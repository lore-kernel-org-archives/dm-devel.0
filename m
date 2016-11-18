From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Makefiles: Fix function availability checks
Date: Fri, 18 Nov 2016 11:52:31 -0800
Message-ID: <1c628eb2-589d-d8b8-952c-d64c5e74d785@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The current implementation of the code that checks for function
presence is not correct because it checks for a prefix match only.
Introduce a function that checks for the exact function name.
Additionally, report whether or not the function has been found.
An example of the output produced by this function if 'make' is
run:

Checking for dm_task_no_flush in /usr/include/libdevmapper.h ... yes
Checking for dm_task_set_cookie in /usr/include/libdevmapper.h ... yes
Checking for udev_monitor_set_receive_buffer_size in /usr/include/libudev.h ... yes
Checking for dm_task_deferred_remove in /usr/include/libdevmapper.h ... yes

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 Makefile.inc          | 14 ++++++++++++++
 kpartx/Makefile       |  4 +---
 libmultipath/Makefile | 16 ++++------------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 1cc8f44..e7f4e05 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -69,5 +69,19 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
 CFLAGS		= $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 SHARED_FLAGS	= -shared
 
+# Check whether a function with name $1 has been declared in header file $2.
+check_func =								       \
+    $(shell								       \
+	if grep -Eq "^[^[:blank:]]+[[:blank:]]+$1[[:blank:]]*(.*)*" "$2"; then \
+	   found=1;							       \
+	   status="yes";						       \
+	else								       \
+	   found=0;							       \
+	   status="no";							       \
+	fi;								       \
+	echo 1>&2 "Checking for $1 in $2 ... $$status";			       \
+	echo "$$found"							       \
+    )
+
 %.o:	%.c
 	$(CC) $(CFLAGS) -c -o $@ $<
diff --git a/kpartx/Makefile b/kpartx/Makefile
index e8a59f2..9441a2b 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -7,9 +7,7 @@ CFLAGS += -I. -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
 LIBDEPS += -ldevmapper
 
-LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie' /usr/include/libdevmapper.h)
-
-ifneq ($(strip $(LIBDM_API_COOKIE)),0)
+ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 495cebe..a11e483 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -20,27 +20,19 @@ ifdef SYSTEMD
 	endif
 endif
 
-LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
-
-ifneq ($(strip $(LIBDM_API_FLUSH)),0)
+ifneq ($(call check_func,dm_task_no_flush,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
 endif
 
-LIBDM_API_COOKIE = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_set_cookie' /usr/include/libdevmapper.h)
-
-ifneq ($(strip $(LIBDM_API_COOKIE)),0)
+ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
-LIBUDEV_API_RECVBUF = $(shell grep -Ecs '^[a-z]*[[:space:]]+udev_monitor_set_receive_buffer_size' /usr/include/libudev.h)
-
-ifneq ($(strip $(LIBUDEV_API_RECVBUF)),0)
+ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,/usr/include/libudev.h),0)
 	CFLAGS += -DLIBUDEV_API_RECVBUF
 endif
 
-LIBDM_API_DEFERRED = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_deferred_remove' /usr/include/libdevmapper.h)
-
-ifneq ($(strip $(LIBDM_API_DEFERRED)),0)
+ifneq ($(call check_func,dm_task_deferred_remove,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_DEFERRED
 endif
 
-- 
2.10.1
