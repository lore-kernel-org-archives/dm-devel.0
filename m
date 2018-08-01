From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 15/32] kpartx: remove duplicated gpt validation
	check
Date: Wed,  1 Aug 2018 15:57:01 -0500
Message-ID: <1533157038-3924-16-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The identical check exists twice in a row.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/gpt.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 6ef20f9..e31611a 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -348,16 +348,6 @@ is_gpt_valid(int fd, uint64_t lba,
 		return 0;
 	}
 
-
-	/* Check that sizeof_partition_entry has the correct value */
-	if (__le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
-		// printf("GUID partition entry size check failed.\n");
-		free(*gpt);
-		*gpt = NULL;
-		return 0;
-	}
-
-
 	if (!(*ptes = alloc_read_gpt_entries(fd, *gpt))) {
 		free(*gpt);
 		*gpt = NULL;
-- 
2.7.4
