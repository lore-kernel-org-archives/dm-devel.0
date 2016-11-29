From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: define data_offset status field
Date: Tue, 29 Nov 2016 19:26:08 +0100
Message-ID: <1480443968-24270-1-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 9bd531a..5e3786f 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -242,6 +242,10 @@ recovery.  Here is a fuller description of the individual fields:
 			in RAID1/10 or wrong parity values found in RAID4/5/6.
 			This value is valid only after a "check" of the array
 			is performed.  A healthy array has a 'mismatch_cnt' of 0.
+	<data_offset>   The current data offset to the start of the user data on
+			each component device of a raid set (see the respective
+			raid parameter to support out-of-place reshaping).
+
 
 Message Interface
 -----------------
-- 
2.7.4
