Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE66FEB64DD
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jul 2023 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688593711;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ibO2Ea+pGx/lg8XjMq4/57wJgTIHbIxUqUFGHb41A2w=;
	b=DAkz1AqE2qWiFFev3uun3gQCEox5mYDIYiqYqbKF+nI0m+4bjXXSANGW8a6HZEmJgg5oaZ
	zjS8Ge09VB2wfDrOtAqIBVnhntK0gKCKHY9zKK+0gn+dGvZh9ngDs5RmcIHBibx/cNpVTC
	ZB9ii4OHF2yuzA6IJ22RO52Rx/iY6xA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-Wffm4XKROXK5FBXKmjUy3A-1; Wed, 05 Jul 2023 17:48:28 -0400
X-MC-Unique: Wffm4XKROXK5FBXKmjUy3A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0841029ABA10;
	Wed,  5 Jul 2023 21:48:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B083B492C13;
	Wed,  5 Jul 2023 21:48:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B6861946589;
	Wed,  5 Jul 2023 21:48:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 719F71946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 21:48:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B815207B2DD; Wed,  5 Jul 2023 21:48:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03CC3207B2DB
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 21:48:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA55085A58A
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 21:48:24 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-Z_SJRA4tMlqwqqmRSGlBzw-1; Wed, 05 Jul 2023 17:48:23 -0400
X-MC-Unique: Z_SJRA4tMlqwqqmRSGlBzw-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-682ae5d4184so27588b3a.1
 for <dm-devel@redhat.com>; Wed, 05 Jul 2023 14:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688593702; x=1691185702;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BOPvhh+ov5YJbwQGH/Di2AOKn8vSvodS2CRBdcRd+fM=;
 b=Vc3drnA3G+v43Zei6FXPEa252IeUVIkyxsQ0RxseIiHln+Fp3x7zAi8pfAf0h8+o1Q
 R8qciQhPdG0+Fhng62/b3CVnqoiMfDPXcMewry+GDCThC+fU5ZYkUqhSj89143riHYI0
 jjovwg8ctYoAYYVtt2aIWtMM3yuHPungBMAAaDX2z8aUAHCUgEo5GdaFqM6/f8Flu3Yf
 z6ZmHEE6GboUfFM3rCJRY6Fot+4SDB3yJ3VW4nwVldHaADTC0RbqgO45wRlzDjTWxktQ
 8x4A+EWHJBs6g5ewpN8jlLoPmME2ZEEJahSdy1n3TN0AsKiw2PfXUhepT47cOVUKoGKv
 owlw==
X-Gm-Message-State: ABy/qLaYEYXdFhvYTppf/9t2uX9oJztlQubgQ9IdbzZTyIM4cre4RGtV
 YM9BWVDEJpJih4kpsBiDDmrmFw==
X-Google-Smtp-Source: APBJJlH2ZqRP11QkNFCo9JfQxpUtuhUf7s+3LhTDPi7Xc+3dYYUlgngnznYruHc3MSBJm+YpmKXLdg==
X-Received: by 2002:a05:6a20:7da6:b0:12e:2fdb:7865 with SMTP id
 v38-20020a056a207da600b0012e2fdb7865mr171579pzj.0.1688593702110; 
 Wed, 05 Jul 2023 14:48:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 v23-20020aa78517000000b0064f95bc04d3sm18895pfn.20.2023.07.05.14.48.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jul 2023 14:48:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
In-Reply-To: <20230610061139.212085-1-ebiggers@kernel.org>
References: <20230610061139.212085-1-ebiggers@kernel.org>
Message-Id: <168859370102.821139.12959799730929938922.b4-ty@kernel.dk>
Date: Wed, 05 Jul 2023 15:48:21 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] blk-crypto: use dynamic lock class for
 blk_crypto_profile::lock
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
Cc: dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Fri, 09 Jun 2023 23:11:39 -0700, Eric Biggers wrote:
> When a device-mapper device is passing through the inline encryption
> support of an underlying device, calls to blk_crypto_evict_key() take
> the blk_crypto_profile::lock of the device-mapper device, then take the
> blk_crypto_profile::lock of the underlying device (nested).  This isn't
> a real deadlock, but it causes a lockdep report because there is only
> one lock class for all instances of this lock.
> 
> [...]

Applied, thanks!

[1/1] blk-crypto: use dynamic lock class for blk_crypto_profile::lock
      commit: de9f927faf8dfb158763898e09a3e371f2ebd30d

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

