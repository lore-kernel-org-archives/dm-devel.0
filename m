From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: update multipathd man page
Date: Fri, 3 Dec 2010 17:32:53 -0600
Message-ID: <20101203233253.GL25172@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

Add missing items to the multipathd man page.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8 |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Index: multipath-tools-101104/multipathd/multipathd.8
===================================================================
--- multipath-tools-101104.orig/multipathd/multipathd.8
+++ multipath-tools-101104/multipathd/multipathd.8
@@ -35,9 +35,17 @@ The following commands can be used in in
 .B list|show paths
 Show the paths that multipathd is monitoring, and their state. 
 .TP
+.B list|show paths format $format
+Show the paths that multipathd is monitoring, using a format string with path
+format wildcards.
+.TP
 .B list|show maps|multipaths
 Show the multipath devices that the multipathd is monitoring. 
 .TP
+.B list|show maps|multipaths format $format
+Show the status of all multipath devices that the multipathd is monitoring,
+using a format string with multipath format wildcards.
+.TP
 .B list|show maps|multipaths status
 Show the status of all multipath devices that the multipathd is monitoring.
 .TP
@@ -54,6 +62,9 @@ Show the current multipath topology. Sam
 Show topology of a single multipath device specified by $map, e.g. 36005076303ffc56200000000000010aa.
 This map could be obtained from "list maps".
 .TP
+.B list|show wildcards
+Show the format wildcards used in interactive commands taking $format
+.TP
 .B list|show config
 Show the currently used configuration, derived from default values and values specified within the configuration file /etc/multipath.conf.
 .TP
@@ -99,11 +110,20 @@ Sets path $path into failed state.
 .B reinstate path $path
 Resumes path $path from failed state.
 .TP
+.B disablequeueing maps|multipaths
+Disable queueing on all multipath devices.
+.TP
+.B restorequeueing maps|multipaths
+Restore queueing on all multipath devices.
+.TP
 .B disablequeueing map|multipath $map
-Disabled queuing on multipathed map $map
+Disable queuing on multipathed map $map
 .TP
 .B restorequeueing map|multipath $map
 Restore queuing on multipahted map $map
+.TP
+.B quit|exit
+End interactive session.
 
 .SH "SEE ALSO"
 .BR multipath (8)
