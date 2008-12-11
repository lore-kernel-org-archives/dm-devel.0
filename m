From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/6] Fix for kpartx on sparc64
Date: Thu, 11 Dec 2008 16:06:07 -0600
Message-ID: <20081211220607.GJ1585@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This typedef change is necessary to make kpartx work on sparc64 machines.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/lopart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-081203/kpartx/lopart.c
===================================================================
--- multipath-tools-081203.orig/kpartx/lopart.c
+++ multipath-tools-081203/kpartx/lopart.c
@@ -30,7 +30,7 @@
 #if defined(__hppa__) || defined(__powerpc64__) || defined (__alpha__) \
  || defined (__x86_64__)
 typedef unsigned long __kernel_old_dev_t;
-#elif defined(__powerpc__) || defined(__ia64__)
+#elif defined(__powerpc__) || defined(__ia64__) || (defined(__sparc__) && defined (__arch64__))
 typedef unsigned int __kernel_old_dev_t;
 #else
 typedef unsigned short __kernel_old_dev_t;
