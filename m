Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616B0C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 21:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657919353;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wXNCpsDLh5WwaNbQ8ilkAeNlGcOhTwl7Pd3CpJltn3c=;
	b=CdfiflR2wD6w/dACAGwxzw5ANGOyQ4Ea5SR2YpHt0B5Cb2JQcNnPZJyvl436CjZ+CeAuUJ
	Oy7v0D4MGuWb5cNxNbjeMAA4S6ct/qqkJX+c8kWiQbt/tRgz9wB2mlR6SHXX5Nb4cpOED+
	pRmOMyc7e3bBJnvt+00QvcZ7Aq7GKIk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-gfyew40tPPKRkIqdNAkbSQ-1; Fri, 15 Jul 2022 17:09:10 -0400
X-MC-Unique: gfyew40tPPKRkIqdNAkbSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB4023C0D865;
	Fri, 15 Jul 2022 21:09:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76D531121314;
	Fri, 15 Jul 2022 21:09:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2AA621947041;
	Fri, 15 Jul 2022 21:09:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D1EF19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 21:09:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7717E2026D07; Fri, 15 Jul 2022 21:09:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72E552026D64
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 21:09:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57D2E101A54E
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 21:09:05 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-03YRNApPO5uEJH_9nTv61w-1; Fri, 15 Jul 2022 17:09:02 -0400
X-MC-Unique: 03YRNApPO5uEJH_9nTv61w-1
Received: by mail-wr1-f45.google.com with SMTP id f2so8333061wrr.6;
 Fri, 15 Jul 2022 14:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=WRKY8N/4KSEkSZsSRYgIRwoH9ieLQeFZjq3NOIAkwXw=;
 b=HrHDxvvGQ15lP/QOgsohXbUnhh7Jy5pn7gMfjTC4cWdQ5US/kmqy6F2Wf2pThm/YAy
 LR1LIXGTNLJ56kxZopSmeXFPitl5LnKdfeNkqKzl7d4Xe5z11eMPHNvquGDnZTOYOj28
 IkKC+SQtKIz4kThULspGOuL+hwy1a7BayqGim/fSkPHp4ZEoOuEQnfe49AjPlz7aiono
 h6Tn4LtjSbh5cEN7i8M9cfb1WohPXU35xzVooE3KwUTGpU2Ff8mRk6N/r/uVKF9wUIJv
 7M8S/ClQ9ajyZ/v89rzFv3hLdtiPUSOLKun01EYPEXxcF2dIRtvz/Qwizeg6re1SfGaa
 8xoA==
X-Gm-Message-State: AJIora87Ge1X/rOsszU3OlSghvnKuOgKcb0z6DN1RY/CFT+jWy83UOhm
 QFE26jE2A40Mg7iOAhBU79oR/bOZjkk3
X-Google-Smtp-Source: AGRyM1uBAV4dQXMCv8SSGV/Flrt0oW23Dp0+AR/lDNMf6s9AiUTb/9/gFvvKeBfNPTdP4f4d0OhiPQ==
X-Received: by 2002:a5d:5985:0:b0:21d:b6aa:23f5 with SMTP id
 n5-20020a5d5985000000b0021db6aa23f5mr14431070wri.18.1657919341377; 
 Fri, 15 Jul 2022 14:09:01 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 i16-20020a05600c355000b003a2f88b2559sm10242043wmq.44.2022.07.15.14.09.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Jul 2022 14:09:00 -0700 (PDT)
Message-ID: <8dbb3068-0b27-44b5-ba95-0b6494e1db0c@gmail.com>
Date: Fri, 15 Jul 2022 23:08:59 +0200
MIME-Version: 1.0
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Martin Wilck <martin.wilck@suse.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
 <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
 <20220608144006.GW5254@octiron.msp.redhat.com>
 <b5ad7b428d5998e39863a3144d57e40d32f72c1d.camel@suse.com>
 <20220609163652.GC5254@octiron.msp.redhat.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20220609163652.GC5254@octiron.msp.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

This patch is still pending.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

