From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/20] test-kpartx: add test for mapping
	without UUID
Date: Sat, 13 Jan 2018 22:19:33 +0100
Message-ID: <20180113211938.31552-16-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

kpartx shouldn't remove these mappings.
---
 kpartx/test-kpartx | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kpartx/test-kpartx b/kpartx/test-kpartx
index 60b3eb231de2..09d15a9458ea 100755
--- a/kpartx/test-kpartx
+++ b/kpartx/test-kpartx
@@ -131,7 +131,7 @@ step "create DM devices (spans)"
 # They also serve as DM devices to test partition removal on those.
 
 TABLE="\
-0 $((SIZE/SECTSIZ-OFFS)) linear $DEV1 $OFFS
+0 $((SIZE/SECTSIZ-OFFS)) linear $DEV1 $OFFS 
 $((SIZE/SECTSIZ-OFFS)) $((SIZE/SECTSIZ-OFFS)) linear $DEV2 $OFFS"
 
 SPAN1=kpt
@@ -142,9 +142,17 @@ push_cleanup 'dmsetup remove -f $SPAN1'
 dmsetup create $SPAN2 <<<"$TABLE"
 push_cleanup 'dmsetup remove -f $SPAN2'
 
+# This is a non-kpartx pseudo "partition" mapping
+USER1=user1
+push_cleanup 'dmsetup remove -f $USER1'
+dmsetup create $USER1 <<EOF
+0 $((SIZE/SECTSIZ-OFFS)) linear $DEV1 $OFFS
+EOF
+
 usleep $WAIT_US
 [[ -b /dev/mapper/$SPAN1 ]]
 [[ -b /dev/mapper/$SPAN2 ]]
+[[ -b /dev/mapper/$USER1 ]]
 
 step "create vg on $LO3"
 # On the 3rd loop device, we create a VG and an LV
@@ -290,6 +298,7 @@ pop_cleanup
 # spans should not have been removed
 [[ -b /dev/mapper/$SPAN1 ]]
 [[ -b /dev/mapper/$SPAN2 ]]
+[[ -b /dev/mapper/$USER1 ]]
 # LVs neither
 [[ -b /dev/mapper/$VG-$LV ]]
 
-- 
2.15.1
