From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] kpartx: verify GUID partition entry size
Date: Fri, 10 Feb 2012 12:14:39 -0600
Message-ID: <20120210181439.GP1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch pulls in some kernel code to catch a corrupt GUID partition
table with the wrong size.

Signed-off-by: Boris Ranto <branto@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/gpt.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: multipath-tools-120123/kpartx/gpt.c
===================================================================
--- multipath-tools-120123.orig/kpartx/gpt.c
+++ multipath-tools-120123/kpartx/gpt.c
@@ -367,6 +367,15 @@ is_gpt_valid(int fd, uint64_t lba,
 	}
 
 
+	/* Check that sizeof_partition_entry has the correct value */
+	if (__le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
+		// printf("GUID partition entry size check failed.\n");
+		free(*gpt);
+		*gpt = NULL;
+		return 0;
+	}
+
+
 	if (!(*ptes = alloc_read_gpt_entries(fd, *gpt))) {
 		free(*gpt);
 		*gpt = NULL;
