From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 9 of 10] LVM: testsuite additions for mirrored log
Date: Fri, 26 Feb 2010 17:37:10 -0600
Message-ID: <201002262337.o1QNbA0r024642@hydrogen.msp.redhat.com>
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

Patch name: lvm-testsuite-additions-for-mirrored-log.patch

Testsuite additions for 'mirrored' log type.

Index: LVM2/test/t-snapshots-of-mirrors.sh
===================================================================
--- LVM2.orig/test/t-snapshots-of-mirrors.sh
+++ LVM2/test/t-snapshots-of-mirrors.sh
@@ -21,11 +21,11 @@ not lvconvert -m2 $vg/lv
 # Log conversion (disk -> core)
 lvconvert --mirrorlog core $vg/lv
 
-# Log conversion (core -> redundant)
-not lvconvert --mirrorlog redundant $vg/lv
+# Log conversion (core -> mirrored)
+lvconvert --mirrorlog mirrored $vg/lv
 
-# Log conversion (redundant -> core)
-# lvconvert --mirrorlog core $vg/lv
+# Log conversion (mirrored -> core)
+lvconvert --mirrorlog core $vg/lv
 
 # Log conversion (core -> disk)
 lvconvert --mirrorlog disk $vg/lv
Index: LVM2/test/t-mirror-lvconvert.sh
===================================================================
--- LVM2.orig/test/t-mirror-lvconvert.sh
+++ LVM2/test/t-mirror-lvconvert.sh
@@ -252,6 +252,38 @@ mirrorlog_is_on_ $vg/$lv1 $dev3 
 check_and_cleanup_lvs_
 
 # ---
+# core log to mirrored log
+
+# change the log type from 'core' to 'mirrored'
+prepare_lvs_
+lvcreate -l2 -m1 --mirrorlog core -n $lv1 $vg $dev1 $dev2
+check_mirror_count_ $vg/$lv1 2
+not_sh check_mirror_log_ $vg/$lv1
+lvconvert --mirrorlog mirrored -i1 $vg/$lv1 $dev3 $dev4
+check_no_tmplvs_ $vg/$lv1
+check_mirror_log_ $vg/$lv1
+mimages_are_redundant_ $vg $lv1
+
+# ---
+# mirrored log to core log
+
+# change the log type from 'mirrored' to 'core'
+lvconvert --mirrorlog core -i1 $vg/$lv1 $dev3 $dev4
+check_no_tmplvs_ $vg/$lv1
+not_sh check_mirror_log_ $vg/$lv1
+mimages_are_redundant_ $vg $lv1
+check_and_cleanup_lvs_
+
+# ---
+# Linear to mirror with mirrored log using --alloc anywhere
+prepare_lvs_
+lvcreate -l2 -n $lv1 $vg $dev1
+lvconvert -m +1 --mirrorlog mirrored $vg/$lv1 $dev1 $dev2 --alloc anywhere
+mimages_are_redundant_ $vg $lv1
+check_and_cleanup_lvs_
+
+
+# ---
 # check polldaemon restarts
 
 # convert inactive mirror and start polling
Index: LVM2/test/t-lvcreate-operation.sh
===================================================================
--- LVM2.orig/test/t-lvcreate-operation.sh
+++ LVM2/test/t-lvcreate-operation.sh
@@ -25,9 +25,18 @@ aux prepare_pvs 2
 aux pvcreate --metadatacopies 0 $dev1
 aux vgcreate -c n $vg $devs
 
-#COMM create snapshots of LVs on --metadatacopies 0 PV (bz450651)
+# ---
+# Create snapshots of LVs on --metadatacopies 0 PV (bz450651)
 lvcreate -n$lv1 -l4 $vg $dev1
 lvcreate -n$lv2 -l4 -s $vg/$lv1
-#lvremove -f $vg/$lv2
 cleanup_lvs
 
+# ---
+# Create mirror on two devices with mirrored log using --alloc anywhere
+lvcreate -m 1 -l4 -n $lv1 --mirrorlog mirrored $vg --alloc anywhere $dev1 $dev2
+cleanup_lvs
+
+# --
+# Create mirror on one dev with mirrored log using --alloc anywhere, should fail
+lvcreate -m 1 -l4 -n $lv1 --mirrorlog mirrored $vg --alloc anywhere $dev1
+cleanup_lvs
