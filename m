Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D0DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 16:51:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D04386141B
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 16:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D04386141B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-k070dEneMPSL_79v7pM9nA-1; Thu, 21 Oct 2021 12:51:46 -0400
X-MC-Unique: k070dEneMPSL_79v7pM9nA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA29100CCC0;
	Thu, 21 Oct 2021 16:51:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69F9660657;
	Thu, 21 Oct 2021 16:51:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B7FF4A704;
	Thu, 21 Oct 2021 16:51:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LGo7Ts009868 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 12:50:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C5F62166B25; Thu, 21 Oct 2021 16:50:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 173A82166B2F
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 16:50:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EA7C899EC2
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 16:50:02 +0000 (UTC)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
	[209.85.210.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-186-F5_OV99cN_SN6Unf7CdWbw-1; Thu, 21 Oct 2021 12:50:00 -0400
X-MC-Unique: F5_OV99cN_SN6Unf7CdWbw-1
Received: by mail-ot1-f41.google.com with SMTP id
	g62-20020a9d2dc4000000b0054752cfbc59so1192140otb.1
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 09:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
	:message-id:date:mime-version:content-transfer-encoding;
	bh=H/Eozbq7KtLQv7I05PmFbNf/apdYsXdfHT73zybO8ZE=;
	b=e4D/1NB19lri38UQDG1Zoqamt2YryNQhRlpd67rrCWjxG7oD3lOrAPg9wPml0ZIiBc
	GU4u6uG4LwDLyalAOfIPvqCnA5QV81s1QQR6n9Rq6RnBwXjUgPmyO89lg+kz8ZJo0N+O
	lY4HH/Ul9x39IOjes+wXkq89BhgeCEZgrvMFhJSjN23irFAEwNTyC+WoIG/yTGykwJR8
	VtS7oL6DGlmCbmr06Y3jJP48752MoGGIHK1Dt1Jv+u9AWBKcC3bghPEavNZ2vEfX8Oh0
	GCsgXiUhsDM9bn6QEFdU34Ygbd3Ha9smsg6TolgWLdKSytNw9Zs85epg3xQrLE6hZFHY
	6HJQ==
X-Gm-Message-State: AOAM531EXJuJsGv3DDO59b9As7lq+SSukJK3TX0pRQ7kXNRReUF3fbJE
	bm1n5GzjdmEJoXkL/R6lDP22qd9GU+PDgw==
X-Google-Smtp-Source: ABdhPJw4fg+s6o/fbrAgM6IxFUri1B2riMoKLYLBK8KHXUcxmp3h8VPW/Swvw/MRzkp1OZUSWEvhAw==
X-Received: by 2002:a9d:3b8:: with SMTP id f53mr6001846otf.253.1634834999951; 
	Thu, 21 Oct 2021 09:49:59 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:783a:c43c:af64:c142:4db7:63ac])
	by smtp.gmail.com with ESMTPSA id
	g29sm1179353oic.27.2021.10.21.09.49.59
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 21 Oct 2021 09:49:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
In-Reply-To: <20211018180453.40441-1-ebiggers@kernel.org>
References: <20211018180453.40441-1-ebiggers@kernel.org>
Message-Id: <163483499921.66288.14458324918559511031.b4-ty@kernel.dk>
Date: Thu, 21 Oct 2021 10:49:59 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v6 0/4] blk-crypto cleanups
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 18 Oct 2021 11:04:49 -0700, Eric Biggers wrote:
> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the
> "blk-crypto profile" of a device, similar to blk_integrity_profile.
> 
> This series also improves the inline-encryption.rst documentation file,
> and cleans up blk-crypto-fallback a bit.
> 
> [...]

Applied, thanks!

[1/4] blk-crypto-fallback: properly prefix function and struct names
      commit: eebcafaebb17cb8fda671709fab5dd836bdc3a08
[2/4] blk-crypto: rename keyslot-manager files to blk-crypto-profile
      commit: 1e8d44bddf57f6d878e083f281a34d5c88feb7db
[3/4] blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
      commit: cb77cb5abe1f4fae4a33b735606aae22f9eaa1c7
[4/4] blk-crypto: update inline encryption documentation
      commit: 8e9f666a6e66d3f882c094646d35536d2759103a

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

