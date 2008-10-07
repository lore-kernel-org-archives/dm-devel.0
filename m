From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: [patch 1/1] libmultipath/Makefile dm_task_no_flush check
Date: Tue, 07 Oct 2008 16:24:46 +0200
Message-ID: <30405.4540036761$1223389792@news.gmane.org>
References: <20081007142445.415423000@linux.vnet.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=Makefile.diff
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

Description: In libmultipath Makefile it is checked if the
symbol dm_task_no_flush is defined within the device mapper
library. On my system beside the library there exists a 
symbolic link within the same directory pointing to this
library and containing libdevmapper.so in it's name:

[root@t6360034 libmultipath]# ll /lib64/libdevmapper.so*
lrwxrwxrwx 1 root root    20 Sep 22 22:15 /lib64/libdevmapper.so -> libdevmapper.so.1.02
-rwxr-xr-x 1 root root 89928 Feb 14  2008 /lib64/libdevmapper.so.1.02

In this case "grep -c" returns a 2 instead of 1 that is assumed
in the Makefile. I changed this check to not equal zero.


Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com> 

---
 libmultipath/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/libmultipath/Makefile	2008-10-07 15:29:03.000000000 +0200
+++ b/libmultipath/Makefile	2008-10-07 15:29:57.000000000 +0200
@@ -16,7 +16,7 @@ OBJS = memory.o parser.o vector.o devmap
 
 LIBDM_API_FLUSH = $(shell if test -d /lib64 ; then objdump -T /lib64/libdevmapper.so* ; else objdump -T /lib/libdevmapper.so.* ; fi | grep -c dm_task_no_flush)
 
-ifeq ($(strip $(LIBDM_API_FLUSH)),1)
+ifneq ($(strip $(LIBDM_API_FLUSH)),0)
 	CFLAGS += -DLIBDM_API_FLUSH
 endif
 

-- 
