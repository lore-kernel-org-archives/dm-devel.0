Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6E4C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jun 2023 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686552352;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LfPRrINlzbr15zwP1ioMNQh2VHVnQ82gA4GaETQFj4I=;
	b=cGWSr2ikXGVEuuC+hUi9KqqrMBSxOz5eM4NVp+gt0r3A+QMaLv+MOolzRONzpLrW/pILGc
	VWMnaa5GGbR+Ows0wIoC2c60Di03rDSQnY+S/kHmEnD4WJ6HB6TCa6pnhPa3veJuyu7TMu
	YZ2lHTOV+Vhvz0vA+PFBk/6G9CaPwGo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-4uj-tloiOyGdAsvkaafbgg-1; Mon, 12 Jun 2023 02:45:49 -0400
X-MC-Unique: 4uj-tloiOyGdAsvkaafbgg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6206A801182;
	Mon, 12 Jun 2023 06:45:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF305492B17;
	Mon, 12 Jun 2023 06:45:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E92A519465B9;
	Mon, 12 Jun 2023 06:45:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 594E5194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 10:01:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 356C7145B966; Fri,  9 Jun 2023 10:01:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D2C5145B965
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 10:01:01 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8A54811E8D
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 10:01:00 +0000 (UTC)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-1X5fZw-MPUOmv-UfdZ13ZQ-1; Fri, 09 Jun 2023 06:00:52 -0400
X-MC-Unique: 1X5fZw-MPUOmv-UfdZ13ZQ-1
Received: by mail-pl1-f197.google.com with SMTP id
 d9443c01a7336-1b046bc0a83so3990405ad.2
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 03:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686304852; x=1688896852;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=M0n8/D5gSrVbcAskz0QgbStZ+qE9a1Ww6ORHIZhs/gc=;
 b=lagxkyvgCI6w4O3VwXs3N9c2MutkRHBDeBDSAXWw2Dn8ZUy9iEzNCuMwxBHoyAA7Fd
 y0mo0EHxWRR6OnYYpUauxQtiiy12KS/0lSTtrq5LkHwAQBP75zG2D/195V5OIJXPoA+I
 yidWNWoqH9o0uriw7JWYVSxvCp8DAQoH24TqdxEa3V2BTKz7PF17JOFeI2rDZcfGgPDA
 vt4a1td5QRVvDYVI+kXeKYEXR/VmrIAmN3F9r5RnDlLnBTEhOxuF1ZCEL082aqSSWXWY
 8JkWFXGRjzQWaanMcZLTgK+KoKY6sImrav8AKKyys2utg5tpRXFQebqi2uPd4bf6gskk
 DNNA==
X-Gm-Message-State: AC+VfDyQ7XyeYAWwJqS0DZDBVmgR3KLmaiF6C7JZ7jMTJr0RTbfVgzgV
 R3ALMmRFuY5EnPtxS01em8YNsKTYuB35sLWkLu/KKCsHvL00LCuQGqqJ8kEn1f/M0JJ/aCpRUle
 /rziy8Bkry7egbn8=
X-Received: by 2002:a17:902:b194:b0:1b0:74f5:bf10 with SMTP id
 s20-20020a170902b19400b001b074f5bf10mr468747plr.65.1686304851825; 
 Fri, 09 Jun 2023 03:00:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4D79t5gV/Mp/rSDmH1GlwdJpW+EfHN7X7D7bUurjaZ92cyqHMbXsDdD5+zEeKB48041JGjYg==
X-Received: by 2002:a17:902:b194:b0:1b0:74f5:bf10 with SMTP id
 s20-20020a170902b19400b001b074f5bf10mr468730plr.65.1686304851467; 
 Fri, 09 Jun 2023 03:00:51 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 az5-20020a170902a58500b001b034faf49csm1437300plb.285.2023.06.09.03.00.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jun 2023 03:00:50 -0700 (PDT)
Date: Fri, 9 Jun 2023 17:58:11 +0800
From: Coiby Xu <coxu@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <mmvghlh7pdleopnkwu3mmqlc4etqjs3rmjwfgh2grbys5icehj@2ifbkc2a6ot5>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
 <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
 <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
 <oosx274kf6kzasncdfdg5a53ut6wey3nlnbho5x3rql2df3zep@c6r6m4whphvh>
 <88581a3c-8bd3-f7b2-064c-c809a2152ed3@gmail.com>
 <maamg4udo7visvgzp4m4qkfcds6djyiga236lb2mwtjasi6pvj@zmqzb2lijegj>
 <f7a1a20c-bee8-c7a4-4c49-b66415f556f9@gmail.com>
