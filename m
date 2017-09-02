From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/31] test-kpartx: test deletion with empty part
	table
Date: Sun,  3 Sep 2017 00:38:36 +0200
Message-ID: <20170902223900.7339-8-mwilck@suse.com>
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

Added a test case for "kpartx: fix part deletion without partition
table".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/test-kpartx | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kpartx/test-kpartx b/kpartx/test-kpartx
index 35b0f064..60b3eb23 100755
--- a/kpartx/test-kpartx
+++ b/kpartx/test-kpartx
@@ -68,6 +68,10 @@ mk_partitions() {
     parted -s -- $1 mkpart prim ext2 1MiB -1s
 }
 
+wipe_ptable() {
+    dd if=/dev/zero of=$1 bs=1b count=1
+}
+
 step preparation
 
 [[ $UID -eq 0 ]]
@@ -165,8 +169,18 @@ mk_partitions $LO2
 # Test invocation of kpartx with regular file here
 LO2P1=/dev/mapper/$(basename $LO2)-foo1
 $KPARTX $KPARTX_OPTS -a -p -foo $FILE2
+[[ -b $LO2P1 ]]
 push_cleanup 'dmsetup remove -f $(basename $LO2P1)'
 
+step "remove partitions with deleted ptable"
+wipe_ptable $LO2
+$KPARTX $KPARTX_OPTS -d $LO2
+[[ ! -b $LO2P1 ]]
+
+mk_partitions $LO2
+$KPARTX $KPARTX_OPTS -a -p -foo $FILE2
+[[ -b $LO2P1 ]]
+
 LO1P1=/dev/mapper/$(basename $LO1)-eggs1
 $KPARTX $KPARTX_OPTS -a -p -eggs $LO1
 push_cleanup 'dmsetup remove -f $(basename $LO1P1)'
-- 
2.14.0
