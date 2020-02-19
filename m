From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 05/18] libmultipath: constify get_unaligned_be*
Date: Wed, 19 Feb 2020 00:48:27 -0600
Message-ID: <1582094920-9883-6-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/unaligned.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/unaligned.h b/libmultipath/unaligned.h
index 68c07742..b9eaa7cb 100644
--- a/libmultipath/unaligned.h
+++ b/libmultipath/unaligned.h
@@ -10,14 +10,14 @@ static inline uint16_t get_unaligned_be16(const void *ptr)
 	return p[0] << 8 | p[1];
 }
 
-static inline uint32_t get_unaligned_be32(void *ptr)
+static inline uint32_t get_unaligned_be32(const void *ptr)
 {
 	const uint8_t *p = ptr;
 
 	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
-static inline uint64_t get_unaligned_be64(void *ptr)
+static inline uint64_t get_unaligned_be64(const void *ptr)
 {
 	uint32_t low = get_unaligned_be32(ptr + 4);
 	uint64_t high = get_unaligned_be32(ptr);
-- 
2.17.2
