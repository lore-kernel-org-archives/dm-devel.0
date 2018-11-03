From: AliOS system security <alios_sys_security@linux.alibaba.com>
Subject: [PATCH] dm crypt: use unsigned long long instead of
	sector_t to store iv_offset
Date: Sat,  3 Nov 2018 11:53:28 +0800
Message-ID: <1541217208-60218-1-git-send-email-alios_sys_security@linux.alibaba.com>
References: <20a82f81-071e-e742-fc18-2088853efb0f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20a82f81-071e-e742-fc18-2088853efb0f@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, AliOS system security <alios_sys_security@linux.alibaba.com>
List-Id: dm-devel.ids

The iv_offset in the mapping table of crypt target is a 64bit number
when iv mode is plain64 or plain64be. It will be assigned to iv_offset of
struct crypt_config, cc_sector of struct convert_context and iv_sector of
struct dm_crypt_request. These structures members are defined as a sector_t.
But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit kernel. In this
situation sector_t is not big enough to store the 64bit iv_offset.

Signed-off-by: AliOS system security <alios_sys_security@linux.alibaba.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b8eec51..49be7a6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -49,7 +49,7 @@ struct convert_context {
 	struct bio *bio_out;
 	struct bvec_iter iter_in;
 	struct bvec_iter iter_out;
-	sector_t cc_sector;
+	unsigned long long cc_sector;
 	atomic_t cc_pending;
 	union {
 		struct skcipher_request *req;
@@ -81,7 +81,7 @@ struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
-	sector_t iv_sector;
+	unsigned long long iv_sector;
 };
 
 struct crypt_config;
@@ -160,7 +160,7 @@ struct crypt_config {
 		struct iv_lmk_private lmk;
 		struct iv_tcw_private tcw;
 	} iv_gen_private;
-	sector_t iv_offset;
+	unsigned long long iv_offset;
 	unsigned int iv_size;
 	unsigned short int sector_size;
 	unsigned char sector_shift;
-- 
2.7.4
