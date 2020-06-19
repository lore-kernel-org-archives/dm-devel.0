From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH v4 2/4] dm dust: update doc after message results
	report to user directly
Date: Fri, 19 Jun 2020 17:11:44 -0400
Message-ID: <1592601104-3978-1-git-send-email-bgurney@redhat.com>
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

Since some type of message will report the results to user directly,
we should update the doc too.

[Bryan: update output examples to include function name printing]

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 .../admin-guide/device-mapper/dm-dust.rst         | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index b6e7e7ead831..cf8079e368de 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -69,10 +69,11 @@ Create the dm-dust device:
         $ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 4096'
 
 Check the status of the read behavior ("bypass" indicates that all I/O
-will be passed through to the underlying device)::
+will be passed through to the underlying device; "verbose" indicates that
+bad block additions, removals, and remaps will be verbosely logged)::
 
         $ sudo dmsetup status dust1
-        0 33552384 dust 252:17 bypass
+        0 33552384 dust 252:17 bypass verbose
 
         $ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=128 iflag=direct
         128+0 records in
@@ -164,7 +165,7 @@ following message command::
 A message will print with the number of bad blocks currently
 configured on the device::
 
-        kernel: device-mapper: dust: countbadblocks: 895 badblock(s) found
+        countbadblocks: 895 badblock(s) found
 
 Querying for specific bad blocks
 --------------------------------
@@ -176,11 +177,11 @@ following message command::
 
 The following message will print if the block is in the list::
 
-        device-mapper: dust: queryblock: block 72 found in badblocklist
+        dust_query_block: block 72 found in badblocklist
 
 The following message will print if the block is not in the list::
 
-        device-mapper: dust: queryblock: block 72 not found in badblocklist
+        dust_query_block: block 72 not found in badblocklist
 
 The "queryblock" message command will work in both the "enabled"
 and "disabled" modes, allowing the verification of whether a block
@@ -198,12 +199,12 @@ following message command::
 
 After clearing the bad block list, the following message will appear::
 
-        kernel: device-mapper: dust: clearbadblocks: badblocks cleared
+        dust_clear_badblocks: badblocks cleared
 
 If there were no bad blocks to clear, the following message will
 appear::
 
-        kernel: device-mapper: dust: clearbadblocks: no badblocks found
+        dust_clear_badblocks: no badblocks found
 
 Message commands list
 ---------------------
-- 
2.25.4