MIME-Version: 1.0
In-Reply-To: <f7a1a20c-bee8-c7a4-4c49-b66415f556f9@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 12 Jun 2023 06:45:41 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Thu, Jun 08, 2023 at 12:39:26PM +0200, Milan Broz wrote:
>On 6/7/23 14:39, Coiby Xu wrote:
>...
>>>I do not think you need any cryptsetup patches, all you need is to write
>>>decrypted volume key from LUKS metadata with
>>>  cryptsetup luksDump ---dump-volume-key -volume-key-file <out> <device>
>>>(or any code equivalent with libcryptsetup), am I correct?
>>
>>Correct me if I'm wrong, but I don't think there will be a safer way to
>>preserve key without patching cryptsetup. Actually the --dump-volume-key
>>approach has been proposed before and I agree with your conclusion [1]
>>on that approach i.e. "passing volume key this way is quite insecure".
>>Without patching cryptsetup, even if I save the volume key in the memory
>>reserved for the kdump kernel, I need to retrieve this key in the
>>userspace to unlock the LUKS device which may lead to quite a security
>>vulnerability.
>
>Hm, where are the patches for cryptsetup, then? I am afraid we do not want
>to add such specific things there.

Thanks for cleaning up the text to make the discussion easier! Sorry I
only mentioned it [3] in the cover letter and didn't provide one in
previous reply. [3] was done in a quick-and-dirty way (I plan to send a
formal merge request after finishing the kernel part) and there is no need
to read it. Let's me explain what [3] does here instead,
  1) After unlocking the LUKS-encrypted device, if cryptsetup finds
     /sys/kernel/crash_luks_volume_key exists, it will write the key
     description of the volume key to it to notify the kernel to save a copy
     of this logon key linked to its thread keyring for the kdump kernel
  2) After the 1st kernel crashes, if crytpsetup finds it's in the kdump
     kernel, instead of deriving the volume key from a passphrase, it
     will write the key description to /sys/kernel/crash_luks_volume_key
     to ask the kdump kernel to link the saved key to its thread keyring.

[3] https://gitlab.com/coxu/cryptsetup/-/commit/750a46d933fac82e0c994b5c41de40a0b8cac647

>
>But we are just going to merge a patchset that changes how we use keyring
>where you can tell cryptsetup to store/link key under some specific name
>and to specific keyring
>(see https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/492)
>(Please talk to Red Hat cryptsetup maintainers for more info,
>I just mentioned this mail to them today.)

Thanks for pointing me to the above MR which looks promising! Unlike
treating the kdump use case as a special case [3], it just provides a
generic way with the implemented options --link-vk-to-keyring and
--volume-key-keyring.

>
>>I respect the efforts from you and the cryptsetup community to make LUKS
>>as secure as possible. And kdump is used in product environment. Kdump
>>is to a server as a black box is to an aircraft. So by no means I want
>>to reverse the used security measures and patching cryptsetup can allow
>>to keep the security measures. One concern raised by you against "FRC
>>v1" was a copy of the LUKS volume key for the kdump kernel creates an
>>attack vector. I took this feedback seriously and have sought advice
>>from my colleagues to implement the countermeasures ([PATCH 1/5] and
>>[Patch 4/5]).
>>
>>[1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/
>
>Yes, I appreciate that. And it is perfectly ok if your customers accept
>the trade-off and security risk of handling the key this way.
>
>Anyway, I feel we are going in circles here, and as it seems to be my fault,
>I do not want to sound grumpy as I am perhaps missing some context.

Actually I should thank you for your patience! You have been always
offering your feedback on this work kindly and promptly starting with
the first proposed solution [1].

>
>Could you please talk to internal RH cryptsetup maintainers first and discuss
>your solution? They know what we can do here can help to find an acceptable
>solution. (I added cc to Ondra.)

Sure, I'll talk to them first. Thanks for letting Ondra know!

>
>Thanks,
>Milan
>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

