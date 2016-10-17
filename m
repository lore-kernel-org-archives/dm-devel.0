From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] Doc: dm raid: Fix typo in dm-raid.txt
Date: Mon, 17 Oct 2016 21:17:10 +0900
Message-ID: <20161017121710.16927-1-standby24x7@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: snitzer@redhat.com, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, agk@redhat.com, dm-devel@redhat.com
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: dm-devel.ids

This patch fix spelling typos in Documentation/device-mapper/dm-raid.txt.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/device-mapper/dm-raid.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index e5b6497116f4..89ecc8021178 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -17,7 +17,7 @@ The target is named "raid" and it accepts the following parameters:
   raid0		RAID0 striping (no resilience)
   raid1		RAID1 mirroring
   raid4		RAID4 with dedicated last parity disk
-  raid5_n 	RAID5 with dedicated last parity disk suporting takeover
+  raid5_n 	RAID5 with dedicated last parity disk supporting takeover
 		Same as raid4
 		-Transitory layout
   raid5_la	RAID5 left asymmetric
@@ -36,7 +36,7 @@ The target is named "raid" and it accepts the following parameters:
 		- rotating parity N (right-to-left) with data continuation
   raid6_n_6	RAID6 with dedicate parity disks
 		- parity and Q-syndrome on the last 2 disks;
-		  laylout for takeover from/to raid4/raid5_n
+		  layout for takeover from/to raid4/raid5_n
   raid6_la_6	Same as "raid_la" plus dedicated last Q-syndrome disk
 		- layout for takeover from raid5_la from/to raid6
   raid6_ra_6	Same as "raid5_ra" dedicated last Q-syndrome disk
@@ -137,8 +137,8 @@ The target is named "raid" and it accepts the following parameters:
 		device removal (negative value) or device addition (positive
 		value) to any reshape supporting raid levels 4/5/6 and 10.
 		RAID levels 4/5/6 allow for addition of devices (metadata
-		and data device tupel), raid10_near and raid10_offset only
-		allow for device addtion. raid10_far does not support any
+		and data device tuple), raid10_near and raid10_offset only
+		allow for device addition. raid10_far does not support any
 		reshaping at all.
 		A minimum of devices have to be kept to enforce resilience,
 		which is 3 devices for raid4/5 and 4 devices for raid6.
-- 
2.10.1.432.g8a36cd8

