From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 16/21] [multipath] Update multipath.8 manpage
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.9B63DD44CF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Update multipath.8 manpage. Add option '-t' and fix
cross-references.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.8 |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 693872b..e72cc45 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -6,7 +6,7 @@ multipath \- Device mapper target autoco
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-F \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -47,6 +47,9 @@ flush a multipath device map specified a
 .B \-F
 flush all unused multipath device maps
 .TP
+.B \-t
+print internal hardware table to stdout
+.TP
 .BI \-p " policy"
 force maps to specified policy:
 .RS 1.2i
@@ -76,6 +79,9 @@ is in the /dev/sdb (as shown by udev in
 .I device
 may alternatively be a multipath mapname
 .SH "SEE ALSO"
+.BR multipathd (8),
+.BR multipath.conf (5),
+.BR kpartx (8),
 .BR udev (8),
 .BR dmsetup (8)
 .BR hotplug (8)
-- 
1.4.3.4
