From: bmarzins@sourceware.org
Subject: multipath-tools multipath.conf.synthetic
Date: 7 Mar 2011 18:42:04 -0000
Message-ID: <20110307184204.25414.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-03-07 18:42:03

Modified files:
	.              : multipath.conf.synthetic 

Log message:
	Forgot to remove /bin/true reference from multipath.conf.synthetic. Removing.
	Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.6&r2=1.11.2.7

--- multipath-tools/multipath.conf.synthetic	2008/09/08 22:01:19	1.11.2.6
+++ multipath-tools/multipath.conf.synthetic	2011/03/07 18:42:03	1.11.2.7
@@ -8,7 +8,7 @@
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
 #	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#	prio_callout		/bin/true
+#	prio_callout		none
 #	path_checker		readsector0
 #	rr_min_io		100
 #	max_fds			8192
