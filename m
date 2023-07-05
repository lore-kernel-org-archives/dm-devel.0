Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6327EB64DA
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jul 2023 21:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688594288;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kjEawu8/5S3m1U8nXoR5RgNm4pZR+sI8mHhc3O5uJ9Y=;
	b=DGK/sy5eEj+8QO3CIhTv80st1hZuRXjkom/4vOOJ6zuVZcxzeaX+lgf+3HYVrSwYLZ4D6T
	AIlbr9Dhi+jwLnh7t79oZ9m6f/hUOV8j1N2/vsTz9y1FuFfVDHHaocBlMBzPCbm0B1BUUR
	Nn+WHzKV/MEDQAdbPsxrWiGZ8Su2pDE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-I-9Iw_PDPWCrjuh9bTbSlA-1; Wed, 05 Jul 2023 17:58:05 -0400
X-MC-Unique: I-9Iw_PDPWCrjuh9bTbSlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43D53299E76F;
	Wed,  5 Jul 2023 21:58:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82294C54FB3;
	Wed,  5 Jul 2023 21:58:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 653F51946589;
	Wed,  5 Jul 2023 21:58:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A89411946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 21:57:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F80AF6404; Wed,  5 Jul 2023 21:57:59 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (unknown
 [10.67.24.122])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF133F6401;
 Wed,  5 Jul 2023 21:57:58 +0000 (UTC)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
 by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1qHAVM-000b7a-Fj; Thu, 06 Jul 2023 07:57:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation);
 Thu, 06 Jul 2023 05:57:37 +0800
Date: Thu, 6 Jul 2023 05:57:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
 <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
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
Cc: Fiona Trahe <fiona.trahe@intel.com>, horia.geanta@nxp.com,
 pankaj.gupta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org, qat-linux@intel.com,
 Eric Biggers <ebiggers@kernel.org>, iuliana.prodan@nxp.com,
 dm-devel@redhat.com, meenakshi.aggarwal@nxp.com, linux-crypto@vger.kernel.org,
 davem@davemloft.net, agk@redhat.com, V.Sethi@nxp.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gondor.apana.org.au
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 05, 2023 at 09:57:54PM +0100, Giovanni Cabiddu wrote:
>
> Then we are then back to square one. We need to check how many entries
> are present in the scatterlists encrypted by crypt_journal() before
> adjusting the meaning of !CRYPTO_ALG_ALLOCATES_MEMORY.

Indeed.  I missed the fact that it was preallocating memory with
GFP_KERNEL.

So perhaps the answer is to adjust our API to allow the drivers to
pre-allocate memory.  I'll look into this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

