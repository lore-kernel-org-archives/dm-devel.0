Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B958DC7EE25
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 06:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686206932;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jxk8TVzCFtzzp9L6Dcz43oMf22VRxABEyHyAUZMyhak=;
	b=XLRFX7qh2hAdIpB99fOeNT9kit3iJX881/zGsZvztF5er2och54aroKB04x8UykruxizgN
	us6pRXOlrdEQieV2qzTdLM5Q2lxjAD0f3mXS6pXRJpWfE5+9O4eZxA247Tz0uyYf2B/elG
	+5zVkFzQ+lqZ+kkXGlnUahc7eTooukQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-meCbbsI0NwiHwCOcaRV8rQ-1; Thu, 08 Jun 2023 02:48:51 -0400
X-MC-Unique: meCbbsI0NwiHwCOcaRV8rQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6231C00BA4;
	Thu,  8 Jun 2023 06:48:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CACE7C154D2;
	Thu,  8 Jun 2023 06:48:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4302A19451EF;
	Thu,  8 Jun 2023 06:48:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 342A519465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 12:40:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01B7FC16046; Wed,  7 Jun 2023 12:40:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE361C1603B
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:40:53 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA7FB282CCAC
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 12:40:53 +0000 (UTC)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-ZzeK-gJjOXiL3JtXbIQvrg-1; Wed, 07 Jun 2023 08:40:52 -0400
X-MC-Unique: ZzeK-gJjOXiL3JtXbIQvrg-1
Received: by mail-pl1-f199.google.com with SMTP id
 d9443c01a7336-1b1bc451355so20543845ad.3
 for <dm-devel@redhat.com>; Wed, 07 Jun 2023 05:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686141651; x=1688733651;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oT2y53ulYulPm7eYD4DjOZtoHv5XIt/WJdWLVzd0fzQ=;
 b=egsn+bVh0TPXZwc79ov2tr71wmImj4U+QBEJzcZOZ6VYCF3g4hFIpK1WN+8Jnsp7xH
 onJtx//8YBMvyv+HZlRMBe0m9IFE/P6wZsd/jZrMy8Dh/fvj4yk1564QSlUL/qbCunjW
 Uy2CI6Oi8FZ8DS37OjuQUoBuKYa/BRZtyUP4WA77/1/x2H1onyl6WOHF570FzHfi1OAC
 TnV1Ei371MlpVm9SinwWSlKBnCJqoMhd0vg12vxdkyxCCbKnHUFFwlziZsiZ8/akI+ac
 +yNQOnZ9bDaKVkt/W7HBPAU91oCX3sCL0sPeL0AkNzT9wPStY1SctAibcmg8Jv49Qgxs
 zQIA==
X-Gm-Message-State: AC+VfDyZldJ8EBraOL7hzi2rVIhiFB+zx23ZyX36WLpG6Zb5yscldo4s
 AjSD+oY3Xo76/d5V3gfoW2Y3eUtS6JzQLFulv3vlVL1K/iItX0emjdGW6OuLED0j20ug/WgM0Bn
 Yal1PlYBnDhFiZFE=
X-Received: by 2002:a17:902:db0c:b0:1b2:43a2:f2d with SMTP id
 m12-20020a170902db0c00b001b243a20f2dmr1491479plx.32.1686141651533; 
 Wed, 07 Jun 2023 05:40:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5WvWyXbPR8N3R/UFeTjYGCxTiv7+FaAuP9pTiCykGOIlpyziaDB0cvh9McEZlbMXXGNjIn1w==
X-Received: by 2002:a17:902:db0c:b0:1b2:43a2:f2d with SMTP id
 m12-20020a170902db0c00b001b243a20f2dmr1491467plx.32.1686141651162; 
 Wed, 07 Jun 2023 05:40:51 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 b4-20020a170903228400b001b21bcea439sm5160378plh.170.2023.06.07.05.40.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Jun 2023 05:40:50 -0700 (PDT)
Date: Wed, 7 Jun 2023 20:39:56 +0800
From: Coiby Xu <coxu@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <maamg4udo7visvgzp4m4qkfcds6djyiga236lb2mwtjasi6pvj@zmqzb2lijegj>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
 <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
 <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
 <oosx274kf6kzasncdfdg5a53ut6wey3nlnbho5x3rql2df3zep@c6r6m4whphvh>
 <88581a3c-8bd3-f7b2-064c-c809a2152ed3@gmail.com>
