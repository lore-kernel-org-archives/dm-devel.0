Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8837CC77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685487812;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hdpvNDhzK3Qe5E1dnSOsKcBjts1mhhzDA3Kg0bcKa70=;
	b=I3CakHyYP0Aa1hFbp9u+VIxTxcLhIa7bWRhX4R9N+v7mEWlH0TK1YcZVIfsMsRBArNm6NX
	hKqE7J9w4Spd4w9UsyksyUxx3Xl6uQmHzmgvWsD4h1YeTt49pP338PiFswQVkt56bVtFxG
	5raTRSNklmKGAuP5pgV+MR2E27VfeVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-TVn_Ey6tNgiiH3dqSvv-WA-1; Tue, 30 May 2023 19:03:28 -0400
X-MC-Unique: TVn_Ey6tNgiiH3dqSvv-WA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9A5D185A78E;
	Tue, 30 May 2023 23:03:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30DD4202696C;
	Tue, 30 May 2023 23:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F9A219465B3;
	Tue, 30 May 2023 23:03:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1813A19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 23:03:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EAB4940CF8F7; Tue, 30 May 2023 23:03:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E32DA40CF8F6
 for <dm-devel@redhat.com>; Tue, 30 May 2023 23:03:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1B08185A793
 for <dm-devel@redhat.com>; Tue, 30 May 2023 23:03:22 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-lwxuZ3-EN-6wKpYLgkIx7w-1; Tue, 30 May 2023 19:03:21 -0400
X-MC-Unique: lwxuZ3-EN-6wKpYLgkIx7w-1
Received: by mail-qk1-f198.google.com with SMTP id
 af79cd13be357-75b1c0a6b2fso356815585a.0
 for <dm-devel@redhat.com>; Tue, 30 May 2023 16:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685487801; x=1688079801;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=pKs4wbQndTavzhsczBJzKi8qv7Q4nRnq+Yk6Q+JcObA=;
 b=P9dS0j8dLrfcbDliYNSFTk15Z4mYvgm3xfB8ojpsJ2qtzNqPAPWOevUFx+cu7p8wZC
 z4hwU+l4NvxXzNZCb38YzHrW6TI9CEAkcYHK2VCMDJ8HV+VcvO5N3toUArxTqXiK3TUw
 0PBkzMr5rB7DDpLgcfRbe01orG6FbPJo/VXzDuya4rzA7Dm86/tf7WVWai1CK8LQj4+1
 eJfaT8nVwJ+WEUwG7QTpLREF3i70jOacXXUBV9g5WHqi1KeWQAW3GbniX3RF7sPz78If
 eU8+Bd/8w0P54nKCteK01590HAulLUJWiT6Oi5OiNQHDmRctMkZ57F52I3bCXzq/Jzoi
 EioA==
X-Gm-Message-State: AC+VfDwxg4ewwS0UBR3zN1engzFAW2Wi5pwr7PAh0JCYd89iIjV3A8Fa
 8hC0FhtIntEOFPwRH1d5DRFzYFkyx0+ODrm3GMo+cozuBde/VF5eG84KrqHT1OQQiqqPEYnT6Mv
 JUMR61fMV7oQwTvU=
X-Received: by 2002:a05:620a:884:b0:75b:23a1:8e6a with SMTP id
 b4-20020a05620a088400b0075b23a18e6amr3588728qka.59.1685487801131; 
 Tue, 30 May 2023 16:03:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7U7dNXZBhOi8VI9A5TO3l+qcE1AblN+OzvViMpHOENYgH+39jJlsruHW8G0OV5WKI/KyEQvA==
X-Received: by 2002:a05:620a:884:b0:75b:23a1:8e6a with SMTP id
 b4-20020a05620a088400b0075b23a18e6amr3588712qka.59.1685487800847; 
 Tue, 30 May 2023 16:03:20 -0700 (PDT)
Received: from [192.168.1.133] ([209.6.119.155])
 by smtp.gmail.com with ESMTPSA id
 o14-20020a05620a130e00b0075cb085cbc8sm4191403qkj.97.2023.05.30.16.03.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 30 May 2023 16:03:11 -0700 (PDT)
Message-ID: <be55a799-5367-cd05-2b58-c002f9f2935d@redhat.com>
Date: Tue, 30 May 2023 19:03:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Eric Biggers <ebiggers@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523224047.GE888341@google.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20230523224047.GE888341@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/23/23 18:40, Eric Biggers wrote:
> On Tue, May 23, 2023 at 05:45:00PM -0400, J. corwin Coburn wrote:
>> The dm-vdo target provides inline deduplication, compression, zero-block
>> elimination, and thin provisioning. A dm-vdo target can be backed by up to
>> 256TB of storage, and can present a logical size of up to 4PB. This target
>> was originally developed at Permabit Technology Corp. starting in 2009. It
>> was first released in 2013 and has been used in production environments
>> ever since. It was made open-source in 2017 after Permabit was acquired by
>> Red Hat.
> 
> As with any kernel patchset, please mention the git commit that it applies to.
> This can be done using the --base option to 'git format-patch'.

This will be in the next version of the patch set.

> - Eric
> 
> _______________________________________________
> vdo-devel mailing list
> vdo-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/vdo-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

