Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8702FC4321E
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 00:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670026460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MxG40Be59LiBzuG6405lBWy5xQjTnTqXExeALM0euhc=;
	b=BOdFeW66rjNG8E2O/Mt0qHs90F7/g+eM4KU5i4a3V4bBsYU06baQi1btz2mbPsalv8H/PV
	cvWX7H7+sAiIVjXvJV9I77fRTmpGIZYuTBvIccm8pCoUUPBbRYVZkZFJFgDk4Tw2lSyocp
	SvQixFtjllbiwYR6ffWrkzcQTkgiLvI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-xtAbkD67PuGzcAQhwObkfw-1; Fri, 02 Dec 2022 19:14:17 -0500
X-MC-Unique: xtAbkD67PuGzcAQhwObkfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBF93C01D9D;
	Sat,  3 Dec 2022 00:14:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B253F1401C3A;
	Sat,  3 Dec 2022 00:14:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6978C194658F;
	Sat,  3 Dec 2022 00:14:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E06F11946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 00:14:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E8982166BC0; Sat,  3 Dec 2022 00:14:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 976652166B2A
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:14:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79B5129AB40B
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 00:14:12 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-1FxDQCt3O9y-YUEOEr3SCg-1; Fri, 02 Dec 2022 19:14:08 -0500
X-MC-Unique: 1FxDQCt3O9y-YUEOEr3SCg-1
Received: by mail-wm1-f51.google.com with SMTP id
 125-20020a1c0283000000b003d076ee89d6so5010146wmc.0; 
 Fri, 02 Dec 2022 16:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Csa428ppCdUNrPt+KgAd5MVc/5H9oyItEpxhtqEaGgY=;
 b=PaW+cIJxDUnDesl8rURkQBGXkI4QPeX4+fwVbb/8zhwQUcXmhyH3z4QSmgNRswGEih
 gMNjjFQ+BiP/2Za1Vw4USmfOJVz9kOwiMxUK8TRJfYztynERM8sv0i3i+RUx67l5sbwg
 cYfLHNiA8iwMqgiyn9AkvmVn1sJjB7+9wv82VwHBSV2Lh68HBgvMP+EBUdHyYzGcIpSf
 NMDr9LcGQDmYGPhtXJQgKqdob9H0mEOm0WVbGnozDEdlP18DrQKEbWjRF1DDk+vHagjE
 e4d7sKLKr/5N4nQCxK+u9P0N1KEPk90i/cMwoFxHmuzvDEConjHEM5XX/KS8GRNVv3Kt
 b8kw==
X-Gm-Message-State: ANoB5pnEWeKw4I9c7G3+CJRMMHb81raoKDKbhKWDTnFcggkce/y7dAC/
 hxdssQQ0rst3NsJFkl2eLw==
X-Google-Smtp-Source: AA0mqf6m/xDmFRSK/V8FjZvyupn8z4+HkVA1Q4y+6+HuQTcn3Uy7vFZhpmt166V4FH0h7VErHec87Q==
X-Received: by 2002:a05:600c:3d8f:b0:3cf:6b14:1033 with SMTP id
 bi15-20020a05600c3d8f00b003cf6b141033mr54317656wmb.103.1670026447236; 
 Fri, 02 Dec 2022 16:14:07 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 o37-20020a05600c512500b003cf5ec79bf9sm11555425wms.40.2022.12.02.16.14.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Dec 2022 16:14:06 -0800 (PST)
Message-ID: <4c726fd9-3545-6e48-a26d-c3eaa591002c@gmail.com>
Date: Sat, 3 Dec 2022 01:14:06 +0100
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>, Roger Heflin <rogerheflin@gmail.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
 <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
 <91e6e7158648b2f5f2bc583e62c9563f5d8fe914.camel@suse.com>
 <CAAMCDec=joUfwX3TFGPTAFB8UP7ihxqOz5EiLR-Mp2yJQtSsnQ@mail.gmail.com>
 <e506d4c8d63e0fda3c28297c4316b49c0e2a9fb1.camel@suse.com>
 <CAAMCDeeAQL8yaq2HVE+hFdYv=Ax7aSCn0gqKEW2AV-jzzN9esg@mail.gmail.com>
 <cf398b5ccefd3a1a6f458ab5e4811f8f6afc415c.camel@suse.com>
 <CAAMCDeeUkfetN6ABUcDTU29m0yR1gv7UPh8_2HtLg_ZPBougXg@mail.gmail.com>
 <2ac89d4413992bd1158e4552d0632cf8c6a8dd89.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <2ac89d4413992bd1158e4552d0632cf8c6a8dd89.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/3/22 01:02, Martin Wilck wrote:

> Funny, Ben never told me there was a conflicting option name in RHEL.
> I guess it's too late now, as I said, the upstream option has existed
> for 4 years.

Because it was remove in RHEL-8, since multipath-tools were updated to 0.8.4
RHEL-7 uses a very old code base(0.4.9) with a lot of patches(273)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

