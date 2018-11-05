From: AliOS system security <alios_sys_security@linux.alibaba.com>
Subject: [PATCH v2] dm crypt: use u64 instead of sector_t to
	store iv_offset
Date: Mon,  5 Nov 2018 15:31:42 +0800
Message-ID: <1541403102-103156-1-git-send-email-alios_sys_security@linux.alibaba.com>
References: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1541062439-55558-1-git-send-email-alios_sys_security@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, AliOS system security <alios_sys_security@linux.alibaba.com>
List-Id: dm-devel.ids

The iv_offset in the mapping table of crypt target is a 64bit number when
IV algorithm is plain64, plain64be, essiv or benbi. It will be assigned to
iv_offset of struct crypt_config, cc_sector of struct convert_context and
iv_sector of struct dm_crypt_request. These structures members are defined
as a sector_t. But sector_t is 32bit when CONFIG_LBDAF is not set in 32bit
kernel. In this situation sector_t is not big enough to store the 64bit
iv_offset.

Here is a reproducer.
Prepare test image and device (loop is automatically allocated by cryptsetup):

  # dd if=/dev/zero of=tst.img bs=1M count=1
  # echo "tst"|cryptsetup open --type plain -c aes-xts-plain64 \
  --skip 500000000000000000 tst.img test

On 32bit system (use IV offset value that overflows to 64bit; CONFIG_LBDAF if off)
and device checksum is wrong:

  # dmsetup table test --showkeys
  0 2048 crypt aes-xts-plain64 dfa7cfe3c481f2239155739c42e539ae8f2d38f304dcc89d20b26f69daaf0933 3551657984 7:0 0

  # sha256sum /dev/mapper/test
  533e25c09176632b3794f35303488c4a8f3f965dffffa6ec2df347c168cb6c19 /dev/mapper/test

On 64bit system (and on 32bit system with the patch), table and checksum is now correct:

  # dmsetup table test --showkeys
  0 2048 crypt aes-xts-plain64 dfa7cfe3c481f2239155739c42e539ae8f2d38f304dcc89d20b26f69daaf0933 500000000000000000 7:0 0

  # sha256sum /dev/mapper/test
  5d16160f9d5f8c33d8051e65fdb4f003cc31cd652b5abb08f03aa6fce0df75fc /dev/mapper/test

Signed-off-by: AliOS system security <alios_sys_security@linux.alibaba.com>
Tested-and-Reviewed-by: Milan Broz <gmazyland@gmail.com>
---

Changes since v2:
* add all IV algorithms that are affected in commit message
* add reproducer in commit message
* use u64 instead of unsigned long long
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b8eec51..9a4dec0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -49,7 +49,7 @@ struct convert_context {
 	struct bio *bio_out;
 	struct bvec_iter iter_in;
 	struct bvec_iter iter_out;
-	sector_t cc_sector;
+	u64 cc_sector;
 	atomic_t cc_pending;
 	union {
 		struct skcipher_request *req;
@@ -81,7 +81,7 @@ struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
-	sector_t iv_sector;
+	u64 iv_sector;
 };
 
 struct crypt_config;
@@ -160,7 +160,7 @@ struct crypt_config {
 		struct iv_lmk_private lmk;
 		struct iv_tcw_private tcw;
 	} iv_gen_private;
-	sector_t iv_offset;
+	u64 iv_offset;
 	unsigned int iv_size;
 	unsigned short int sector_size;
 	unsigned char sector_shift;
-- 
2.7.4
