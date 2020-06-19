From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH] dm dust: update documentation to reflect
	__func__ output
Date: Fri, 19 Jun 2020 13:59:53 -0400
Message-ID: <1592589593-26739-1-git-send-email-bgurney@redhat.com>
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
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

The dm-dust messages "queryblock" and "clearbadblocks" now print
the function name in the DMEMIT output.  Update the documentation
to match the appearance of the actual output.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 Documentation/admin-guide/device-mapper/dm-dust.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.rst b/Documentation/admin-guide/device-mapper/dm-dust.rst
index 5c66a71e3442..75bc396ebeb1 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.rst
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -177,11 +177,11 @@ following message command::
 
 The following message will print if the block is in the list::
 
-        block 72 found in badblocklist
+        dust_query_block: block 72 found in badblocklist
 
 The following message will print if the block is not in the list::
 
-        block 72 not found in badblocklist
+        dust_query_block: block 72 not found in badblocklist
 
 The "queryblock" message command will work in both the "enabled"
 and "disabled" modes, allowing the verification of whether a block
@@ -199,12 +199,12 @@ following message command::
 
 After clearing the bad block list, the following message will appear::
 
-        badblocks cleared
+        dust_clear_badblocks: badblocks cleared
 
 If there were no bad blocks to clear, the following message will
 appear::
 
-        no badblocks found
+        dust_clear_badblocks: no badblocks found
 Listing the bad block list
 --------------------------
 
-- 
2.25.4
