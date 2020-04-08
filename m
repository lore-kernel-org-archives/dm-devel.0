From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-integrity: Document allow_discard option.
Date: Wed,  8 Apr 2020 23:40:08 +0200
Message-ID: <20200408214008.209424-1-gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

This patch adds decription of the allow_discard option
added in commit 84597a44a9d86ac949900441cea7da0af0f2f473.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 .../admin-guide/device-mapper/dm-integrity.rst    | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index c00f9f11e3f3..8439d2ae689b 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -182,12 +182,15 @@ fix_padding
 	space-efficient. If this option is not present, large padding is
 	used - that is for compatibility with older kernels.
 
-
-The journal mode (D/J), buffer_sectors, journal_watermark, commit_time can
-be changed when reloading the target (load an inactive table and swap the
-tables with suspend and resume). The other arguments should not be changed
-when reloading the target because the layout of disk data depend on them
-and the reloaded target would be non-functional.
+allow_discards
+	Allow block discard requests (a.k.a. TRIM) for the integrity device.
+	Discards are only allowed to devices using internal hash.
+
+The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
+allow_discards can be changed when reloading the target (load an inactive
+table and swap the tables with suspend and resume). The other arguments
+should not be changed when reloading the target because the layout of disk
+data depend on them and the reloaded target would be non-functional.
 
 
 The layout of the formatted block device:
-- 
2.26.0
