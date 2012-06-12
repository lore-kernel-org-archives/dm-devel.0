From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] libblkid: update dm-verity scan
Date: Tue, 12 Jun 2012 13:18:02 +0200
Message-ID: <1339499882-1432-1-git-send-email-mbroz@redhat.com>
References: <1338550448-13005-1-git-send-email-mbroz@redhat.com>
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338550448-13005-1-git-send-email-mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

New superblock now contains UUID. Old version is not going to be used.

Signed-off-by: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 libblkid/src/superblocks/lvm.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/libblkid/src/superblocks/lvm.c b/libblkid/src/superblocks/lvm.c
index 57d2b6e..0afc773 100644
--- a/libblkid/src/superblocks/lvm.c
+++ b/libblkid/src/superblocks/lvm.c
@@ -143,31 +143,36 @@ static int probe_lvm1(blkid_probe pr, const struct blkid_idmag *mag)
 	return 0;
 }
 
-#define MAX_SALT_SIZE 384
 struct verity_sb {
-	uint8_t signature[8];
-	uint8_t version;
-	uint8_t data_block_bits;
-	uint8_t hash_block_bits;
-	uint8_t pad1[1];
-	uint16_t salt_size;
-	uint8_t pad2[2];
-	uint32_t data_blocks_hi;
-	uint32_t data_blocks_lo;
-	uint8_t algorithm[16];
-	uint8_t salt[MAX_SALT_SIZE];
-	uint8_t pad3[88];
+	uint8_t  signature[8];	/* "verity\0\0" */
+	uint32_t version;	/* superblock version */
+	uint32_t hash_type;	/* 0 - Chrome OS, 1 - normal */
+	uint8_t  uuid[16];	/* UUID of hash device */
+	uint8_t  algorithm[32];/* hash algorithm name */
+	uint32_t data_block_size; /* data block in bytes */
+	uint32_t hash_block_size; /* hash block in bytes */
+	uint64_t data_blocks;	/* number of data blocks */
+	uint16_t salt_size;	/* salt size */
+	uint8_t  _pad1[6];
+	uint8_t  salt[256];	/* salt */
+	uint8_t  _pad2[168];
 } __attribute__((packed));
 
 static int probe_verity(blkid_probe pr, const struct blkid_idmag *mag)
 {
 	struct verity_sb *sb;
+	unsigned int version;
 
 	sb = blkid_probe_get_sb(pr, mag, struct verity_sb);
 	if (sb == NULL)
 		return -1;
 
-	blkid_probe_sprintf_version(pr, "%u", sb->version);
+	version = le32_to_cpu(sb->version);
+	if (version != 1)
+		return 1;
+
+	blkid_probe_set_uuid(pr, sb->uuid);
+	blkid_probe_sprintf_version(pr, "%u", version);
 	return 0;
 }
 
-- 
1.7.10

--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
