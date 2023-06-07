Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B16C77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686118496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ABBEFcX5F4pBihFDMdSqFoWR353YUoIclmR86SDk1Ws=;
	b=a7GIatvjcE4u1CtnuqAeG450v4IJROD12jxxsw2WBQJtBeDrBaSNf0IlEO703uEfgt7b3Q
	hbkSJxjtHlccyRh2sVXw9g2ztFFvvBXlwTdPRiOcQLWkzuSxP+rB+PkigYP6Bi+hCjamg8
	Nx+b0BeCCGKkyp6hcIuGraJK9y60YaA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-0JOiL8d2PVCn2SuC5uUaZA-1; Wed, 07 Jun 2023 02:14:55 -0400
X-MC-Unique: 0JOiL8d2PVCn2SuC5uUaZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F6D3802AE3;
	Wed,  7 Jun 2023 06:14:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97A3C9E93;
	Wed,  7 Jun 2023 06:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 413F419459F1;
	Wed,  7 Jun 2023 06:14:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88E7D19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 06:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 62C432026D6A; Wed,  7 Jun 2023 06:14:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A9CF2026D49
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 06:14:52 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B6B9101A52C
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 06:14:52 +0000 (UTC)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com
 [209.85.218.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-zur9rsNUNrC3Kg8UINsQhA-1; Wed, 07 Jun 2023 02:14:48 -0400
X-MC-Unique: zur9rsNUNrC3Kg8UINsQhA-1
Received: by mail-ej1-f44.google.com with SMTP id
 a640c23a62f3a-974f4897d87so811110266b.0; 
 Tue, 06 Jun 2023 23:14:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686118486; x=1688710486;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qLbVbVUg9j5I15+llYMFFF7NMo/S4z5Ys0RB/9uQl58=;
 b=a0LAm3SK31o0tlJ6OyWa9GSRpBqOjeu44LZJtZJD8FOuzsE9FI++X1ZuqWCr/I7y4o
 F4piguCoJL+gicixvcoaUiYlpY1hbJJeRAbJ4gAUttXhUve57vqvBaNwmqFGKYh3qcpP
 WZ1u8ehMD94E23GywIuFCYAfPrcCDZkA8tu0Ggy4lCXuqMiVqJu3vLZrMJpVYBuEGwqo
 gO+POcLsgev6RhNijG98SGeEaxRxDDfnwbMPsgusBBY4I1nIM36Yl7jNMzqxflYMolk9
 JFWYCFHOA6ELBn3ctbfv+/SYkgDQ9l6VdIvxiVxylr6HoYwJvTJ+yix0Bc/hwkhO+MC7
 Bmaw==
X-Gm-Message-State: AC+VfDztjI1RDxlVTPlf51ofatm7VUFBhBp/LM7w/Tp/qCzNUWz9d5bw
 34VGy26gu0I2rB04gc/KCg/cdfDOF5Ay6w==
X-Google-Smtp-Source: ACHHUZ51uxuxW9U9f1VRvp0RizzYWoG0e9p/q7tzibsqn8ln24i89Nm+W/E8vW4DMNN/8/X4G/ILVA==
X-Received: by 2002:a17:906:6a15:b0:974:b15:fcda with SMTP id
 qw21-20020a1709066a1500b009740b15fcdamr4759049ejc.54.1686118486290; 
 Tue, 06 Jun 2023 23:14:46 -0700 (PDT)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 cd13-20020a170906b34d00b0096b15e4ffcesm6412886ejb.85.2023.06.06.23.14.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 06 Jun 2023 23:14:45 -0700 (PDT)
Message-ID: <88581a3c-8bd3-f7b2-064c-c809a2152ed3@gmail.com>
Date: Wed, 7 Jun 2023 08:14:44 +0200
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
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <oosx274kf6kzasncdfdg5a53ut6wey3nlnbho5x3rql2df3zep@c6r6m4whphvh>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/6/23 13:02, Coiby Xu wrote:
> On Mon, Jun 05, 2023 at 09:09:49AM +0200, Milan Broz wrote:
>> On 6/5/23 04:31, Coiby Xu wrote:
>>> Hi Eric and Milan,
>>>
>>> On Sat, Jun 03, 2023 at 11:22:52AM +0200, Milan Broz wrote:
>>>> On 6/2/23 23:34, Eric Biggers wrote:
>>>>> On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>>>>>> [PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
>>>>>
>>>>> The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
>>>>> happens to use.  But LUKS is a userspace concept.
>>>>>
>>>>> This is a kernel patchset, so why does it make sense for it to be talking about
>>>>> LUKS at all?  Perhaps you mean dm-crypt?
>>>>
>>>> Exactly.
>>>
>>> Thanks for raising the above concern! The use cases like CoreOS and
>>> Confidential VMs explicitly want kdump to work for LUKS. And correct me
>>> if I'm wrong, I think the two problems addressed by this patch set only
>>> apply to LUKS so the kdump part of the kernel only cares about the LUKS
>>> case. If there are use cases where similar approach is needed, I'll be
>>> happy to make the solution more generic.
>>>
>>>>
>>>> I had the same comment almost a year ago... and it still applies:
>>>> https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
>>>>
>>>> Anyway, please fix the naming before this patchset can be read or reviewed!
>>>>
>>>> LUKS is user-space key management only (on-disk metadata); the kernel has
>>>> no idea how the key is derived or what LUKS is - dm-crypt only knows the key
>>>> (either through keyring or directly in the mapping table).
>>>>
>>>> Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
>>>> is used in many other mappings (plain, bitlocker, veracrypt, ...)
>>>> Just use the dm-crypt key, do not reference LUKS at all.
>>>
>>> Thanks for the reminding! That comment was on the first RFC version. But
>>> starting with "RFC v2", there is no longer any interaction with dm-crypt
>>> (to save a copy of the LUKS volume key for the kdump kernel) and now I
>>> make cryptsetup talks to the kdump part of the kernel via the sysfs to
>>> reuse the volume key. So only the kdump part of the kernel needs to know
>>> LUKS which is what it cares. Thus I don't think there is any kernel
>>> namespace pollution now.
>>
>> Hi,
>>
>> I am sorry if I did understand correctly, but I thought that kdump is part
>> of the kernel.
> 
> Yes, there is the kernel part of the kdump although there is also the
> userspace part to make the feature complete:)
> 
>>
>> I am trying to say that kernel generally has no concept of LUKS;
>> this is a userspace abstraction for key management.
>>
>> Even the cryptsetup dm-crypt configuration mapping table generated from LUKS
>> has nothing LUKS special in it (only in DM-UUID as a name prefix).
>>
>> So I do not understand why you need to mention LUKS even in kdump part.
>> Perhaps it is still only a naming problem, nothing more.
>>
>> All you need is to preserve key and configuration parameters (for dm-crypt).
>> If it is set by cryptsetup, dmsetup, or any other way is not important - on this
>> kernel layer, it has nothing to do with LUKS key management metadata.
>>
>> No problem if you support only LUKS in userspace, but really, all this machinery
>> should work for any dm-crypt devices. Perhaps your patch even works for it already.
> 
> Thanks for the explanation! After reflecting on your words for some
> time, I realize I had an implicit assumption. I assumed is if I use a
> name like dm_crypt_key instead of luks_volume_key, I need to support all
> mappings like plain, bitlocker, veracrypt as mentioned by you and this
> could mean much more efforts. So I'm not motivated to do that as
> currently users only request kdump to work for LUKS.

Thanks, I think it is perfectly fine to implement just subset here.

> But maybe I can divide the efforts into the kernel part and userspace
> part. For the kernel part, almost no effort is needed since only
> renaming is needed as pointed out by you. For the userpace part, maybe
> it's OK to support preserving key only for LUKS2 in cryptsetup as hinted
> by your last paragraph? Does it look good to you from the viewpoint of
> the maintainer of cryptsetup?

My comment was just about proper naming in kernel, it is of course up to you
what you want to support in userspace (and even in kernel, extensions can
be added later).

Only LUKS2 uses keyring for volume key in dm-crypt as default option anyway.
I do not think you need any cryptsetup patches, all you need is to write
decrypted volume key from LUKS metadata with
   cryptsetup luksDump ---dump-volume-key -volume-key-file <out> <device>
(or any code equivalent with libcryptsetup), am I correct?

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

