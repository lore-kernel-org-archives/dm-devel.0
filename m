From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/31] test-kpartx: add tests for renaming
	functionality
Date: Sun,  3 Sep 2017 00:38:33 +0200
Message-ID: <20170902223900.7339-5-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Add test for the functionality implemented in patch
"kpartx: search partitions by UUID, and rename".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/test-kpartx | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/kpartx/test-kpartx b/kpartx/test-kpartx
index 7c45cd14..35b0f064 100755
--- a/kpartx/test-kpartx
+++ b/kpartx/test-kpartx
@@ -207,6 +207,17 @@ usleep $WAIT_US
 [[ -b $SPAN2P1 ]]
 [[ -b $SPAN1P1 ]]
 
+step "rename partitions on DM device to default"
+$KPARTX $KPARTX_OPTS -u /dev/mapper/$SPAN1
+[[ ! -b ${SPAN1P1} ]]
+# This assumes that $SPAN1 ends in a non-digit
+[[ -b ${SPAN1P1//-spam/} ]]
+
+step "rename partitions on DM device back from default"
+$KPARTX $KPARTX_OPTS -u -p -spam /dev/mapper/$SPAN1
+[[ -b ${SPAN1P1} ]]
+[[ ! -b ${SPANP1//-foo/} ]]
+
 step "delete partitions on DM devices"
 $KPARTX $KPARTX_OPTS -d /dev/mapper/$SPAN1 >&2
 usleep $WAIT_US
@@ -223,6 +234,31 @@ usleep $WAIT_US
 [[ -b $LO2P1 ]]
 [[ ! -b $SPAN2P1 ]]
 
+step "rename partitions on loop device"
+$KPARTX $KPARTX_OPTS -u -p -spam $LO2
+[[ ! -b ${LO2P1} ]]
+[[ -b ${LO2P1//-foo/-spam} ]]
+
+step "rename partitions on loop device back"
+$KPARTX $KPARTX_OPTS -u -p -foo $LO2
+[[ -b ${LO2P1} ]]
+[[ ! -b ${LO2P1//-foo/-spam} ]]
+
+step "rename partitions on loop device to default"
+$KPARTX $KPARTX_OPTS -u $LO2
+#read a
+[[ ! -b ${LO2P1} ]]
+# $LO1 ends in a digit
+[[ -b ${LO2P1//-foo/p} ]]
+
+step "rename partitions on loop device back from default"
+$KPARTX $KPARTX_OPTS -u -p -foo $LO2
+[[ -b ${LO2P1} ]]
+[[ ! -b ${LO2P1//-foo/p} ]]
+
+step "rename partitions on loop devices"
+$KPARTX $KPARTX_OPTS -u -p spam $LO2
+
 step "delete partitions on loop devices"
 
 $KPARTX $KPARTX_OPTS -d $LO3
-- 
2.14.0
