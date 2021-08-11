Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E40AC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 16:09:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CD5A60F38
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 16:09:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7CD5A60F38
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-ja6VQ9zwNLSCQizeUNq-pA-1; Wed, 11 Aug 2021 12:09:22 -0400
X-MC-Unique: ja6VQ9zwNLSCQizeUNq-pA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABBBA8C26C0;
	Wed, 11 Aug 2021 16:09:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 583425D6CF;
	Wed, 11 Aug 2021 16:09:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 961A44BB7C;
	Wed, 11 Aug 2021 16:09:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BG8Imx013815 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 12:08:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B3A14207B0C6; Wed, 11 Aug 2021 16:08:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A857E207B165
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 16:08:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF3CC8556F4
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 16:08:13 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
	[209.85.216.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-590-evCBBmmbOXKV73HUv4qysg-1; Wed, 11 Aug 2021 12:08:10 -0400
X-MC-Unique: evCBBmmbOXKV73HUv4qysg-1
Received: by mail-pj1-f52.google.com with SMTP id
	w13-20020a17090aea0db029017897a5f7bcso5744177pjy.5; 
	Wed, 11 Aug 2021 09:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=P2bD0+aCri1zzmKe0kM8Zk0xtD+ZTNijWsZlAizAD+I=;
	b=LN1Pra/BZZzZRqbXtNmrM5N1yRN+8d6jJ5/hLMiqFm5IlwrDKq1tkCrckjRIElxZn4
	zbYaEEUFCIdWAd79lk+Wz+Nouba0H9d0unHcD+T/EBm0TJu/Y+kzg0cSShj3hSN0gP2H
	+nEBJE77/23LUSQ3O1EtjfTPSianZcH8NcYOS1TCIpyNBvy7UsaFRG4Z1a0pAwwLk/A6
	ycD6a/jraEznvSCvP2k1TY8lMO+pNoyAguMFV+CVmGiHl84WB4yyCLUwYjWxYJGAyTFi
	VSOczxqk6vnEHxzXnhfVujSXpevfXwK+dro3qGuvVhMv6UjuvKx6nE3q0V/CGzVyDqmC
	MvRg==
X-Gm-Message-State: AOAM532Am3FBNpPYWO3rebO0DjLOs/hG2outQPfHPVM5kHSJyrqijQVY
	PGRE4qaB12Mrd5ipcmCX29+OC5e3x/8rHDM5
X-Google-Smtp-Source: ABdhPJyXlW7IIWaKPXm1oAlAkocpySVYaJavUMPo1P3oMORepbOff8aXK17DTUyKMduXBD/7ANti9Q==
X-Received: by 2002:aa7:8e56:0:b029:3cd:c2ec:6c1c with SMTP id
	d22-20020aa78e560000b02903cdc2ec6c1cmr9848795pfr.80.1628698089054;
	Wed, 11 Aug 2021 09:08:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:1:85f2:bb0e:80b9:d6f6])
	by smtp.gmail.com with ESMTPSA id
	h20sm29136546pfn.173.2021.08.11.09.08.07
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 11 Aug 2021 09:08:08 -0700 (PDT)
To: mwilck@suse.com, Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210811154150.24714-1-mwilck@suse.com>
	<20210811154150.24714-3-mwilck@suse.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <942d3693-959a-556d-35b8-d2bf7c4e55e4@acm.org>
Date: Wed, 11 Aug 2021 09:08:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811154150.24714-3-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 2/9] libmultipath: strbuf: simple api for
 growing string buffers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/21 8:41 AM, mwilck@suse.com wrote:
> Add an API for string buffers that grow in size as text is added.
> This API will be useful in several places of the multipath-tools code
> base. Add unit tests for these helpers, too.

Has it been considered to switch to C++ and use std::string and/or 
std::ostringstream instead of implementing a string library in C?

Thanks,

Bart.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

