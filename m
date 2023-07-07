Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21471EB64D9
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jul 2023 10:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688725551;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=10it4ZqjpQziW5/pbQ7IUnG9XS0Kd1Cmq7R4UDXWGp4=;
	b=QwJqn7qSygyBQxRYdB33g2Yq6YFQer95p02ww5Zq+MTkXa0zaIj1RQQD26SFMiOC467aa+
	VNE/fFeitcIBmNnXqt46KWB7nSmLDQJRVa88elOGC2OhZgmzMzumnNEVXHEz/lnrAorey0
	MoKjSrR84Pm+5SElLPey9NUqT2PDVz4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-KAQdShErOhGwFPBVmOnXoQ-1; Fri, 07 Jul 2023 06:25:47 -0400
X-MC-Unique: KAQdShErOhGwFPBVmOnXoQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3903E1C0782A;
	Fri,  7 Jul 2023 10:25:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 769B5F6401;
	Fri,  7 Jul 2023 10:25:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 602D4194658F;
	Fri,  7 Jul 2023 10:25:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC9321946589
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Jul 2023 10:25:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 794762166B26; Fri,  7 Jul 2023 10:25:42 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A3F52166B25;
 Fri,  7 Jul 2023 10:25:42 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 3D2B830C0457; Fri,  7 Jul 2023 10:25:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 378983FB76; Fri,  7 Jul 2023 12:25:42 +0200 (CEST)
Date: Fri, 7 Jul 2023 12:25:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
In-Reply-To: <20230705201205.GA866@sol.localdomain>
Message-ID: <6388bd2-8342-d08-5b4b-7a37e8f8b323@redhat.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Fiona Trahe <fiona.trahe@intel.com>, herbert@gondor.apana.org.au,
 horia.geanta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
 snitzer@kernel.org, pankaj.gupta@nxp.com, linux-kernel@vger.kernel.org,
 iuliana.prodan@nxp.com, dm-devel@redhat.com, qat-linux@intel.com,
 linux-crypto@vger.kernel.org, meenakshi.aggarwal@nxp.com, davem@davemloft.net,
 agk@redhat.com, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

If you allocate memory in crypto processing in dm-integrity, you risk the 
low-memory deadlock when swapping to dm-integrity.

I.e. the machine runs out of memory, it needs to swap out pages to free 
some memory, the swap-out bio goes to dm-integrity and dm-integrity calls 
the crypto API and tries to allocate more memory => deadlock.



On Wed, 5 Jul 2023, Eric Biggers wrote:

> On Wed, Jul 05, 2023 at 05:40:07PM +0100, Giovanni Cabiddu wrote:
> > The flag CRYPTO_ALG_ALLOCATES_MEMORY indicates that an algorithm might
> > allocate memory in the datapath and therefore sleep.
> > Dm-integrity is filtering out implementations of skcipher algorithms
> > that have this flag set. However, in the same function it does
> > allocations with GFP_KERNEL.

It's OK to use GFP_KERNEL in the device mapper target constructor (because 
at this point there is no I/O going to the device). But it's not OK to use 
it for individual bio processing.

> Which function is the above referring to?  The actual encryption/decryption
> happens in crypt_journal(), and I don't see any memory allocations there.
> 
> > As dm-integrity is re-entrant and capable of handling sleeps that could
> > occur during allocations with GFP_KERNEL, then it is also capable of
> > using skcipher algorithm implementations that have
> > CRYPTO_ALG_ALLOCATES_MEMORY set.
> > 
> > Remove the filtering of skcipher implementations with the flag
> > CRYPTO_ALG_ALLOCATES_MEMORY set.
> 
> What about the use of CRYPTO_ALG_ALLOCATES_MEMORY in get_mac()?
> 
> > 
> > Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Link: https://lore.kernel.org/linux-crypto/ZILvtASXQKLG43y9@gondor.apana.org.au/
> > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> 
> This needs:
> 
>     Fixes: a7a10bce8a04 ("dm integrity: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY")
>     Cc: stable@vger.kernel.org
> 
> But, are you 100% sure the explanation in commit a7a10bce8a04 was incorrect?
> 
> - Eric

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

