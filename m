From: heinzm@sourceware.org
Subject: dmraid/logwatch dmeventd dmeventd.conf dmevent ...
Date: 11 Jan 2010 15:18:14 -0000
Message-ID: <20100111151814.16735.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2010-01-11 15:18:13

Added files:
	logwatch       : dmeventd dmeventd.conf dmeventd_cronjob.txt 
	                 logwatch.conf 

Log message:
	logwatch files

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/logwatch/dmeventd.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/logwatch/dmeventd.conf.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/logwatch/dmeventd_cronjob.txt.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/logwatch/logwatch.conf.diff?cvsroot=dm&r1=NONE&r2=1.1

/cvs/dm/dmraid/logwatch/dmeventd,v  -->  standard output
revision 1.1
--- dmraid/logwatch/dmeventd
+++ -	2010-01-11 15:18:13.643886000 +0000
@@ -0,0 +1,89 @@
+########################################################################
+# Copyright (C) 2007-2008, Intel Corp. All rights reserved.
+#
+#
+# This program is free software; you can redistribute it and/or modify it under
+# the terms of the GNU General Public License as published by the Free Software
+# Foundation; either version 2 of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
+# for more details.
+#
+# You should have received a copy of the GNU General Public License along
+# with this program; if not, write to the Free Software Foundation, Inc.,
+# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+########################################################################
+
+########################################################
+# dmeventd
+########################################################
+
+########################################################
+# This was written by:
+#    Brian Wood <brian.j.wood@intel.com>
+#
+# Changes to get it to work:
+#    Heinz Mauelshagen <heinzm@redhat.com>
+#
+#    Needs more tweking to deal with absolute timestamp timestamps properly
+#    in order to avoid mismatches in the log file being displayed!!!
+#
+# 
+########################################################
+
+# Set the location of the folder to store last time stamp
+# (This is used to record the last log sent out so repeats 
+#  are not mailed in error.)
+$syslogpattern_file =
+        "/etc/logwatch/scripts/services/dmeventd_syslogpattern.txt";
+
+if (-e $syslogpattern_file) {
+	open(FD, "+<", $syslogpattern_file) or die $!;        
+        $last_pattern = join('', <FD>);
+} else {
+	open(FD, ">", $syslogpattern_file) or die $!;
+	$last_pattern = "";
+}
+
+# SAMPLE LOG DATA:
+# Oct 15 01:14:33 dmraid-devhost dmeventd[24857]: Processing device \
+# "isw_febiihjha_Volume0" for events
+@entries = ();
+@pattern = ();
+
+while (<>) {
+	($month, $day, $time, $message) = split(' ', $_, 4);
+	($m, $d, $t, $mes) = split(' ', @pattern[0], 4);
+	if ($time ne $t) {
+		@pattern = ();
+	} 
+
+	# New pattern.
+	push (@pattern, $_);
+	push (@entries, $_);
+
+	if (join('', @pattern) eq $last_pattern) {
+                @entries = ();
+                @pattern = ();
+                $last_pattern = "";
+	}
+}
+
+if ($#entries > -1) {
+	print("There were a total of ", $#entries + 1, " new log entries\n\n");
+	print("Date             Message\n");
+	print("-" x 80, "\n");
+	print @entries;
+
+	# Now save current pattern.
+        close(FD);
+        open(FD, ">", $syslogpattern_file) or die $!;
+	printf FD join('',@pattern);
+}
+
+close(FD);
+exit(0);
+
+# vi: shiftwidth=3 syntax=perl et
/cvs/dm/dmraid/logwatch/dmeventd.conf,v  -->  standard output
revision 1.1
--- dmraid/logwatch/dmeventd.conf
+++ -	2010-01-11 15:18:13.754495000 +0000
@@ -0,0 +1,31 @@
+########################################################################
+# Copyright (C) 2007-2008, Intel Corp. All rights reserved.
+#
+#
+# This program is free software; you can redistribute it and/or modify it under
+# the terms of the GNU General Public License as published by the Free Software
+# Foundation; either version 2 of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
+# for more details.
+#
+# You should have received a copy of the GNU General Public License along
+# with this program; if not, write to the Free Software Foundation, Inc.,
+# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+########################################################################
+
+##################################################################
+#
+# dmeventd script ver. 0.0.1 for Logwatch.
+#
+# Written by B. Wood <brian.j.wood@intel.com>
+#
+##################################################################
+
+Title = "Dmeventd Errors"
+LogFile = messages
+*OnlyService = dmeventd
+
+# vi: shiftwidth=3 tabstop=3 et
/cvs/dm/dmraid/logwatch/dmeventd_cronjob.txt,v  -->  standard output
revision 1.1
--- dmraid/logwatch/dmeventd_cronjob.txt
+++ -	2010-01-11 15:18:13.952920000 +0000
@@ -0,0 +1,2 @@
+# |DMEVENTD| This will run logwatch checking for dmeventd events every minute.
+# * * * * * /usr/sbin/logwatch --service dmeventd --range today --detail med
/cvs/dm/dmraid/logwatch/logwatch.conf,v  -->  standard output
revision 1.1
--- dmraid/logwatch/logwatch.conf
+++ -	2010-01-11 15:18:14.067861000 +0000
@@ -0,0 +1,26 @@
+########################################################################
+# Copyright (C) 2007-2008, Intel Corp. All rights reserved.
+#
+#
+# This program is free software; you can redistribute it and/or modify it under
+# the terms of the GNU General Public License as published by the Free Software
+# Foundation; either version 2 of the License, or (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
+# for more details.
+#
+# You should have received a copy of the GNU General Public License along
+# with this program; if not, write to the Free Software Foundation, Inc.,
+# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+########################################################################
+
+# Local configuration options go here (defaults are in /usr/share/logwatch/default.conf/logwatch.conf)
+MailTo = root
+# To send email to an external user change "root" to something like: guest@anonymous.com
+mailer = "/usr/sbin/sendmail -t"
+LogDir = /var/log
+MailFrom = Logwatch
+Range = Today
+Detail = Med 
