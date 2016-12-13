From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: change raid4/5/6 journal device status
	health char to 'A' rather than 'J'
Date: Tue, 13 Dec 2016 19:28:52 +0100
Message-ID: <20161213182852.21749-1-heinzm@redhat.com>
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

There's no need to create a tautology by introducing a new device health char 'J',
because the position of the status line field uniquely defines the char refering
to the journal.

This patch is on top of
"[PATCH v2] dm raid: add raid4/5/6 journaling support"
dated 11/30/2016.

Related: rhbz1400194
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt | 2 +-
 drivers/md/dm-raid.c                    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 67f69b2..8e6d910 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -254,7 +254,7 @@ recovery.  Here is a fuller description of the individual fields:
 	<data_offset>   The current data offset to the start of the user data on
 			each component device of a raid set (see the respective
 			raid parameter to support out-of-place reshaping).
-	<journal_char>	'J' - active raid4/5/6 journal device.
+	<journal_char>	'A' - active raid4/5/6 journal device.
 			'D' - dead journal device.
 			'-' - no journal device.
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 215285b..25bb5ab 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3170,17 +3170,16 @@ static const char *decipher_sync_action(struct mddev *mddev)
  *
  * Status characters:
  *
- *  'D' = Dead/Failed device
+ *  'D' = Dead/Failed raid set component or raid4/5/6 journal device
  *  'a' = Alive but not in-sync
- *  'A' = Alive and in-sync
- *  'J' = Journal device (raid4/5/6)
+ *  'A' = Alive and in-sync raid set component or alive raid4/5/6 journal device
  */
 static const char *__raid_dev_status(struct md_rdev *rdev, bool array_in_sync)
 {
 	if (test_bit(Faulty, &rdev->flags))
 		return "D";
 	else if (test_bit(Journal, &rdev->flags))
-		return "J";
+		return "A";
 	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
 		return "a";
 	else
-- 
2.9.3
