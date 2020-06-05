From: yangerkun <yangerkun@huawei.com>
Subject: [RFC 2/2] dm dust: introduce listbadblocks in the rst
Date: Fri, 5 Jun 2020 15:32:01 +0800
Message-ID: <20200605073201.1742675-3-yangerkun@huawei.com>
References: <20200605073201.1742675-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200605073201.1742675-1-yangerkun@huawei.com>
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
---
 .../admin-guide/device-mapper/dm-dust.rst        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index b6e7e7ead831..185b3ce6298b 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -205,6 +205,21 @@ appear::
 
         kernel: device-mapper: dust: clearbadblocks: no badblocks found
 
+Listling the bad block list
+---------------------------
+
+To list all bad block list, run the following message command::
+
+        $ sudo dmsetup message dust1 0 listbadblocks
+
+We will get following message(image that we have insert block 1/2, and
+we will list the block index in order)::
+
+        device-mapper: dust: dust_list_badblocks: badblocks list as below:
+        device-mapper: dust: bad block: 1
+        device-mapper: dust: bad block: 2
+        device-mapper: dust: dust_list_badblocks: badblocks list end.
+
 Message commands list
 ---------------------
 
@@ -223,6 +238,7 @@ Single argument message commands::
 
         countbadblocks
         clearbadblocks
+        listbadblocks
         disable
         enable
         quiet
-- 
2.25.4
