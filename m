Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4197C83005
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120541;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V1lIA5jyiJISvhghhdRTvWHGqSEriaIFU2/8s1z72o0=;
	b=PQHt7Ndqa/0heLPM3rp0cnyBoERUsZgROTDLCM5fjEnwun13ue4Sz2HFZHP1Mi+DYVy1rk
	WotURG8SiwOju0nsuW8mmtaFtgdLxW/yo679gLSqIdqLPA3NFMMB/Ec/AVlRxAaKFA/GVy
	p6gxQC4knvNmnD/xyOXOxeJL77zMQUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-Xm7N2KJGOyGF_w00Pol9AQ-1; Wed, 07 Jun 2023 02:48:59 -0400
X-MC-Unique: Xm7N2KJGOyGF_w00Pol9AQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D42DF805AF7;
	Wed,  7 Jun 2023 06:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C159640E6A43;
	Wed,  7 Jun 2023 06:48:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F6B8194E006;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4458B1946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 11:03:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C59CC9E8D; Tue,  6 Jun 2023 11:03:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE32C9E8B
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 11:03:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35230185A792
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 11:03:34 +0000 (UTC)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-VUaz89pMMv-7i9r8tyxeJA-1; Tue, 06 Jun 2023 07:03:33 -0400
X-MC-Unique: VUaz89pMMv-7i9r8tyxeJA-1
Received: by mail-pg1-f200.google.com with SMTP id
 41be03b00d2f7-53fd224ad48so1799611a12.2
 for <dm-devel@redhat.com>; Tue, 06 Jun 2023 04:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686049411; x=1688641411;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=PECCGAhd7teBhoQVIkKkQ0gCChVRirWpXr8QC6vVa88=;
 b=fqEoB6AjmX7CscAcoELqhcd0n/td4cyfMsiycw6IduOEW6Z4nqbYNQ3s9q0C4IYw6u
 Ql3CyADTVT8HhJjXWDI16hzfFGXCqb7/PDiVNCDW/S2ya2r1MyqpO8tU/E4j1s+YFdU9
 4I+ulFI1cu4i9GPuznwHjEnvcXL50t1qsxquGFCNphdOZAHmgWVRtsYuKBkIAGVsG7eb
 cHQsSkoJCZzzZajO6I/5gG9EQqjmm0YAEUeoS4S1Mu9SRnqYA4H39bzDnHP/Zh08MQEL
 cNRMDv0YZ9SyhE/ue6/rGsDEDYvT+PMNDgNm+7sySO1rRgr54MkWhkGo/3hydGggxFGK
 pVsQ==
X-Gm-Message-State: AC+VfDwRL72Sa4RhR7FN6FLxWFJq4w6UxqdSBt0HmevO5pQzedbQcQMA
 ZHpTgwemlyQzCC1t9Oa66ZZDfecpDlmmW4mhli3D8s3j2sCkPzGagAVWl2wed0y/V3zwhKMtFj+
 pO146wcsRRiqJazg=
X-Received: by 2002:a17:90a:cb8f:b0:24e:2e86:5465 with SMTP id
 a15-20020a17090acb8f00b0024e2e865465mr244058pju.31.1686049411620; 
 Tue, 06 Jun 2023 04:03:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Ut1fWyiC1Sxe/ag4hpzoFeyDmazttp0G3bC8zYvg1LgXcS3Mz6lzRVYGA5vny7y9WWqUGuQ==
X-Received: by 2002:a17:90a:cb8f:b0:24e:2e86:5465 with SMTP id
 a15-20020a17090acb8f00b0024e2e865465mr244050pju.31.1686049411302; 
 Tue, 06 Jun 2023 04:03:31 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 l3-20020a6542c3000000b005307501cfe4sm6611337pgp.44.2023.06.06.04.03.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Jun 2023 04:03:30 -0700 (PDT)
Date: Tue, 6 Jun 2023 19:02:19 +0800
From: Coiby Xu <coxu@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <oosx274kf6kzasncdfdg5a53ut6wey3nlnbho5x3rql2df3zep@c6r6m4whphvh>
References: <20230601072444.2033855-1-coxu@redhat.com>
 <20230602213452.GC628@quark.localdomain>
 <f569a35a-bff9-9dbb-2ded-7e02ee060a9a@gmail.com>
 <36mz3gn764ceadfbuhhmoo2zaiqmzplpkdcnszha2hzhmb3i62@sm6hilxryzk4>
 <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a5eaa21d-6551-5857-98cd-50578fe59566@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Mon, Jun 05, 2023 at 09:09:49AM +0200, Milan Broz wrote:
