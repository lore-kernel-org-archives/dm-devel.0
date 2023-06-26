Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57A1EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687791103;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6wWsWky0NCzmZFFjhMazYTigWSmVOF+/pHe4gw6HujI=;
	b=b7asxqyeKlINZcELDTE+MgzU0uBBGXnF7xom1d5dQrq7DEPiE9F+LlAieSFfaE7jxY1sXH
	kW5OuezA4kGOtYG3I3draW0OL4gAZDAxltTBcdx6QABKjwopvyjJT6B2rkvZiFMOY50UEB
	1fz78Kh8A/794WhOIolDu6zFopFOiLc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-eAW1wgevNimert-IKSls6g-1; Mon, 26 Jun 2023 10:51:39 -0400
X-MC-Unique: eAW1wgevNimert-IKSls6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2FAC90ED2E;
	Mon, 26 Jun 2023 14:51:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 53BAA14682F9;
	Mon, 26 Jun 2023 14:51:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36D1D1946588;
	Mon, 26 Jun 2023 14:51:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 89C571946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 14:51:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7995F2166B26; Mon, 26 Jun 2023 14:51:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 713FD2166B25
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 14:51:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51B5E28040C2
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 14:51:07 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-LgEEBOWGPc6MChbZpAmPHQ-1; Mon, 26 Jun 2023 10:50:59 -0400
X-MC-Unique: LgEEBOWGPc6MChbZpAmPHQ-1
Received: by mail-pf1-f181.google.com with SMTP id
 d2e1a72fcca58-666683eb028so1479449b3a.0
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 07:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687791057; x=1690383057;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :sender:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3/i5nGpo6bAYzHRYmjepgeMVK+fjAMmYYEQI4A8dzWk=;
 b=KambB0IsQIqmOBhuRnmJSrmRiSsRHi3t2Ew4o1c1NZYqk0mjjrwBufx03aM7S6ra01
 DzxV9GJaCsn9Ny4jIheYKrcMleQTCSxDMDjULmSf15jQAz7jQq8Fvt4H860xm6Uq9jsz
 VLT93nwm/V/hqZe9onnzCXTrpXArhDviUNViEdCjx33LO1ZilMdjbN4bHdvvih7R21SW
 q4SQ/99SkfZXO6ogBQ9Zcp1dq73Wlm5nAcGC+n5P7e0DcuchSIi71syPJTF3gyvc/Kf7
 6XBUJD3ceMXk5EK4ulfVoJaxqZi10XuBUNLqVIFY6zdqODXuNM4biNRUZr16WmT4kiPU
 M68Q==
X-Gm-Message-State: AC+VfDxnMWOowIra7bJOZkjCQlOLFTifylYtDear+TfUNPLdNV0KUld2
 OYbEduNzDzC+OMFXFIw7hole0ACri80=
X-Google-Smtp-Source: ACHHUZ7gyf8JRcVX0msxlw87KM1NXLxkxhxSkyxpkjUkB5RP08dHtYuS1O5W3TiyOlTbkG5rO5m/Jw==
X-Received: by 2002:a05:6a00:244f:b0:63b:5c82:e209 with SMTP id
 d15-20020a056a00244f00b0063b5c82e209mr18091552pfj.10.1687791057379; 
 Mon, 26 Jun 2023 07:50:57 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c?
 ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 u15-20020aa7838f000000b0066a6059d399sm3889133pfm.116.2023.06.26.07.50.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 26 Jun 2023 07:50:56 -0700 (PDT)
Message-ID: <7e708dfa-4019-fe28-afbd-91ad847fada0@roeck-us.net>
Date: Mon, 26 Jun 2023 07:50:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-9-hch@lst.de>
 <c1391658-d785-4b2f-ba7e-01e4668685d7@roeck-us.net>
 <20230626075325.GA26851@lst.de>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230626075325.GA26851@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 08/24] init: pass root_device_name explicitly
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
Cc: Jens Axboe <axboe@kernel.dk>, Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/26/23 00:53, Christoph Hellwig wrote:
> On Fri, Jun 23, 2023 at 05:08:59PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On Wed, May 31, 2023 at 02:55:19PM +0200, Christoph Hellwig wrote:
>>> Instead of declaring root_device_name as a global variable pass it as an
>>> argument to the functions using it.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> This patch results in the following build error when trying to build
>> xtensa:tinyconfig.
>>
>> WARNING: modpost: vmlinux: section mismatch in reference: strcpy.isra.0+0x14 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
>> ERROR: modpost: Section mismatches detected.
> 
> I can reproduce these with gcc 13.1 on xtensa, but the report makes
> no sense to me.  If I disable CONFIG_CC_OPTIMIZE_FOR_SIZE it now reports
> a similar warning for put_page intead of strcpy which seems just as
> arcance.
> 

I don't see that (I tried 11.3, 11.4, 12.3, and 13.1), but then I am not sure
if this is worth tracking down. I just force CONFIG_SECTION_MISMATCH_WARN_ONLY=y
for xtensa builds instead.

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

