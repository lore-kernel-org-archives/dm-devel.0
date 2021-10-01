Return-Path: <SRS0=qylv=OV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AA3C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 10:40:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7979B61361
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 10:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7979B61361
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-sCrLMmTpOP6_6bGCENjCFg-1; Fri, 01 Oct 2021 06:40:50 -0400
X-MC-Unique: sCrLMmTpOP6_6bGCENjCFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84BBD1966320;
	Fri,  1 Oct 2021 10:40:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51524608BA;
	Fri,  1 Oct 2021 10:40:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 187FD4E58F;
	Fri,  1 Oct 2021 10:40:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 191Aed1k029185 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 1 Oct 2021 06:40:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 928E411F4CF; Fri,  1 Oct 2021 10:40:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 809851973B8
	for <dm-devel@redhat.com>; Fri,  1 Oct 2021 10:40:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 824CB8001EA
	for <dm-devel@redhat.com>; Fri,  1 Oct 2021 10:40:30 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-syUkqs_GPVunCLqUQUu0bw-1; Fri, 01 Oct 2021 06:40:29 -0400
X-MC-Unique: syUkqs_GPVunCLqUQUu0bw-1
Received: by mail-wm1-f41.google.com with SMTP id
	b192-20020a1c1bc9000000b0030cfaf18864so6407237wmb.4; 
	Fri, 01 Oct 2021 03:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=hddOjHZpiLEi0GcWaCBVU5t+NqqX4A1dTkOJryVoDWs=;
	b=KFh7Qnx0CUi1PoO92jPkRflW0ibIFZbpdYo1DRxqIENqvysEciouGU6rJUOVYFmbkX
	AwVy8Y3JvPs3vARR/xCL0k7X0Rp9IBCUG7QlZml9dUh0fqJ+6yp7Vnj+0uQzNG9uFT3e
	Xa8x2e0fQVEa4K3IAytkVAD0IpVXqMmQivDlPCj7GKg6wLwyzTKRwpDKKrA+Ig8TrqHG
	LBJNRujF+tgIateRbbM5nSxVKwmFAkHEyNwGPSb+fsBLHkkpNxJB646feA0kt20ScYBQ
	xD+DBV+nyo6vWQ3mH0z1tvrJHyHROyFuzjBo9qboD1MTKSwKV+0MvmsFeSyqS7GTx7Zb
	F9VA==
X-Gm-Message-State: AOAM53146IAEkSHrc6ecCaC1gqHy0PnxzI7aNH0TJXa4mnGSg9nNYmJl
	57pro5TNtbNo9xxVHFRoWw==
X-Google-Smtp-Source: ABdhPJyBnAZOETTWwhANBP6Rn8zyp/ezALOVvcSEusvtXjwUGJhAVitrATWMOzsDD/QzeQfy1VHf/A==
X-Received: by 2002:a1c:751a:: with SMTP id o26mr3845114wmc.94.1633084827666; 
	Fri, 01 Oct 2021 03:40:27 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67])
	by smtp.gmail.com with ESMTPSA id v23sm4940270wmj.4.2021.10.01.03.40.26
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 01 Oct 2021 03:40:26 -0700 (PDT)
Message-ID: <3dcac7f0-7cf2-82e3-3413-e55b651010bf@gmail.com>
Date: Fri, 1 Oct 2021 12:40:25 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20210928203917.25237-1-xose.vazquez@gmail.com>
	<d1e3fd7c448c5ca50b256990fbb4cac2019f1382.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <d1e3fd7c448c5ca50b256990fbb4cac2019f1382.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: remove Compellent maintainer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/29/21 09:43, Martin Wilck wrote:

> On Tue, 2021-09-28 at 22:39 +0200, Xose Vazquez Perez wrote:
>> e-mail was bounced: 550 5.1.1 User Unknown
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> (Do we want to maintain this information in our hwtable in the long
> run?)

Why not? They are just comments.

It's useful to check settings with arrays vendors.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

