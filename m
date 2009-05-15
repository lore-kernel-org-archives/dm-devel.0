From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile ./multipath.conf.an ...
Date: 15 May 2009 21:01:30 -0000
Message-ID: <20090515210130.16397.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-05-15 21:01:27

Modified files:
	.              : Makefile multipath.conf.annotated 
	libmultipath   : callout.c config.c config.h dict.c propsel.c 
	multipath      : Makefile multipath.conf.5 
	multipathd     : multipathd.init.redhat 
Added files:
	path_priority/pp_weighted: Makefile pp_weighted.c 

Log message:
	Fix for 437588. Added a new prio callout mpath_prio_weighted.  This allows
	people to add priorities based on a device's devname or HTBL.  However, this
	callout has problems.  On reboots and driver reloads, the devname and HTBL can
	change. But if people really want to use this anyway, they can.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.3&r2=1.7.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.12&r2=1.18.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/callout.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.8&r2=1.19.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.7&r2=1.18.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.10&r2=1.17.2.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.2&r2=1.11.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.2&r2=1.17.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.5.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/multipathd.init.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.4.4&r2=1.2.4.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_weighted/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_weighted/pp_weighted.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1

--- multipath-tools/Makefile	2008/07/12 01:24:07	1.7.2.3
+++ multipath-tools/Makefile	2009/05/15 21:01:26	1.7.2.4
@@ -22,13 +22,14 @@
 BUILDDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	    path_priority/pp_emc path_priority/pp_hds_modular \
 	    path_priority/pp_netapp path_priority/pp_rdac \
-	    path_priority/pp_tpc path_priority/pp_hp_sw
+	    path_priority/pp_tpc path_priority/pp_hp_sw \
+	    path_priority/pp_weighted
 
 ALLDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	  path_priority/pp_emc path_priority/pp_hds_modular \
 	  path_priority/pp_netapp path_priority/pp_rdac \
 	  path_priority/pp_hp_sw path_priority/pp_tpc \
-	  libmultipath libcheckers
+	  path_priority/pp_weighted libmultipath libcheckers
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
 
--- multipath-tools/multipath.conf.annotated	2009/05/05 22:02:30	1.18.2.12
+++ multipath-tools/multipath.conf.annotated	2009/05/15 21:01:26	1.18.2.13
@@ -302,6 +302,17 @@
 #		path_grouping_policy	multibus
 #
 #		#
+#		# name    : prio_callout
+#		# scope   : multipath
+#		# desc    : the program and args to callout to obtain a path
+#		#           weight. Weights are summed for each path group to
+#		#	    determine the next PG to use case of failure.
+#		#	    "none" is a valid value.
+#		# default : no callout, all paths equals
+#		#
+#		prio_callout          "/sbin/mpath_prio_balance_units %d"
+#
+#		#
 #		# name    : path_selector
 #		# desc    : the path selector algorithm to use for this mpath
 #		#           these algo are offered by the kernel mpath target
--- multipath-tools/libmultipath/callout.c	2009/01/16 22:47:31	1.5.2.1
+++ multipath-tools/libmultipath/callout.c	2009/05/15 21:01:26	1.5.2.2
@@ -189,6 +189,18 @@
 		snprintf(p, len, "%s", pp->dev_t);
 		p += len - 1;
 		break;
+	case 'h':
+		if (pp->sg_id.host_no < 0)
+			len = snprintf(p, myfree, "#:#:#:#");
+		else
+			len = snprintf(p, myfree, "%d:%d:%d:%d",
+				       pp->sg_id.host_no, pp->sg_id.channel,
+				       pp->sg_id.scsi_id, pp->sg_id.lun);
+		myfree -= (len + 1);
+		if (myfree < 2)
+			return 1;
+		p += len;
+		break;
 	default:
 		break;
 	}
--- multipath-tools/libmultipath/config.c	2009/04/29 04:41:33	1.19.2.8
+++ multipath-tools/libmultipath/config.c	2009/05/15 21:01:26	1.19.2.9
@@ -219,6 +219,9 @@
 	if (mpe->alias)
 		FREE(mpe->alias);
 
+	if (mpe->getprio)
+		FREE(mpe->getprio);
+
 	FREE(mpe);
 }
 
--- multipath-tools/libmultipath/config.h	2008/09/08 22:01:20	1.18.2.7
+++ multipath-tools/libmultipath/config.h	2009/05/15 21:01:26	1.18.2.8
@@ -39,6 +39,7 @@
 	char * alias;
 	char * getuid;
 	char * selector;
+	char * getprio;
 
 	int pgpolicy;
 	int pgfailback;
--- multipath-tools/libmultipath/dict.c	2009/04/29 04:41:33	1.17.2.10
+++ multipath-tools/libmultipath/dict.c	2009/05/15 21:01:26	1.17.2.11
@@ -731,7 +731,7 @@
 }
 
 static int
-prio_callout_handler(vector strvec)
+hw_prio_callout_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 	
@@ -999,6 +999,28 @@
 }
 
 static int
+mp_prio_callout_handler(vector strvec)
+{
+	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	mpe->getprio = set_value(strvec);
+
+	if (!mpe->getprio)
+		return 1;
+
+	if (strlen(mpe->getprio) == 4 && !strcmp(mpe->getprio, "none")) {
+		FREE(mpe->getprio);
+		mpe->getprio = NULL;
+		return 0;
+	}
+
+	return push_callout(mpe->getprio);
+}
+
+static int
 mp_failback_handler(vector strvec)
 {
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
@@ -1327,6 +1349,26 @@
 }
 
 static int
