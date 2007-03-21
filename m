From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/3] Fix the priority calculation to use
	PATH_GHOST state
Date: Wed, 21 Mar 2007 11:38:45 -0800
Message-ID: <20070321193845.24487.53463.sendpatchset@localhost.localdomain>
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
--- multipath-tools-0.4.7.orig/libmultipath/discovery.c	2007-03-20 14:45:21.000000000 -0700
+++ multipath-tools-0.4.7/libmultipath/discovery.c	2007-03-20 14:45:41.000000000 -0700
@@ -699,7 +699,7 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state != PATH_DOWN)
+	if (mask & DI_PRIO && pp->state == PATH_UP)
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
Index: multipath-tools-0.4.7/libmultipath/switchgroup.c
===================================================================
--- multipath-tools-0.4.7.orig/libmultipath/switchgroup.c	2007-03-20 14:45:21.000000000 -0700
+++ multipath-tools-0.4.7/libmultipath/switchgroup.c	2007-03-20 14:45:41.000000000 -0700
@@ -28,7 +28,7 @@
 		priority = 0;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state != PATH_DOWN)
+			if (pp->state == PATH_UP)
 				priority += pp->priority;
 		}
 		pgp->priority = priority;

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
