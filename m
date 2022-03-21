Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24543C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lv6FrjqjvWuHOD+AQ0HcpWAtalRpV/uE+zzgjzZQlYo=;
	b=WyxKP19dCQOVTGkDwMvm7qmvks5BPf6jZQyRdmfYw5KJfw2zwzK+RllMt6xEEIOG14wkmw
	X2oGF5gEAXA2D05W8a//CK+sYr7voMlP3lvcEIolU3v29CUnJyc1u1Bm0Zis2yw+yryzK/
	B1LgWCjevhIJW9VO7F1ochIQmd9cuso=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-Z-EWyXyVOTCujsMlR0x1Tg-1; Mon, 21 Mar 2022 02:54:57 -0400
X-MC-Unique: Z-EWyXyVOTCujsMlR0x1Tg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 949731C05AFD;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 836FA400F725;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E9B019451EF;
	Mon, 21 Mar 2022 06:54:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7935F19451EF
 for <dm-devel@listman.corp.redhat.com>; Mon, 21 Mar 2022 01:45:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 539D642633A; Mon, 21 Mar 2022 01:45:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B6EC426331
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 01:45:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 021882A59549
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 01:45:20 +0000 (UTC)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-Zj1RzYO2PK2NWQJd2qDX0w-1; Sun, 20 Mar 2022 21:45:18 -0400
X-MC-Unique: Zj1RzYO2PK2NWQJd2qDX0w-1
Received: by mail-pl1-f198.google.com with SMTP id
 w24-20020a170902a71800b001538d7b076dso4959284plq.16
 for <dm-devel@redhat.com>; Sun, 20 Mar 2022 18:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mrGOJLeYO4kxv1PcAb4WwM1yZJ2NAcruFxRY/Piqipk=;
 b=S54x7wyguUhlnkN6t6uW7eu6TglVGKbc/MKiHg/YdFkWc4BNKgjJKmAtz9mgaw5ai3
 Dr005Fglgawk9LH9r1Wmnj2Nyn8W7qLBySPm0G1+xGXQElWz7EKCgrrBPHhXRQIZ67QF
 fn9lGWtYcC0Zvfx7vpPzef3kz5evehqmVg0mMrSaHMmCYckhItYL+xVSDrl+9R3RUC+p
 WWiUKAdqTRiVwxx/OZxRLUkxvIbsOkkebqmVoQgq5CVEuogw2ZdK1CR/yvBaN97FGjf/
 tbGcoBrdyC37qCfoeQJahxeh1nJ7r9tyUaSKpRubbCqHJTB5jdm/qkwG3b2gNQDbIP4R
 mO+g==
X-Gm-Message-State: AOAM531rnPpYaTxCcNotJPA0BrAmAoGPwalM0rtS8101JNvaQ0awxBFY
 wanWus17VIE53S8Ohq8yQJRzRy7VkFokqVcGn5fOR3HBzbMTF6Se9XlDW7lsUllPPuZXhWzxNnC
 qbPwpk5D2KjogedU=
X-Received: by 2002:a17:903:404b:b0:154:297b:7125 with SMTP id
 n11-20020a170903404b00b00154297b7125mr9676485pla.11.1647827117635; 
 Sun, 20 Mar 2022 18:45:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysQCPDHeU47c8jpQLkfUpZf+9xpLC0+nNHh3e0J3hAwhF8jvdr0t58bH/P0+tdQeNlmTwPDw==
X-Received: by 2002:a17:903:404b:b0:154:297b:7125 with SMTP id
 n11-20020a170903404b00b00154297b7125mr9676460pla.11.1647827117312; 
 Sun, 20 Mar 2022 18:45:17 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 o65-20020a17090a0a4700b001bef5cffea7sm18971387pjo.0.2022.03.20.18.45.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 20 Mar 2022 18:45:16 -0700 (PDT)
Date: Mon, 21 Mar 2022 09:41:50 +0800
From: Coiby Xu <coxu@redhat.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Message-ID: <20220321014150.w6wux5azabweu7dr@Rk>
References: <20220318103423.286410-1-coxu@redhat.com>
 <c06a21cc-e1c1-e627-f908-ebc2a041e29a@igalia.com>
MIME-Version: 1.0
In-Reply-To: <c06a21cc-e1c1-e627-f908-ebc2a041e29a@igalia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:50 +0000
Subject: Re: [dm-devel] [RFC 0/4] Support kdump with LUKS encryption by
 reusing LUKS master key
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
Cc: Baoquan He <bhe@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 kexec@lists.infradead.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Sat, Mar 19, 2022 at 05:13:21PM -0300, Guilherme G. Piccoli wrote:
>On 18/03/2022 07:34, Coiby Xu wrote:
>> [...]
>> Based on Milan's feedback [1] on Kairui's ideas to support kdump with
>> LUKS encryption, this patch set addresses the above issues by
>>  1) first saving the LUKS master key to kexec when opening the encrypted
>>     device
>>  2) then saving the master key to the reserved memory for kdump when
>>     loading kdump kernel image.
>>
>> So the LUKS master key never leaves the kernel space and once the key has
>> been saved to the reserved memory for kdump, it would be wiped
>> immediately. If there is no security concern with this approach or any
>> other concern, I will drop the following assumptions made for this RFC
>> version in v1,
>>  - only x86 is supported
>>  - there is only one LUKS device for the system
>>
>> to extend the support to other architectures including POWER, ARM and
>> s390x and address the case of multiple LUKS devices. Any feedback will be
>> appreciated, thanks!
>>
>
>Hi Coiby, thanks for the very interesting work!

Hi Guilherme,

I'm glad this work interests you and thanks for sharing your thoughts!

>I confess I didn't review the code as I have not much experience in
>dm-crypt/key management, but I have a generic question related with the
>motivation of the patch set.
>
>My understanding is that one (the main?) motivation of this series would
>be to protect the saved memory (vmcore) from being read by some
>"unauthorized" entity - in order to achieve this goal, it is hereby
>proposed to allow kdump kernel to access a memory-saved key and with
>that, mount an encrypted volume, saving the vmcore over there correct?

>
>So, what if instead of playing with the volume key, users with this
>concern address that by reserving some *unencrypted partition* for
>saving the vmcore, but then *encrypt the vmcore* itself! So, instead of
>requiring saving a full-volume key, mount everything, risk data
>corruption if something goes bad...we just have makedumpfile encrypting
>the vmcore with some preloaded key (which might be saved inside the
>kdump minimal intird, for example), and saving the encrypted file into a
>clear/unencrypted volume? This way we also prevent excessive memory
>consumption during kdump due to the lvm/dm-userspace paraphernalia usage.

I believe some users have security concern for where to save vmcore.
This use case exactly fits your description and your proposed solution
shall be good for this type of users. But I think many more users may
just choose to encrypt the hard drive when installing the system and
they would naturally expect kdump to work for the case of full disk
encryption. So your proposed solution may not address the latter case 
where there is a much large user base.

>
>Does it make sense or am I being silly or missing something?
>Cheers,
>
>
>Guilherme
>
>_______________________________________________
>kexec mailing list
>kexec@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/kexec
>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

