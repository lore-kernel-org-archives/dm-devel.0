From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH v4 4/4] dm dust: introduce listbadblocks in the
	rst
Date: Fri, 19 Jun 2020 17:13:04 -0400
Message-ID: <1592601184-4168-1-git-send-email-bgurney@redhat.com>
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
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: yangerkun <yangerkun@huawei.com>, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

From: yangerkun <yangerkun@huawei.com>

From: yangerkun <yangerkun@huawei.com>

Since we support the listbadblocks command, introduce the detail in the
doc.

[Bryan: formatting and wording fixes]

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 .../admin-guide/device-mapper/dm-dust.rst       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index cf8079e368de..e35ec8cd2f88 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -206,6 +206,22 @@ appear::
 
         dust_clear_badblocks: no badblocks found
 
+Listing the bad block list
+--------------------------
+
+To list all bad blocks in the bad block list (using an example device
+with blocks 1 and 2 in the bad block list), run the following message
+command::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+        1
+        2
+
+If there are no bad blocks in the bad block list, the command will
+execute with no output::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+
 Message commands list
 ---------------------
 
@@ -224,6 +240,7 @@ Single argument message commands::
 
         countbadblocks
         clearbadblocks
+        listbadblocks
         disable
         enable
         quiet
-- 
2.25.4
