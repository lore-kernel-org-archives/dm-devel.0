From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Define LIBDM_API_FLUSH for 64bit systems
	correctly
Date: Wed, 30 Apr 2008 11:04:45 +0200
Message-ID: <20080430090446.1D74918C6FF@pentland.suse.de>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


64bit Installation will have libraries in /lib64, not /lib.
So we'll have to check against this directory, too, to calculate
the correct LIBDM_API_FLUSH define.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 16bd978..18241a2 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -18,7 +18,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	CFLAGS += -DDAEMON
 #endif
 
-LIBDM_API_FLUSH = $(shell objdump -T /lib/libdevmapper.so.* | grep -c dm_task_no_flush)
+LIBDM_API_FLUSH = $(shell if test -d /lib64 ; then objdump -T /lib64/libdevmapper.so* ; else objdump -T /lib/libdevmapper.so.* ; fi | grep -c dm_task_no_flush)
 
 ifeq ($(strip $(LIBDM_API_FLUSH)),1)
 	CFLAGS += -DLIBDM_API_FLUSH
-- 
1.5.2.4
