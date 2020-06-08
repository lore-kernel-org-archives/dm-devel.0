From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH 2/2] dm dust: introduce listbadblocks in the rst
Date: Mon, 8 Jun 2020 16:45:13 +0800
Message-ID: <20200608084513.115671-3-yangerkun@huawei.com>
References: <20200608084513.115671-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200608084513.115671-1-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bgurney@redhat.com, agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

Since we support the listbadblocks command, introduce the detail in the
doc.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Bryan Gurney <bgurney@redhat.com>
---
 .../admin-guide/device-mapper/dm-dust.rst      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index b6e7e7ead831..2c51a4acb8be 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -205,6 +205,23 @@ appear::
 
         kernel: device-mapper: dust: clearbadblocks: no badblocks found
 
+Listing the bad block list
+--------------------------
+
+To list all bad blocks in the bad block list, run the following message
+command::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+
+The following message will appear, listing one bad block number per
+line (using an example device with blocks 1 and 2 in the bad block
+list)::
+
+        device-mapper: dust: dust_list_badblocks: badblocks list below:
+        device-mapper: dust: bad block: 1
+        device-mapper: dust: bad block: 2
+        device-mapper: dust: dust_list_badblocks: badblocks list end.
+
 Message commands list
 ---------------------
 
@@ -223,6 +240,7 @@ Single argument message commands::
 
         countbadblocks
         clearbadblocks
+        listbadblocks
         disable
         enable
         quiet
-- 
2.23.0.rc2.8.gff66981f45