MIME-Version: 1.0
In-Reply-To: <88581a3c-8bd3-f7b2-064c-c809a2152ed3@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 08 Jun 2023 06:48:45 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Wed, Jun 07, 2023 at 08:14:44AM +0200, Milan Broz wrote:
>On 6/6/23 13:02, Coiby Xu wrote:
>>On Mon, Jun 05, 2023 at 09:09:49AM +0200, Milan Broz wrote:
>>>On 6/5/23 04:31, Coiby Xu wrote:
>>>>Hi Eric and Milan,
>>>>
>>>>On Sat, Jun 03, 2023 at 11:22:52AM +0200, Milan Broz wrote:
>>>>>On 6/2/23 23:34, Eric Biggers wrote:
>>>>>>On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>>>>>>>[PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
>>>>>>
>>>>>>The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
>>>>>>happens to use.  But LUKS is a userspace concept.
>>>>>>
>>>>>>This is a kernel patchset, so why does it make sense for it to be talking about
>>>>>>LUKS at all?  Perhaps you mean dm-crypt?
>>>>>
>>>>>Exactly.
>>>>
>>>>Thanks for raising the above concern! The use cases like CoreOS and
>>>>Confidential VMs explicitly want kdump to work for LUKS. And correct me
>>>>if I'm wrong, I think the two problems addressed by this patch set only
>>>>apply to LUKS so the kdump part of the kernel only cares about the LUKS
>>>>case. If there are use cases where similar approach is needed, I'll be
>>>>happy to make the solution more generic.
>>>>
>>>>>
>>>>>I had the same comment almost a year ago... and it still applies:
>>>>>https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
>>>>>
>>>>>Anyway, please fix the naming before this patchset can be read or reviewed!
>>>>>
>>>>>LUKS is user-space key management only (on-disk metadata); the kernel has
>>>>>no idea how the key is derived or what LUKS is - dm-crypt only knows the key
>>>>>(either through keyring or directly in the mapping table).
>>>>>
>>>>>Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
>>>>>is used in many other mappings (plain, bitlocker, veracrypt, ...)
>>>>>Just use the dm-crypt key, do not reference LUKS at all.
>>>>
>>>>Thanks for the reminding! That comment was on the first RFC version. But
>>>>starting with "RFC v2", there is no longer any interaction with dm-crypt
>>>>(to save a copy of the LUKS volume key for the kdump kernel) and now I
>>>>make cryptsetup talks to the kdump part of the kernel via the sysfs to
>>>>reuse the volume key. So only the kdump part of the kernel needs to know
>>>>LUKS which is what it cares. Thus I don't think there is any kernel
>>>>namespace pollution now.
>>>
>>>Hi,
>>>
>>>I am sorry if I did understand correctly, but I thought that kdump is part
>>>of the kernel.
>>
>>Yes, there is the kernel part of the kdump although there is also the
>>userspace part to make the feature complete:)
>>
>>>
>>>I am trying to say that kernel generally has no concept of LUKS;
>>>this is a userspace abstraction for key management.
>>>
>>>Even the cryptsetup dm-crypt configuration mapping table generated from LUKS
>>>has nothing LUKS special in it (only in DM-UUID as a name prefix).
>>>
>>>So I do not understand why you need to mention LUKS even in kdump part.
>>>Perhaps it is still only a naming problem, nothing more.
>>>
>>>All you need is to preserve key and configuration parameters (for dm-crypt).
>>>If it is set by cryptsetup, dmsetup, or any other way is not important - on this
>>>kernel layer, it has nothing to do with LUKS key management metadata.
>>>
>>>No problem if you support only LUKS in userspace, but really, all this machinery
>>>should work for any dm-crypt devices. Perhaps your patch even works for it already.
>>
>>Thanks for the explanation! After reflecting on your words for some
>>time, I realize I had an implicit assumption. I assumed is if I use a
>>name like dm_crypt_key instead of luks_volume_key, I need to support all
>>mappings like plain, bitlocker, veracrypt as mentioned by you and this
>>could mean much more efforts. So I'm not motivated to do that as
>>currently users only request kdump to work for LUKS.
>
>Thanks, I think it is perfectly fine to implement just subset here.
>
[...]
>
>My comment was just about proper naming in kernel, it is of course up to you
>what you want to support in userspace (and even in kernel, extensions can
>be added later).

Thanks for the confirmation!

>
>Only LUKS2 uses keyring for volume key in dm-crypt as default option anyway.

Thanks for the info!

>I do not think you need any cryptsetup patches, all you need is to write
>decrypted volume key from LUKS metadata with
>  cryptsetup luksDump ---dump-volume-key -volume-key-file <out> <device>
>(or any code equivalent with libcryptsetup), am I correct?

Correct me if I'm wrong, but I don't think there will be a safer way to
preserve key without patching cryptsetup. Actually the --dump-volume-key
approach has been proposed before and I agree with your conclusion [1]
on that approach i.e. "passing volume key this way is quite insecure".
Without patching cryptsetup, even if I save the volume key in the memory
reserved for the kdump kernel, I need to retrieve this key in the
userspace to unlock the LUKS device which may lead to quite a security
vulnerability.

I respect the efforts from you and the cryptsetup community to make LUKS
as secure as possible. And kdump is used in product environment. Kdump
is to a server as a black box is to an aircraft. So by no means I want
to reverse the used security measures and patching cryptsetup can allow
to keep the security measures. One concern raised by you against "FRC
v1" was a copy of the LUKS volume key for the kdump kernel creates an
attack vector. I took this feedback seriously and have sought advice
from my colleagues to implement the countermeasures ([PATCH 1/5] and
[Patch 4/5]).

[1] https://yhbt.net/lore/all/e5abd089-3398-fdb4-7991-0019be434b79@gmail.com/


>
>Milan
>

-- 
Best regards,
Coiby

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

