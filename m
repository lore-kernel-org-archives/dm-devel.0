Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7592C4332F
	for <dm-devel@archiver.kernel.org>; Tue,  8 Nov 2022 08:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667897996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ULSiDZkS1JOKf3kfzF7OpJvF9dDj4EUwC6gZ81ZSwEQ=;
	b=RVexNcOAN+Vrtj8JI8xhRP7i9olz6arJjZH7SiiLnOFyNaCnNM65LL/2EUR3XkvYK5tZgB
	bGuJBmW9xDJXdF2P56+756F2OqQS5NlcvSuPiBUtC8qp9il15w7bHmVwcTy37kj1zittnZ
	0+E0nNDxd7/MHjNN73kbGyhWI1PU11c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-2Z3nexrvMhGnAGsHR_LrhQ-1; Tue, 08 Nov 2022 03:59:53 -0500
X-MC-Unique: 2Z3nexrvMhGnAGsHR_LrhQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CC2038035A3;
	Tue,  8 Nov 2022 08:59:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7A204B400F;
	Tue,  8 Nov 2022 08:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39D1219465A2;
	Tue,  8 Nov 2022 08:59:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B03AB1946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 12:22:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86EDC40C6DC7; Mon,  7 Nov 2022 12:22:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8023440C6EC2
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 12:22:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64BAB185A794
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 12:22:39 +0000 (UTC)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-rjKn1QOyO9aug8RLSTpBMA-1; Mon, 07 Nov 2022 07:22:38 -0500
X-MC-Unique: rjKn1QOyO9aug8RLSTpBMA-1
Received: by mail-pg1-f200.google.com with SMTP id
 x16-20020a63b210000000b0045f5c1e18d0so6145690pge.0
 for <dm-devel@redhat.com>; Mon, 07 Nov 2022 04:22:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=UkKO48JHU7AdpIz5HqGu/48iS0PHjFOMt3eONI773Ns=;
 b=wkzMWURunZAXceJ8zBPajhMzWoAvRQ4c96DYlzvHDtMWxirqPHTbZmLTEESi7r0X0a
 I9z03rApre5GObDcACf/JUs/iIKjczxm8lWRltzC461OqaEEAoeCWNAA/0CaK7/RgBIM
 spGdh+3YfCrstxOnOaO70i2dVjozUL9s8UmPJ/BZMy8RSeUzNE505ha5jhulizIgVtY1
 bw8Lc8VCHRvB0dx1uzAS8GfXfiXN5PHgcKXk8QT1onJg6ngYwaM//EssAoMdHV9gRtvb
 ngW0QIoOnWY8dji0wpsy5QBb/PWE1MRkAeulc15VI/hNtih54OcURMJiBj0XTHaTQQPE
 SQTw==
X-Gm-Message-State: ACrzQf1BF4pkbFUU/a9iUXFpJSNWGE19x6iH885QyxHMEJHX8fgSyS+E
 C5/W6TXUrNETru4wLQ2tpW1RbHfNkPUW5f8SMpLnrvClIFvHwOHgYXT0b8IrKySytSW86oUrkZN
 5GmyrVodJ5oIzNIHjb32MM1FspGnnNfp92hXqJBdI8BJei+93K2RykNYxJGSJwA==
X-Received: by 2002:a63:1b16:0:b0:46b:8e7:3e0a with SMTP id
 b22-20020a631b16000000b0046b08e73e0amr41957606pgb.86.1667823756954; 
 Mon, 07 Nov 2022 04:22:36 -0800 (PST)
X-Google-Smtp-Source: AMsMyM54z0KpX6BrG0jb5HceqF99cLDbTVANVh5EEu2lAH1NfSs1sTekzka5M0bm/WOXysXAK/hMyQ==
X-Received: by 2002:a63:1b16:0:b0:46b:8e7:3e0a with SMTP id
 b22-20020a631b16000000b0046b08e73e0amr41957580pgb.86.1667823756640; 
 Mon, 07 Nov 2022 04:22:36 -0800 (PST)
Received: from localhost ([240e:3a1:313:8350:fe71:9f84:6361:a65b])
 by smtp.gmail.com with ESMTPSA id
 x11-20020aa7940b000000b0056bf29c9ba3sm4521881pfo.146.2022.11.07.04.22.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 04:22:36 -0800 (PST)
From: Coiby Xu <coxu@redhat.com>
To: dm-devel@redhat.com
Date: Mon,  7 Nov 2022 20:22:33 +0800
Message-Id: <20221107122233.261096-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 08 Nov 2022 08:59:40 +0000
Subject: [dm-devel] [PATCH] dm-crypt: fix incorrect use of strcmp when
 telling if there is no key
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
Cc: Mike Snitzer <snitzer@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

strcmp returns 0 when two strings are equal.

Fixes: 69a8cfcda210 ("dm crypt: set key size early")
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..cfefe0f18150 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2590,7 +2590,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	int key_string_len = strlen(key);
 
 	/* Hyphen (which gives a key_size of zero) means there is no key. */
-	if (!cc->key_size && strcmp(key, "-"))
+	if (!cc->key_size && !strcmp(key, "-"))
 		goto out;
 
 	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

