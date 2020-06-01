From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] qat: fix misunderstood -EBUSY return code in
	asym algorithms
Date: Mon, 01 Jun 2020 18:03:34 +0200
Message-ID: <20200601160419.414457600@debian-a64.vm>
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
Content-Disposition: inline; filename=qat-fix-asym.patch
To: Mike Snitzer <msnitzer@redhat.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc: guazhang@redhat.com, qat-linux@intel.com, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org, jpittman@redhat.com
List-Id: dm-devel.ids

This patch fixes a bug in QAT in async asymetric algorithm.

adf_send_message returns -EAGAIN when the queue is full. The caller
misunderstands it as -EBUSY - so the retry loop will never happen.

Furthermore, when the crypto driver return -EBUSY, it is expected that it
has queued the request and the caller should stop sending more requests.
When the request is returned with -EINPROGRESS, the caller can send more
requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_asym_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -179,6 +179,7 @@ struct qat_asym_request {
 		struct kpp_request *dh;
 	} areq;
 	int err;
+	int backed_off;
 	void (*cb)(struct icp_qat_fw_pke_resp *resp);
 } __aligned(64);
 
@@ -219,6 +220,8 @@ static void qat_dh_cb(struct icp_qat_fw_
 			 sizeof(struct qat_dh_output_params),
 			 DMA_TO_DEVICE);
 
+	if (req->backed_off)
+		kpp_request_complete(areq, -EINPROGRESS);
 	kpp_request_complete(areq, err);
 }
 
@@ -263,7 +266,7 @@ static int qat_dh_compute_value(struct k
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(kpp_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 	int n_input_params = 0;
 
 	if (unlikely(!ctx->xa))
@@ -388,17 +391,17 @@ static int qat_dh_compute_value(struct k
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_dh_output_params),
-				 DMA_TO_DEVICE);
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
@@ -585,6 +588,8 @@ static void qat_rsa_cb(struct icp_qat_fw
 			 sizeof(struct qat_rsa_output_params),
 			 DMA_TO_DEVICE);
 
+	if (req->backed_off)
+		akcipher_request_complete(areq, -EINPROGRESS);
 	akcipher_request_complete(areq, err);
 }
 
@@ -692,7 +697,7 @@ static int qat_rsa_enc(struct akcipher_r
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (unlikely(!ctx->n || !ctx->e))
 		return -EINVAL;
@@ -782,17 +787,18 @@ static int qat_rsa_enc(struct akcipher_r
 	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
@@ -826,7 +832,7 @@ static int qat_rsa_dec(struct akcipher_r
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret, backed_off;
 
 	if (unlikely(!ctx->n || !ctx->d))
 		return -EINVAL;
@@ -934,17 +940,18 @@ static int qat_rsa_dec(struct akcipher_r
 		msg->input_param_count = 3;
 
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
-
-	if (!ret)
-		return -EINPROGRESS;
-
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+
+	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->pke_tx);
+again:
+	ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	if (ret == -EAGAIN) {
+		qat_req->backed_off = backed_off = 1;
+		cpu_relax();
+		goto again;
+	}
+
+	return backed_off ? -EBUSY : -EINPROGRESS;
+
 unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
