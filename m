From: heinzm@redhat.com
Subject: [PATCH 6/4 v2] dm-raid: enhance discard_zeroes_data
	documentation
Date: Fri, 15 May 2015 20:35:10 +0200
Message-ID: <1431714910-375-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch adds documentation explaining background of
discard_zeroes_data issues with raid4/5/6 and the related
devices_handle_discards_safely module parameter.


Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 Documentation/device-mapper/dm-raid.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index bceb865..713739b 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -226,4 +226,25 @@ Version History
 1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
 1.6.0   Add devices_handle_discards_safely module parameter to
 	allow discards on disks anouncing uncertain discard_zeroes_data
+	(see *discard* below for more details)
 1.7.0   Add support for MD RAID0 mappings
+
+*discard'
+The MD raid4/5/6 personalities trust discard_zeroes_data ensuring
+to return zeroes as block content after a discard and thus avoid
+rewriting them; the zeroed content is used to reconstruct data
+on a disk failure thus leading to corrupion in any reconstructed
+block derived from discarded ones.
+
+Field reports showed, that an unknown number of disks fail supporting
+discard_zeroes_data properly, hence they may return non-zero block
+content after a discard.
+
+In order to avoid data corruption on recovery of failed RAID device
+content using discarded blocks, we have to avoid using the feature
+by default.
+
+For convenience, the module parameter devices_handle_discards_safely
+allows users knowing for sure that discard_zeroes_data works properly
+on all their raid disks to overwrite the default and make use
+of the discard_zeroes_data optimization.
-- 
2.1.0
