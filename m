From: heinzm@sourceware.org
Subject: dmraid/lib/format/ataraid sil.c
Date: 1 Dec 2009 13:26:04 -0000
Message-ID: <20091201132604.8302.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-12-01 13:26:04

Modified files:
	lib/format/ataraid: sil.c 

Log message:
	Fix Silicon Image metadata format handler JBOD support

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/sil.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/format/ataraid/sil.c	2009/09/16 11:45:14	1.4
+++ dmraid/lib/format/ataraid/sil.c	2009/12/01 13:26:04	1.5
@@ -1,8 +1,8 @@
 /*
  * Silicon Image Medley ATARAID metadata format handler.
  *
- * Copyright (C) 2004,2005  Heinz Mauelshagen, Red Hat GmbH.
- *                          All rights reserved.
+ * Copyright (C) 2004,2005,2009  Heinz Mauelshagen, Red Hat GmbH.
+ *				 All rights reserved.
  *
  * See file LICENSE at the top of this source tree for license information.
  */
@@ -166,6 +166,16 @@
 	return 1;
 }
 
+/* Return number of array sectors. */
+static uint64_t
+array_size(struct raid_dev *rd)
+{
+	struct sil *sil = META(rd, sil);
+
+	return (((uint64_t) sil->array_sectors_high) << 32) +
+	       sil->array_sectors_low;
+}
+
 static void
 free_sils(struct sil **sils, unsigned int i)
 {
@@ -381,6 +391,10 @@
 	struct sil *sil = META(rd, sil);
 
 	switch (sil->type) {
+	case SIL_T_JBOD:
+		ret = array_size(rd) < rd->sectors ?
+		      1 : sil->drives_per_striped_set;
+		break;
 	case SIL_T_RAID0:
 	case SIL_T_RAID10:
 		ret = sil->drives_per_striped_set;
@@ -519,12 +533,9 @@
 static uint64_t
 sectors(struct raid_dev *rd)
 {
-	uint64_t array_sectors, ret = 0;
+	uint64_t array_sectors = array_size(rd), ret = 0;
 	struct sil *sil = META(rd, sil);
 
-	array_sectors = (((uint64_t) sil->array_sectors_high) << 32) +
-		sil->array_sectors_low;
-
 	switch (sil->type) {
 	case SIL_T_SPARE:
 		/* Cook them up... */
