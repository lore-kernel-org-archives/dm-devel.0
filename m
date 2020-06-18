From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH v2 2/2] dm dust: introduce list badblocks in the
	rst
Date: Thu, 18 Jun 2020 17:06:20 +0800
Message-ID: <20200618090620.3517530-3-yangerkun@huawei.com>
References: <20200618090620.3517530-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200618090620.3517530-1-yangerkun@huawei.com>
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

Since we can list bad blocks with command status, introduce the detail
in the doc.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 .../admin-guide/device-mapper/dm-dust.rst          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index b6e7e7ead831..9267d9330482 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -205,6 +205,20 @@ appear::
 
         kernel: device-mapper: dust: clearbadblocks: no badblocks found
 
+Listing the bad blocks
+----------------------
+
+After we have add some bad blocks(like block 1 and 2), run the following
+command can help us to check the bad blocks::
+
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 bypass verbose badblocks list: 1 2
+
+And if there is no bad blocks, we will get following results::
+
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 bypass verbose badblocks list: null
+
 Message commands list
 ---------------------
 
-- 
2.25.4
