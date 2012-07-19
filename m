From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [RFC PATCH] multipath-tools: Preventing silent swapping
 of underlying LUNs
Date: Thu, 19 Jul 2012 17:07:31 +0900
Message-ID: <5007C043.4000006@ce.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I found multipathd could unexpectedly swaps underlying LUNs
when it should swap names.

Suppose someone has following /etc/multipath/bindings:
  mpathA  <wwid of LUN0>
  mpathB  <wwid of LUN1>
and created those multipath devices.

If he modified bindings as below and do 'multipathd -kreconfigure':
  mpathB  <wwid of LUN0>
  mpathA  <wwid of LUN1>
I think it is natural to expect the mpath device for <wwid of LUN0>
("mpathA") is renamed to "mpathB" and vice versa.

However, what actually happens is mpathA's underlying device is
changed to LUN1 and mpathB's underlying device is changed to LUN0.

As a result, users of those devices (mounted file systems, LVs, etc.)
could get errors and/or corrupt data.

(This not just about dynamic reconfiguration.
 Similar thing could happen if you forget to rebuild initrd
 after modifying bindings.)

If there is smarter solution such as swapping aliases correctly,
it would be nice.
But I think it's good to have a patch like this at a minimum
to prevent the bad thing from happening.

Comments?
---
Jun'ichi Nomura, NEC Corporation


Given alias/wwid pair in config, if there is a mpath with the wwid
and different alias, the mpath should be renamed to the given alias.
If there is already other mpath with the alias, though, we could not
simply rename it.
However, we must NOT try to create a mpath with the given alias/wwid
by changing the wwid (i.e. mappings) of the other mpath, that could
corrupt data.

The patch checks this case and give up processing.

diff -urp multipath-tools.orig/libmultipath/configure.c multipath-tools.new/libmultipath/configure.c
--- multipath-tools.orig/libmultipath/configure.c	2012-07-19 15:17:40.368622358 +0900
+++ multipath-tools.new/libmultipath/configure.c	2012-07-19 15:29:23.360746687 +0900
@@ -150,6 +150,7 @@ static void
 select_action (struct multipath * mpp, vector curmp, int force_reload)
 {
 	struct multipath * cmpp;
+	struct multipath * cmpp_tmp;
 
 	cmpp = find_mp_by_alias(curmp, mpp->alias);
 
@@ -169,7 +170,8 @@ select_action (struct multipath * mpp, v
 		return;
 	}
 
-	if (!find_mp_by_wwid(curmp, mpp->wwid)) {
+	cmpp_tmp = find_mp_by_wwid(curmp, mpp->wwid);
+	if (!cmpp_tmp) {
 		condlog(2, "%s: remove (wwid changed)", cmpp->alias);
 		dm_flush_map(mpp->alias);
 		strncpy(cmpp->wwid, mpp->wwid, WWID_SIZE);
@@ -180,6 +182,14 @@ select_action (struct multipath * mpp, v
 		return;
 	}
 
+	if (cmpp != cmpp_tmp) {
+		condlog(2, "%s: unable to rename %s to %s (%s is used by %s)",
+			mpp->wwid, cmpp_tmp->alias, mpp->alias,
+			mpp->alias, cmpp->wwid);
+		mpp->action = ACT_NOTHING;
+		return;
+	}
+
 	if (pathcount(mpp, PATH_UP) == 0) {
 		mpp->action = ACT_NOTHING;
 		condlog(3, "%s: set ACT_NOTHING (no usable path)",
