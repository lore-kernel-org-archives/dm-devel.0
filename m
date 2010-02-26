From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 10 of 10] LVM: remove name restriction check for
	repair
Date: Fri, 26 Feb 2010 17:37:20 -0600
Message-ID: <201002262337.o1QNbKXb024717@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: lvm-remove-name-restriction-check-for-repair.patch

I've removed the 'apply_lvname_restrictions' call in lvconvert if the
'--repair' option is given on the command line.  This is because the
repair action will be making no new LV names; so the check shouldn't
be necessary.  (Unless you don't like the idea of passing in hidden
LVs.)


Index: LVM2/tools/lvconvert.c
===================================================================
--- LVM2.orig/tools/lvconvert.c
+++ LVM2/tools/lvconvert.c
@@ -105,7 +105,12 @@ static int _lvconvert_name_params(struct
 	if ((ptr = strrchr(lp->lv_name_full, '/')))
 		lp->lv_name = ptr + 1;
 
-	if (!apply_lvname_restrictions(lp->lv_name))
+	/*
+	 * Repair will alter existing LVs - not make new ones - so
+	 * it doesn't make sense to do name restriction tests.
+	 */
+	if (!arg_count(cmd, repair_ARG) &&
+	    !apply_lvname_restrictions(lp->lv_name))
 		return_0;
 
 	if (*pargc && lp->snapshot) {
