Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B6FC05027
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 04:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675828974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9I/pn1/OzUJ68YPgsB6gl5jD4IQo3Pc7awEhhZy9Gog=;
	b=XF/GfGn4R+i2XQs4H/W9/RePD7B3oiU9VEIeJ4QzYOUvLM4hyONZMEyOC/MpdBXNV346vJ
	TbqlUsyOLjmNKNq3e2Lo17ceseIlxs5V6NOcDdCAV4ZO99jrahuh/UNjBPrHGKLFBzhySX
	C1QGFovfDtgPZfNMET1rcM+r1Nvl4AM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-Heu9RPZ7PDygj0xFu0Gbyw-1; Tue, 07 Feb 2023 23:02:50 -0500
X-MC-Unique: Heu9RPZ7PDygj0xFu0Gbyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A62C885C1D1;
	Wed,  8 Feb 2023 04:02:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D082718EC5;
	Wed,  8 Feb 2023 04:02:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9FCB01946589;
	Wed,  8 Feb 2023 04:02:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E6DE1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 04:02:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18C8F40398A4; Wed,  8 Feb 2023 04:02:45 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACC0F40398A0;
 Wed,  8 Feb 2023 04:02:44 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pPbev-008jle-Fn; Wed, 08 Feb 2023 12:02:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Wed, 08 Feb 2023 12:02:13 +0800
Date: Wed, 8 Feb 2023 12:02:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jakub Kicinski <kuba@kernel.org>
Message-ID: <Y+MexdOj12Y5Ikj1@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <20230206231008.64c822c1@kernel.org>
 <Y+IF6L4cb2Ijy0fN@gondor.apana.org.au>
 <20230207105146.267fc5e8@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230207105146.267fc5e8@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 0/17] crypto: api - Change completion
 callback argument to void star
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
Cc: David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
 keyrings@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Boris Pismenny <borisp@nvidia.com>, John Fastabend <john.fastabend@gmail.com>,
 Tyler Hicks <code@tyhicks.com>, Paolo Abeni <pabeni@redhat.com>,
 Johan Hedberg <johan.hedberg@gmail.com>, Marcel Holtmann <marcel@holtmann.org>,
 ecryptfs@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>,
 linux-bluetooth@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 07, 2023 at 10:51:46AM -0800, Jakub Kicinski wrote:
.
> Any aes-gcm or chacha-poly implementations which would do that come 
> to mind? I'm asking 'cause we probably want to do stable if we know
> of a combination which would be broken, or the chances of one existing
> are high.

Good point.  I had a quick look at tls_sw.c and it *appears* to be
safe with the default software code.  As tls_sw only uses the generic
AEAD algorithms (rather than the IPsec-specific variants which aren't
safe), the software-only paths *should* be OK.

However, drivers that support these algorithms may require fallbacks
for esoteric reasons.  For example, drivers/crypto/amcc appears to
require a fallback for certain input parameters which may or may not
be possible with TLS.

To be on the safe side I would do a backport once this has been
in mainline for a little bit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

