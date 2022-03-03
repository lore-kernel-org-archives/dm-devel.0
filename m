Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93070C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 21:45:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-0IuXiEZUPGyVs07ZPtNJ8g-1; Thu, 03 Mar 2022 16:45:10 -0500
X-MC-Unique: 0IuXiEZUPGyVs07ZPtNJ8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A196801AAD;
	Thu,  3 Mar 2022 21:45:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF49F45303;
	Thu,  3 Mar 2022 21:45:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B1644ED27;
	Thu,  3 Mar 2022 21:45:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223LixRw030741 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 16:44:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67401400E87F; Thu,  3 Mar 2022 21:44:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 62D8F40CFD0E
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 21:44:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 499DE85A5BC
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 21:44:59 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-209-QpD4zirqPFSyAailPNQAjw-1; Thu, 03 Mar 2022 16:44:57 -0500
X-MC-Unique: QpD4zirqPFSyAailPNQAjw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 6747AB8267E;
	Thu,  3 Mar 2022 21:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3A4C004E1;
	Thu,  3 Mar 2022 21:44:54 +0000 (UTC)
Date: Thu, 3 Mar 2022 21:44:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <YiE21aPGG5DHwJvb@gmail.com>
References: <Yh2c4Vwu61s51d6N@gondor.apana.org.au> <Yh9G7FyCLtsm2mFA@kroah.com>
	<Yh9ZvLHuztwQCu0d@silpixa00400314> <Yh+FpKuoyj3G16lK@kroah.com>
	<Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
	<Yh/yr6oB5yeOUErL@silpixa00400314>
	<Yh/znCnZzWaL49+o@gondor.apana.org.au>
	<YiDHT31ujlGdQEe/@silpixa00400314> <YiEVPc2cd38AnLZB@gmail.com>
	<YiEyGoHacN80FcOL@silpixa00400314>
MIME-Version: 1.0
In-Reply-To: <YiEyGoHacN80FcOL@silpixa00400314>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 03, 2022 at 09:24:42PM +0000, Giovanni Cabiddu wrote:
> On Thu, Mar 03, 2022 at 07:21:33PM +0000, Eric Biggers wrote:
> > If these algorithms have critical bugs, which it appears they do, then IMO it
> > would be better to disable them (either stop registering them, or disable the
> > whole driver) than to leave them available with low cra_priority.  Low
> > cra_priority doesn't guarantee that they aren't used.
> Thanks for your feedback Eric.
> 
> Here is a patch that disables the registration of the algorithms in the
> QAT driver by setting, a config time, the number of HW queues (aka
> instances) to zero.
> 
> ---8<---
> From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Subject: [PATCH] crypto: qat - disable registration of algorithms
> Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
> 
> The implementations of aead and skcipher in the QAT driver do not
> support properly requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
> If the HW queue is full, the driver returns -EBUSY but does not enqueue
> the request.
> This can result in applications like dm-crypt waiting indefinitely for a
> completion of a request that was never submitted to the hardware.
> 
> To avoid this problem, disable the registration of all skcipher and aead
> implementations in the QAT driver by setting the number of crypto
> instances to 0 at configuration time.
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
>  drivers/crypto/qat/qat_common/qat_crypto.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Sounds good; is there any reason not to apply this upstream too, though?
You could revert it later as part of the patch series that fixes the driver.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

