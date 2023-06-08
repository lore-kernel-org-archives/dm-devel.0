Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A95C7EE29
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686220788;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5awsvnczSNuIZ2AH9gYUrO1EOyob7m+5cNgduODhBjU=;
	b=SbGg6ViTvDiiUAQJ5Fi219GIWSzC4cRnwNzDdlCZhe3v0O6L7ImQQWh1op0XP2lq+hekb/
	pjEBpYvIOUqOmsk+y7M/twsb/EWadpIakQaX4p4RSFSCpcQiJX4N/EtcshfX0gesEB5gxR
	spMN2PTwfzcgW0JCklKy5neS0MyRsFE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-43_CdvR4Ov6VSiNqj-Ghqw-1; Thu, 08 Jun 2023 06:39:45 -0400
X-MC-Unique: 43_CdvR4Ov6VSiNqj-Ghqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F07CA3C0BE41;
	Thu,  8 Jun 2023 10:39:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B05C407E440;
	Thu,  8 Jun 2023 10:39:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB51819452CC;
	Thu,  8 Jun 2023 10:39:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ECFE194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 10:39:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 505C69E94; Thu,  8 Jun 2023 10:39:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 47EE39E8B
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 10:39:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BE24811E7C
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 10:39:35 +0000 (UTC)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-_ltwhb1WMBW94VKyPP2Yvg-1; Thu, 08 Jun 2023 06:39:31 -0400
X-MC-Unique: _ltwhb1WMBW94VKyPP2Yvg-1
Received: by mail-ed1-f43.google.com with SMTP id
 4fb4d7f45d1cf-5147dce372eso661786a12.0; 
 Thu, 08 Jun 2023 03:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686220769; x=1688812769;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=8wgec4tfIWdnEhpMr6ykg9xNvcCtcxWUQ6Om3tn4cEU=;
 b=Y8C/NaaPLPg+sqv677aCjFiI22h11LwU8YJcvJDzDGTfnloVXYvPwM5LWiXfO0rjUQ
 kPecl4TgjNrSUyFM5g6F/uYh+gFIM7R+Ii0GomroDDW1TwdJ1MJWqaJ49VcAWVxLoRap
 vSidINJ8dVhqNC8TzbUHMy13+9vcpFdt7HWZ31XYtsPAKUHRf1ZCQix1hgkx4R0ezJIy
 a3TPPz5sVyOSKU3dBmLXle+1FHbWox2Fr4DNPkywM6dIgato8kYcPmIUP0sk+wvbWKGm
 xm9fwHVzRIQyLRY/fQRnZf2uqrlWqlY2FRAhpJrvIsZEbpdmL4ZE+dd06QCSbYuRrYOI
 gaNg==
X-Gm-Message-State: AC+VfDx4+B+DaMC0vfG0+8Q8dytCQ6Zj0ila+5Cuv6DEhoZ6z7VIMAjm
 0rfORWYRl3Cvipy8PNjsT+EyDUqHJfkfrA==
X-Google-Smtp-Source: ACHHUZ4ytm/M/a+Iwv6nZciUDlVTlAht7v/lQ5uBsyjdfFH4TWUuLUvl3T6ueNXwjFKIgWOf3yY0ng==
X-Received: by 2002:a05:6402:31ef:b0:514:8e14:7f1b with SMTP id
 dy15-20020a05640231ef00b005148e147f1bmr6910012edb.12.1686220768883; 
 Thu, 08 Jun 2023 03:39:28 -0700 (PDT)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 o11-20020aa7c50b000000b00516a1fa0e60sm384205edq.89.2023.06.08.03.39.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 08 Jun 2023 03:39:28 -0700 (PDT)
Message-ID: <f7a1a20c-bee8-c7a4-4c49-b66415f556f9@gmail.com>
Date: Thu, 8 Jun 2023 12:39:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
To: Coiby Xu <coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
 <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
 <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
 <oosx274kf6kzasncdfdg5a53ut6wey3nlnbho5x3rql2df3zep@c6r6m4whphvh>
 <88581a3c-8bd3-f7b2-064c-c809a2152ed3@gmail.com>
 <maamg4udo7visvgzp4m4qkfcds6djyiga236lb2mwtjasi6pvj@zmqzb2lijegj>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <maamg4udo7visvgzp4m4qkfcds6djyiga236lb2mwtjasi6pvj@zmqzb2lijegj>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/5] Support kdump with LUKS encryption by
 reusing LUKS volume key
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
Cc: Baoquan He <bhe@redhat.com>, Kairui Song <ryncsn@gmail.com>, x86@kernel.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Pingfan Liu <kernelfans@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>, dm-devel@redhat.com,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Ondrej Kozina <okozina@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/7/23 14:39, Coiby Xu wrote:
...
>> I do not think you need any cryptsetup patches, all you need is to write
>> decrypted volume key from LUKS metadata with
>>   cryptsetup luksDump ---dump-volume-key -volume-key-file <out> <device>
>> (or any code equivalent with libcryptsetup), am I correct?
> 
> Correct me if I'm wrong, but I don't think there will be a safer way to
> preserve key without patching cryptsetup. Actually the --dump-volume-key
> approach has been proposed before and I agree with your conclusion [1]
> on that approach i.e. "passing volume key this way is quite insecure".
> Without patching cryptsetup, even if I save the volume key in the memory
> reserved for the kdump kernel, I need to retrieve this key in the
> userspace to unlock the LUKS device which may lead to quite a security
> vulnerability.

Hm, where are the patches for cryptsetup, then? I am afraid we do not want
to add such specific things there.

But we are just going to merge a patchset that changes how we use keyring
where you can tell cryptsetup to store/link key under some specific name
and to specific keyring
(see https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/492)
(Please talk to Red Hat cryptsetup maintainers for more info,
I just mentioned this mail to them today.)

> I respect the efforts from you and the cryptsetup community to make LUKS
> as secure as possible. And kdump is used in product environment. Kdump
> is to a server as a black box is to an aircraft. So by no means I want
> to reverse the used security measures and patching cryptsetup can allow
> to keep the security measures. One concern raised by you against "FRC
> v1" was a copy of the LUKS volume key for the kdump kernel creates an
> attack vector. I took this feedback seriously and have sought advice
> from my colleagues to implement the countermeasures ([PATCH 1/5] and
> [Patch 4/5]).
> 
> [1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/

Yes, I appreciate that. And it is perfectly ok if your customers accept
the trade-off and security risk of handling the key this way.

Anyway, I feel we are going in circles here, and as it seems to be my fault,
I do not want to sound grumpy as I am perhaps missing some context.

Could you please talk to internal RH cryptsetup maintainers first and discuss
your solution? They know what we can do here can help to find an acceptable
solution. (I added cc to Ondra.)

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

