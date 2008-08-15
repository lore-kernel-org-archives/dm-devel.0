From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/10] dm snapshot: make the disk format endian
	explict
Date: Fri, 15 Aug 2008 15:42:43 +0900
Message-ID: <1218782571-15290-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1218782571-15290-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1218782571-15290-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

The two disk formats of dm snapshot (disk_header and disk_exception)
are little endian. This makes it explicit.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-exception-store.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index fe5f8b4..8931364 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -60,27 +60,27 @@
 #define SNAPSHOT_DISK_VERSION 1
 
 struct disk_header {
-	uint32_t magic;
+	__le32 magic;
 
 	/*
 	 * Is this snapshot valid.  There is no way of recovering
 	 * an invalid snapshot.
 	 */
-	uint32_t valid;
+	__le32 valid;
 
 	/*
 	 * Simple, incrementing version. no backward
 	 * compatibility.
 	 */
-	uint32_t version;
+	__le32 version;
 
 	/* In sectors */
-	uint32_t chunk_size;
+	__le32 chunk_size;
 };
 
 struct disk_exception {
-	uint64_t old_chunk;
-	uint64_t new_chunk;
+	__le64 old_chunk;
+	__le64 new_chunk;
 };
 
 struct commit_callback {
-- 
1.5.5.GIT