+snprint_mp_prio_callout (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if (!conf->getprio && !mpe->getprio)
+		return 0;
+	if (!conf->getprio && mpe->getprio)
+		return snprintf(buff, len, "%s", mpe->getprio);
+	if (conf->getprio && !mpe->getprio)
+		return snprintf(buff, len, "none");
+
+	/* conf->getprio && mpe->getprio */
+	if (strlen(mpe->getprio) == strlen(conf->getprio) &&
+	    !strcmp(mpe->getprio, conf->getprio))
+		return 0;
+
+	return snprintf(buff, len, "%s", mpe->getprio);
+}
+
+static int
 snprint_mp_rr_weight (char * buff, int len, void * data)
 {
 	struct mpentry * mpe = (struct mpentry *)data;
@@ -2016,7 +2058,7 @@
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
 	install_keyword("features", &hw_features_handler, &snprint_hw_features);
 	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
-	install_keyword("prio_callout", &prio_callout_handler, &snprint_hw_prio_callout);
+	install_keyword("prio_callout", &hw_prio_callout_handler, &snprint_hw_prio_callout);
 	install_keyword("failback", &hw_failback_handler, &snprint_hw_failback);
 	install_keyword("rr_weight", &hw_weight_handler, &snprint_hw_rr_weight);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
@@ -2033,6 +2075,7 @@
 	install_keyword("path_grouping_policy", &mp_pgpolicy_handler, &snprint_mp_path_grouping_policy);
 	install_keyword("path_selector", &mp_selector_handler, &snprint_mp_selector);
 	install_keyword("failback", &mp_failback_handler, &snprint_mp_failback);
+	install_keyword("prio_callout", &mp_prio_callout_handler, &snprint_mp_prio_callout);
 	install_keyword("rr_weight", &mp_weight_handler, &snprint_mp_rr_weight);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
--- multipath-tools/libmultipath/propsel.c	2008/09/04 20:09:48	1.11.2.2
+++ multipath-tools/libmultipath/propsel.c	2009/05/15 21:01:26	1.11.2.3
@@ -259,6 +259,16 @@
 extern int
 select_getprio (struct path * pp)
 {
+	struct mpentry * mpe;
+
+	if ((mpe = find_mpe(pp->wwid))) {
+		if (mpe->getprio) {
+			pp->getprio = mpe->getprio;
+			condlog(3, "%s: getprio = %s (LUN setting)",
+				pp->dev, pp->getprio);
+			return 0;
+		}
+	}
 	if (pp->hwe && pp->hwe->getprio) {
 		pp->getprio = pp->hwe->getprio;
 		condlog(3, "%s: getprio = %s (controller setting)",
--- multipath-tools/multipath/Makefile	2009/05/06 17:26:43	1.17.2.2
+++ multipath-tools/multipath/Makefile	2009/05/15 21:01:27	1.17.2.3
@@ -55,7 +55,7 @@
 	rm $(DESTDIR)$(bindir)/mpath_wait
 	rm $(DESTDIR)$(bindir)/mpath_ctl
 	rm $(DESTDIR)$(mandir)/$(EXEC).8
-	rm $(DESTDIR)$(mandir)/$(EXEC).conf.5
+	rm $(DESTDIR)$(man5dir)/$(EXEC).conf.5
 
 clean:
 	$(MAKE) -C $(multipathdir) clean
--- multipath-tools/multipath/Attic/multipath.conf.5	2009/05/05 22:02:31	1.1.2.1
+++ multipath-tools/multipath/Attic/multipath.conf.5	2009/05/15 21:01:27	1.1.2.2
@@ -143,6 +143,18 @@
 .B mpath_prio_hds_modular %b
 Generate the path priority for Hitachi HDS Modular storage arrays.
 .TP
+.B mpath_prio_weighted %n|%h <regex1> <prio1> [<regex2> <prio2>] ...
+Generate a path priority based on the matching either the device name \fI%n\fR
+or the H:B:T:L \fI%h\fR of the devices against a series of regular expressions.
+\fIWARNING:\fR Both the device name and the H:B:T:L of a device can change when
+the node is rebooted, or the device driver is reloaded. If you use this callout
+it may be necessary to manually edit your regular expressions whenever either
+of these events occurs.
+\fINOTE:\fR The regular expression must match the complete device name or
+H:B:T:L. For instance a regular expression of \fIsda\fR will only match a
+device named sda, not sdaa, sdab, etc. To match all of them, you would need to
+use the regular expression \fIsda.*\fR
+.TP
 Default value is \fBnone\fR.
 .RE
 .TP
@@ -343,6 +355,8 @@
 .TP 18
 .B path_grouping_policy
 .TP
+.B prio_callout
+.TP
 .B path_selector
 .TP
 .B failback
--- multipath-tools/multipathd/multipathd.init.redhat	2009/04/06 16:50:44	1.2.4.4
+++ multipath-tools/multipathd/multipathd.init.redhat	2009/05/15 21:01:27	1.2.4.5
@@ -29,8 +29,7 @@
 
 teardown_slaves()
 {
-pwd=`pwd`
-cd $1; 
+pushd $1 > /dev/null
 if [ -d "slaves" ]; then
 for slave in slaves/*;
 do
@@ -55,7 +54,7 @@
 			exit 1
 		fi
 fi
-cd $pwd
+popd > /dev/null
 }
 
 #
