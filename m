Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C5BC4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:28:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F6E120756
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F6E120756
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-G2TmPnb5OOKGTUhac-p1Xw-1; Mon, 26 Oct 2020 14:28:03 -0400
X-MC-Unique: G2TmPnb5OOKGTUhac-p1Xw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D367DA0C04;
	Mon, 26 Oct 2020 18:27:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6BA85C1BB;
	Mon, 26 Oct 2020 18:27:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8475892F2D;
	Mon, 26 Oct 2020 18:27:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QIQd3t007282 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 14:26:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 47FC22022E00; Mon, 26 Oct 2020 18:26:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42D772023499
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:26:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7D31858298
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:26:36 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-126-Cjb7rYmYNGubMqs1KldjpA-1;
	Mon, 26 Oct 2020 14:26:32 -0400
X-MC-Unique: Cjb7rYmYNGubMqs1KldjpA-1
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net
	[172.10.235.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 80DAE20874;
	Mon, 26 Oct 2020 18:26:30 +0000 (UTC)
Date: Mon, 26 Oct 2020 11:26:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Message-ID: <20201026182628.GI858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-2-gilad@benyossef.com>
	<20201026182448.GH858@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <20201026182448.GH858@sol.localdomain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

On Mon, Oct 26, 2020 at 11:24:50AM -0700, Eric Biggers wrote:
> > +static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> > +{
> > +	struct crypto_attr_type *algt;
> > +	const char *inner_cipher_name;
> > +	struct skcipher_instance *skcipher_inst = NULL;
> > +	struct crypto_instance *inst;
> > +	struct crypto_alg *base, *block_base;
> > +	struct eboiv_instance_ctx *ictx;
> > +	struct skcipher_alg *skcipher_alg = NULL;
> > +	int ivsize;
> > +	u32 mask;
> > +	int err;
> > +
> > +	algt = crypto_get_attr_type(tb);
> > +	if (IS_ERR(algt))
> > +		return PTR_ERR(algt);
> 
> Need to check that the algorithm is being instantiated as skcipher.
> crypto_check_attr_type() should be used.
> 
> > +
> > +	inner_cipher_name = crypto_attr_alg_name(tb[1]);
> > +	if (IS_ERR(inner_cipher_name))
> > +		return PTR_ERR(inner_cipher_name);
> 
> The result of crypto_attr_alg_name() can be passed directly to
> crypto_grab_skcipher().
> 
> > +	mask = crypto_algt_inherited_mask(algt);
> > +
> > +	skcipher_inst = kzalloc(sizeof(*skcipher_inst) + sizeof(*ictx), GFP_KERNEL);
> > +	if (!skcipher_inst)
> > +		return -ENOMEM;
> > +
> > +	inst = skcipher_crypto_instance(skcipher_inst);
> > +	base = &skcipher_inst->alg.base;
> > +	ictx = crypto_instance_ctx(inst);
> > +
> > +	/* Symmetric cipher, e.g., "cbc(aes)" */
> > +	err = crypto_grab_skcipher(&ictx->skcipher_spawn, inst, inner_cipher_name, 0, mask);
> > +	if (err)
> > +		goto out_free_inst;
> > +
> > +	skcipher_alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
> > +	block_base = &skcipher_alg->base;
> > +	ivsize = crypto_skcipher_alg_ivsize(skcipher_alg);
> > +
> > +	if (ivsize != block_base->cra_blocksize)
> > +		goto out_drop_skcipher;
> 
> Shouldn't it be verified that the underlying algorithm is actually cbc?
> 
> > +	skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
> > +	skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
> 
> Setting these isn't necessary.
> 
> > +
> > +	skcipher_inst->free		= eboiv_skcipher_free_instance;
> > +
> > +	err = skcipher_register_instance(tmpl, skcipher_inst);
> > +
> > +	if (err)
> > +		goto out_drop_skcipher;
> > +
> > +	return 0;
> > +
> > +out_drop_skcipher:
> > +	crypto_drop_skcipher(&ictx->skcipher_spawn);
> > +out_free_inst:
> > +	kfree(skcipher_inst);
> > +	return err;
> > +}
> 
> eboiv_skcipher_free_instance() can be called on the error path.

Here's the version of eboiv_create() I recommend (untested):

static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
{
	struct skcipher_instance *inst;
	struct eboiv_instance_ctx *ictx;
	struct skcipher_alg *alg;
	u32 mask;
	int err;

	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
	if (err)
		return err;

	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
	if (!inst)
		return -ENOMEM;
	ictx = skcipher_instance_ctx(inst);

	err = crypto_grab_skcipher(&ictx->skcipher_spawn,
				   skcipher_crypto_instance(inst),
				   crypto_attr_alg_name(tb[1]), 0, mask);
	if (err)
		goto err_free_inst;
	alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);

	err = -EINVAL;
	if (strncmp(alg->base.cra_name, "cbc(", 4) ||
	    crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
		goto err_free_inst;

	err = -ENAMETOOLONG;
	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "eboiv(%s)",
		     alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
		goto err_free_inst;

	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
		     "eboiv(%s)", alg->base.cra_driver_name) >=
	    CRYPTO_MAX_ALG_NAME)
		goto err_free_inst;

	inst->alg.base.cra_blocksize	= alg->base.cra_blocksize;
	inst->alg.base.cra_ctxsize	= sizeof(struct eboiv_tfm_ctx);
	inst->alg.base.cra_alignmask	= alg->base.cra_alignmask;
	inst->alg.base.cra_priority	= alg->base.cra_priority;

	inst->alg.setkey	= eboiv_skcipher_setkey;
	inst->alg.encrypt	= eboiv_skcipher_encrypt;
	inst->alg.decrypt	= eboiv_skcipher_decrypt;
	inst->alg.init		= eboiv_skcipher_init_tfm;
	inst->alg.exit		= eboiv_skcipher_exit_tfm;

	inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(alg);
	inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(alg);
	inst->alg.ivsize	= crypto_skcipher_alg_ivsize(alg);

	inst->free		= eboiv_skcipher_free_instance;

	err = skcipher_register_instance(tmpl, inst);
	if (err) {
err_free_inst:
		eboiv_skcipher_free_instance(inst);
	}
	return err;
}

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

