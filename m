Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE6CC636D3
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675792255;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LlscqQV1yszeu7sZXxnvx0HR4gaFIaulze24IpCGN+s=;
	b=ZeHIzkXNCbXjhtSULuGu+IPph1mDFHgZ7BlHT18g2iyUzSnx+qzP6sBDP0WKmo22mPCoGf
	uZa6MPlNm/fTpf3axdFcInwlkxbyOVu9CfHfauknmOQkmmbrM/k9RG7GMJIGY1lCp6PnmD
	FEC/U6rHi5bwWgv5yeYs+fA8c4OCKLM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-blWeGiU7MFuw3M28F51nsQ-1; Tue, 07 Feb 2023 12:50:53 -0500
X-MC-Unique: blWeGiU7MFuw3M28F51nsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2457882824;
	Tue,  7 Feb 2023 17:50:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5174D2026D3F;
	Tue,  7 Feb 2023 17:50:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CED9194658D;
	Tue,  7 Feb 2023 17:50:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5CC41946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 17:50:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B1AA492C3F; Tue,  7 Feb 2023 17:50:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93642492C3C
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 17:50:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7569C101A5B4
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 17:50:46 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-wMGksnF2OsOf-e9jILd_NQ-1; Tue, 07 Feb 2023 12:50:44 -0500
X-MC-Unique: wMGksnF2OsOf-e9jILd_NQ-1
Received: by mail-ej1-f47.google.com with SMTP id gr7so44643537ejb.5;
 Tue, 07 Feb 2023 09:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=p+caIN1JymgogQtIiQqJeNUwIQlbruEmUvxoX1EvuhA=;
 b=tFysg45z4EgEP7LSeE3lxjm+csGQn3h6M5aswOPyr1V9OKt6vFHfLX0qcwI+qmPSnc
 QpjYLtQVRkSgO1loIW/5NtIekMavF5sxxAujNKFxpzzTusRDAFn31+GRG37/pkWktF9t
 FYbd31UbVtJF1qGj+nUA4aLJ3BiQzlBu1+gzOK2rL8cw7QGe/HUbG+P51TtUbNXszCbz
 /oI0OkekPyZ+1r5wlD3kA4/CmE6iN3A47itVH/ftryA/ogHMtWlzrMfDJbqmlUAolE39
 P7UZqRwpiA+hSLEC6syPvNsJj0k1ps+kukejN3EWbIcA1EcEWfZi9xT6sr4+428VHZg2
 sZQQ==
X-Gm-Message-State: AO0yUKWaFcFhFpyyjGRTqAur04uxxWcOjCHOvs+roOZ3u1kwJJAan6Q2
 99oq8xa+JsYl6IKUxSM+k+M=
X-Google-Smtp-Source: AK7set8iZkI0y/zHlc4U92+BgNzHp/Fpl19Hv1jtQb79wJPALBEHTT4TIV+fKzGHr2z4lD+8sgd6Uw==
X-Received: by 2002:a17:907:98b7:b0:881:44e3:baae with SMTP id
 ju23-20020a17090798b700b0088144e3baaemr4000996ejc.54.1675792243009; 
 Tue, 07 Feb 2023 09:50:43 -0800 (PST)
Received: from [192.168.0.177] ([83.148.32.207])
 by smtp.gmail.com with ESMTPSA id
 s15-20020a170906a18f00b0089d5aaf85besm3781083ejy.219.2023.02.07.09.50.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Feb 2023 09:50:42 -0800 (PST)
Message-ID: <6a8e356c-cdb8-c535-b91f-4f5e2c793666@gmail.com>
Date: Tue, 7 Feb 2023 18:50:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Joe Thornber <thornber@redhat.com>
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
 <CAJ0trDZsTcD43s3GQ7aKR_3eABWv0rREMrajw8xBQiu96X+B8w@mail.gmail.com>
 <Y+J6CgDVnBlW3pO+@itl-email>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <Y+J6CgDVnBlW3pO+@itl-email>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/2] Fail I/O to thin pool devices
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dne 07. 02. 23 v 17:19 Demi Marie Obenour napsal(a):
> On Tue, Feb 07, 2023 at 03:02:51PM +0000, Joe Thornber wrote:
>> Nack.
>>
>> I don't see the security issue; how is this any different from running the
>> thin tools on any incorrect device?  Or even the data device that the pool
>> is mirroring.
> 
> I special-cased the pool device for two reasons:
> 
> 1. I have run the thin tools on the pool device myself before realising
>     that they needed to be run on the metadata device.  It took me a
>     while to realize that I was using the wrong device.  I have not made
>     that mistake with other devices, which is why I special-cased the
>     pool device in this patch.
> 
> 2. Doing I/O to the pool device is pointless.  The pool device is
>     strictly slower than the data device and exposes the exact same
>     contents, so accessing the pool device directly is never what one
>     wants.
> 
> If there are backwards compatibility concerns, I could make this be
> controlled by a Kconfig option, module parameter, or both.
> 
>> In general the thin tools don't modify the metadata they're
>> running on.  If you know of a security issue with the thin tools please let
>> me know.
> 
> I am not aware of a concrete security problem, but in general I prefer
> not to expose unnecessary attack surface.

lvm2 introduced 'protection' layer device - which keeps   -tpool opened and 
thus avoid possibility to use  i.e.  mkfs on thin-pool itself (as it requires 
exclusive open)

Zdenek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

