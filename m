Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8746AC6379F
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 07:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675756571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MBptI1LG6xLoat8EO+AcBiwncB7Q3CQq5TyVHctT/V0=;
	b=dsU8TUZQQP6uGqX3FRnqA5hR+6C/6NiNEuWaO4CKlCFahY5784FE9/7SbwjLAwDA1Q6i0w
	1veozb1qRqneAaXUzjVC8SPHm18vJ/oTPkNfEugefKFuRJ2hHdFSYChAyAcv+JmYm5J84w
	jfuuzbIb9S8d019Xx7IjRGJhjudiGPM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-JxmAmMeaOVy4nvzaGHM2wg-1; Tue, 07 Feb 2023 02:56:10 -0500
X-MC-Unique: JxmAmMeaOVy4nvzaGHM2wg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E25638123A3;
	Tue,  7 Feb 2023 07:56:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 191372026D37;
	Tue,  7 Feb 2023 07:56:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 622911946A4A;
	Tue,  7 Feb 2023 07:56:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 935A41946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 07:16:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70D11440D9; Tue,  7 Feb 2023 07:16:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68716175AD
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:16:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 493DB1C270A6
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:16:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608--9wna8_aOpaN1dlc_7g1aw-1; Tue, 07 Feb 2023 02:16:34 -0500
X-MC-Unique: -9wna8_aOpaN1dlc_7g1aw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DE486B815FB;
 Tue,  7 Feb 2023 07:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D323C433EF;
 Tue,  7 Feb 2023 07:16:30 +0000 (UTC)
Date: Mon, 6 Feb 2023 23:16:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20230206231629.03572f5a@kernel.org>
In-Reply-To: <20230206231008.64c822c1@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <20230206231008.64c822c1@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 6 Feb 2023 23:10:08 -0800 Jakub Kicinski wrote:
> Buggy means bug could be hit in real light or buggy == did not use 
> the API right?

"in real light"... time to sign off for the night. s/light/life/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

