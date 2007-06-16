From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath 3/3] remove bashisms from kpartx_id
Date: Sat, 16 Jun 2007 20:07:16 +0200
Message-ID: <11820172373748-git-send-email-agx@sigxcpu.org>
References: <11820172361537-git-send-email-agx@sigxcpu.org>
	<11820172372216-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11820172372216-git-send-email-agx@sigxcpu.org>
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

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index e876b98..81f32bf 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 #
 # kpartx_id
 #
@@ -43,7 +43,7 @@ dmuuid=${UUID#*-}
 dmtbl=${UUID%%-*}
 dmpart=${dmtbl#part}
 # kpartx types are 'part<num>'
-if [ "$dmpart" == "$dmtbl" ] ; then
+if [ "$dmpart" = "$dmtbl" ] ; then
     dmpart=
 else
     dmtbl=part
@@ -51,7 +51,7 @@ fi
 
 # Set the name of the table. We're only interested in dmraid,
 # multipath, and kpartx tables; everything else is ignored.
-if [ "$dmtbl" == "part" ] ; then
+if [ "$dmtbl" = "part" ] ; then
     # The name of the kpartx table is the name of the parent table
     dmname=$($DMSETUP info  -c --noheadings -o name -u $dmuuid)
     echo "DM_NAME=$dmname"
@@ -62,11 +62,11 @@ if [ "$dmtbl" == "part" ] ; then
 	    dmdeps=$($DMSETUP deps -u $dmuuid)
 	    ;;
     esac
-elif [ "$dmtbl" == "mpath" ] ; then
+elif [ "$dmtbl" = "mpath" ] ; then
     dmname=$tblname
     # We need the dependencies of the table to figure out the type
     dmdeps=$($DMSETUP deps -u $UUID)
-elif [ "$dmtbl" == "dmraid" ] ; then
+elif [ "$dmtbl" = "dmraid" ] ; then
     dmname=$tblname
 fi
 
-- 
1.5.2.1
