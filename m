From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] cpt-crypto: don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was
 not specified
Date: Wed, 17 Jun 2020 09:48:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006170946590.18714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161102250.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616175022.GD207319@gmail.com> <alpine.LRH.2.02.2006161416510.12390@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616182327.GE207319@gmail.com> <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2006170940510.18714@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>, George Cherian <gcherian@marvell.com>, Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

There is this call chain:
cvm_encrypt -> cvm_enc_dec -> cptvf_do_request -> process_request -> kzalloc
where we call sleeping allocator function even if CRYPTO_TFM_REQ_MAY_SLEEP 
was not specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.11+
Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")

---
 drivers/crypto/cavium/cpt/cptvf_algs.c       |    1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |   12 ++++++------
 drivers/crypto/cavium/cpt/request_manager.h  |    2 ++
 3 files changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ linux-2.6/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -200,6 +200,7 @@ static inline int cvm_enc_dec(struct skc
 	int status;
 
 	memset(req_info, 0, sizeof(struct cpt_request_info));
+	req_info->may_sleep = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) != 0;
 	memset(fctx, 0, sizeof(struct fc_context));
 	create_input_list(req, enc, enc_iv_len);
 	create_output_list(req, enc_iv_len);
Index: linux-2.6/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ linux-2.6/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -133,7 +133,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup gather (input) components */
 	g_sz_bytes = ((req->incnt + 3) / 4) * sizeof(struct sglist_component);
-	info->gather_components = kzalloc(g_sz_bytes, GFP_KERNEL);
+	info->gather_components = kzalloc(g_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->gather_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -150,7 +150,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup scatter (output) components */
 	s_sz_bytes = ((req->outcnt + 3) / 4) * sizeof(struct sglist_component);
-	info->scatter_components = kzalloc(s_sz_bytes, GFP_KERNEL);
+	info->scatter_components = kzalloc(s_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->scatter_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -167,7 +167,7 @@ static inline int setup_sgio_list(struct
 
 	/* Create and initialize DPTR */
 	info->dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
-	info->in_buffer = kzalloc(info->dlen, GFP_KERNEL);
+	info->in_buffer = kzalloc(info->dlen, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->in_buffer) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -195,7 +195,7 @@ static inline int setup_sgio_list(struct
 	}
 
 	/* Create and initialize RPTR */
-	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, GFP_KERNEL);
+	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->out_buffer) {
 		ret = -ENOMEM;
 		goto scatter_gather_clean;
@@ -421,7 +421,7 @@ int process_request(struct cpt_vf *cptvf
 	struct cpt_vq_command vq_cmd;
 	union cpt_inst_s cptinst;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for info_buffer\n");
 		return -ENOMEM;
@@ -443,7 +443,7 @@ int process_request(struct cpt_vf *cptvf
 	 * Get buffer for union cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = kzalloc(sizeof(union cpt_res_s), GFP_KERNEL);
+	info->completion_addr = kzalloc(sizeof(union cpt_res_s), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info->completion_addr)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for completion_addr\n");
 		ret = -ENOMEM;
Index: linux-2.6/drivers/crypto/cavium/cpt/request_manager.h
===================================================================
--- linux-2.6.orig/drivers/crypto/cavium/cpt/request_manager.h
+++ linux-2.6/drivers/crypto/cavium/cpt/request_manager.h
@@ -62,6 +62,8 @@ struct cpt_request_info {
 	union ctrl_info ctrl; /* User control information */
 	struct cptvf_request req; /* Request Information (Core specific) */
 
+	bool may_sleep;
+
 	struct buf_ptr in[MAX_BUF_CNT];
 	struct buf_ptr out[MAX_BUF_CNT];
 
