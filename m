Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB4BC636CC
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 07:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675842327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=acASsnsqz9SZ9GMf9uUa9ncJ2570TkFeYG2oSLcpPdo=;
	b=XSJkzRPx9H1GpB/ve9OKu6xQsA5L/ZjJyo67ZqBvGxEbxAVLGB43f0xkmausQrEzBuNQDf
	lFsKrYlBFFnC/Tw5UBSDQczuz6PUrQF3Wv8OOAsHs53ud3hf6uARZRT87WnuPotq+s6KsD
	2VB9V5DAO61ttFBqzpNHmUew5FsygVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-FIh4gxhyOQi6TZ1fezEIcg-1; Wed, 08 Feb 2023 02:45:24 -0500
X-MC-Unique: FIh4gxhyOQi6TZ1fezEIcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5EDA800D84;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0A6940398A4;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB97D194658F;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBA291946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 18:57:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBC91492B22; Tue,  7 Feb 2023 18:57:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1E14492B25
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 18:57:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DF31800B23
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 18:57:16 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-AAN5kHNvMzK3r0OvecPwJg-1; Tue, 07 Feb 2023 13:57:15 -0500
X-MC-Unique: AAN5kHNvMzK3r0OvecPwJg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2EAF9610E8;
 Tue,  7 Feb 2023 18:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34E9C433D2;
 Tue,  7 Feb 2023 18:50:37 +0000 (UTC)
Date: Tue, 7 Feb 2023 10:50:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20230207105036.76b30090@kernel.org>
In-Reply-To: <Y+IJXEYPuaQWjfR5@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydn-007zi3-LG@formenos.hmeau.com>
 <20230206231521.712f53e5@kernel.org>
 <Y+IJXEYPuaQWjfR5@gondor.apana.org.au>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 08 Feb 2023 07:45:20 +0000
Subject: Re: [dm-devel] [PATCH] tls: Pass rec instead of aead_req into
 tls_encrypt_done
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 7 Feb 2023 16:18:36 +0800 Herbert Xu wrote:
> > >  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > > -				  tls_encrypt_done, sk);
> > > +				  tls_encrypt_done, aead_req);  
> > 
> > ... let's just pass rec instead of aead_req here, then?  
> 
> Good point.  Could we do this as a follow-up patch? Reposting
> the whole series would disturb a lot of people.  Of course if
> other major issues crop up I can fold this into the existing
> patch.

Whatever works best!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

