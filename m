Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F24C4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:27:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0ABB120756
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ABB120756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-WCD9OovQMECmHK0aSaFasQ-1; Mon, 26 Oct 2020 14:27:54 -0400
X-MC-Unique: WCD9OovQMECmHK0aSaFasQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B871818CB745;
	Mon, 26 Oct 2020 18:27:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F33C5C1BB;
	Mon, 26 Oct 2020 18:27:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE00D181A870;
	Mon, 26 Oct 2020 18:27:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QIOvZ1007175 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 14:24:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5659A82CED; Mon, 26 Oct 2020 18:24:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 512CF5D220
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:24:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A8D8102F1E2
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:24:55 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-238-Di0IP-FWMdaPupG5Z1bseg-1;
	Mon, 26 Oct 2020 14:24:51 -0400
X-MC-Unique: Di0IP-FWMdaPupG5Z1bseg-1
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net
	[172.10.235.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 16F6420874;
	Mon, 26 Oct 2020 18:24:50 +0000 (UTC)
Date: Mon, 26 Oct 2020 11:24:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Message-ID: <20201026182448.GH858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-2-gilad@benyossef.com>
MIME-Version: 1.0
In-Reply-To: <20201026130450.6947-2-gilad@benyossef.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 1/4] crypto: add eboiv as a crypto API
	template
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 26, 2020 at 03:04:44PM +0200, Gilad Ben-Yossef wrote:
> diff --git a/crypto/eboiv.c b/crypto/eboiv.c
> new file mode 100644
> index 000000000000..467833e89139
> --- /dev/null
> +++ b/crypto/eboiv.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * EBOIV skcipher template for block encryption
> + *
> + * This template encapsulates the  Encrypted byte-offset IV generation algorithm
> + * used in Bitlocker in CBC mode by dm-crypt, which converts the initial vector
> + * for the skcipher used for block encryption, by encrypting it using the same
> + * skcipher key as encryption key. Usually, the input IV is a 64-bit sector
> + * offset (the byte offset of the start of the sector) in LE representation
> + * zero-padded to the size of the IV, but this * is not assumed by this driver.
> + *
> + * The typical use of this template is to instantiate the skcipher
> + * 'eboiv(cbc(aes))', which is the only instantiation used by
> + * dm-crypt for supporting BitLocker AES-CBC mode as specified in
> + * https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
> + *
> + * Copyright (C) 2020 ARM Limited or its affiliates.
> + * Written by Gilad Ben-Yossef <gilad@benyossef.com>
> + *
> + * Heavily based on:
> + *
> + * ESSIV skcipher and aead template for block encryption
> + * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * and
> + *
> + * dm-crypt eboiv code
> + * by Milan Broz <gmazyland@gmail.com> and Ard Biesheuvel <ardb@kernel.org>
> + *
> + */
> +
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/module.h>
> +
> +#include "internal.h"

internal.h shouldn't be included here.

> +
> +struct eboiv_instance_ctx {
> +	struct crypto_skcipher_spawn skcipher_spawn;
> +	char eboiv_cipher_name[CRYPTO_MAX_ALG_NAME];
> +};

The 'eboiv_cipher_name' field isn't used.

> +static void eboiv_skcipher_iv_done(struct crypto_async_request *areq, int err)
> +{
> +	struct eboiv_req_ctx *req_ctx = areq->data;
> +	struct skcipher_request *req = req_ctx->req;
> +	int ret;
> +
> +	if (!err) {
> +
> +		ret = eboiv_skcipher_do_crypt(req, req_ctx->enc);
> +
> +		if ((ret == -EINPROGRESS) || (ret == -EBUSY))
> +			return;
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}

This looks wrong, because if eboiv_skcipher_do_crypt() fails,
skcipher_request_complete() will be called with err=0.

> +static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +	struct crypto_attr_type *algt;
> +	const char *inner_cipher_name;
> +	struct skcipher_instance *skcipher_inst = NULL;
> +	struct crypto_instance *inst;
> +	struct crypto_alg *base, *block_base;
> +	struct eboiv_instance_ctx *ictx;
> +	struct skcipher_alg *skcipher_alg = NULL;
> +	int ivsize;
> +	u32 mask;
> +	int err;
> +
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return PTR_ERR(algt);

Need to check that the algorithm is being instantiated as skcipher.
crypto_check_attr_type() should be used.

> +
> +	inner_cipher_name = crypto_attr_alg_name(tb[1]);
> +	if (IS_ERR(inner_cipher_name))
> +		return PTR_ERR(inner_cipher_name);

The result of crypto_attr_alg_name() can be passed directly to
crypto_grab_skcipher().

> +	mask = crypto_algt_inherited_mask(algt);
> +
> +	skcipher_inst = kzalloc(sizeof(*skcipher_inst) + sizeof(*ictx), GFP_KERNEL);
> +	if (!skcipher_inst)
> +		return -ENOMEM;
> +
> +	inst = skcipher_crypto_instance(skcipher_inst);
> +	base = &skcipher_inst->alg.base;
> +	ictx = crypto_instance_ctx(inst);
> +
> +	/* Symmetric cipher, e.g., "cbc(aes)" */
> +	err = crypto_grab_skcipher(&ictx->skcipher_spawn, inst, inner_cipher_name, 0, mask);
> +	if (err)
> +		goto out_free_inst;
> +
> +	skcipher_alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
> +	block_base = &skcipher_alg->base;
> +	ivsize = crypto_skcipher_alg_ivsize(skcipher_alg);
> +
> +	if (ivsize != block_base->cra_blocksize)
> +		goto out_drop_skcipher;

Shouldn't it be verified that the underlying algorithm is actually cbc?

> +	skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
> +	skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);

Setting these isn't necessary.

> +
> +	skcipher_inst->free		= eboiv_skcipher_free_instance;
> +
> +	err = skcipher_register_instance(tmpl, skcipher_inst);
> +
> +	if (err)
> +		goto out_drop_skcipher;
> +
> +	return 0;
> +
> +out_drop_skcipher:
> +	crypto_drop_skcipher(&ictx->skcipher_spawn);
> +out_free_inst:
> +	kfree(skcipher_inst);
> +	return err;
> +}

eboiv_skcipher_free_instance() can be called on the error path.

> +/* eboiv(cipher_name) */
> +static struct crypto_template eboiv_tmpl = {
> +	.name	= "eboiv",
> +	.create	= eboiv_create,
> +	.module	= THIS_MODULE,
> +};

"cipher_name" => "cbc_cipher_name", since it wraps something like "cbc(aes)",
not "aes".

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

