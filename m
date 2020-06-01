From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] dm-crypt: sleep and retry on allocation
	errors
Date: Mon, 01 Jun 2020 18:03:36 +0200
Message-ID: <20200601160421.912555280@debian-a64.vm>
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
Content-Disposition: inline; filename=crypt-enomem.patch
To: Mike Snitzer <msnitzer@redhat.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc: guazhang@redhat.com, qat-linux@intel.com, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, jpittman@redhat.com
List-Id: dm-devel.ids

Some hardware crypto drivers use GFP_ATOMIC allocations in the request
routine. These allocations can randomly fail - for example, they fail if
too many network packets are received.

If we propagated the failure up to the I/O stack, it would cause I/O
errors and data corruption. So, we sleep and retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1534,6 +1534,7 @@ static blk_status_t crypt_convert(struct
 		crypt_alloc_req(cc, ctx);
 		atomic_inc(&ctx->cc_pending);
 
+again:
 		if (crypt_integrity_aead(cc))
 			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
 		else
@@ -1541,6 +1542,17 @@ static blk_status_t crypt_convert(struct
 
 		switch (r) {
 		/*
+		 * Some hardware crypto drivers use GFP_ATOMIC allocations in
+		 * the request routine. These allocations can randomly fail. If
+		 * we propagated the failure up to the I/O stack, it would cause
+		 * I/O errors and data corruption.
+		 *
+		 * So, we sleep and retry.
+		 */
+		case -ENOMEM:
+			msleep(1);
+			goto again;
+		/*
 		 * The request was queued by a crypto driver
 		 * but the driver request queue is full, let's wait.
 		 */
