Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1136C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 16 Nov 2022 23:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668640790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oOimOmHe8e76nL6VhCZ8veCXc1RWbqOhAExyKcop+xk=;
	b=aw4y59O4MVCkxwOzc/i+01K4kfJnU8rCaZtPLDrEtddCVeURHVwQ3CkVBAzR/TK+3jFKHj
	LZu579ruBJSJ+Ww+MlwXvwlDgIIheNY/vMqbTFyXbfaZDR829gWLI+xpG1Z7g9vqgxYlkd
	d+i16N3P1yltfznUX2eDZDrKq6n2y2I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-cZ2x2EUWNcq-3Bx54jfWlA-1; Wed, 16 Nov 2022 18:19:49 -0500
X-MC-Unique: cZ2x2EUWNcq-3Bx54jfWlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69DA1811E75;
	Wed, 16 Nov 2022 23:19:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0ACB62166B30;
	Wed, 16 Nov 2022 23:19:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0ECF19465A4;
	Wed, 16 Nov 2022 23:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3272719465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Nov 2022 22:58:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DC3F1415114; Wed, 16 Nov 2022 22:58:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05AFB140EBF3
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 22:58:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFABB185A792
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 22:58:27 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-qX4pOYfDN9CT8Yu5BHPGvQ-1; Wed, 16 Nov 2022 17:58:26 -0500
X-MC-Unique: qX4pOYfDN9CT8Yu5BHPGvQ-1
Received: by mail-pg1-f171.google.com with SMTP id h193so303858pgc.10
 for <dm-devel@redhat.com>; Wed, 16 Nov 2022 14:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=JenFovSTQN9+wzGd6rk1pX/UQFf/Esi4jnYBpJTyW6k=;
 b=do5QJJMJzSwsqbVni6eft+FZNB281VaKBOh44906ZiYmodqKOBiDWf2DLM0LmK6+7F
 n2T2pReJeizbYMZXTE0gYrGoTlT3W+6rj2r+VvcfH6VgAvG4HH2rWatTZajZbEpGViDa
 gU4CxjKVTodx2nAropm+Gxpd3rUyBZmjRjQBHiyNhr7yD29KYOLdYj6DoRPrjRbLjII8
 IovB+S3w0BEHRwHchyxToLj7NPwVBonztap6h2lRw5i14YUxFHmRfjogE5qoEaH0taIC
 PNVmW+TLQkKefoF9j1apn9ZFsVW/5lnPmg/UNY2i1qjgZXsv++hIJZRpBGmx6Fh4moif
 QDEA==
X-Gm-Message-State: ANoB5plV6nU92RMRD8ZSVpVuaJSkXIQpnYDKvLOkutdJFJHmCSVyCckh
 IcXo3TNwZGnfRVLyo5HkTb4UCQ==
X-Google-Smtp-Source: AA0mqf4tuHJxwwqe1b7MIqPh5fOVIaMq+WItB05J/gZuYEoZcL8yGsMlVDLBnsm67KcdNeRNlET/sg==
X-Received: by 2002:a05:6a00:440b:b0:56b:b53f:e887 with SMTP id
 br11-20020a056a00440b00b0056bb53fe887mr290248pfb.3.1668639504962; 
 Wed, 16 Nov 2022 14:58:24 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 q8-20020a170902dac800b0018725c2fc46sm12891214plx.303.2022.11.16.14.58.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 14:58:24 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Keith Busch <kbusch@meta.com>
In-Reply-To: <20221110184501.2451620-1-kbusch@meta.com>
References: <20221110184501.2451620-1-kbusch@meta.com>
Message-Id: <166863950373.9526.11859127241881103074.b4-ty@kernel.dk>
Date: Wed, 16 Nov 2022 15:58:23 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCHv2 0/5] fix direct io device mapper errors
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
Cc: Keith Busch <kbusch@kernel.org>, ebiggers@kernel.org, mpatocka@redhat.com,
 me@demsh.org, stefanha@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 10 Nov 2022 10:44:56 -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The 6.0 kernel made some changes to the direct io interface to allow
> offsets in user addresses. This based on the hardware's capabilities
> reported in the request_queue's dma_alignment attribute.
> 
> dm-crypt, -log-writes and -integrity require direct io be aligned to the
> block size. Since it was only ever using the default 511 dma mask, this
> requirement may fail if formatted to something larger, like 4k, which
> will result in unexpected behavior with direct-io.
> 
> [...]

Applied, thanks!

[1/5] block: make dma_alignment a stacking queue_limit
      commit: c964d62f5cab7b43dd0534f22a96eab386c6ec5d
[2/5] dm-crypt: provide dma_alignment limit in io_hints
      commit: 86e4d3e8d1838ca88fb9267e669c36f6c8f7c6cd
[3/5] block: make blk_set_default_limits() private
      commit: b3228254bb6e91e57f920227f72a1a7d81925d81
[4/5] dm-integrity: set dma_alignment limit in io_hints
      commit: 29aa778bb66795e6a78b1c99beadc83887827868
[5/5] dm-log-writes: set dma_alignment limit in io_hints
      commit: 50a893359cd2643ee1afc96eedc9e7084cab49fa

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