>On 6/5/23 04:31, Coiby Xu wrote:
>>Hi Eric and Milan,
>>
>>On Sat, Jun 03, 2023 at 11:22:52AM +0200, Milan Broz wrote:
>>>On 6/2/23 23:34, Eric Biggers wrote:
>>>>On Thu, Jun 01, 2023 at 03:24:39PM +0800, Coiby Xu wrote:
>>>>>[PATCH 0/5] Support kdump with LUKS encryption by reusing LUKS volume key
>>>>
>>>>The kernel has no concept of LUKS at all.  It provides dm-crypt, which LUKS
>>>>happens to use.  But LUKS is a userspace concept.
>>>>
>>>>This is a kernel patchset, so why does it make sense for it to be talking about
>>>>LUKS at all?  Perhaps you mean dm-crypt?
>>>
>>>Exactly.
>>
>>Thanks for raising the above concern! The use cases like CoreOS and
>>Confidential VMs explicitly want kdump to work for LUKS. And correct me
>>if I'm wrong, I think the two problems addressed by this patch set only
>>apply to LUKS so the kdump part of the kernel only cares about the LUKS
>>case. If there are use cases where similar approach is needed, I'll be
>>happy to make the solution more generic.
>>
>>>
>>>I had the same comment almost a year ago... and it still applies:
>>>https://lore.kernel.org/all/c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com/
>>>
>>>Anyway, please fix the naming before this patchset can be read or reviewed!
>>>
>>>LUKS is user-space key management only (on-disk metadata); the kernel has
>>>no idea how the key is derived or what LUKS is - dm-crypt only knows the key
>>>(either through keyring or directly in the mapping table).
>>>
>>>Polluting kernel namespace with "luks" names variables is wrong - dm-crypt
>>>is used in many other mappings (plain, bitlocker, veracrypt, ...)
>>>Just use the dm-crypt key, do not reference LUKS at all.
>>
>>Thanks for the reminding! That comment was on the first RFC version. But
>>starting with "RFC v2", there is no longer any interaction with dm-crypt
>>(to save a copy of the LUKS volume key for the kdump kernel) and now I
>>make cryptsetup talks to the kdump part of the kernel via the sysfs to
>>reuse the volume key. So only the kdump part of the kernel needs to know
>>LUKS which is what it cares. Thus I don't think there is any kernel
>>namespace pollution now.
>
>Hi,
>
>I am sorry if I did understand correctly, but I thought that kdump is part
>of the kernel.

Yes, there is the kernel part of the kdump although there is also the
userspace part to make the feature complete:)

>
>I am trying to say that kernel generally has no concept of LUKS;
>this is a userspace abstraction for key management.
>
>Even the cryptsetup dm-crypt configuration mapping table generated from LUKS
>has nothing LUKS special in it (only in DM-UUID as a name prefix).
>
>So I do not understand why you need to mention LUKS even in kdump part.
>Perhaps it is still only a naming problem, nothing more.
>
>All you need is to preserve key and configuration parameters (for dm-crypt).
>If it is set by cryptsetup, dmsetup, or any other way is not important - on this
>kernel layer, it has nothing to do with LUKS key management metadata.
>
>No problem if you support only LUKS in userspace, but really, all this machinery
>should work for any dm-crypt devices. Perhaps your patch even works for it already.

Thanks for the explanation! After reflecting on your words for some
time, I realize I had an implicit assumption. I assumed is if I use a
name like dm_crypt_key instead of luks_volume_key, I need to support all
mappings like plain, bitlocker, veracrypt as mentioned by you and this
could mean much more efforts. So I'm not motivated to do that as
currently users only request kdump to work for LUKS.  

But maybe I can divide the efforts into the kernel part and userspace
part. For the kernel part, almost no effort is needed since only
renaming is needed as pointed out by you. For the userpace part, maybe
it's OK to support preserving key only for LUKS2 in cryptsetup as hinted
by your last paragraph? Does it look good to you from the viewpoint of
the maintainer of cryptsetup?

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

