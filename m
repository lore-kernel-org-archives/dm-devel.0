Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B950C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Mar 2022 06:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647845704;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GExKTbUf0cKzT/tXLTFcSDA9EwvgLqJb4EXngZGgDRo=;
	b=RRr+gi89oqOfGj/y7oz39/TW1POF4PJQl+Asl/lqbg1RHvBUwSW4FOt21OKEPkU2SIXd9U
	J+XlsXTvF883aX/NG1Pe29WZEfKVsmk6OWHWzIsgboHnF6OTFgOITptVEDUbX6oUGbOtMk
	TqtehCDS34mxzrZ0hmMGTdZCECX7EsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-E9sQWa0aNfyN6T0DIqk7TQ-1; Mon, 21 Mar 2022 02:54:56 -0400
X-MC-Unique: E9sQWa0aNfyN6T0DIqk7TQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2F83866DFB;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB792401E50;
	Mon, 21 Mar 2022 06:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6DF111953569;
	Mon, 21 Mar 2022 06:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71D8B194035B
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 01:45:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3593A40CF8E5; Sat, 19 Mar 2022 01:45:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3172340CF8E4
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 01:45:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17ADF811E76
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 01:45:25 +0000 (UTC)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-ft6_z6o0N4yPlvvxEazAiw-1; Fri, 18 Mar 2022 21:45:23 -0400
X-MC-Unique: ft6_z6o0N4yPlvvxEazAiw-1
Received: by mail-pf1-f197.google.com with SMTP id
 m22-20020a628c16000000b004f6f1b43114so6142102pfd.3
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 18:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ieSlFoCeto0AVAtI6K8jKTyxvQGGjjQJE1a9Rco3C2E=;
 b=kuVDCiUUkOykX8WrQUUrrylVvUIp+3/y+Uj7kkLPBYPVQJbZU2nmmFu8rnvaHJQCmE
 xPu4QwtZvkHMCrbJW29ycvCizesKewQuxw13CNJ6PLzDCGrvdx18Haejt48ycSZ3si3r
 ZSy0dHWnVdlKoN5ptgP8HWXoVKIEir+G7HwvTWzijCXu5ADhtlbq2hRWJ9KGnqvSs4fx
 /KxoN/0JAi76gl8xfs8RHOnJE/qqMfnbPsqFlTERSy0ZStk51xJAThWAjK7MAmNpobvl
 3jfsHUHSRjzPlKgcli1btYbqCwwCvV0Zd890sKnUzddRdjFwdo609YeCDGWeOYditTa0
 kqQA==
X-Gm-Message-State: AOAM533qraut8jJ0pEasDcBltQDNPmP40p5STtWw55C1MuenvbpVwZ9p
 KQKdwWuEdvmMcnCCp9Xj7x80Onr6/BMdR17ij12cSIRA/BenPtVJ/dJJrobN/uDV9zmli37DNhw
 g0lbCkzMkz2xt9Tk=
X-Received: by 2002:a17:902:f60f:b0:151:4f66:55b4 with SMTP id
 n15-20020a170902f60f00b001514f6655b4mr2309246plg.127.1647654322694; 
 Fri, 18 Mar 2022 18:45:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6kv1/v7LKf9RNEE8Smtok7Dg/0kGtE36CEGe6Q1XOCvrObPFLCmAnA8TsLXh6chusfsFb9A==
X-Received: by 2002:a17:902:f60f:b0:151:4f66:55b4 with SMTP id
 n15-20020a170902f60f00b001514f6655b4mr2309227plg.127.1647654322331; 
 Fri, 18 Mar 2022 18:45:22 -0700 (PDT)
Received: from localhost ([240e:3a1:2e5:800:f995:6136:f760:a3d0])
 by smtp.gmail.com with ESMTPSA id
 u5-20020a056a00158500b004f745148736sm11647956pfk.179.2022.03.18.18.45.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 18:45:21 -0700 (PDT)
Date: Sat, 19 Mar 2022 09:41:23 +0800
From: Coiby Xu <coxu@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <20220319014123.v26w2snihbuyd4fz@Rk>
References: <20220318103423.286410-1-coxu@redhat.com>
 <c857dcf8-024e-ab8a-fd26-295ce2e0ae41@gmail.com>
 <20220318122110.7qjrnrduwytjle3w@Rk>
 <a5b9e66c-235b-51dd-234c-b543dbacc464@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a5b9e66c-235b-51dd-234c-b543dbacc464@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 21 Mar 2022 06:54:49 +0000
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
Cc: Mike Snitzer <snitzer@redhat.com>, Baoquan He <bhe@redhat.com>,
 kexec@lists.infradead.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Fri, Mar 18, 2022 at 02:53:37PM +0100, Milan Broz wrote:
