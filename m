From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/3] Increase the wait time for device to appear
	in /dev
Date: Wed, 21 Mar 2007 11:38:50 -0800
Message-ID: <20070321193850.24487.87662.sendpatchset@localhost.localdomain>
References: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070321193833.24487.76682.sendpatchset@localhost.localdomain>
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
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, christophe.varoqui@free.fr, agk@redhat.com
List-Id: dm-devel.ids

Index: multipath-tools-0.4.7/libmultipath/discovery.c
===================================================================
--- multipath-tools-0.4.7.orig/libmultipath/discovery.c	2007-03-20 14:45:41.000000000 -0700
+++ multipath-tools-0.4.7/libmultipath/discovery.c	2007-03-20 14:46:16.000000000 -0700
@@ -112,7 +112,7 @@
  * not multipath(8), ran by udev
  */
 #if DAEMON
-#define WAIT_MAX_SECONDS 5
+#define WAIT_MAX_SECONDS 60
 #define WAIT_LOOP_PER_SECOND 5
 
 static int

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
