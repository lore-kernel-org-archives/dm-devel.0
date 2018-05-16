From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] libmultipath: print correct default for
	delay_*_checks
Date: Wed, 16 May 2018 17:43:26 -0500
Message-ID: <1526510607-21144-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

These options default to "no", so they should display that when the
config is printed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4040611..3e7c5d6 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1115,7 +1115,8 @@ print_off_int_undef(char * buff, int len, long v)
 }
 
 declare_def_handler(delay_watch_checks, set_off_int_undef)
-declare_def_snprint(delay_watch_checks, print_off_int_undef)
+declare_def_snprint_defint(delay_watch_checks, print_off_int_undef,
+			   DEFAULT_DELAY_CHECKS)
 declare_ovr_handler(delay_watch_checks, set_off_int_undef)
 declare_ovr_snprint(delay_watch_checks, print_off_int_undef)
 declare_hw_handler(delay_watch_checks, set_off_int_undef)
@@ -1123,7 +1124,8 @@ declare_hw_snprint(delay_watch_checks, print_off_int_undef)
 declare_mp_handler(delay_watch_checks, set_off_int_undef)
 declare_mp_snprint(delay_watch_checks, print_off_int_undef)
 declare_def_handler(delay_wait_checks, set_off_int_undef)
-declare_def_snprint(delay_wait_checks, print_off_int_undef)
+declare_def_snprint_defint(delay_wait_checks, print_off_int_undef,
+			   DEFAULT_DELAY_CHECKS)
 declare_ovr_handler(delay_wait_checks, set_off_int_undef)
 declare_ovr_snprint(delay_wait_checks, print_off_int_undef)
 declare_hw_handler(delay_wait_checks, set_off_int_undef)
-- 
2.7.4
