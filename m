Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A6DC636CC
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 08:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675757949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HBaqnnuS3jFrJ8JYn1TCZ9SH4g/e/cTHzGdvDsrSOa8=;
	b=D/syHWBMBpVPw/qwL2SV3ceKZpC3kHoez6Ge/6fWgdDXnam5CpfebCpZv9Z5zyGBbImaH+
	D2CSugPHb/AMyl+3Tr8OnVQPEenBKj7MFTtr+jgGrzjNwbPemBopVEroOkYXhdm0U6hvId
	oCf0Y0f7P1tYgWJ1GXg34XP5oOhlWp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-mxPad9k6PLiZEhsmqw56bQ-1; Tue, 07 Feb 2023 03:19:06 -0500
X-MC-Unique: mxPad9k6PLiZEhsmqw56bQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E86E85A5A3;
	Tue,  7 Feb 2023 08:19:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C122C15BA0;
	Tue,  7 Feb 2023 08:19:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9F64194658C;
	Tue,  7 Feb 2023 08:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1760A1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 08:19:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2EDF2026D38; Tue,  7 Feb 2023 08:19:02 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F1C62026D37;
 Tue,  7 Feb 2023 08:19:02 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pPJBU-008OYZ-Tl; Tue, 07 Feb 2023 16:18:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Tue, 07 Feb 2023 16:18:36 +0800
Date: Tue, 7 Feb 2023 16:18:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jakub Kicinski <kuba@kernel.org>
Message-ID: <Y+IJXEYPuaQWjfR5@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydn-007zi3-LG@formenos.hmeau.com>
 <20230206231521.712f53e5@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230206231521.712f53e5@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] tls: Pass rec instead of aead_req into
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 06, 2023 at 11:15:21PM -0800, Jakub Kicinski wrote:
>
> >  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > -				  tls_encrypt_done, sk);
> > +				  tls_encrypt_done, aead_req);
> 
> ... let's just pass rec instead of aead_req here, then?

Good point.  Could we do this as a follow-up patch? Reposting
the whole series would disturb a lot of people.  Of course if
other major issues crop up I can fold this into the existing
patch.

Thanks!

---8<---
The function tls_encrypt_done only uses aead_req to get ahold of
the tls_rec object.  So we could pass that in instead of aead_req
to simplify the code.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0515cda32fe2..6dfec2e8fdfa 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -430,18 +430,16 @@ int tls_tx_records(struct sock *sk, int flags)
 
 static void tls_encrypt_done(void *data, int err)
 {
-	struct aead_request *aead_req = data;
 	struct tls_sw_context_tx *ctx;
 	struct tls_context *tls_ctx;
 	struct tls_prot_info *prot;
+	struct tls_rec *rec = data;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
-	struct tls_rec *rec;
 	bool ready = false;
 	struct sock *sk;
 	int pending;
 
-	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
 
 	sk = rec->sk;
@@ -536,7 +534,7 @@ static int tls_do_encryption(struct sock *sk,
 			       data_len, rec->iv_data);
 
 	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tls_encrypt_done, aead_req);
+				  tls_encrypt_done, rec);
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

