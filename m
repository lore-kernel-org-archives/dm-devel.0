From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: add status line documentation
Date: Tue, 2 Jun 2020 09:48:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006020946520.826@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

This patch adds status line documentation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-integrity.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-integrity.rst	2020-06-02 13:15:58.000000000 +0200
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-integrity.rst	2020-06-02 15:46:42.000000000 +0200
@@ -193,6 +193,14 @@ should not be changed when reloading the
 data depend on them and the reloaded target would be non-functional.
 
 
+Status line:
+
+1. the number of integrity mismatches
+2. provided data sectors - that is the number of sectors that the user
+   could use
+3. the current recalculating position (or '-' if we didn't recalculate)
+
+
 The layout of the formatted block device:
 
 * reserved sectors
