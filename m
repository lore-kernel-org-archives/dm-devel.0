From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/8] libmultipath: add (get|put)_unaligned_be64
Date: Sun, 24 Jun 2018 15:19:51 +0200
Message-ID: <20180624131955.20206-5-mwilck@suse.com>
References: <20180624131955.20206-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624131955.20206-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/unaligned.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/unaligned.h b/libmultipath/unaligned.h
index 14ec8b23..68c07742 100644
--- a/libmultipath/unaligned.h
+++ b/libmultipath/unaligned.h
@@ -17,6 +17,14 @@ static inline uint32_t get_unaligned_be32(void *ptr)
 	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
 }
 
+static inline uint64_t get_unaligned_be64(void *ptr)
+{
+	uint32_t low = get_unaligned_be32(ptr + 4);
+	uint64_t high = get_unaligned_be32(ptr);
+
+	return high << 32 | low;
+}
+
 static inline void put_unaligned_be16(uint16_t val, void *ptr)
 {
 	uint8_t *p = ptr;
@@ -35,4 +43,12 @@ static inline void put_unaligned_be32(uint32_t val, void *ptr)
 	p[3] = val;
 }
 
+static inline void put_unaligned_be64(uint64_t val, void *ptr)
+{
+	uint8_t *p = ptr;
+
+	put_unaligned_be32(val >> 32, p);
+	put_unaligned_be32(val, p + 4);
+}
+
 #endif /* _UNALIGNED_H_ */
-- 
2.17.1
