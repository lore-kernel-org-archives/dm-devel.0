From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH]: multipath-tools: check header file instead of
	intalled lib
Date: Sat, 21 Nov 2009 18:15:25 +0100
Message-ID: <20091121171525.GA15102@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
attached patch checks the header file instead of an installed lib for
dm_task_struct. Since distros have this lib add different patchs the
check should be more reliable.
Cheers,
 -- Guido

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-check-header-file-for-defintion-of-dm_task_no_flush.patch"

From: =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Date: Sun, 30 Aug 2009 13:38:55 +0200
Subject: [PATCH] check header file for defintion of dm_task_no_flush

instead of checking the so for the symbol (which seems to be hard to
find).
---
 libmultipath/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 13178bd..d59e2f3 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -14,7 +14,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
        log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
        lock.o waiter.o
 
-LIBDM_API_FLUSH = $(shell if test -d /lib64 ; then objdump -T /lib64/libdevmapper.so* ; else objdump -T /lib/libdevmapper.so.* ; fi | grep -c dm_task_no_flush)
+LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
 
 ifneq ($(strip $(LIBDM_API_FLUSH)),0)
 	CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
-- 

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--x+6KMIRAuhnl3hBn--
