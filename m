From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: document when snapshot has finished merging
Date: Wed, 27 Jan 2010 15:55:59 -0500
Message-ID: <1264625759-23087-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Update Documentation/device-mapper/snapshot.txt to cover "How to
determine when a snapshot has finished merging".

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/snapshot.txt |   42 ++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/snapshot.txt b/Documentation/device-mapper/snapshot.txt
index e3a77b2..7028a2a 100644
--- a/Documentation/device-mapper/snapshot.txt
+++ b/Documentation/device-mapper/snapshot.txt
@@ -122,3 +122,45 @@ volumeGroup-base: 0 2097152 snapshot-merge 254:11 254:12 P 16
 brw-------  1 root root 254, 11 29 ago 18:15 /dev/mapper/volumeGroup-base-real
 brw-------  1 root root 254, 12 29 ago 18:16 /dev/mapper/volumeGroup-base-cow
 brw-------  1 root root 254, 10 29 ago 18:16 /dev/mapper/volumeGroup-base
+
+
+How to determine when a snapshot has finished merging
+=====================================================
+The status for the snapshot-merge (and snapshot) target includes the
+"allocated metadata sectors".  The snapshot(-merge) status format is:
+<sectors_allocated>/<total_sectors> <metadata_sectors>
+
+Merging has finished when <sectors_allocated> == <metadata_sectors>
+
+Here is a practical example (using a hybrid of lvm and dmsetup commands):
+
+# lvs
+  LV             VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
+  testlv1        test owi-a- 4.00g
+  testlv1_snap   test swi-a- 1.00g testlv1  18.97
+
+# dmsetup status test-testlv1_snap
+0 8388608 snapshot 397896/2097152 1560
+                                  ^^^^ metadata sectors
+
+# lvconvert --merge -b test/testlv1_snap
+  Merging of volume testlv1_snap started.
+
+# lvs test/testlv1
+  LV      VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
+  testlv1 test Owi-a- 4.00g          17.23
+
+# dmsetup status test-testlv1
+0 8388608 snapshot-merge 281688/2097152 1104
+
+# dmsetup status test-testlv1
+0 8388608 snapshot-merge 180480/2097152 712
+
+# dmsetup status test-testlv1
+0 8388608 snapshot-merge 16/2097152 16
+
+Merging has finished
+
+# lvs
+  LV             VG   Attr   LSize Origin  Snap%  Move Log Copy%  Convert
+  testlv1        test owi-a- 4.00g
