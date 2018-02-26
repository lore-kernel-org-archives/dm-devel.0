From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: fix wrong output of "multipath -t"
Date: Mon, 26 Feb 2018 13:55:58 +0100
Message-ID: <20180226125558.13861-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The default values printed by "multipath -t" or "multipathd show config"
for "detect_prio", "detect_checker", and "retain_attached_hw_handler"
don't match the actual compiled-in defaults. Moreover, several other
options would also be displayed wrongly if the defaults were changed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 36cccc94efb4..98dfc4b8744b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -345,7 +345,7 @@ declare_def_handler(checker_timeout, set_int)
 declare_def_snprint(checker_timeout, print_nonzero)
 
 declare_def_handler(flush_on_last_del, set_yes_no_undef)
-declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, DEFAULT_FLUSH)
 declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
 declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
 declare_hw_handler(flush_on_last_del, set_yes_no_undef)
@@ -354,7 +354,8 @@ declare_mp_handler(flush_on_last_del, set_yes_no_undef)
 declare_mp_snprint(flush_on_last_del, print_yes_no_undef)
 
 declare_def_handler(user_friendly_names, set_yes_no_undef)
-declare_def_snprint_defint(user_friendly_names, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
+			   DEFAULT_USER_FRIENDLY_NAMES)
 declare_ovr_handler(user_friendly_names, set_yes_no_undef)
 declare_ovr_snprint(user_friendly_names, print_yes_no_undef)
 declare_hw_handler(user_friendly_names, set_yes_no_undef)
@@ -372,21 +373,24 @@ declare_def_handler(prkeys_file, set_str)
 declare_def_snprint(prkeys_file, print_str)
 
 declare_def_handler(retain_hwhandler, set_yes_no_undef)
-declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef,
+			   DEFAULT_RETAIN_HWHANDLER)
 declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
 declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)
 declare_hw_handler(retain_hwhandler, set_yes_no_undef)
 declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
 
 declare_def_handler(detect_prio, set_yes_no_undef)
-declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(detect_prio, print_yes_no_undef,
+			   DEFAULT_DETECT_PRIO)
 declare_ovr_handler(detect_prio, set_yes_no_undef)
 declare_ovr_snprint(detect_prio, print_yes_no_undef)
 declare_hw_handler(detect_prio, set_yes_no_undef)
 declare_hw_snprint(detect_prio, print_yes_no_undef)
 
 declare_def_handler(detect_checker, set_yes_no_undef)
-declare_def_snprint_defint(detect_checker, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(detect_checker, print_yes_no_undef,
+			   DEFAULT_DETECT_CHECKER)
 declare_ovr_handler(detect_checker, set_yes_no_undef)
 declare_ovr_snprint(detect_checker, print_yes_no_undef)
 declare_hw_handler(detect_checker, set_yes_no_undef)
@@ -396,7 +400,8 @@ declare_def_handler(force_sync, set_yes_no)
 declare_def_snprint(force_sync, print_yes_no)
 
 declare_def_handler(deferred_remove, set_yes_no_undef)
-declare_def_snprint_defint(deferred_remove, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(deferred_remove, print_yes_no_undef,
+			   DEFAULT_DEFERRED_REMOVE)
 declare_ovr_handler(deferred_remove, set_yes_no_undef)
 declare_ovr_snprint(deferred_remove, print_yes_no_undef)
 declare_hw_handler(deferred_remove, set_yes_no_undef)
@@ -417,7 +422,8 @@ declare_def_handler(strict_timing, set_yes_no)
 declare_def_snprint(strict_timing, print_yes_no)
 
 declare_def_handler(skip_kpartx, set_yes_no_undef)
-declare_def_snprint_defint(skip_kpartx, print_yes_no_undef, YNU_NO)
+declare_def_snprint_defint(skip_kpartx, print_yes_no_undef,
+			   DEFAULT_SKIP_KPARTX)
 declare_ovr_handler(skip_kpartx, set_yes_no_undef)
 declare_ovr_snprint(skip_kpartx, print_yes_no_undef)
 declare_hw_handler(skip_kpartx, set_yes_no_undef)
@@ -634,7 +640,8 @@ print_fast_io_fail(char * buff, int len, void *ptr)
 }
 
 declare_def_handler(fast_io_fail, set_fast_io_fail)
-declare_def_snprint_defint(fast_io_fail, print_fast_io_fail, DEFAULT_FAST_IO_FAIL)
+declare_def_snprint_defint(fast_io_fail, print_fast_io_fail,
+			   DEFAULT_FAST_IO_FAIL)
 declare_ovr_handler(fast_io_fail, set_fast_io_fail)
 declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
 declare_hw_handler(fast_io_fail, set_fast_io_fail)
@@ -828,7 +835,7 @@ print_rr_weight (char * buff, int len, void *ptr)
 }
 
 declare_def_handler(rr_weight, set_rr_weight)
-declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE)
+declare_def_snprint_defint(rr_weight, print_rr_weight, DEFAULT_RR_WEIGHT)
 declare_ovr_handler(rr_weight, set_rr_weight)
 declare_ovr_snprint(rr_weight, print_rr_weight)
 declare_hw_handler(rr_weight, set_rr_weight)
-- 
2.16.1