>On 18/03/2022 13:21, Coiby Xu wrote:
>...
>>>Why is it not done through keyring and forcing kdump to retain key there
>>>(under the same keyring key name as dm-crypt used)?
>>>Kernel dm-crypt supports this already; LUKS2 uses keyring by default too.
>>>That's all you need, or not? Why do you need to add another "kdump:" thing?
>>>IOW why kdump cannot copy the key to keyring under the name dm-crypt
>>>has in the mapping table and let dm-crypt activate the device almost without
>>>code changes?
>>
>>Sorry, I haven't explained how kdump works. Once the 1st kernel crashes and
>>the system boots into the kdump kernel, the kdump kernel only have direct
>>access to the memory exclusively reserved for it i.e. the kdump kernel
>>loses the direct access to the keyring constructed in the 1st kernel. In
>>theory, the kdump kernel could do some "hacking" to find out the key
>>stored in the memory directly managed by the 1st kernel but I imagine
>>this would be difficult task (imagine I present the memory dump of my
>>computer to you and ask you to rebuild all the relevant kernel data
>>structures and find the key). Besides, it's not reliable to read the
>>memory directly managed by the first kernel for example the memory could
>>be corrupt. So we have to pass the master key from the 1st kernel to the kdump
>>kernel.
>
>OK, then why you cannot store it to the (2nd) kdump kernel keyring?
>(From the kdump area copy, then you do not need to patch anything else
>in dm-crypt than that one line storing the key to the kdump area.)

cryptsetup stores the master key in the thread keyring
(KEY_SPEC_THREAD_KEYRING). I couldn't come up with a easy way to store
the key to the (2nd) kdump kernel keyring. For example, one problem is
how can I know in adance the thread ID of cryptsetup? I imagine
drivers/md/dm-crypt.c needs to support a new type of message in
crypt_message so cryptsetup can tell dm-crypt to store the master key
in the thread keyring as a preparation for opening the device. So one
line change of code isn't sufficient. What's more important is I don't see 
any benefit by doing so I regards storing the key to the kdump kernel
keyring first as an unnecessary step.

>
>A clear approach would be to store the key in the 2nd kernel kdump keyring
>and allow userspace to read it.
>Then cryptsetup can just validate the key (LUKS key digest does not use Argon)
>and activates it without asking for a passphrase.

Thanks for bringing my attention to validating the key! Currently I
simply skip key validation in cryptsetup when implementing the
"--kdump-master-key" option because it requires pass the master key to
the user space. I have a side question, if somehow the master key is
changed and the wrong key is used to get the expanded key, will it lead
to a devastating effect say corrupting the user data on the disk?

>Perhaps this will need some new cryptsetup option (or API call), but I think
>it can be done.
>
>Or, you can actually simulate it with
>  cryptsetup open ... --master-key-file <file>
>where this keyfile contains directly the volume key, not a passphrase.
>The key digest is verified in this case only; no costly PBKDF is needed.
>
>If you have a way to retrieve the kdump stored key to kdump userspace, this
>is perhaps a much simpler solution.
>
>All this is against all countermeasures to not expose encryption key
>directly - but if kdump is debugging environment, just saying...

I respect and appreciate all the efforts done by you and other community
members to increase security margin so the last thing I want to do is to
reverse the security measures. Besides, I believe some users choose to
dump vmcore to an encrypted disk exactly out of security concern. The
only thing this patch set does about master key is to store it in the
memory exclusively reserved for kdump. To be precise, storing the master
key in the memory exclusively reserved for kdump may be different from
what you mean by "exposing encryption key directly". This reserved memory
won't be used by the 1st kernel (which means if we reserve 1GB more for
the kdump kernel, the 1st kernel would have 1GB less kernel to use. And I
would expect strong objection from the user due to a loss of 1GB memory).
Only kexec knows how to store the master key in this exclusively reserved
memory area and but kexec itself doesn't know to retrieve the master key in
the 1st kernel. So the situation is similar to how expanded key is stored.
struct crypto_aes_ctx has the expanded key, but there is no API to retrieve
it. If you still think this line of reasoning doesn't convince you, how
about encrypting the master key before storing the key to the kdump memory?
kexec could calculate the SHA256 digest of loaded kdump kernel and initrd.
We can use this SHA256 digest to get an encryption key and then encrypt
the master key.

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

