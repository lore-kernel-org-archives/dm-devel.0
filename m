Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E150C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:23:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D69B23B88
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D69B23B88
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-OEnd4U-0Pua9E1AOJHziUA-1; Fri, 18 Dec 2020 17:23:43 -0500
X-MC-Unique: OEnd4U-0Pua9E1AOJHziUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97EBE800D53;
	Fri, 18 Dec 2020 22:23:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C5CB6B8DF;
	Fri, 18 Dec 2020 22:23:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 758764BB7B;
	Fri, 18 Dec 2020 22:23:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIMNXaV023385 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 17:23:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 014BA2166B28; Fri, 18 Dec 2020 22:23:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F09E52166B27
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:23:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C279F101A53F
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:23:30 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-531-oiT9aLgsOturm6CJySKXXw-1; Fri, 18 Dec 2020 17:23:25 -0500
X-MC-Unique: oiT9aLgsOturm6CJySKXXw-1
Received: by mail-wr1-f49.google.com with SMTP id a12so3933139wrv.8;
	Fri, 18 Dec 2020 14:23:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:to:from:subject:message-id:date:mime-version
	:content-language:content-transfer-encoding;
	bh=jUTvg/T7HgSBwUXd92KAi1UBcUaL+tsATcvBOU4LguU=;
	b=rezqBKiS2GNLqLpQGzH+bhxa1C2gPHRmLQn5Glv27jZEv0uJVy+RF/lNlovORtZiVT
	XSjOE5L8/pxlToINi8xmo9SUa8TVFwYamhglylxtL9nTPRFhNP7b9xp0hL9meKkc160h
	F9yXYmN0EQCwvg9HKrgal2AWOOvc8mDiDDtcYQtP/Dt+BAi9yxNEB1Xwe/ceDIPS2X9s
	mV7gNcyswS/5V0sq8QnWDRisImZoL6Thbm1i3I7FwV4wC9+EBzfi6kDnDGOWbo5MVvHN
	s9Fm0W9lJ+s4ch5oP44scXq/XUJ0NwTSQXi1w3omYuCyquI6Og2P4UR2LSggvbNFTiKZ
	UPmA==
X-Gm-Message-State: AOAM530FGBf5u/E8LRg39dprRljYoU0pAy/okyBNqMz4ruZ2Z58Zvtgx
	O2qdhb5lwvjP4EvF9ptIpgACMrZXpcT6
X-Google-Smtp-Source: ABdhPJwuyNfwMA1FtwphCwUHzGXsOD0O/iaBp2SyUjpSsjy3qwZHind2Isfg7eo72KooiAFEoR/mXQ==
X-Received: by 2002:adf:e688:: with SMTP id r8mr6558216wrm.20.1608330204134;
	Fri, 18 Dec 2020 14:23:24 -0800 (PST)
Received: from localhost (242.red-95-127-155.staticip.rima-tde.net.
	[95.127.155.242]) by smtp.gmail.com with ESMTPSA id
	r1sm16270110wrl.95.2020.12.18.14.23.22
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 18 Dec 2020 14:23:23 -0800 (PST)
To: DM-DEVEL ML <dm-devel@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <1dc19756-4639-5412-e44a-4472ab789c26@gmail.com>
Date: Fri, 18 Dec 2020 23:23:21 +0100
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
Subject: [dm-devel] one warning in current upstream-queue branch
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

With clang-11:

[...]
make -C libmultipath
[...]
clang --std=gnu99  -O2 -g -fstack-protector-strong --param=ssp-buffer-size=4 -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-securit y 
-Werror=cast-qual  -pipe -DBIN_DIR=\"/sbin\" -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -MMD -MP -fPIC -I../libmpathcmd -I../libmpathpersist -I../libmultipath/nvme -DUSE_SYSTEMD=246 -DLIBDM_ API_FLUSH 
-D_GNU_SOURCE -DLIBDM_API_GET_ERRNO -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -DLIBDM_API_HOLD_CONTROL -Wp,-D_FORTIFY_SOURCE=2  -c -o log.o log.c
log.c:142:32: error: format string is not a string literal [-Werror,-Wformat-nonliteral]
         vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
                                       ^~~
1 error generated.
make[1]: [../Makefile.inc:139: log.o] Error 1 (ignored)
[...]

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

