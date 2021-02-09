Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1240CC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:24:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D20F64E4F
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D20F64E4F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-cKG2nqmNNp2fmkeBsGsjgA-1; Tue, 09 Feb 2021 09:24:18 -0500
X-MC-Unique: cKG2nqmNNp2fmkeBsGsjgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F23B79EC9;
	Tue,  9 Feb 2021 14:24:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F135F60CD2;
	Tue,  9 Feb 2021 14:24:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CFAC18095CB;
	Tue,  9 Feb 2021 14:24:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119EO9iR028238 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 09:24:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 36B172166B27; Tue,  9 Feb 2021 14:24:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 314EC2166B2A
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 14:24:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5755858F17
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 14:24:05 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
	[209.85.208.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-324-jPJrFvGRNxO9PWtiwuWh-g-1; Tue, 09 Feb 2021 09:24:03 -0500
X-MC-Unique: jPJrFvGRNxO9PWtiwuWh-g-1
Received: by mail-ed1-f41.google.com with SMTP id l12so23893176edt.3
	for <dm-devel@redhat.com>; Tue, 09 Feb 2021 06:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=v35INao9+dVtf3SI+UT77JvzVjV43yqCRietP886/dY=;
	b=ZHPpqJf7HX0Jwwdc+yYj3aPA63yTGZw5a9jrhwE0+ydXx5YqMfR1EPQXYIE0dYIUfF
	yqetilM8c8SPHQDjShlJPtj7neF+5pM79EjGFn70PHXf6EKevv1L6v1hGd0FQ0W+7mAP
	v00WkUDj+wGz2T0SL2uQfIYhh6IJJ2Fe0Gj6MKEfAM1iP8lqApPx/m8ndvuhzx3NB/Bv
	IC6fVbNt7iCf/q8TPd5UJ54ggHm8eYh2Frvk31198+OwtMFDG3J2EQu4vadmrWyj46Jm
	6nH+JZh7qXBwQfss4GO8Fm/KH7GGeadxDiwyCRnM15Hi7PQiTH/5Dm0L06FI70dHYrnz
	q0tw==
X-Gm-Message-State: AOAM531Ari9CmkejNGahRh1oGDMLmtD7YzVU8zkgJ7lRdvACH5vHVOg+
	SglneM8V0WsgIvtZITeKnoO3Ig==
X-Google-Smtp-Source: ABdhPJx9sn9zhBtcGfbgfK1vn9byz7OCBZW9PWNv9Ds5UYIMlMlq4SL3S8VwQeARWt7tovR4cASusg==
X-Received: by 2002:a05:6402:27d1:: with SMTP id
	c17mr22986131ede.109.1612880641585; 
	Tue, 09 Feb 2021 06:24:01 -0800 (PST)
Received: from [172.16.10.100] (46.246.242.173.dsl.dyn.forthnet.gr.
	[46.246.242.173]) by smtp.gmail.com with ESMTPSA id
	j5sm11925512edl.42.2021.02.09.06.24.00
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 09 Feb 2021 06:24:00 -0800 (PST)
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
References: <20210122151931.24645-1-ntsironis@arrikto.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <7b1119f1-e7a5-87a0-adea-ba253ec8d8f2@arrikto.com>
Date: Tue, 9 Feb 2021 16:23:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210122151931.24645-1-ntsironis@arrikto.com>
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
Cc: ejt@redhat.com
Subject: Re: [dm-devel] [PATCH 0/2] dm era: Fix bugs that lead to lost
	writes after crash
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

Hello,

This is a kind reminder for the dm-era fixes I have sent with this and
the rest of the relevant mails.

I'm bumping this thread to solicit your feedback. If there is anything
else I may need to do, please let me know.

Thanks,
Nikos

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

