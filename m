Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761FEC636D4
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675756571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y6sLfns2nLPwiY5EAaXMDmX0rwP6xiJlLdy2I5M05RA=;
	b=erVL9MtGkdq700py6jC9Bux4nSQKPOG4Kj5B9Ssoxc/LpyKpZ0lRXxzGPS07HapcH/8Hva
	re26HCa6Zl9bVbk37oZABo48+Mwq7ig3YbYW3A8DwyQCrfNnbdxXuWLM1ISmwtVnjLHnnB
	G3+wFIdceK9RcWsfY6zr0vm9+qtjUig=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-rGjNBbKXNsqJvki8djIsbg-1; Tue, 07 Feb 2023 02:56:10 -0500
X-MC-Unique: rGjNBbKXNsqJvki8djIsbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF52F87B2A6;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF3C34024A7E;
	Tue,  7 Feb 2023 07:56:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7B5719465A4;
	Tue,  7 Feb 2023 07:56:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1EA51946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 07:18:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDC6F400DFDB; Tue,  7 Feb 2023 07:18:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B67F6401014C
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:18:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99852857D07
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:18:40 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-v6KqtHSlPiyd03RZ8fceEQ-1; Tue, 07 Feb 2023 02:18:38 -0500
X-MC-Unique: v6KqtHSlPiyd03RZ8fceEQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E7E6EB81600;
 Tue,  7 Feb 2023 07:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B308DC433D2;
 Tue,  7 Feb 2023 07:10:09 +0000 (UTC)
Date: Mon, 6 Feb 2023 23:10:08 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20230206231008.64c822c1@kernel.org>
In-Reply-To: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 07 Feb 2023 07:56:04 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 6 Feb 2023 18:21:06 +0800 Herbert Xu wrote:
> The crypto completion function currently takes a pointer to a
> struct crypto_async_request object.  However, in reality the API
> does not allow the use of any part of the object apart from the
> data field.  For example, ahash/shash will create a fake object
> on the stack to pass along a different data field.

"different data field" == copy the value to a different structure?
A bit hard to parse TBH.

> This leads to potential bugs where the user may try to dereference
> or otherwise use the crypto_async_request object.
> 
> This series changes the completion function to take a void *
> argument instead of crypto_async_request.
> 
> This series touches code in a number of different subsystems.
> Most of them are trivial except for tls which was actually buggy
> as it did exactly what was described above.

Buggy means bug could be hit in real light or buggy == did not use 
the API right?

> I'd like to pull all the changes through the crypto tree.  But
> feel free to object if you'd like the relevant patches to go
> through your trees instead and I'll split this up.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

