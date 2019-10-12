From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 53/72] libmultipath,
 kpartx: byteorder: always use unsigned types
Date: Sat, 12 Oct 2019 21:28:42 +0000
Message-ID: <20191012212703.12989-54-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The swapped results are unsigned, so the non-swapped ones should
be unsigned, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/gpt.c             |  6 +++---
 libmultipath/byteorder.h | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 4f88d486..aa2a440c 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -40,9 +40,9 @@
 #include "kpartx.h"
 
 #if BYTE_ORDER == LITTLE_ENDIAN
-#  define __le16_to_cpu(x) (x)
-#  define __le32_to_cpu(x) (x)
-#  define __le64_to_cpu(x) (x)
+#  define __le16_to_cpu(x) (uint16_t)(x)
+#  define __le32_to_cpu(x) (uint32_t)(x)
+#  define __le64_to_cpu(x) (uint64_t)(x)
 #  define __cpu_to_le32(x) (x)
 #elif BYTE_ORDER == BIG_ENDIAN
 #  define __le16_to_cpu(x) bswap_16(x)
diff --git a/libmultipath/byteorder.h b/libmultipath/byteorder.h
index 5c771467..0a862447 100644
--- a/libmultipath/byteorder.h
+++ b/libmultipath/byteorder.h
@@ -9,19 +9,19 @@
 #endif
 
 #if BYTE_ORDER == LITTLE_ENDIAN
-#  define le16_to_cpu(x) (x)
+#  define le16_to_cpu(x) (uint16_t)(x)
 #  define be16_to_cpu(x) bswap_16(x)
-#  define le32_to_cpu(x) (x)
-#  define le64_to_cpu(x) (x)
+#  define le32_to_cpu(x) (uint32_t)(x)
+#  define le64_to_cpu(x) (uint64_t)(x)
 #  define be32_to_cpu(x) bswap_32(x)
 #  define be64_to_cpu(x) bswap_64(x)
 #elif BYTE_ORDER == BIG_ENDIAN
 #  define le16_to_cpu(x) bswap_16(x)
-#  define be16_to_cpu(x) (x)
+#  define be16_to_cpu(x) (uint16_t)(x)
 #  define le32_to_cpu(x) bswap_32(x)
 #  define le64_to_cpu(x) bswap_64(x)
-#  define be32_to_cpu(x) (x)
-#  define be64_to_cpu(x) (x)
+#  define be32_to_cpu(x) (uint32_t)(x)
+#  define be64_to_cpu(x) (uint64_t)(x)
 #else
 #  error unsupported
 #endif
-- 
2.23.0
