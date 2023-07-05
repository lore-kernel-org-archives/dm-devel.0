Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E191BEB64DA
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jul 2023 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688587941;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s+YMkbjaShu2JvWnq9UV7HvNHfsKIEtWTvjrc6Vu5eQ=;
	b=JlRMzJwdlMEuQLdixd2o2FFRYcLj9l12aHLLZduQyu31PYv8IeA4KiqkfJU65JUBWAw9yg
	aaaeJkrPjcxFE3QaTqEYJgBx+ztQVXeXXoRIOocOtu7NbSS0cDi5iVc7Za9I19ZecK1TC+
	NGeRVT43C4jPukrqEcokyB/NIITuTVw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-UcTh5yaaOSWSAkEpmF2iNg-1; Wed, 05 Jul 2023 16:12:19 -0400
X-MC-Unique: UcTh5yaaOSWSAkEpmF2iNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CADD81044591;
	Wed,  5 Jul 2023 20:12:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A99A492C13;
	Wed,  5 Jul 2023 20:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB7B61946589;
	Wed,  5 Jul 2023 20:12:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D989C1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 20:12:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ADA6F640B; Wed,  5 Jul 2023 20:12:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9396EF5CFA
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 20:12:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7577629AA2C6
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 20:12:10 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-a-8p55wsPaCnVgE1gwmoCg-1; Wed, 05 Jul 2023 16:12:09 -0400
X-MC-Unique: a-8p55wsPaCnVgE1gwmoCg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 120B7616E4;
 Wed,  5 Jul 2023 20:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D87C433C7;
 Wed,  5 Jul 2023 20:12:06 +0000 (UTC)
Date: Wed, 5 Jul 2023 13:12:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <20230705201205.GA866@sol.localdomain>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230705164009.58351-2-giovanni.cabiddu@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Fiona Trahe <fiona.trahe@intel.com>, herbert@gondor.apana.org.au,
 horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 heinzm@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 qat-linux@intel.com, iuliana.prodan@nxp.com, dm-devel@redhat.com,
 meenakshi.aggarwal@nxp.com, linux-crypto@vger.kernel.org, davem@davemloft.net,
 agk@redhat.com, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 05, 2023 at 05:40:07PM +0100, Giovanni Cabiddu wrote:
> The flag CRYPTO_ALG_ALLOCATES_MEMORY indicates that an algorithm might
> allocate memory in the datapath and therefore sleep.
> Dm-integrity is filtering out implementations of skcipher algorithms
> that have this flag set. However, in the same function it does
> allocations with GFP_KERNEL.

Which function is the above referring to?  The actual encryption/decryption
happens in crypt_journal(), and I don't see any memory allocations there.

> As dm-integrity is re-entrant and capable of handling sleeps that could
> occur during allocations with GFP_KERNEL, then it is also capable of
> using skcipher algorithm implementations that have
> CRYPTO_ALG_ALLOCATES_MEMORY set.
> 
> Remove the filtering of skcipher implementations with the flag
> CRYPTO_ALG_ALLOCATES_MEMORY set.

What about the use of CRYPTO_ALG_ALLOCATES_MEMORY in get_mac()?

> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Link: https://lore.kernel.org/linux-crypto/ZILvtASXQKLG43y9@gondor.apana.org.au/
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>

This needs:

    Fixes: a7a10bce8a04 ("dm integrity: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY")
    Cc: stable@vger.kernel.org

But, are you 100% sure the explanation in commit a7a10bce8a04 was incorrect?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

