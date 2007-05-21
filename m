From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/2] Undo fix priority made earlier
Date: Mon, 21 May 2007 14:50:37 -0700
Message-ID: <20070521215037.29373.90024.sendpatchset@localhost.localdomain>
References: <20070521215031.29373.63818.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070521215031.29373.63818.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

While debugging I found that multipath was not selecting the preferred path
many a times (inlcuding the failback scenarios). 

Added a priority callout function and the expected behavior was still not
seen (patch 2 of 2).

More debugging revealed that the changes I made to work in the ghost
mode was wrong. Reverting those changes made the multipath behave properly.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Index: multipath-tools-0.4.7/libmultipath/discovery.c
===================================================================
--- multipath-tools-0.4.7.orig/libmultipath/discovery.c	2007-04-05 15:25:09.000000000 -0700
+++ multipath-tools-0.4.7/libmultipath/discovery.c	2007-05-17 10:07:56.000000000 -0700
@@ -699,7 +699,7 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state == PATH_UP)
+	if (mask & DI_PRIO && pp->state != PATH_DOWN)
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
Index: multipath-tools-0.4.7/libmultipath/switchgroup.c
===================================================================
--- multipath-tools-0.4.7.orig/libmultipath/switchgroup.c	2007-04-04 12:25:32.000000000 -0700
+++ multipath-tools-0.4.7/libmultipath/switchgroup.c	2007-05-17 10:07:56.000000000 -0700
@@ -28,7 +28,7 @@
 		priority = 0;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state == PATH_UP)
+			if (pp->state != PATH_DOWN)
 				priority += pp->priority;
 		}
 		pgp->priority = priority;

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
