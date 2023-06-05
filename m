Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E576C7EE23
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 07:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685949006;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z3hIPsSEZx5RPKd3kRZZrWm6wjg35cW5cUR+Dz7Qerk=;
	b=PetaPALhku7+cOqrfM0uV7h3guaHY8DuAnbCFJnz2MO4s1lcs3f1ODf8ZAzHJo3+kdSwJM
	UufQsDMANKNZvHIpvEUHI6V3Ymheyd8ve5QsQsTA5GZjYy1Jjp8PcvZHl5oRNFrIgKfE3O
	LmA22mdMWMrM9cg/lKAT+h7XS6ATmS8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-W3CQp6k4N5C5hUqPrgmdUQ-1; Mon, 05 Jun 2023 03:10:03 -0400
X-MC-Unique: W3CQp6k4N5C5hUqPrgmdUQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4042B85A5BB;
	Mon,  5 Jun 2023 07:10:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BE3448205E;
	Mon,  5 Jun 2023 07:10:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB66919465A0;
	Mon,  5 Jun 2023 07:10:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 14CF91946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 07:09:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8DD7F140E955; Mon,  5 Jun 2023 07:09:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85B52140E954
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 07:09:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A4771C06EC7
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 07:09:59 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-C82a7KxiOUWWUjtyPSAIHg-1; Mon, 05 Jun 2023 03:09:53 -0400
X-MC-Unique: C82a7KxiOUWWUjtyPSAIHg-1
Received: by mail-ed1-f41.google.com with SMTP id
 4fb4d7f45d1cf-5162d2373cdso6701116a12.3; 
 Mon, 05 Jun 2023 00:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685948991; x=1688540991;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=40CnV0seHNA+3J+ZtxxY5lWq8+DP/bF+vwPGX6memA4=;
 b=YLUiwmtK89koO3xXit2avzJnml0zOh8x5emQdIpgZK80w4ZCcncrA8Yr4p6paIwiB+
 PbIZKUvSXv/TiB9IK+wvswK+JO0Kh/aZ5w4pQhB6edSUEWWUPPKOYe8u1/39hlW3wsMx
 7At9D3aCv0VgDU4LQwYUe9l9mUYZERebFkCyAbE72MKNdYx3xIuHACug8X5Bjwc3o/IF
 OdhprD8txFk0PkOg94BR/f7z5GoEHsz+FVjxs0Ua8QjZwXQfmkyhL/UF+71XhIVZLzie
 wDs8WhvEZ4mbFQPDqUyitZit91c2K42DeZzKk0/fsqRWH8HS1u3MJwWG9bGCVdMo2P2P
 yfmg==
X-Gm-Message-State: AC+VfDzyfF0YMTfp+BFvD6Rvph6C+ze5CuaZikc5W/jVNqHpQZlOgnqJ
 g6dm7NXiubIS8AWJOlUTS2aqtYp2kXWChg==
X-Google-Smtp-Source: ACHHUZ4avov38OYLaR3Bj09ogtbzgAw+IJvsxh/+I2jNWLZnteyosL/g2MigG3R1N70vvHtsLvmoLg==
X-Received: by 2002:a05:6402:659:b0:516:642e:f92b with SMTP id
 u25-20020a056402065900b00516642ef92bmr783879edx.1.1685948991066; 
 Mon, 05 Jun 2023 00:09:51 -0700 (PDT)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 b13-20020a056402138d00b00516654bf182sm334943edv.41.2023.06.05.00.09.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Jun 2023 00:09:50 -0700 (PDT)
Message-ID: <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
Date: Mon, 5 Jun 2023 09:09:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
To: Coiby Xu <coxu@redhat.com>, Eric Biggers <ebiggers@kernel.org>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
 <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 Pingfan Liu <kernelfans@gmail.com>, Dave Hansen <dave.hansen@intel.com>,
 dm-devel@redhat.com, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/5/23 04:31, Coiby Xu wrote:
> Hi Eric and Milan,
> 
> On Sat, Jun 03, 2023 at 11:22:52AM +0200, Milan Broz wrote:
>> On 6/2/23 23:34, Eric Biggers wrote:
>>> On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>>>> [PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
>>>
>>> The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
>>> happens to use.  But LUKS is a userspace concept.
>>>
>>> This is a kernel patchset, so why does it make sense for it to be talking about
>>> LUKS at all?  Perhaps you mean dm-crypt?
>>
>> Exactly.
> 
> Thanks for raising the above concern! The use cases like CoreOS and
> Confidential VMs explicitly want kdump to work for LUKS. And correct me
> if I'm wrong, I think the two problems addressed by this patch set only
> apply to LUKS so the kdump part of the kernel only cares about the LUKS
> case. If there are use cases where similar approach is needed, I'll be
> happy to make the solution more generic.
> 
>>
>> I had the same comment almost a year ago... and it still applies:
>> https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
>>
>> Anyway, please fix the naming before this patchset can be read or reviewed!
>>
>> LUKS is user-space key management only (on-disk metadata); the kernel has
>> no idea how the key is derived or what LUKS is - dm-crypt only knows the key
>> (either through keyring or directly in the mapping table).
>>
>> Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
>> is used in many other mappings (plain, bitlocker, veracrypt, ...)
>> Just use the dm-crypt key, do not reference LUKS at all.
> 
> Thanks for the reminding! That comment was on the first RFC version. But
> starting with "RFC v2", there is no longer any interaction with dm-crypt
> (to save a copy of the LUKS volume key for the kdump kernel) and now I
> make cryptsetup talks to the kdump part of the kernel via the sysfs to
> reuse the volume key. So only the kdump part of the kernel needs to know
> LUKS which is what it cares. Thus I don't think there is any kernel
> namespace pollution now.

Hi,

I am sorry if I did understand correctly, but I thought that kdump is part
of the kernel.

I am trying to say that kernel generally has no concept of LUKS;
this is a userspace abstraction for key management.

Even the cryptsetup dm-crypt configuration mapping table generated from LUKS
has nothing LUKS special in it (only in DM-UUID as a name prefix).

So I do not understand why you need to mention LUKS even in kdump part.
Perhaps it is still only a naming problem, nothing more.

All you need is to preserve key and configuration parameters (for dm-crypt).
If it is set by cryptsetup, dmsetup, or any other way is not important - on this
kernel layer, it has nothing to do with LUKS key management metadata.

No problem if you support only LUKS in userspace, but really, all this machinery
should work for any dm-crypt devices. Perhaps your patch even works for it already.

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

