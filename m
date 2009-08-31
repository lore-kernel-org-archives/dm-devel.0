From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: [PATCH] Update multipathd manpage
Date: Mon, 31 Aug 2009 10:42:41 +0530
Message-ID: <1251695561-14783-1-git-send-email-rsarraf@netapp.com>
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
To: dm-devel@redhat.com
Cc: rsarraf@netapp.com
List-Id: dm-devel.ids

New commands added to the multipathd -k command mode.
Document them in the manpage

Signed-off-by: Ritesh Raj Sarraf <rsarraf@netapp.com>
---
 multipathd/multipathd.8 |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 480b8ed..275f24c 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -1,4 +1,4 @@
-.TH MULTIPATHD 8 "November 2006" "Linux Administrator's Manual"
+.TH MULTIPATHD 8 "November 2009" "Linux Administrator's Manual"
 .SH NAME
 multipathd \- multipath daemon
 
@@ -74,6 +74,9 @@ Add a multipath device to the list of monitored devices. $map can either be a de
 .TP
 .B remove|del map $map
 Stop monitoring a multipath device.
+.TP
+.B resize map|multipath $map
+Resizes map $map to the given size
 .TP 
 .B switch|switchgroup map $map group $group
 Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
@@ -92,6 +95,12 @@ Sets path $path into failed state.
 .TP
 .B reinstate path $path
 Resumes path $path from failed state.
+.TP
+.B disablequeueing map|multipath $map
+Disabled queuing on multipathed map $map
+.TP
+.B restorequeueing map|multipath $map
+Restore queuing on multipahted map $map
 
 .SH "SEE ALSO"
 .BR multipath (8)
-- 
1.6.3.3
