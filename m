Return-Path: <SRS0=55Wq=F5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43802C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 25 Dec 2020 19:28:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91E29221F2
	for <dm-devel@archiver.kernel.org>; Fri, 25 Dec 2020 19:28:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91E29221F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-sQHRvmp9P5WlwPqdZUAMyQ-1; Fri, 25 Dec 2020 14:28:16 -0500
X-MC-Unique: sQHRvmp9P5WlwPqdZUAMyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 007E019251A0;
	Fri, 25 Dec 2020 19:28:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B526070957;
	Fri, 25 Dec 2020 19:28:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA1BD180954D;
	Fri, 25 Dec 2020 19:28:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BPJRxVh022204 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 25 Dec 2020 14:27:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 317C52166B2B; Fri, 25 Dec 2020 19:27:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C44B2166B29
	for <dm-devel@redhat.com>; Fri, 25 Dec 2020 19:27:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9E37101A53F
	for <dm-devel@redhat.com>; Fri, 25 Dec 2020 19:27:55 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-507-8Y3KTxbWNWCYmhQ-pZ31wQ-1;
	Fri, 25 Dec 2020 14:27:53 -0500
X-MC-Unique: 8Y3KTxbWNWCYmhQ-pZ31wQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739D3221F2;
	Fri, 25 Dec 2020 19:20:08 +0000 (UTC)
Date: Fri, 25 Dec 2020 11:20:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Message-ID: <X+Y7Zg8vMZbxMJgK@sol.localdomain>
References: <20201223223841.11311-1-ardb@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>, Megha Dey <megha.dey@intel.com>
Subject: Re: [dm-devel] [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR
 glue helper code
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23, 2020 at 11:38:31PM +0100, Ard Biesheuvel wrote:
> After applying my performance fixes for AES-NI in XTS mode, the only
> remaining users of the x86 glue helper module are the niche algorithms
> camellia, cast6, serpent and twofish.
> 
> It is not clear from the history why all these different versions of these
> algorithms in XTS and CTR modes were added in the first place: the only
> in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> CTR modes don't seem to be widely used either.
> 
> Since the glue helper code relies heavily on indirect calls for small chunks
> of in/output, it needs some work to recover from the performance hit caused
> by the retpoline changes. However, it makes sense to only expend the effort
> for algorithms that are being used in the first place, and this does not
> seem to be the case for XTS and CTR.
> 
> CTR mode can simply be removed: it is not used in the kernel, and it is
> highly unlikely that it is being relied upon via algif_skcipher. And even
> if it was, the generic CTR mode driver can still provide the CTR transforms
> if necessary.
> 
> XTS mode may actually be in use by dm-crypt users, so we cannot simply drop
> this code entirely. However, as it turns out, the XTS template wrapped
> around the ECB mode skciphers perform roughly on par *, and so there is no
> need to retain all the complicated XTS helper logic. In the unlikely case
> that dm-crypt users are relying on xts(camellia) or xts(serpent) in the
> field, they should not be impacted by these changes at all.
> 
> As a follow-up, it makes sense to rework the ECB and CBC mode implementations
> to get rid of the indirect calls. Or perhaps we could drop [some of] these
> algorithms entirely ...
> 
> * tcrypt results for various XTS implementations below, captured on a
>   Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz
> 
> Cc: Megha Dey <megha.dey@intel.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Milan Broz <gmazyland@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> 
> Ard Biesheuvel (10):
>   crypto: x86/camellia - switch to XTS template
>   crypto: x86/cast6 - switch to XTS template
>   crypto: x86/serpent- switch to XTS template
>   crypto: x86/twofish - switch to XTS template
>   crypto: x86/glue-helper - drop XTS helper routines
>   crypto: x86/camellia - drop CTR mode implementation
>   crypto: x86/cast6 - drop CTR mode implementation
>   crypto: x86/serpent - drop CTR mode implementation
>   crypto: x86/twofish - drop CTR mode implementation
>   crypto: x86/glue-helper - drop CTR helper routines

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

