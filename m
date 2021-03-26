Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A785FC433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 18:12:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1910D61A2A
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 18:12:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1910D61A2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-pDrRZaglP1e44cBSjuNtww-1; Fri, 26 Mar 2021 14:12:42 -0400
X-MC-Unique: pDrRZaglP1e44cBSjuNtww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127D2108BD0D;
	Fri, 26 Mar 2021 18:12:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 981F450A98;
	Fri, 26 Mar 2021 18:12:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8C46D1809C83;
	Fri, 26 Mar 2021 18:12:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QIAYGB012141 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 14:10:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F1332026D65; Fri, 26 Mar 2021 18:10:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49D762026D07
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 18:10:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1286858EED
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 18:10:31 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
	[209.85.128.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-486-gmbMQYboMQGd6ZQdUUxjBQ-1; Fri, 26 Mar 2021 14:10:29 -0400
X-MC-Unique: gmbMQYboMQGd6ZQdUUxjBQ-1
Received: by mail-wm1-f54.google.com with SMTP id
	r10-20020a05600c35cab029010c946c95easo3447258wmq.4; 
	Fri, 26 Mar 2021 11:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=WycUcq5NGia49PTBmDFcXWYu+dg/NM1WkPfovKN3/Rk=;
	b=PQRta0NymtViR/6xumTU7EeqGqck1qOLMlVo5J9uIJVaYBxzMAEJ+7OSEhRdt7u6kA
	ug1+Uo6am2JzsJRg/Tc8aNW0V3OHXNT1sKIkRZMy5Ti0yoCoTrlnjk2pBQgHJCHsAUds
	UxjHbsywD6AgwhHI+Ui1/IQnslQPN4HB46qMR76D5QEEupXZ59ODLBQi4EeCB2sb0PPZ
	ciUPBIx6Dw42m8mm5RXoPTN4VU26mRmcU2NVtgBVx9atcs1JJOJa++3PnvaOd0Kw+XEQ
	/qf5BVZpVTudWOKJ6ucPBSTFNPYmXRp9rVyv2ww3HOCk9MAB82Zo2CQVe1aA+1fpFsHt
	z+7A==
X-Gm-Message-State: AOAM530GhD8gvUK1YagvAJHKv9LeIcXr89wyQjv7a67VgEMsOiftIa6c
	QLvIiRlrsVDo7pPLg1a3puKX+kWUW6/m
X-Google-Smtp-Source: ABdhPJwq6u1IOpDHIQreKDIEJzW6sERyW4CpJ9u4Hx8Ks3aUi2epJBvCnLuKvOVdFb1i3Q/EL3C+yw==
X-Received: by 2002:a7b:c1c9:: with SMTP id a9mr13853813wmj.145.1616782228121; 
	Fri, 26 Mar 2021 11:10:28 -0700 (PDT)
Received: from localhost (92.red-83-33-157.dynamicip.rima-tde.net.
	[83.33.157.92]) by smtp.gmail.com with ESMTPSA id
	i4sm10952772wmq.12.2021.03.26.11.10.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 26 Mar 2021 11:10:27 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>
References: <20210326030839.15452-1-xose.vazquez@gmail.com>
	<c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <d07187d1-ff96-b3f8-6ba4-d65d7d739b2f@gmail.com>
Date: Fri, 26 Mar 2021 19:10:25 +0100
MIME-Version: 1.0
In-Reply-To: <c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Zhouweigang <zhouweigang09@huawei.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: convert back HUAWEI/XSG1 to
	multibus
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
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/26/21 6:24 PM, Martin Wilck wrote:

> Forgive me if I'm missing something here, but what is this good for?
> multipathd detects ALUA support by default.
> 
>   1 if the device doesn't support ALUA, it falls back to "const" anyway,
>     in which case "group_by_prio" degenerates to "multibus" - which is
>     exactly what this patch does;
>   2 if the device supports ALUA, but returns the same ALUA state for
>     all ports, again "group_by_prio" degenerates to "multibus";
>   3 if the device supports ALUA and returns different states for
>     different ports, "group_by_prio" is the best bet anyway.
> 
> So why not just use "group_by_prio"?
You are right, but:

1.- It's the official vendor recommendation, and people trust it blindly
     above the multipath-tools setting. Sad but true.
     So it's going to be manually replaced by the vendor's config.

2.- It generates an awful warning:

     [This is SLES 12SP5 with 4.12.14-122.54-default on x86_64
     and multipath-tools-0.7.9+195+suse.16740c5-3.6.1.x86_64]

# multipath -ll

Mar 26 18:34:46 | sdi: prio = const (setting: emergency fallback - alua failed)
Mar 26 18:34:46 | sdj: prio = const (setting: emergency fallback - alua failed)
Mar 26 18:34:46 | sdk: prio = const (setting: emergency fallback - alua failed)
Mar 26 18:34:46 | sdl: prio = const (setting: emergency fallback - alua failed)
36a35324100e5x5d408d0526600000001 dm-1 HUAWEI,XSG1
size=10G features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=enabled
   |- 0:0:4:1 sdi 8:128 active ready running
   |- 0:0:5:1 sdj 8:144 active ready running
   |- 1:0:4:1 sdk 8:160 active ready running
   `- 1:0:5:1 sdl 8:176 active ready running

     No nice, mainly for people without knowledge of mpt internals.

3.- The LUN is blacklisted by Fedora and derivatives(RHEL,CentOS,Oracle,...)
     And the installation program is unable to see it, this involves manual intervention.
     See page 76 of the OceanStor RHEL Guide.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

