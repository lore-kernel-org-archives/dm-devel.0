Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15AAAC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 19:29:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-ImA63zKBMMO5O8nQVKe-dA-1; Thu, 03 Mar 2022 14:28:56 -0500
X-MC-Unique: ImA63zKBMMO5O8nQVKe-dA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2747B81424A;
	Thu,  3 Mar 2022 19:28:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 666111000077;
	Thu,  3 Mar 2022 19:28:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF7DD44A59;
	Thu,  3 Mar 2022 19:28:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223JRZRu021296 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 14:27:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37B2040D2829; Thu,  3 Mar 2022 19:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33A3640D2828
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 19:27:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18C153C174C3
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 19:27:35 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-556-mDT2hxplOVKRjqajASKVHQ-1; Thu, 03 Mar 2022 14:27:33 -0500
X-MC-Unique: mDT2hxplOVKRjqajASKVHQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id C4797B81DB8;
	Thu,  3 Mar 2022 19:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FFBC004E1;
	Thu,  3 Mar 2022 19:21:35 +0000 (UTC)
Date: Thu, 3 Mar 2022 19:21:33 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <YiEVPc2cd38AnLZB@gmail.com>
References: <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
	<CAHk-=wi+xewHz=BH7LcZAxrj9JXi66s9rp+kBqRchVG3a-b2BA@mail.gmail.com>
	<Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
	<Yh9ZvLHuztwQCu0d@silpixa00400314> <Yh+FpKuoyj3G16lK@kroah.com>
	<Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
	<Yh/yr6oB5yeOUErL@silpixa00400314>
	<Yh/znCnZzWaL49+o@gondor.apana.org.au>
	<YiDHT31ujlGdQEe/@silpixa00400314>
MIME-Version: 1.0
In-Reply-To: <YiDHT31ujlGdQEe/@silpixa00400314>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
	Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 03, 2022 at 01:49:03PM +0000, Giovanni Cabiddu wrote:
> On Thu, Mar 03, 2022 at 10:45:48AM +1200, Herbert Xu wrote:
> > On Wed, Mar 02, 2022 at 10:42:20PM +0000, Giovanni Cabiddu wrote:
> > >
> > > I was thinking, as an alternative, to lower the cra_priority in the QAT
> > > driver for the algorithms used by dm-crypt so they are not used by
> > > default.
> > > Is that a viable option?
> > 
> > Yes I think that should work too.
> The patch below implements that solution and applies to linux-5.4.y.
> If it is ok, I can send it to stable for all kernels <= 5.4 following
> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3
> 
> ---8<---
> From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Date: Thu, 3 Mar 2022 11:54:07 +0000
> Subject: [PATCH] crypto: qat - drop priority of algorithms
> Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
> 
> The implementations of aead and skcipher in the QAT driver are not
> properly supporting requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
> If the HW queue is full, the driver returns -EBUSY but does not enqueue
> the request.
> This can result in applications like dm-crypt waiting indefinitely for a
> completion of a request that was never submitted to the hardware.
> 
> To mitigate this problem, reduce the priority of all skcipher and aead
> implementations in the QAT driver so they are not used by default.
> 
> This patch deviates from the original upstream solution, that prevents
> dm-crypt to use drivers registered with the flag
> CRYPTO_ALG_ALLOCATES_MEMORY, since a backport of that set to stable
> kernels may have a too wide effect.
> 
> commit 7bcb2c99f8ed032cfb3f5596b4dccac6b1f501df upstream
> commit 2eb27c11937ee9984c04b75d213a737291c5f58c upstream
> commit fbb6cda44190d72aa5199d728797aabc6d2ed816 upstream
> commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54 upstream
> commit cd74693870fb748d812867ba49af733d689a3604 upstream
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index 6b8ad3d67481..a5c28a08fd8c 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -1274,7 +1274,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha1),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha1",
> -		.cra_priority = 4001,
> +		.cra_priority = 1,
>  		.cra_flags = CRYPTO_ALG_ASYNC,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1291,7 +1291,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha256),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha256",
> -		.cra_priority = 4001,
> +		.cra_priority = 1,
>  		.cra_flags = CRYPTO_ALG_ASYNC,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1308,7 +1308,7 @@ static struct aead_alg qat_aeads[] = { {
>  	.base = {
>  		.cra_name = "authenc(hmac(sha512),cbc(aes))",
>  		.cra_driver_name = "qat_aes_cbc_hmac_sha512",
> -		.cra_priority = 4001,
> +		.cra_priority = 1,
>  		.cra_flags = CRYPTO_ALG_ASYNC,
>  		.cra_blocksize = AES_BLOCK_SIZE,
>  		.cra_ctxsize = sizeof(struct qat_alg_aead_ctx),
> @@ -1326,7 +1326,7 @@ static struct aead_alg qat_aeads[] = { {
>  static struct crypto_alg qat_algs[] = { {
>  	.cra_name = "cbc(aes)",
>  	.cra_driver_name = "qat_aes_cbc",
> -	.cra_priority = 4001,
> +	.cra_priority = 1,
>  	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>  	.cra_blocksize = AES_BLOCK_SIZE,
>  	.cra_ctxsize = sizeof(struct qat_alg_ablkcipher_ctx),
> @@ -1348,7 +1348,7 @@ static struct crypto_alg qat_algs[] = { {
>  }, {
>  	.cra_name = "ctr(aes)",
>  	.cra_driver_name = "qat_aes_ctr",
> -	.cra_priority = 4001,
> +	.cra_priority = 1,
>  	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>  	.cra_blocksize = 1,
>  	.cra_ctxsize = sizeof(struct qat_alg_ablkcipher_ctx),
> @@ -1370,7 +1370,7 @@ static struct crypto_alg qat_algs[] = { {
>  }, {
>  	.cra_name = "xts(aes)",
>  	.cra_driver_name = "qat_aes_xts",
> -	.cra_priority = 4001,
> +	.cra_priority = 1,
>  	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>  	.cra_blocksize = AES_BLOCK_SIZE,
>  	.cra_ctxsize = sizeof(struct qat_alg_ablkcipher_ctx),
> 
> base-commit: 866ae42cf4788c8b18de6bda0a522362702861d7
> -- 
> 2.35.1
> 

If these algorithms have critical bugs, which it appears they do, then IMO it
would be better to disable them (either stop registering them, or disable the
whole driver) than to leave them available with low cra_priority.  Low
cra_priority doesn't guarantee that they aren't used.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

