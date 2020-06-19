From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH v3 4/4] dm dust: introduce listbadblocks in the
	rst
Date: Fri, 19 Jun 2020 20:38:03 +0800
Message-ID: <20200619123803.1441373-5-yangerkun@huawei.com>
References: <20200619123803.1441373-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619123803.1441373-1-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, bgurney@redhat.com, agk@redhat.com, bmr@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

Since we support the listbadblocks command, introduce the detail in the
doc.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 .../admin-guide/device-mapper/dm-dust.rst        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index 84149c08b68f..5c66a71e3442 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -205,6 +205,21 @@ If there were no bad blocks to clear, the following message will
 appear::
 
         no badblocks found
+Listing the bad block list
+--------------------------
+
+To list all bad blocks in the bad block list(using an example device
+with blocks 1 and 2 in the bad block list),run the following message
+command::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+        1
+        2
+
+No bad block exists, same message will get following report::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+        null
 
 Message commands list
 ---------------------
@@ -224,6 +239,7 @@ Single argument message commands::
 
         countbadblocks
         clearbadblocks
+        listbadblocks
         disable
         enable
         quiet
-- 
2.25.4
