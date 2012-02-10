From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: adjust messages
Date: Fri, 10 Feb 2012 12:16:50 -0600
Message-ID: <20120210181650.GQ1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Stop the rport_id messages from being dispalyed all the time, and add a message
alerting users when multipath tries to setup a map and fails, or ends up
removing the map.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |    3 +++
 libmultipath/discovery.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: multipath-tools-120123/libmultipath/configure.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/configure.c
+++ multipath-tools-120123/libmultipath/configure.c
@@ -576,6 +576,9 @@ coalesce_paths (struct vectors * vecs, v
 				   "for create/reload map",
 				mpp->alias, r);
 			if (r == DOMAP_FAIL) {
+				condlog(2, "%s: %s map",
+					mpp->alias, (mpp->action == ACT_CREATE)?
+					"ignoring" : "removing");
 				remove_map(mpp, vecs, 0);
 				continue;
 			} else /* if (r == DOMAP_RETRY) */
Index: multipath-tools-120123/libmultipath/discovery.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/discovery.c
+++ multipath-tools-120123/libmultipath/discovery.c
@@ -318,7 +318,7 @@ sysfs_set_scsi_tmo (struct multipath *mp
 	vector_foreach_slot(mpp->paths, pp, i) {
 		rport_id = find_rport_id(pp);
 		if (rport_id < 0) {
-			condlog(0, "failed to find rport_id for target%d:%d:%d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
+			condlog(3, "failed to find rport_id for target%d:%d:%d", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
 			return 1;
 		}
 
