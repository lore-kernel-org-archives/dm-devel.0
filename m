From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Date: Mon, 01 Jun 2020 18:03:33 +0200
Message-ID: <20200601160418.171851200@debian-a64.vm>
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
Content-Disposition: inline; filename=qat-fix-4.patch
To: Mike Snitzer <msnitzer@redhat.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc: guazhang@redhat.com, qat-linux@intel.com, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, jpittman@redhat.com
List-Id: dm-devel.ids

Using dm-crypt with QAT result in deadlocks.

If a crypto routine returns -EBUSY, it is expected that the crypto driver
have already queued the request and the crypto API user should assume that
this request was processed, but it should stop sending more requests. When
an -EBUSY request is processed, the crypto driver calls the callback with
the error code -EINPROGRESS - this means that the request is still being
processed (i.e. the user should wait for another callback), but the user
can start sending more requests now.

The QAT driver misunderstood this logic, it return -EBUSY when the queue
was full and didn't queue the request - the request was lost and it
resulted in a deadlock.

This patch fixes busy state handling - if the queue is at least 15/16
full, we return -EBUSY to signal to the user that no more requests should
be sent. We remember that we returned -EBUSY (the variable backed_off) and
if we finish the request, we return -EINPROGRESS to indicate that the user
can send more requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
@@ -826,6 +826,9 @@ static void qat_aead_alg_callback(struct
 	qat_alg_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
+
+	if (qat_req->backed_off)
+		areq->base.complete(&areq->base, -EINPROGRESS);
 	areq->base.complete(&areq->base, res);
 }
 
@@ -847,6 +850,8 @@ static void qat_skcipher_alg_callback(st
 	dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
 			  qat_req->iv_paddr);
 
+	if (qat_req->backed_off)
+		sreq->base.complete(&sreq->base, -EINPROGRESS);
 	sreq->base.complete(&sreq->base, res);
 }
 
@@ -869,7 +874,7 @@ static int qat_alg_aead_dec(struct aead_
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -890,15 +895,16 @@ static int qat_alg_aead_dec(struct aead_
 	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_aead_enc(struct aead_request *areq)
@@ -911,7 +917,7 @@ static int qat_alg_aead_enc(struct aead_
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	uint8_t *iv = areq->iv;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
 	if (unlikely(ret))
@@ -935,15 +941,15 @@ static int qat_alg_aead_enc(struct aead_
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_rekey(struct qat_alg_skcipher_ctx *ctx,
@@ -1051,7 +1057,7 @@ static int qat_alg_skcipher_encrypt(stru
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1081,17 +1087,16 @@ static int qat_alg_skcipher_encrypt(stru
 	cipher_param->cipher_offset = 0;
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
@@ -1111,7 +1116,7 @@ static int qat_alg_skcipher_decrypt(stru
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1141,17 +1146,16 @@ static int qat_alg_skcipher_decrypt(stru
 	cipher_param->cipher_offset = 0;
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
+again:
+	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
 	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
-				  qat_req->iv_paddr);
-		return -EBUSY;
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
 	}
-	return -EINPROGRESS;
+	return backed_off ? -EBUSY : -EINPROGRESS;
 }
 
 static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.c
+++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
@@ -114,10 +114,19 @@ static void adf_disable_ring_irq(struct
 	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
 }
 
+bool adf_should_back_off(struct adf_etr_ring_data *ring)
+{
+	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
+}
+
 int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
 {
-	if (atomic_add_return(1, ring->inflights) >
-	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
+	int limit = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
+
+	if (atomic_read(ring->inflights) >= limit)
+		return -EAGAIN;
+
+	if (atomic_add_return(1, ring->inflights) > limit) {
 		atomic_dec(ring->inflights);
 		return -EAGAIN;
 	}
Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.h
+++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.h
@@ -58,6 +58,7 @@ int adf_create_ring(struct adf_accel_dev
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
+bool adf_should_back_off(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
Index: linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_crypto.h
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -90,6 +90,7 @@ struct qat_crypto_request {
 		   struct qat_crypto_request *req);
 	void *iv;
 	dma_addr_t iv_paddr;
+	int backed_off;
 };
 
 #endif
