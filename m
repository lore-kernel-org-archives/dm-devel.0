From: agk@sourceware.org
Subject: device-mapper/po device-mapper.po
Date: 27 Apr 2007 19:55:26 -0000
Message-ID: <20070427195526.19378.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-04-27 20:55:26

Modified files:
	po             : device-mapper.po 

Log message:
	po

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/po/device-mapper.po.diff?cvsroot=dm&r1=1.2&r2=1.3

--- device-mapper/po/device-mapper.po	2007/01/29 19:57:24	1.2
+++ device-mapper/po/device-mapper.po	2007/04/27 19:55:26	1.3
@@ -8,7 +8,7 @@
 msgstr ""
 "Project-Id-Version: PACKAGE VERSION\n"
 "Report-Msgid-Bugs-To: \n"
-"POT-Creation-Date: 2007-01-29 19:56+0000\n"
+"POT-Creation-Date: 2007-04-27 20:54+0100\n"
 "PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
 "Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
 "Language-Team: LANGUAGE <LL@li.org>\n"
@@ -37,6 +37,12 @@
 #: libdm-deptree.c:1667 libdm-deptree.c:1676 libdm-deptree.c:1685
 #: libdm-deptree.c:1697 libdm-deptree.c:1733 libdm-deptree.c:1752
 #: libdm-deptree.c:1795 libdm-deptree.c:1809 libdm-deptree.c:1820
+#: libdm-report.c:313 libdm-report.c:384 regex/matcher.c:181
+#: regex/matcher.c:202 regex/matcher.c:205 regex/matcher.c:277
+#: regex/matcher.c:281 regex/matcher.c:293 regex/matcher.c:313
+#: regex/parse_rx.c:228 regex/parse_rx.c:279 regex/parse_rx.c:304
+#: regex/parse_rx.c:327 regex/parse_rx.c:339 regex/ttree.c:90
+#: regex/ttree.c:110
 msgid "<backtrace>"
 msgstr ""
 
@@ -223,7 +229,7 @@
 
 #: ioctl/libdm-iface.c:1557
 #, c-format
-msgid "dm %s %s %s%s%s %s%.0d%s%.0d%s%s%c%c%s %.0llu %s [%u]"
+msgid "dm %s %s %s%s%s %s%.0d%s%.0d%s%s%c%c%s %.0lu %s [%u]"
 msgstr ""
 
 #: ioctl/libdm-iface.c:1581 ioctl/libdm-iface.c:1586
@@ -688,7 +694,7 @@
 msgid "dm_report_field_uint64: uint64 too big: %d"
 msgstr ""
 
-#: libdm-report.c:264 libdm-report.c:428
+#: libdm-report.c:264 libdm-report.c:448
 msgid " "
 msgstr ""
 
@@ -712,92 +718,92 @@
 msgid "dm_report: field not match: %s"
 msgstr ""
 
-#: libdm-report.c:316 libdm-report.c:347
+#: libdm-report.c:307
 msgid "dm_report: struct field_properties allocation failed"
 msgstr ""
 
-#: libdm-report.c:361
+#: libdm-report.c:387
 #, c-format
 msgid "dm_report: Ignoring duplicate sort field: %s"
 msgstr ""
 
-#: libdm-report.c:393
+#: libdm-report.c:419
 msgid "dm_report: Missing sort field name"
 msgstr ""
 
-#: libdm-report.c:430
+#: libdm-report.c:450
 #, c-format
 msgid "Unrecognised field: %.*s"
 msgstr ""
 
-#: libdm-report.c:452
+#: libdm-report.c:472
 #, c-format
 msgid "dm_report: Unrecognised field: %.*s"
 msgstr ""
 
-#: libdm-report.c:474
+#: libdm-report.c:494
 msgid "dm_report_init: dm_malloc failed"
 msgstr ""
 
-#: libdm-report.c:506
+#: libdm-report.c:526
 msgid "dm_report_init: allocation of memory pool failed"
 msgstr ""
 
-#: libdm-report.c:552
+#: libdm-report.c:577
 msgid "dm_report_object: struct row allocation failed"
 msgstr ""
 
-#: libdm-report.c:562
+#: libdm-report.c:587
 msgid "dm_report_object: row sort value structure allocation failed"
 msgstr ""
 
-#: libdm-report.c:573
+#: libdm-report.c:598
 msgid "dm_report_object: struct dm_report_field allocation failed"
 msgstr ""
 
-#: libdm-report.c:586
+#: libdm-report.c:611
 #, c-format
 msgid "dm_report_object: report function failed for field %s"
 msgstr ""
 
-#: libdm-report.c:626
+#: libdm-report.c:651
 msgid "dm_report: dm_pool_begin_object failed for headings"
 msgstr ""
 
-#: libdm-report.c:640
+#: libdm-report.c:665
 msgid "dm_report: snprintf heading failed"
 msgstr ""
 
-#: libdm-report.c:644 libdm-report.c:649 libdm-report.c:656 libdm-report.c:661
+#: libdm-report.c:669 libdm-report.c:674 libdm-report.c:681 libdm-report.c:686
 msgid "dm_report: Failed to generate report headings for printing"
 msgstr ""
 
-#: libdm-report.c:664 libdm-report.c:826
+#: libdm-report.c:689 libdm-report.c:851
 #, c-format
 msgid "%s"
 msgstr ""
 
-#: libdm-report.c:727
+#: libdm-report.c:752
 msgid "dm_report: sort array allocation failed"
 msgstr ""
 
-#: libdm-report.c:770
+#: libdm-report.c:795
 msgid "dm_report: Unable to allocate output line"
 msgstr ""
 
-#: libdm-report.c:784 libdm-report.c:798 libdm-report.c:808 libdm-report.c:817
+#: libdm-report.c:809 libdm-report.c:823 libdm-report.c:833 libdm-report.c:842
 msgid "dm_report: Unable to extend output line"
 msgstr ""
 
-#: libdm-report.c:794
+#: libdm-report.c:819
 msgid "dm_report: left-aligned snprintf() failed"
 msgstr ""
 
-#: libdm-report.c:804
+#: libdm-report.c:829
 msgid "dm_report: right-aligned snprintf() failed"
 msgstr ""
 
-#: libdm-report.c:823
+#: libdm-report.c:848
 msgid "dm_report: Unable to terminate output line"
 msgstr ""
 
@@ -842,3 +848,36 @@
 #, c-format
 msgid "Out of memory.  Requested %zu bytes."
 msgstr ""
+
+#: regex/matcher.c:136
+msgid "Internal error: Unknown calc node type"
+msgstr ""
+
+#: regex/matcher.c:262
+#, c-format
+msgid "Matcher built with %d dfa states"
+msgstr ""
+
+#: regex/matcher.c:303
+msgid "Couldn't parse regex"
+msgstr ""
+
+#: regex/parse_rx.c:88
+msgid "Incomplete rangespecification"
+msgstr ""
+
+#: regex/parse_rx.c:166
+msgid "Badly quoted character at end of expression"
+msgstr ""
+
+#: regex/parse_rx.c:240
+msgid "missing ')' in regular expression"
+msgstr ""
+
+#: regex/parse_rx.c:322
+msgid "Badly formed 'or' expression"
+msgstr ""
+
+#: regex/parse_rx.c:350
+msgid "Parse error in regex"
+msgstr ""
