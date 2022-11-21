Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C2EC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 21 Nov 2022 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669055997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6Whvifa9TH3kPN21ntZmExeJYVaTvMZcl8NfYUuvfkY=;
	b=FhI3Im9v8nSbRwdvi3AC2OjuD3Yhpmj+k70AZEGJ3lATKVLl1K4QDD4OTNUJwMxehh6ldq
	XYeijVRK2YHa3o62CGHqmb3hYg+JbY8/mxypyzKHBOLQ2tzRm355dHA0Q0FMQ1z5odlHLd
	miKZxpUIL8D/4ISSFnGpA8qg6oSHIbY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-OM5ptQa1NLOuXR6hFHxT6A-1; Mon, 21 Nov 2022 13:39:54 -0500
X-MC-Unique: OM5ptQa1NLOuXR6hFHxT6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6083101A56C;
	Mon, 21 Nov 2022 18:39:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD1A21415117;
	Mon, 21 Nov 2022 18:39:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 690AC1946588;
	Mon, 21 Nov 2022 18:39:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D868F1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 21 Nov 2022 18:39:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38BAB492B16; Mon, 21 Nov 2022 18:39:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31137492B06
 for <dm-devel@redhat.com>; Mon, 21 Nov 2022 18:39:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1644385A5A6
 for <dm-devel@redhat.com>; Mon, 21 Nov 2022 18:39:38 +0000 (UTC)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-02lTihkcNvSGQMj7FVEn0A-1; Mon, 21 Nov 2022 13:39:36 -0500
X-MC-Unique: 02lTihkcNvSGQMj7FVEn0A-1
Received: by mail-io1-f47.google.com with SMTP id h206so9248346iof.10
 for <dm-devel@redhat.com>; Mon, 21 Nov 2022 10:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=6pMBKkz/dz3aQqTl7mhhbAzRSuHiokJcH7elJ899uEM=;
 b=JGdpAndKLa3YVsvSTJpC3JaO9KO4WzzzbSvO9t4FXIUp450Y/FTl2o8OIy1gGfEKL4
 wHQO6s9aIOJ/wweVvtfvUuI+vzsUsj4hs4bsgylNlVm8s6BSfKrL1KWEnDnly5aTCKc3
 Cxs1X4GHqhhgPoQcWkb0n3rJVL/XFXrY0OHRY+KElv8fNEYtn8Wx/yESlbMWjuYfWftw
 ypHlhcTgloYrYyTR6HJwYC31uLg01bGbbOWoiMDbzITv1sJbe1kgZmk9utnNdXpWMv8w
 TVCBfEb+3H2QRG/6WzbLnCIRCp+UVsvcuHAC/IBfpMrkH7fp8n8zh4zBXfSnEEcFN5/F
 dP6Q==
X-Gm-Message-State: ANoB5pnVSfoBvLEqYv94XT72CFhB7GOJTLDZyCESLEVR2HgQxScBuDp1
 W77J7pVpPxqz9mKaOTxN5Iuceg==
X-Google-Smtp-Source: AA0mqf7mgkRUpfMeIYsGOMnxGuuOO5ueSoGqz6a+HzTinXPm92/vpzyly1tUfn12/gMh5aR47F8sTw==
X-Received: by 2002:a02:780e:0:b0:375:ab48:de95 with SMTP id
 p14-20020a02780e000000b00375ab48de95mr1208395jac.14.1669055975090; 
 Mon, 21 Nov 2022 10:39:35 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 w184-20020a025dc1000000b00356744215f6sm4596037jaa.47.2022.11.21.10.39.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Nov 2022 10:39:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20221114042944.1009870-1-hch@lst.de>
References: <20221114042944.1009870-1-hch@lst.de>
Message-Id: <166905597395.59249.16543635744813742339.b4-ty@kernel.dk>
Date: Mon, 21 Nov 2022 11:39:33 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] pass a struct block_device to the blk-crypto
 interfaces v3
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
Cc: linux-block@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 14 Nov 2022 05:29:41 +0100, Christoph Hellwig wrote:
> this series switches the blk-crypto interfaces to take block_device
> arguments instead of request_queues, and with that finishes off the
> project to hide struct request_queue from file systems.
> 
> Changes since v2:
>  - update a few comments
>  - fix a whitespace error
>  - remove now unused forward declarations
>  - fix spelling errors an not precise enough wording in commit messages
>  - move a few more declarations around inside or between headers
> 
> [...]

Applied, thanks!

[1/3] blk-crypto: don't use struct request_queue for public interfaces
      commit: fce3caea0f241f5d34855c82c399d5e0e2d91f07
[2/3] blk-crypto: add a blk_crypto_config_supported_natively helper
      commit: 6715c98b6cf003f26b1b2f655393134e9d999a05
[3/3] blk-crypto: move internal only declarations to blk-crypto-internal.h
      commit: 3569788c08235c6f3e9e6ca724b2df44787ff487

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

