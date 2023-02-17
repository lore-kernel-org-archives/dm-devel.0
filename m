Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA02C636D6
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 21:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676670124;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bPFuDxpQ8prgpw6V22J6xx3McrZaG7v1f6OxhjBzeNw=;
	b=KjZf+er/9lRCNGZn4mlUs4LXx2iMEGsr9xC4dmTFNpxnf6zx5L2lXVn0Qg8HygVfrsao49
	ApqxQTO5774lOqpcIAd5PhW4vbvaP570blhE72VP8ZrjXG+RT/3RBkFZBKBQr72nWoqKTN
	FkjDHx/YGB3DYuCFJEcnSIH5ptRW5Ks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-TB9GyWxWOFaH9wXEoRarVA-1; Fri, 17 Feb 2023 16:42:03 -0500
X-MC-Unique: TB9GyWxWOFaH9wXEoRarVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A851D1019CBC;
	Fri, 17 Feb 2023 21:41:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95686C15BA0;
	Fri, 17 Feb 2023 21:41:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DBD61946589;
	Fri, 17 Feb 2023 21:41:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC0D61946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 21:41:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7675404CD85; Fri, 17 Feb 2023 21:41:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0646404CD84
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 21:41:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 949D3101A5B4
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 21:41:56 +0000 (UTC)
Received: from mail-il1-f227.google.com (mail-il1-f227.google.com
 [209.85.166.227]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-491-hseYPg46P_6XV0Ih-x5w_Q-1; Fri, 17 Feb 2023 16:41:54 -0500
X-MC-Unique: hseYPg46P_6XV0Ih-x5w_Q-1
Received: by mail-il1-f227.google.com with SMTP id d5so859839ilu.13
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 13:41:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dNanTuJiFaffs6p61iPp8uSQmlAn6aQ4qdubO70a2yY=;
 b=D5T1PRrN9Cgtg9cRnQr6mQBRvP0Dxn8+eU8V0EQN9zCjcAhcGbbl/EnLN9Yxa8CxJ0
 ppLyCbOnTrLh5b2A1UP5QKFgVfsYL4qzu+OLyIbdIeqBQubluE0y+aI9ylJwC1Fept9/
 Mj5WaVrK/L8in++LWIFx4kxi7DCo8M4P3hEqfsva/aR3/QPmM1lajKVHpAdAyFVR642t
 ZQSEdtgDTa1Qjk0dG08ptTBMEXeM+9NvvOg8ltWTwlbD3E/0JddkM8aFQH+Oeg31zFa1
 11zo2IIeFkGd2nNRutScBqb71buWpAVmKn+xJWdt3s4oOCcykBG2/4tAQXrbgcbsnrBo
 pE0w==
X-Gm-Message-State: AO0yUKViAx5NMAKY0tsf5cVAmK4Xo0dAeoprBa3u/2Ecfpqk9weLfLEx
 rOp06F4lCXIEJFHnO5kZYdo/TwAIegx/4cqOd3Vp/wK3HvKO2GVRDHK04xjmSoOnJQ==
X-Google-Smtp-Source: AK7set9qv24vhhnsz2IGKkRz0ahqJKiqry6wPHLLBeGPi5dTQbar9+H/VBUJGVP+dGIm1Dn7A4MHCxt/dNON
X-Received: by 2002:a05:6e02:164d:b0:315:7290:428a with SMTP id
 v13-20020a056e02164d00b003157290428amr1355252ilu.11.1676670113929; 
 Fri, 17 Feb 2023 13:41:53 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
 by smtp-relay.gmail.com with ESMTPS id
 m9-20020a056e021c2900b003152992255asm230795ilh.17.2023.02.17.13.41.53
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 17 Feb 2023 13:41:53 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev5.dev.purestorage.com
 [IPv6:2620:125:9007:640:7:70:36:0])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id CDADC220E9;
 Fri, 17 Feb 2023 14:41:52 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id C7B96E40376; Fri, 17 Feb 2023 14:41:52 -0700 (MST)
Date: Fri, 17 Feb 2023 14:41:52 -0700
From: Uday Shankar <ushankar@purestorage.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <20230217214152.GA1124853@dev-ushankar.dev.purestorage.com>
References: <20230215201507.494152-1-ushankar@purestorage.com>
 <Y+3IoOd02iFGNLnC@infradead.org>
 <20230216192702.GA801590@dev-ushankar.dev.purestorage.com>
 <Y++oTz0ck9OGE4Se@infradead.org> <Y++utrkJXuUsD0K4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y++utrkJXuUsD0K4@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] blk-mq: enforce op-specific segment limits in
 blk_insert_cloned_request
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
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Much easier to address a bug in a driver when seeing this message than
> figuring it out after more elaborate hunting. Not seeing the downside
> of preserving/fixing given it is a quick limit check. *shrug*

I tend to agree - considering the check has been here for a while, I
don't know if lower levels will have particularly enlightening logging
(if any at all) for these errors.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

