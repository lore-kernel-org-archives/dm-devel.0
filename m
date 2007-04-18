From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (5/6) Add '--filter' option to
	dmsetup
Date: Wed, 18 Apr 2007 12:47:47 -0400
Message-ID: <46264BB3.2030101@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040208080103010007060501"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040208080103010007060501
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch adds '--filter' option to dmsetup, so that it can
use the filtering feature of dm_report.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------040208080103010007060501
Content-Type: text/x-patch;
 name="dmsetup-info-add-filter-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmsetup-info-add-filter-option.patch"

Add --filter (-F) option to dmsetup for filtering report output.

---
 dmsetup/dmsetup.c |   15 ++++++++++++++-
 man/dmsetup.8     |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

Index: device-mapper.work/dmsetup/dmsetup.c
===================================================================
--- device-mapper.work.orig/dmsetup/dmsetup.c
+++ device-mapper.work/dmsetup/dmsetup.c
@@ -104,6 +104,7 @@ enum {
 	COLS_ARG,
 	EXEC_ARG,
 	FORCE_ARG,
+	FILTER_ARG,
 	GID_ARG,
 	MAJOR_ARG,
 	MINOR_ARG,
@@ -1650,6 +1651,13 @@ static int _report_init(struct command *
 					options, separator, flags, keys, NULL)))
 		goto out;
 
+	if (_string_args[FILTER_ARG] &&
+	    !dm_report_set_filter(_report, _string_args[FILTER_ARG], 0)) {
+		dm_report_free(_report);
+		_report = NULL;
+		goto out;
+	}
+
 	r = 1;
 
 out:
@@ -2059,6 +2067,7 @@ static int _process_switches(int *argc, 
 		{"columns", 0, &ind, COLS_ARG},
 		{"exec", 1, &ind, EXEC_ARG},
 		{"force", 0, &ind, FORCE_ARG},
+		{"filter", 1, &ind, FILTER_ARG},
 		{"gid", 1, &ind, GID_ARG},
 		{"major", 1, &ind, MAJOR_ARG},
 		{"minor", 1, &ind, MINOR_ARG},
@@ -2133,7 +2142,7 @@ static int _process_switches(int *argc, 
 
 	optarg = 0;
 	optind = OPTIND_INIT;
-	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfGj:m:Mno:O:ru:Uv",
+	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfF:Gj:m:Mno:O:ru:Uv",
 					    long_options, NULL)) != -1) {
 		if (c == ':' || c == '?')
 			return 0;
@@ -2141,6 +2150,10 @@ static int _process_switches(int *argc, 
 			_switches[COLS_ARG]++;
 		if (c == 'f' || ind == FORCE_ARG)
 			_switches[FORCE_ARG]++;
+		if (c == 'F' || ind == FILTER_ARG) {
+			_switches[FILTER_ARG]++;
+			_string_args[FILTER_ARG] = optarg;
+		}
 		if (c == 'r' || ind == READ_ONLY)
 			_switches[READ_ONLY]++;
 		if (c == 'j' || ind == MAJOR_ARG) {
Index: device-mapper.work/man/dmsetup.8
===================================================================
--- device-mapper.work.orig/man/dmsetup.8
+++ device-mapper.work/man/dmsetup.8
@@ -44,7 +44,7 @@ dmsetup \- low level logical volume mana
 .br
 .B dmsetup info -c|-C|--columns
 .I [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields]
-.I [device_name]
+.I [--filter expression] [device_name]
 .br
 .B dmsetup deps
 .I [device_name]

--------------040208080103010007060501
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040208080103010007060501--
