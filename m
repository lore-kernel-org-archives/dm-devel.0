Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1203EB64DC
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jun 2023 17:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687713215;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JmqG8f7imzRDcZMjeMoocRlfRKVsLmkEdMWckXDhM2g=;
	b=EZQORECoeSLRHX1bpLu2YoKEFE+8I62ULT0VSTXrkh4hXpQ1eh8gD+bYETAHgcyu2jlfGM
	3H4UcC4N4uwSfFh7gHfYXpsV0Zz2V9Bz9qB10Gc1N3FepF8cTl6P6x7jMof3Liqs85MZmJ
	fOwInkZTJ2pCBsP/ekl4brACc6/T2nE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-3Fa7GHSqOGWqRUmLIKwCFg-1; Sun, 25 Jun 2023 13:13:33 -0400
X-MC-Unique: 3Fa7GHSqOGWqRUmLIKwCFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 263DB8CC208;
	Sun, 25 Jun 2023 17:13:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5CEA2166B25;
	Sun, 25 Jun 2023 17:13:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F29A1946588;
	Sun, 25 Jun 2023 17:13:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E76B1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Jun 2023 17:13:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3A7A0492CA6; Sun, 25 Jun 2023 17:13:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 322C5492B01
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 17:13:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 174958E44E0
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 17:13:21 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-T3iMyREsMKO3-2DUMCd-sA-1; Sun, 25 Jun 2023 13:13:19 -0400
X-MC-Unique: T3iMyREsMKO3-2DUMCd-sA-1
Received: by mail-ed1-f48.google.com with SMTP id
 4fb4d7f45d1cf-51d97ba7c01so468489a12.2; 
 Sun, 25 Jun 2023 10:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687713197; x=1690305197;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=6DtUGF5Qpp5liEBW4Fkja7ol+KO9225qbllTSnW6B/Y=;
 b=kz81RnI+ShrfgeE/R3kQq2kJqYeOrRoo198eUUuur9SyVKEL6fYHCjUQWY0HfMUBIr
 OBln4bCWwIaYnJRB89L/5kNlUtfu6YuU1X/mTyAS1i7iWIE2aEbZcEuJ956CekpRO1um
 3+lqXrIQz515/nvqjDVSIuNSOgeLrAd12yWPLWQsxk5YCiqeahkg2O9mynH2tWNuUYcN
 7v9/2DvlWmYgnWmPmiNp630wizaVz6zhoTAPpuxeLrmjIbWnP88Mwf2SX0du5HL4iNYC
 7r/noIR+h6lQ1hBBIoufKYKVLh1G6wpCrIbHEW1GDP9H7CGGXS5CFmjZ85HjzYxglR2I
 IELQ==
X-Gm-Message-State: AC+VfDzqKRFZKEW5o7ZARY7YUkJc/qhjWmJSQB4jlwtsXNwTt0qu0q1d
 NXk2MxdUZzSOc5HiUBhvp5/+l7HktlI=
X-Google-Smtp-Source: ACHHUZ7MqiTR1ZIv4/lR3yo9zuXR8WjrHRh2UkkFL6VVLnMuyAw2c8g5nFjyq3Ytz8IdrobUnf643w==
X-Received: by 2002:a17:906:fe4e:b0:96f:c46f:d8fe with SMTP id
 wz14-20020a170906fe4e00b0096fc46fd8femr22094622ejb.27.1687713197211; 
 Sun, 25 Jun 2023 10:13:17 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 ci8-20020a170906c34800b009888aa1da11sm2238306ejb.188.2023.06.25.10.13.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 25 Jun 2023 10:13:16 -0700 (PDT)
Message-ID: <364d626b-c3cf-8492-6c85-38417f2432b4@gmail.com>
Date: Sun, 25 Jun 2023 19:13:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
References: <20230624230950.2272-1-demi@invisiblethingslab.com>
 <20230624230950.2272-4-demi@invisiblethingslab.com>
 <0b22e328-40e1-54d7-367c-96059a3fef7c@gmail.com> <ZJhlGCP0gTz7T3gG@itl-email>
 <81c94a1e-b316-c195-402c-01776f3200dc@gmail.com> <ZJhuw3MaFjW5Bocw@itl-email>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <ZJhuw3MaFjW5Bocw@itl-email>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 3/4] dm ioctl: Allow userspace to suppress
 uevent generation
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
Cc: linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/25/23 18:43, Demi Marie Obenour wrote:
> On Sun, Jun 25, 2023 at 06:33:33PM +0200, Milan Broz wrote:

...

>> BTW we use exactly this scenario in cryptsetup for years with existing flags
>> (DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG | DM_UDEV_DISABLE_DISK_RULES_FLAG
>> DM_UDEV_DISABLE_OTHER_RULES_FLAG) - just rules are ignored while uevent is still
>> sent.
>> Anyway, not sure we need another way to disable it; I just asked do you need it.
> 
> How can one set these flags using the raw kernel ioctls?  The code I am
> working on does not use libdevmapper at all and just uses the kernel API
> directly.

IIRC you need to set cookie (kernel DM_COOKIE env), then default udev dm.rules decode
the flags from it.

(It is libdevmapper internal magic for me, the design is kind of complicated, but works.)

Better ask on LVM list (but the udev DM rules are pretty well inline documented).

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

