Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B470BC636D3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675704587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eEbQvlbi7pZKHY3C7DO7ha/vUaB/k8d4rjgKkcVkaGo=;
	b=TpW98+xWoxlY4gHv4UvUp06ihDyibvpDZRz6yaYBHK5K2J9p3MdI+QEkPx1R2Cen8JDyyx
	Wr+GVWv3CfDCUcedix3G7TA2VAB9NpAn7bOyd6MU+rFxfPp/J2jYoSlDIE1tjNCqK4lS/0
	fq2cu3E+Ol09ieG4+DjP4UZVs57JdQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-X1UnkfkzPcmNjr7UYeH8Zw-1; Mon, 06 Feb 2023 12:29:46 -0500
X-MC-Unique: X1UnkfkzPcmNjr7UYeH8Zw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F24D3886462;
	Mon,  6 Feb 2023 17:29:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF661440D9;
	Mon,  6 Feb 2023 17:29:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAF9D194658C;
	Mon,  6 Feb 2023 17:29:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4561C1946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 17:29:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2567540369A5; Mon,  6 Feb 2023 17:29:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DCF640369A0
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 17:29:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0148C800B24
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 17:29:42 +0000 (UTC)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com
 [209.85.160.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-527-FhCgbO-GMquzk5vL5WRLvg-1; Mon, 06 Feb 2023 12:29:40 -0500
X-MC-Unique: FhCgbO-GMquzk5vL5WRLvg-1
Received: by mail-qt1-f171.google.com with SMTP id cr22so13631177qtb.10
 for <dm-devel@redhat.com>; Mon, 06 Feb 2023 09:29:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=w/LaKIf+3pRA4MyQMhbr3PlVOqptn/pf/udFxon0+9Y=;
 b=PJjgWelFbAP1jpZQJc8U56d/oQm33QBMtOpfFrY1L+lmstRrQQQ//3Pxc5bTfGzxJ0
 /HV3U5YhiMLby87QGsVSlzT/1AbwPdaTZPY0Z1PP6NygV4f1d+1Dxz4MBXfZ/o3fsJwq
 5BDlSSwfsH3HZ2Cs8CY58jpqZDCkoa2YjlTu9CRL5F2kMU0vcbH2AMUzLx80FCl2kfqK
 XaMD+QBQKK/8OgG729ulnA0JYtaAEvfb9T+ikhaGzzBLtaYXPvs0qFSHncgjZrtB85jy
 NfNGuGMtOYVZRWkunIB1X3rT+3wkgctQVNvD/nYgC7lnJwZMgRxZUMr6OIp9fbxX8aPd
 Bwkg==
X-Gm-Message-State: AO0yUKXndIx3dbrUSBQqL9ND7srr+lvqs7fldcLFbMc7FD/EhgSTM0IA
 8hA8hDc6iFkfLkakOCDfoeaVjmI=
X-Google-Smtp-Source: AK7set/ae55jb9i/baaW/xLk4b7RJtQzOV+41D/ChSc6zOFdBQ9usaCQZSB0nyipHZthrt6kgVy39g==
X-Received: by 2002:a05:622a:c7:b0:3ba:1398:c68d with SMTP id
 p7-20020a05622a00c700b003ba1398c68dmr150769qtw.16.1675704579799; 
 Mon, 06 Feb 2023 09:29:39 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b13-20020ac844cd000000b003ba1ccba523sm3956815qto.93.2023.02.06.09.29.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 06 Feb 2023 09:29:39 -0800 (PST)
Date: Mon, 6 Feb 2023 12:29:38 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <Y+E5AkiVTbjgXWjs@redhat.com>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydu-007zio-0W@formenos.hmeau.com>
MIME-Version: 1.0
In-Reply-To: <E1pOydu-007zio-0W@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 11/17] dm: Remove completion function
 scaffolding
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
 Tyler Hicks <code@tyhicks.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Johan Hedberg <johan.hedberg@gmail.com>,
 Marcel Holtmann <marcel@holtmann.org>, ecryptfs@vger.kernel.org,
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

On Mon, Feb 06 2023 at  5:22P -0500,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch removes the temporary scaffolding now that the comletion
> function signature has been converted.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

